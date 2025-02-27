defmodule Accomplish.JobApplications.StagesTest do
  use Accomplish.DataCase

  alias Accomplish.JobApplications.Stages

  describe "get_by_slug/3" do
    setup do
      applicant = user_fixture()
      job_application = job_application_fixture(applicant)
      stage = job_application_stage_fixture(job_application)

      other_application = job_application_fixture(applicant)
      other_stage = job_application_stage_fixture(other_application)

      %{
        job_application: job_application,
        stage: stage,
        other_application: other_application,
        other_stage: other_stage
      }
    end

    test "returns the correct stage by slug", %{job_application: job_application, stage: stage} do
      assert {:ok, found_stage} = Stages.get_by_slug(job_application, stage.slug)
      assert found_stage.id == stage.id
    end

    test "returns :error when stage does not exist", %{job_application: job_application} do
      assert :error = Stages.get_by_slug(job_application, UUIDv7.generate())
    end

    test "does not return a stage from a different application", %{
      other_application: other_application,
      stage: stage
    } do
      assert :error = Stages.get_by_slug(other_application, stage.slug)
    end
  end
end
