defmodule Accomplish.ActivitiesTest do
  use Accomplish.DataCase

  alias Accomplish.Activities

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
          "job_application:status_updated",
          application,
          metadata
        )

      assert activity.actor_id == applicant.id
      assert activity.actor_type == "User"
      assert activity.action == "job_application:status_updated"
      assert activity.target_id == application.id
      assert activity.target_type == "JobApplications.Application"
      assert activity.metadata == metadata
    end

    test "fails when actor is unrecognized", %{application: application} do
      invalid_actor = %{id: UUIDv7.generate()}

      assert {:error, "Invalid actor: Unrecognized actor type"} =
               Activities.log_activity(invalid_actor, "job_application:created", application, %{})
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
        Activities.log_activity(applicant, "job_application:created", application, %{})

      assert activity.metadata == %{}
    end

    test "ensures target_type is correctly formatted", %{
      applicant: applicant,
      application: application
    } do
      {:ok, activity} =
        Activities.log_activity(applicant, "job_application:created", application, %{})

      assert activity.target_type == "JobApplications.Application"
    end

    test "logs multiple activities for the same target", %{
      applicant: applicant,
      application: application
    } do
      {:ok, activity1} =
        Activities.log_activity(applicant, "job_application:created", application, %{})

      {:ok, activity2} =
        Activities.log_activity(applicant, "job_application:status_updated", application, %{
          old_status: "Applied",
          new_status: "Interviewing"
        })

      assert activity1.target_id == application.id
      assert activity2.target_id == application.id
      assert activity1.action == "job_application:created"
      assert activity2.action == "job_application:status_updated"
    end
  end
end
