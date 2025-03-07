defmodule Accomplish.Workers.LogActivity do
  @moduledoc false

  use Oban.Worker, queue: :default

  alias Accomplish.Repo
  alias Accomplish.Activities
  alias Accomplish.Accounts.User

  @impl Oban.Worker
  def perform(%Oban.Job{
        args:
          %{
            "actor_id" => actor_id,
            "action" => action,
            "entity_id" => entity_id,
            "entity_type" => entity_type
          } = args
      }) do
    metadata = Map.get(args, "metadata", %{})
    context_id = Map.get(args, "context_id")
    context_type = Map.get(args, "context_type")

    with {:ok, actor} <- fetch_actor(actor_id),
         {:ok, entity} <- Activities.fetch_entity(entity_id, entity_type),
         {:ok, context} <- fetch_optional_context(context_id, context_type) do
      Activities.log_activity(
        actor,
        action,
        entity,
        metadata,
        DateTime.utc_now(),
        context
      )

      :ok
    else
      {:error, reason} ->
        {:error, "Failed to log activity: #{reason}"}
    end
  end

  # =============================
  # FETCH HELPERS
  # =============================

  defp fetch_actor(actor_id) do
    case Repo.get(User, actor_id) do
      nil -> {:error, "Actor not found (ID: #{actor_id})"}
      actor -> {:ok, actor}
    end
  end

  defp fetch_optional_context(nil, _), do: {:ok, nil}
  defp fetch_optional_context(_, nil), do: {:ok, nil}

  defp fetch_optional_context(context_id, context_type) do
    Activities.fetch_entity(context_id, context_type)
  end
end
