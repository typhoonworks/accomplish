defmodule Accomplish.Activities do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.Activities.Activity
  alias Accomplish.Activities.Events

  @entity_modules %{
    "JobApplications.Application" => Accomplish.JobApplications.Application,
    "JobApplications.Stage" => Accomplish.JobApplications.Stage,
    "Accounts.User" => Accomplish.Accounts.User
  }

  @entity_names %{
    Accomplish.JobApplications.Application => "JobApplications.Application",
    Accomplish.JobApplications.Stage => "JobApplications.Stage",
    Accomplish.Accounts.User => "Accounts.User"
  }

  @pubsub Accomplish.PubSub
  @activities_topic "activities"

  # ===========================
  # FETCH ENTITY & CONTEXT HELPERS
  # ===========================

  def fetch_entity(entity_id, entity_type) do
    case Map.get(@entity_modules, entity_type) do
      nil ->
        {:error, "Unknown entity type: #{entity_type}"}

      module ->
        case Repo.get(module, entity_id) do
          nil -> {:error, "Entity not found (#{entity_type}, ID: #{entity_id})"}
          entity -> {:ok, entity}
        end
    end
  end

  def get_entity_type(%{__struct__: struct}) do
    Map.get(@entity_names, struct, {:error, "Unknown entity type"})
  end

  def get_entity_type(_), do: {:error, "Invalid entity: Expected a struct"}

  def get_context_type(nil), do: nil

  def get_context_type(%{__struct__: struct}),
    do: Map.get(@entity_names, struct, {:error, "Unknown context type"})

  def get_context_type(_), do: {:error, "Invalid context: Expected a struct"}

  # ===========================
  # LOGGING ACTIVITIES
  # ===========================

  def log_activity(
        actor,
        action,
        entity,
        metadata \\ %{},
        occurred_at \\ DateTime.utc_now(),
        context \\ nil
      ) do
    case get_actor_type(actor) do
      {:ok, actor_type} ->
        entity_type = get_entity_type(entity)
        context_type = get_context_type(context)

        result =
          %Activity{}
          |> Activity.changeset(%{
            actor_id: actor.id,
            actor_type: actor_type,
            action: action,
            metadata: metadata,
            entity_id: entity.id,
            entity_type: entity_type,
            context_id: context && context.id,
            context_type: context_type,
            occurred_at: occurred_at
          })
          |> Repo.insert()

        with {:ok, activity} <- result do
          broadcast_activity_logged(activity, actor, entity, context)
          {:ok, activity}
        end

      {:error, reason} ->
        {:error, "Invalid actor: #{reason}"}
    end
  end

  # ===========================
  # RETRIEVING ACTIVITIES
  # ===========================

  def list_activities_for_entity_or_context(entity_or_context) do
    type = get_entity_type(entity_or_context)

    # Base query for activities
    query =
      from(a in Activity,
        where:
          (a.entity_type == ^type and a.entity_id == ^entity_or_context.id) or
            (a.context_type == ^type and a.context_id == ^entity_or_context.id),
        order_by: [desc: a.occurred_at]
      )

    # Preload actors in the initial query
    query =
      query
      |> join(:left, [a], u in Accomplish.Accounts.User,
        on: a.actor_id == u.id and a.actor_type == "User"
      )
      |> select_merge([a, u], %{actor: u})

    # Get the activities with actors preloaded
    activities = Repo.all(query)

    # Preload entities and contexts in batches
    activities
    |> preload_entities()
    |> preload_contexts()
  end

  # Preload entities in a batch operation
  defp preload_entities(activities) do
    # Group activities by entity type
    activities_by_entity_type =
      Enum.group_by(activities, fn activity -> activity.entity_type end)

    # For each entity type, fetch the corresponding entities
    entities_by_type_and_id =
      activities_by_entity_type
      |> Enum.flat_map(fn {entity_type, activities} ->
        entity_ids = Enum.map(activities, & &1.entity_id)
        entity_module = Map.get(@entity_modules, entity_type)

        if entity_module do
          entities = Repo.all(from e in entity_module, where: e.id in ^entity_ids)
          [{entity_type, Enum.group_by(entities, & &1.id)}]
        else
          []
        end
      end)
      |> Map.new()

    # Assign the correct entity to each activity
    Enum.map(activities, fn activity ->
      entity =
        entities_by_type_and_id
        |> get_in([activity.entity_type, activity.entity_id])
        |> List.first()

      Map.put(activity, :entity, entity)
    end)
  end

  # Preload contexts in a batch operation
  defp preload_contexts(activities) do
    # Filter activities that have both context_id and context_type
    activities_with_context =
      Enum.filter(activities, fn activity ->
        not is_nil(activity.context_id) and not is_nil(activity.context_type)
      end)

    # Group activities by context type
    activities_by_context_type =
      Enum.group_by(activities_with_context, fn activity -> activity.context_type end)

    # For each context type, fetch the corresponding contexts
    contexts_by_type_and_id =
      activities_by_context_type
      |> Enum.flat_map(fn {context_type, activities} ->
        context_ids = Enum.map(activities, & &1.context_id)
        context_module = Map.get(@entity_modules, context_type)

        if context_module do
          contexts = Repo.all(from c in context_module, where: c.id in ^context_ids)
          [{context_type, Enum.group_by(contexts, & &1.id)}]
        else
          []
        end
      end)
      |> Map.new()

    # Assign the correct context to each activity
    Enum.map(activities, fn activity ->
      if not is_nil(activity.context_id) and not is_nil(activity.context_type) do
        context =
          contexts_by_type_and_id
          |> get_in([activity.context_type, activity.context_id])
          |> List.first()

        Map.put(activity, :context, context)
      else
        activity
      end
    end)
  end

  defp get_actor_type(%Accomplish.Accounts.User{}), do: {:ok, "User"}
  defp get_actor_type(_), do: {:error, "Unrecognized actor type"}

  # ===========================
  # BROADCASTING EVENTS
  # ===========================

  defp broadcast_activity_logged(activity, actor, entity, context) do
    broadcast!(
      %Events.NewActivity{
        activity: activity,
        actor: actor,
        entity: entity,
        context: context
      },
      entity.id
    )
  end

  defp broadcast!(msg, entity_id) do
    Phoenix.PubSub.broadcast!(@pubsub, @activities_topic <> ":#{entity_id}", {__MODULE__, msg})
  end
end
