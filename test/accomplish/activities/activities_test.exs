defmodule Accomplish.ActivitiesTest do
  use Accomplish.DataCase

  alias Accomplish.Activities

  defmodule FakeStruct do
    defstruct []
  end

  describe "log_activity/5" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      stage = job_application_stage_fixture(application)
      %{applicant: applicant, application: application, stage: stage}
    end

    test "successfully logs an activity", %{applicant: applicant, application: application} do
      metadata = %{old_status: "Applied", new_status: "Interviewing"}

      {:ok, activity} =
        Activities.log_activity(
          applicant,
          "job_application.status_updated",
          application,
          metadata
        )

      assert activity.actor_id == applicant.id
      assert activity.actor_type == "User"
      assert activity.action == "job_application.status_updated"
      assert activity.entity_id == application.id
      assert activity.entity_type == "JobApplications.Application"
      # No context
      assert is_nil(activity.context_id)
      assert activity.metadata == metadata
    end

    test "logs an activity with a context", %{
      applicant: applicant,
      stage: stage,
      application: application
    } do
      metadata = %{from: "pending", to: "scheduled"}

      {:ok, activity} =
        Activities.log_activity(
          applicant,
          "job_application.stage_status_updated",
          stage,
          metadata,
          DateTime.utc_now(),
          application
        )

      assert activity.entity_id == stage.id
      assert activity.entity_type == "JobApplications.Stage"
      assert activity.context_id == application.id
      assert activity.context_type == "JobApplications.Application"
    end

    test "fails when actor is unrecognized", %{application: application} do
      invalid_actor = %{id: UUIDv7.generate()}

      assert {:error, "Invalid actor: Unrecognized actor type"} =
               Activities.log_activity(invalid_actor, "job_application.created", application, %{})
    end

    test "returns an error when required fields are missing", %{
      applicant: applicant,
      application: application
    } do
      assert {:error, changeset} = Activities.log_activity(applicant, nil, application, %{})
      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).action
    end

    test "logs an activity with an empty metadata map", %{
      applicant: applicant,
      application: application
    } do
      {:ok, activity} =
        Activities.log_activity(applicant, "job_application.created", application, %{})

      assert activity.metadata == %{}
    end

    test "ensures entity_type is correctly formatted", %{
      applicant: applicant,
      application: application
    } do
      {:ok, activity} =
        Activities.log_activity(applicant, "job_application.created", application, %{})

      assert activity.entity_type == "JobApplications.Application"
    end

    test "logs multiple activities for the same entity", %{
      applicant: applicant,
      application: application
    } do
      {:ok, activity1} =
        Activities.log_activity(applicant, "job_application.created", application, %{})

      {:ok, activity2} =
        Activities.log_activity(applicant, "job_application.status_updated", application, %{
          old_status: "applied",
          new_status: "interviewing"
        })

      assert activity1.entity_id == application.id
      assert activity2.entity_id == application.id
      assert activity1.action == "job_application.created"
      assert activity2.action == "job_application.status_updated"
    end
  end

  describe "fetch_entity/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      %{application: application}
    end

    test "retrieves an existing entity", %{application: application} do
      assert {:ok, fetched_application} =
               Activities.fetch_entity(application.id, "JobApplications.Application")

      assert fetched_application.id == application.id
    end

    test "returns an error for an unknown entity type" do
      assert {:error, "Unknown entity type: Unknown.Type"} =
               Activities.fetch_entity(UUIDv7.generate(), "Unknown.Type")
    end

    test "returns an error for a non-existent entity ID" do
      non_existent_id = UUIDv7.generate()

      assert {:error, message} =
               Activities.fetch_entity(non_existent_id, "JobApplications.Application")

      assert message =~ "Entity not found (JobApplications.Application, ID: #{non_existent_id})"
    end
  end

  describe "get_entity_type/1" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      %{application: application}
    end

    test "returns the correct type for a known entity", %{application: application} do
      assert Activities.get_entity_type(application) == "JobApplications.Application"
    end

    test "returns an error for an unrecognized struct" do
      assert Activities.get_entity_type(%FakeStruct{}) == {:error, "Unknown entity type"}
    end

    test "returns an error when given a non-struct value" do
      assert Activities.get_entity_type(%{}) == {:error, "Invalid entity: Expected a struct"}
      assert Activities.get_entity_type(123) == {:error, "Invalid entity: Expected a struct"}

      assert Activities.get_entity_type("invalid") ==
               {:error, "Invalid entity: Expected a struct"}
    end
  end

  describe "list_activities_for_entity_or_context/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      stage = job_application_stage_fixture(application)

      timestamp_1 = DateTime.utc_now()
      timestamp_2 = DateTime.add(timestamp_1, 1, :second)

      {:ok, _activity1} =
        Activities.log_activity(
          applicant,
          "job_application.created",
          application,
          %{},
          timestamp_1
        )

      {:ok, _activity2} =
        Activities.log_activity(
          applicant,
          "job_application.stage_updated",
          stage,
          %{
            old_status: "Applied",
            new_status: "Interviewing"
          },
          timestamp_2,
          application
        )

      %{applicant: applicant, application: application, stage: stage}
    end

    test "retrieves activities for an entity", %{application: application} do
      activities = Activities.list_activities_for_entity_or_context(application)

      assert length(activities) == 2
      assert activities |> Enum.at(0) |> Map.get(:action) == "job_application.stage_updated"
      assert activities |> Enum.at(1) |> Map.get(:action) == "job_application.created"
    end

    test "retrieves activities for an entity or its context", %{
      application: application,
      stage: stage
    } do
      activities_for_stage = Activities.list_activities_for_entity_or_context(stage)
      activities_for_app = Activities.list_activities_for_entity_or_context(application)

      assert length(activities_for_stage) == 1
      assert activities_for_stage |> hd() |> Map.get(:action) == "job_application.stage_updated"

      assert length(activities_for_app) == 2
    end

    test "preloads actors when requested", %{application: application, applicant: applicant} do
      activities = Activities.list_activities_for_entity_or_context(application, true)

      assert length(activities) == 2
      assert activities |> hd() |> Map.has_key?(:actor)
      assert activities |> hd() |> Map.get(:actor) == applicant
    end
  end
end
