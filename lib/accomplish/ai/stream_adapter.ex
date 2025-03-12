defmodule Accomplish.AI.StreamAdapter do
  @moduledoc """
  Adapter for handling streaming API responses from AI providers like Anthropic.

  This module creates a process that:
  1. Receives messages from AI providers' streaming APIs
  2. Translates those messages to a consistent internal format
  3. Forwards the translated messages to the Streaming.Manager
  """

  require Logger

  alias Accomplish.Streaming

  @doc """
  Creates a streaming wrapper that handles Anthropic's streaming format.

  Returns a PID that can be passed to Anthropic's API for streaming.

  ## Parameters
    - stream_id: Unique identifier for this stream
    - persistence_fn: Function that takes a buffer string and persists it
    - opts: Additional options for the stream manager
      - save_interval: How often to persist the buffer (in ms)
      - ttl: How long to keep the stream alive without updates (in ms)

  ## Returns
    - A PID that can be used as a stream target for Anthropic
  """
  def create_streaming_wrapper(stream_id, persistence_fn, opts \\ []) do
    case Streaming.Manager.create_stream(stream_id, persistence_fn, opts) do
      {:ok, _} -> :ok
      error -> Logger.error("Failed to create stream: #{inspect(error)}")
    end

    {:ok, stream_pid} = Streaming.Manager.get_stream(stream_id)

    {:ok, wrapper_pid} =
      Task.start(fn ->
        receive_loop(stream_pid)
      end)

    wrapper_pid
  end

  defp receive_loop(stream_pid) do
    receive do
      {_pid, {:data, %{"type" => type} = message}} ->
        case type do
          "message_start" ->
            receive_loop(stream_pid)

          "content_block_delta" ->
            if is_map_key(message, "delta") and is_map_key(message["delta"], "text") do
              Streaming.Manager.append(stream_pid, message["delta"]["text"])
            end

            receive_loop(stream_pid)

          "content_block_stop" ->
            Streaming.Manager.complete_stream(stream_pid)

          "message_stop" ->
            Streaming.Manager.complete_stream(stream_pid)

          _ ->
            receive_loop(stream_pid)
        end

      {:stream_error, error} ->
        Logger.error("Streaming error: #{inspect(error)}")
        Streaming.Manager.complete_stream(stream_pid)

      other ->
        Logger.debug("Unhandled message in StreamAdapter: #{inspect(other)}")
        receive_loop(stream_pid)
    end
  end
end
