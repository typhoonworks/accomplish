defmodule Accomplish.Workers.LogActivityWorkerTest do
  use Accomplish.DataCase, async: true

  alias Accomplish.Workers.LogActivityWorker

  describe "perform/1" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      stage = job_application_stage_fixture(application)

      valid_job_args = %{
        "user_id" => applicant.id,
        "actor_id" => applicant.id,
        "action" => "job_application.stage_added",
        "entity_id" => stage.id,
        "entity_type" => "JobApplications.Stage",
        "context_id" => application.id,
        "context_type" => "JobApplications.Application"
      }

      %{
        applicant: applicant,
        application: application,
        stage: stage,
        valid_job_args: valid_job_args
      }
    end

    test "successfully logs activity", %{valid_job_args: args} do
      job = %Oban.Job{args: args}

      assert :ok = LogActivityWorker.perform(job)

      activity =
        Accomplish.Repo.get_by(Accomplish.Activities.Activity,
          actor_id: args["actor_id"],
          entity_id: args["entity_id"]
        )

      assert activity
      assert activity.action == args["action"]
    end

    test "handles missing actor", %{valid_job_args: args} do
      args = Map.put(args, "actor_id", Ecto.UUID.generate())
      job = %Oban.Job{args: args}

      assert {:error, _reason} = LogActivityWorker.perform(job)
    end

    test "handles missing entity", %{valid_job_args: args} do
      args = Map.put(args, "entity_id", Ecto.UUID.generate())
      job = %Oban.Job{args: args}

      assert {:error, _reason} = LogActivityWorker.perform(job)
    end

    test "logs activity with context", %{valid_job_args: args, stage: stage} do
      args =
        args
        |> Map.put("context_id", stage.id)
        |> Map.put("context_type", "JobApplications.Stage")

      job = %Oban.Job{args: args}

      assert :ok = LogActivityWorker.perform(job)

      activity =
        Accomplish.Repo.get_by(Accomplish.Activities.Activity,
          actor_id: args["actor_id"],
          entity_id: args["entity_id"],
          context_id: stage.id
        )

      assert activity
      assert activity.context_type == "JobApplications.Stage"
    end
  end
end
