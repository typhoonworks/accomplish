defmodule Accomplish.Activities.EventHandler do
  @moduledoc """
  Listens for job application events and logs corresponding activities.
  """

  use GenServer
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

  def handle_info({_, %Events.NewJobApplication{} = event}, state) do
    log_activity(event.application.applicant_id, event.name, event.application)
    {:noreply, state}
  end

  def handle_info({_, %Events.JobApplicationUpdated{} = event}, state) do
    log_activity(event.application.applicant_id, event.name, event.application, event.diff)
    {:noreply, state}
  end

  def handle_info({_, %Events.CurrentJobApplicationStageUpdated{} = event}, state) do
    metadata = %{from: event.from.title, to: event.to.title}
    log_activity(event.application.applicant_id, event.name, event.application, metadata)
    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  defp log_activity(actor_id, action, target, metadata \\ %{}) do
    target_type = Activities.get_target_type(target)

    %{
      "actor_id" => actor_id,
      "action" => action,
      "target_id" => target.id,
      "target_type" => target_type,
      "metadata" => metadata
    }
    |> Accomplish.Activities.Worker.new()
    |> Oban.insert()
  end
end
