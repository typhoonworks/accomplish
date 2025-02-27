defmodule Accomplish.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.Activities` context.
  """

  alias Accomplish.Activities

  @doc """
  Generates an activity log entry.
  """
  def activity_fixture(actor, target, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        actor_id: actor.id,
        actor_type: "User",
        action: "job_application.created",
        metadata: %{},
        target_id: target.id,
        target_type: "JobApplications.Application"
      })

    {:ok, activity} = Activities.log_activity(actor, attrs.action, target, attrs.metadata)

    activity
  end
end
