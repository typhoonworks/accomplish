defmodule Accomplish.Activities do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.Activities.Activity
  alias Accomplish.Activities.Events

  @target_modules %{
    "JobApplications.Application" => Accomplish.JobApplications.Application,
    "Accounts.User" => Accomplish.Accounts.User
  }

  @target_names %{
    Accomplish.JobApplications.Application => "JobApplications.Application",
    Accomplish.Accounts.User => "Accounts.User"
  }

  @pubsub Accomplish.PubSub
  @activities_topic "activities"

  def fetch_target(target_id, target_type) do
    case Map.get(@target_modules, target_type) do
      nil ->
        {:error, "Unknown target type: #{target_type}"}

      module ->
        case Repo.get(module, target_id) do
          nil -> {:error, "Target not found (#{target_type}, ID: #{target_id})"}
          target -> {:ok, target}
        end
    end
  end

  def get_target_type(%{__struct__: struct}) do
    case Map.get(@target_names, struct) do
      nil -> {:error, "Unknown target type"}
      type -> type
    end
  end

  def get_target_type(_), do: {:error, "Invalid target: Expected a struct"}

  def log_activity(actor, action, target, metadata \\ %{}, occurred_at \\ DateTime.utc_now()) do
    case get_actor_type(actor) do
      {:ok, actor_type} ->
        result =
          %Activity{}
          |> Activity.changeset(%{
            actor_id: actor.id,
            actor_type: actor_type,
            action: action,
            metadata: metadata,
            target_id: target.id,
            target_type: get_target_type(target),
            occurred_at: occurred_at
          })
          |> Repo.insert()

        with {:ok, activity} <- result do
          broadcast_activity_logged(activity, actor, target)

          {:ok, activity}
        end

      {:error, reason} ->
        {:error, "Invalid actor: #{reason}"}
    end
  end

  def list_activities_for_target(target, preload_actors \\ false) do
    target_type = get_target_type(target)

    query =
      from(a in Activity,
        where: a.target_type == ^target_type and a.target_id == ^target.id,
        order_by: [desc: a.occurred_at]
      )

    query =
      if preload_actors do
        preload_actors(query)
      else
        query
      end

    Repo.all(query)
    |> Enum.map(&Map.put(&1, :target, target))
  end

  defp preload_actors(query) do
    query
    |> join(:left, [a], u in Accomplish.Accounts.User,
      on: a.actor_id == u.id and a.actor_type == "User"
    )
    |> select_merge([a, u], %{actor: u})
  end

  defp get_actor_type(%Accomplish.Accounts.User{}), do: {:ok, "User"}
  defp get_actor_type(_), do: {:error, "Unrecognized actor type"}

  defp broadcast_activity_logged(activity, actor, target) do
    broadcast!(
      %Events.NewActivity{
        activity: activity,
        actor: actor,
        target: target
      },
      target.id
    )
  end

  defp broadcast!(msg, target_id) do
    Phoenix.PubSub.broadcast!(@pubsub, @activities_topic <> ":#{target_id}", {__MODULE__, msg})
  end
end
