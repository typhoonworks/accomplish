defmodule Accomplish.JobApplications.StagesTest do
  use Accomplish.DataCase

  alias Accomplish.JobApplications.Application
  alias Accomplish.JobApplications.Stages

  describe "create/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)

      %{application: application}
    end

    test "creates a stage and assigns the correct position", %{application: application} do
      assert application.stages_count == 0

      {:ok, stage} = Stages.create(application, %{title: "Screening", type: :interview})
      assert stage.position == 1

      application = Repo.get!(Application, application.id)
      assert application.stages_count == 1
    end

    test "creates multiple stages with sequential positions", %{application: application} do
      {:ok, stage1} = Stages.create(application, %{title: "Phone Screen", type: :screening})

      {:ok, stage2} =
        Stages.create(application, %{title: "Technical Interview", type: :interview})

      assert stage1.position == 1
      assert stage2.position == 2

      application = Repo.get!(Application, application.id)
      assert application.stages_count == 2
    end

    test "sets current_stage_id when first stage is created", %{application: application} do
      assert application.current_stage_id == nil

      {:ok, stage} = Stages.create(application, %{title: "Recruiter Screen", type: :screening})

      application = Repo.get!(Application, application.id)
      assert application.current_stage_id == stage.id
    end

    test "does not overwrite current_stage_id when adding more stages", %{
      application: application
    } do
      {:ok, stage1} = Stages.create(application, %{title: "First Stage", type: :screening})
      initial_stage_id = stage1.id

      {:ok, _stage2} = Stages.create(application, %{title: "Second Stage", type: :interview})

      application = Repo.get!(Application, application.id)
      assert application.current_stage_id == initial_stage_id
    end
  end
end
