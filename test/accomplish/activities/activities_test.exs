defmodule Accomplish.ActivitiesTest do
  use Accomplish.DataCase

  alias Accomplish.Activities

  defmodule FakeStruct do
    defstruct []
  end

  describe "log_activity/4" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      %{applicant: applicant, application: application}
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
      assert activity.target_id == application.id
      assert activity.target_type == "JobApplications.Application"
      assert activity.metadata == metadata
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

    test "ensures target_type is correctly formatted", %{
      applicant: applicant,
      application: application
    } do
      {:ok, activity} =
        Activities.log_activity(applicant, "job_application.created", application, %{})

      assert activity.target_type == "JobApplications.Application"
    end

    test "logs multiple activities for the same target", %{
      applicant: applicant,
      application: application
    } do
      {:ok, activity1} =
        Activities.log_activity(applicant, "job_application.created", application, %{})

      {:ok, activity2} =
        Activities.log_activity(applicant, "job_application.status_updated", application, %{
          old_status: "Applied",
          new_status: "Interviewing"
        })

      assert activity1.target_id == application.id
      assert activity2.target_id == application.id
      assert activity1.action == "job_application.created"
      assert activity2.action == "job_application.status_updated"
    end
  end

  describe "fetch_target/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      %{application: application}
    end

    test "retrieves an existing target", %{application: application} do
      assert {:ok, fetched_application} =
               Activities.fetch_target(application.id, "JobApplications.Application")

      assert fetched_application.id == application.id
    end

    test "returns an error for an unknown target type" do
      assert {:error, "Unknown target type: Unknown.Type"} =
               Activities.fetch_target(UUIDv7.generate(), "Unknown.Type")
    end

    test "returns an error for a non-existent target ID" do
      non_existent_id = UUIDv7.generate()

      assert {:error, message} =
               Activities.fetch_target(non_existent_id, "JobApplications.Application")

      assert message =~ "Target not found (JobApplications.Application, ID: #{non_existent_id})"
    end
  end

  describe "get_target_type/1" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      %{application: application}
    end

    test "returns the correct type for a known target", %{application: application} do
      assert Activities.get_target_type(application) == "JobApplications.Application"
    end

    test "returns an error for an unrecognized struct" do
      assert Activities.get_target_type(%FakeStruct{}) == {:error, "Unknown target type"}
    end

    test "returns an error when given a non-struct value" do
      assert Activities.get_target_type(%{}) == {:error, "Invalid target: Expected a struct"}
      assert Activities.get_target_type(123) == {:error, "Invalid target: Expected a struct"}

      assert Activities.get_target_type("invalid") ==
               {:error, "Invalid target: Expected a struct"}
    end
  end

  describe "list_activities_for_target/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)

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
          "job_application.status_updated",
          application,
          %{
            old_status: "Applied",
            new_status: "Interviewing"
          },
          timestamp_2
        )

      %{applicant: applicant, application: application}
    end

    test "retrieves activities in descending order", %{application: application} do
      activities = Activities.list_activities_for_target(application)

      assert length(activities) == 2
      assert activities |> Enum.at(0) |> Map.get(:action) == "job_application.status_updated"
      assert activities |> Enum.at(1) |> Map.get(:action) == "job_application.created"
    end

    test "preloads actors when requested", %{application: application, applicant: applicant} do
      activities = Activities.list_activities_for_target(application, true)

      assert length(activities) == 2
      assert activities |> hd() |> Map.has_key?(:actor)
      assert activities |> hd() |> Map.get(:actor) == applicant
    end
  end
end
