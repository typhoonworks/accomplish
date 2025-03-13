defmodule Accomplish.TokenCache do
  @moduledoc """
  Manages one-time generation tokens for secure, ephemeral actions.
  """

  use GenServer

  @token_ttl :timer.minutes(15)
  @cleanup_interval :timer.minutes(5)
  @cache_name :token_cache

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def generate_token(context) do
    token = generate_unique_token()
    GenServer.call(__MODULE__, {:create_token, token, context})
    token
  end

  def validate_and_consume_token(token) do
    GenServer.call(__MODULE__, {:validate_token, token})
  end

  @impl true
  def init(_) do
    :ets.new(@cache_name, [:named_table, :set, :private])
    Process.send_after(self(), :cleanup, @cleanup_interval)
    {:ok, %{}}
  end

  @impl true
  def handle_call({:create_token, token, context}, _from, state) do
    :ets.insert(@cache_name, {
      token,
      context,
      :os.system_time(:millisecond) + @token_ttl
    })
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:validate_token, token}, _from, state) do
    now = :os.system_time(:millisecond)

    case :ets.lookup(@cache_name, token) do
      [{^token, context, expiry}] when now < expiry ->
        :ets.delete(@cache_name, token)
        {:reply, {:ok, context}, state}

      _ ->
        {:reply, {:error, :invalid_or_expired_token}, state}
    end
  end

  @impl true
  def handle_info(:cleanup, state) do
    now = :os.system_time(:millisecond)

    :ets.tab2list(@cache_name)
    |> Enum.each(fn {token, _, expiry} ->
      if now >= expiry do
        :ets.delete(@cache_name, token)
      end
    end)

    Process.send_after(self(), :cleanup, @cleanup_interval)
    {:noreply, state}
  end

  defp generate_unique_token do
    :crypto.strong_rand_bytes(6) |> Base.encode16(case: :lower)
  end
end
