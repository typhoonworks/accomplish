defmodule Accomplish.Workers.LogActivity do
  @moduledoc false

  use Oban.Worker, queue: :default

  alias Accomplish.Activities
  alias Accomplish.Accounts

  @impl Oban.Worker
  def perform(%Oban.Job{
        args:
          %{
            "user_id" => user_id,
            "actor_id" => actor_id,
            "action" => action,
            "entity_id" => entity_id,
            "entity_type" => entity_type
          } = args
      }) do
    metadata = Map.get(args, "metadata", %{})
    context_id = Map.get(args, "context_id")
    context_type = Map.get(args, "context_type")

    with {:ok, user} <- fetch_user(user_id),
         {:ok, actor} <- fetch_actor(actor_id),
         {:ok, entity} <- Activities.fetch_entity(entity_id, entity_type),
         {:ok, context} <- fetch_optional_context(context_id, context_type) do
      Activities.log_activity(
        user,
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

  # Add this helper function to properly handle user fetching
  defp fetch_user(user_id) do
    case Accounts.get_user(user_id) do
      nil -> {:error, "User not found (ID: #{user_id})"}
      user -> {:ok, user}
    end
  end

  defp fetch_actor(actor_id) do
    case Accounts.get_user(actor_id) do
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
