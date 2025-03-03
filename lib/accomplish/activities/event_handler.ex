defmodule Accomplish.Activities.EventHandler do
  @moduledoc """
  Listens for events and logs corresponding activities.
  """

  use GenServer
  require Logger

  alias Accomplish.JobApplications.Events
  alias Accomplish.Activities

  @pubsub Accomplish.PubSub
  @events_topic "events:all"

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Phoenix.PubSub.subscribe(@pubsub, @events_topic)
    {:ok, nil}
  end

  # =============================
  # EVENT HANDLING
  # =============================

  def handle_info({_, %Events.NewJobApplication{} = event}, state) do
    log_activity(event.application.applicant_id, event.name, event.application)
    {:noreply, state}
  end

  def handle_info({_, %Events.JobApplicationStatusUpdated{} = event}, state) do
    log_activity(event.application.applicant_id, event.name, event.application,
      metadata: %{from: event.from, to: event.to}
    )

    {:noreply, state}
  end

  def handle_info({_, %Events.JobApplicationNewStage{} = event}, state) do
    log_activity(event.application.applicant_id, event.name, event.stage,
      context: event.application
    )

    {:noreply, state}
  end

  def handle_info({_, %Events.JobApplicationCurrentStageUpdated{} = event}, state) do
    log_activity(event.application.applicant_id, event.name, event.application,
      metadata: %{from: event.from.title, to: event.to.title}
    )

    {:noreply, state}
  end

  def handle_info({_, %Events.JobApplicationStageStatusUpdated{} = event}, state) do
    log_activity(event.application.applicant_id, event.name, event.stage,
      metadata: %{from: event.from, to: event.to},
      context: event.application
    )

    {:noreply, state}
  end

  def handle_info({_, %Events.JobApplicationStageDeleted{} = event}, state) do
    log_activity(event.application.applicant_id, event.name, event.stage,
      context: event.application
    )

    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.warning("Activities.EventHandler: Unhandled event received: #{inspect(msg)}")
    {:noreply, state}
  end

  # =============================
  # LOGGING ACTIVITY
  # =============================

  defp log_activity(actor_id, action, entity, opts \\ []) do
    metadata = Keyword.get(opts, :metadata, %{})
    occurred_at = Keyword.get(opts, :occurred_at, DateTime.utc_now())
    context = Keyword.get(opts, :context, nil)

    entity_type = Activities.get_entity_type(entity)
    context_type = Activities.get_context_type(context)

    %{
      "actor_id" => actor_id,
      "action" => action,
      "entity_id" => entity.id,
      "entity_type" => entity_type,
      "context_id" => context && context.id,
      "context_type" => context_type,
      "metadata" => metadata,
      "occurred_at" => occurred_at
    }
    |> Accomplish.Activities.Worker.new()
    |> Oban.insert()
  end
end
