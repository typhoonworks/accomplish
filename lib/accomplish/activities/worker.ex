defmodule Accomplish.Activities.Worker do
  use Oban.Worker, queue: :default

  alias Accomplish.Repo
  alias Accomplish.Activities
  alias Accomplish.Accounts.User

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "actor_id" => actor_id,
          "action" => action,
          "target_id" => target_id,
          "target_type" => target_type,
          "metadata" => metadata
        }
      }) do
    with {:ok, actor} <- fetch_actor(actor_id),
         {:ok, target} <- Activities.fetch_target(target_id, target_type) do
      Activities.log_activity(actor, action, target, metadata)
      :ok
    else
      {:error, reason} -> {:error, "Failed to log activity: #{reason}"}
    end
  end

  defp fetch_actor(actor_id) do
    case Repo.get(User, actor_id) do
      nil -> {:error, "Actor not found (ID: #{actor_id})"}
      actor -> {:ok, actor}
    end
  end
end
