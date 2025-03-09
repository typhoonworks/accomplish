defmodule Accomplish.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.Activities` context.
  """

  alias Accomplish.Activities

  @doc """
  Generates an activity log entry.
  """
  def activity_fixture(actor, entity, attrs \\ %{}) do
    user = actor
    action = Map.get(attrs, :action, "job_application.created")
    metadata = Map.get(attrs, :metadata, %{})
    occurred_at = Map.get(attrs, :occurred_at, DateTime.utc_now())
    context = Map.get(attrs, :context, nil)

    {:ok, activity} =
      Activities.log_activity(user, actor, action, entity, metadata, occurred_at, context)

    activity
  end
end
