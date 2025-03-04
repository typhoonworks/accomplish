defmodule AccomplishWeb.NavigationTracker do
  @moduledoc """
  Tracks user navigation history across tracked LiveView sessions.

  This GenServer maintains a per-user navigation history using ETS, allowing
  the application to record paths visited in trackable sections and provide
  navigation functionality such as returning to the last meaningful page.
  """

  use GenServer

  @table :navigation_history
  @max_history_size 10

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    :ets.new(@table, [:set, :public, :named_table])
    {:ok, %{}}
  end

  def record_path(user_id, path) do
    current_history = get_history(user_id)

    updated_history =
      [path | current_history]
      |> Enum.uniq()
      |> Enum.take(@max_history_size)

    :ets.insert(@table, {user_id, updated_history})
  end

  def get_last_path(user_id) do
    history = get_history(user_id)
    List.first(history) || "/mission_control"
  end

  def get_history(user_id) do
    case :ets.lookup(@table, user_id) do
      [{^user_id, history}] -> history
      [] -> []
    end
  end

  def clear_history(user_id) do
    :ets.delete(@table, user_id)
  end
end
