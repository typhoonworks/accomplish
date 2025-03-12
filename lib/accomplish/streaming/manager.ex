defmodule Accomplish.Streaming.Manager do
  @moduledoc """
  Manages streaming processes that can outlive LiveView sessions.

  This module provides a GenServer that:
  1. Manages the buffer of streaming content
  2. Persists content periodically to the database
  3. Allows multiple consumers to register for updates
  4. Handles proper cleanup when streaming completes
  """

  use GenServer
  require Logger

  def child_spec(opts) do
    %{
      id: {__MODULE__, opts[:stream_id]},
      start: {__MODULE__, :start_link, [opts]},
      restart: :transient,
      type: :worker,
      shutdown: 5000
    }
  end

  # --------------------------------------------------------------------
  #  Public API
  # --------------------------------------------------------------------

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(opts[:stream_id]))
  end

  def create_stream(stream_id, persistence_fn, opts \\ []) do
    case get_stream(stream_id) do
      {:ok, _pid} ->
        {:ok, stream_id}

      :not_found ->
        DynamicSupervisor.start_child(
          Accomplish.DynamicSupervisor,
          {Accomplish.Streaming.Manager,
           stream_id: stream_id,
           persistence_fn: persistence_fn,
           save_interval: Keyword.get(opts, :save_interval, 5_000),
           ttl: Keyword.get(opts, :ttl, 10_000)}
        )

        {:ok, stream_id}
    end
  end

  def get_stream(stream_id) do
    case Registry.lookup(Accomplish.Registry, {__MODULE__, stream_id}) do
      [{pid, _}] -> {:ok, pid}
      [] -> :not_found
    end
  end

  def via_tuple(stream_id) do
    {:via, Registry, {Accomplish.Registry, {__MODULE__, stream_id}}}
  end

  def stop_stream(stream_id) do
    case get_stream(stream_id) do
      {:ok, pid} ->
        GenServer.cast(pid, :stop_stream)
        :ok

      :not_found ->
        :ok
    end
  end

  def append(pid, chunk) do
    GenServer.cast(pid, {:append, chunk})
  end

  def get_buffer(pid) do
    GenServer.call(pid, :get_buffer)
  end

  def get_status(pid) do
    GenServer.call(pid, :get_status)
  end

  def clear_buffer(pid) do
    GenServer.cast(pid, :clear_buffer)
  end

  def complete_stream(pid) do
    GenServer.cast(pid, :complete)
  end

  def register_consumer(pid, consumer_pid) do
    GenServer.cast(pid, {:register_consumer, consumer_pid})
  end

  # --------------------------------------------------------------------
  #  GenServer Callbacks
  # --------------------------------------------------------------------

  @impl true
  def init(opts) do
    stream_id = opts[:stream_id]
    persistence_fn = opts[:persistence_fn]
    save_interval = opts[:save_interval]
    ttl = opts[:ttl]

    if save_interval > 0 do
      Process.send_after(self(), :save_buffer, save_interval)
    end

    if ttl > 0 do
      Process.send_after(self(), :check_ttl, ttl)
    end

    state = %{
      stream_id: stream_id,
      buffer: "",
      consumers: MapSet.new(),
      status: :streaming,
      persistence_fn: persistence_fn,
      save_interval: save_interval,
      ttl: ttl,
      last_saved_at: DateTime.utc_now(),
      last_update: DateTime.utc_now()
    }

    {:ok, state}
  end

  @impl true
  def handle_cast({:append, chunk}, state) do
    updated_buffer = state.buffer <> chunk

    Enum.each(state.consumers, fn consumer ->
      send(consumer, {:stream_chunk, chunk})
      send(consumer, {:stream_buffer, updated_buffer})
    end)

    {:noreply, %{state | buffer: updated_buffer, last_update: DateTime.utc_now()}}
  end

  @impl true
  def handle_cast(:clear_buffer, state) do
    Enum.each(state.consumers, fn consumer ->
      send(consumer, {:stream_buffer, ""})
    end)

    {:noreply, %{state | buffer: "", last_update: DateTime.utc_now()}}
  end

  @impl true
  def handle_cast(:complete, state) do
    if is_function(state.persistence_fn, 1) do
      try do
        state.persistence_fn.(state.buffer)
      rescue
        e -> Logger.error("Error persisting final buffer: #{inspect(e)}")
      end
    end

    Enum.each(state.consumers, fn consumer ->
      send(consumer, {:stream_complete, state.buffer})
      send(consumer, {:stream_status, :completed})
    end)

    {:stop, :normal, %{state | status: :completed}}
  end

  @impl true
  def handle_cast({:register_consumer, pid}, state) do
    # Watch the consumer process for termination
    Process.monitor(pid)

    # Send current buffer and status to new consumer
    send(pid, {:stream_buffer, state.buffer})
    send(pid, {:stream_status, state.status})

    {:noreply, %{state | consumers: MapSet.put(state.consumers, pid)}}
  end

  @impl true
  def handle_cast(:stop_stream, state) do
    if state.status == :streaming and is_function(state.persistence_fn, 1) do
      try do
        state.persistence_fn.(state.buffer)
      rescue
        e -> Logger.error("Error during final save on stop: #{inspect(e)}")
      end
    end

    Enum.each(state.consumers, fn consumer ->
      send(consumer, {:stream_status, :stopped})
    end)

    {:stop, :normal, state}
  end

  @impl true
  def handle_call(:get_status, _from, state) do
    {:reply, state.status, state}
  end

  @impl true
  def handle_call(:get_buffer, _from, state) do
    {:reply, state.buffer, state}
  end

  @impl true
  def handle_info(:save_buffer, state) do
    state =
      if state.status == :streaming and
           DateTime.compare(state.last_update, state.last_saved_at) == :gt and
           is_function(state.persistence_fn, 1) do
        try do
          state.persistence_fn.(state.buffer)
          %{state | last_saved_at: DateTime.utc_now()}
        rescue
          e ->
            Logger.error("Error persisting streaming buffer: #{inspect(e)}")
            state
        end
      else
        state
      end

    if state.status == :streaming and state.save_interval > 0 do
      Process.send_after(self(), :save_buffer, state.save_interval)
    end

    {:noreply, state}
  end

  @impl true
  def handle_info(:check_ttl, state) do
    time_since_update = DateTime.diff(DateTime.utc_now(), state.last_update, :millisecond)

    if time_since_update > state.ttl do
      Logger.info("Stream #{state.stream_id} TTL expired, shutting down")
      {:stop, :normal, state}
    else
      next_check = max(1000, state.ttl - time_since_update)
      Process.send_after(self(), :check_ttl, next_check)
      {:noreply, state}
    end
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, dead_consumer, _reason}, state) do
    new_consumers = MapSet.delete(state.consumers, dead_consumer)

    if MapSet.size(new_consumers) == 0 and state.status != :streaming do
      {:stop, :normal, %{state | consumers: new_consumers}}
    else
      {:noreply, %{state | consumers: new_consumers}}
    end
  end

  @impl true
  def handle_info(msg, state) do
    Logger.debug("Unhandled message in Streaming.Manager: #{inspect(msg)}")
    {:noreply, state}
  end
end
