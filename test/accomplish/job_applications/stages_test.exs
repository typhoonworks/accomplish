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
      assert {:ok, found_stage} = Stages.get_by_slug(stage.slug, job_application.id)
      assert found_stage.id == stage.id
    end

    test "returns :error when stage does not exist", %{job_application: job_application} do
      assert :error = Stages.get_by_slug("non-existent", job_application.id)
    end

    test "does not return a stage from a different application", %{
      other_application: other_application,
      stage: stage
    } do
      assert :error = Stages.get_by_slug(stage.slug, other_application.id)
    end
  end

  describe "soft delete functionality" do
    setup do
      applicant = user_fixture()
      job_application = job_application_fixture(applicant)
      soft_deleted_stage = soft_deleted_job_application_stage_fixture(job_application)

      %{
        job_application: job_application,
        soft_deleted_stage: soft_deleted_stage
      }
    end

    test "get/3 doesn't return soft deleted stage by default", %{
      job_application: job_application,
      soft_deleted_stage: soft_deleted_stage
    } do
      assert nil == Stages.get(soft_deleted_stage.id, job_application.id)
    end

    test "get/4 returns soft deleted stage when with_deleted: true", %{
      job_application: job_application,
      soft_deleted_stage: soft_deleted_stage
    } do
      found_stage =
        Stages.get(soft_deleted_stage.id, job_application.id, [], with_deleted: true)

      assert found_stage.id == soft_deleted_stage.id
      assert not is_nil(found_stage.deleted_at)
    end

    test "get_by_slug/3 doesn't return soft deleted stage by default", %{
      job_application: job_application,
      soft_deleted_stage: soft_deleted_stage
    } do
      assert :error = Stages.get_by_slug(soft_deleted_stage.slug, job_application.id)
    end

    test "get_by_slug/4 returns soft deleted stage when with_deleted: true", %{
      job_application: job_application,
      soft_deleted_stage: soft_deleted_stage
    } do
      assert {:ok, found_stage} =
               Stages.get_by_slug(soft_deleted_stage.slug, job_application.id, [],
                 with_deleted: true
               )

      assert found_stage.id == soft_deleted_stage.id
      assert not is_nil(found_stage.deleted_at)
    end

    test "get!/3 raises for soft deleted stage by default", %{
      job_application: job_application,
      soft_deleted_stage: soft_deleted_stage
    } do
      assert_raise Ecto.NoResultsError, fn ->
        Stages.get!(soft_deleted_stage.id, job_application.id)
      end
    end

    test "get!/4 returns soft deleted stage when with_deleted: true", %{
      job_application: job_application,
      soft_deleted_stage: soft_deleted_stage
    } do
      found_stage =
        Stages.get!(soft_deleted_stage.id, job_application.id, with_deleted: true)

      assert found_stage.id == soft_deleted_stage.id
      assert not is_nil(found_stage.deleted_at)
    end

    test "list_for_application/2 doesn't include soft deleted stages by default", %{
      job_application: job_application
    } do
      visible_stage = job_application_stage_fixture(job_application)

      stages = Stages.list_for_application(job_application.id)

      assert length(stages) == 1
      assert hd(stages).id == visible_stage.id
    end

    test "list_for_application/3 includes soft deleted stages when with_deleted: true", %{
      job_application: job_application,
      soft_deleted_stage: soft_deleted_stage
    } do
      visible_stage = job_application_stage_fixture(job_application)

      stages = Stages.list_for_application(job_application.id, [], with_deleted: true)

      assert length(stages) == 2

      deleted_stage = Enum.find(stages, &(&1.id == soft_deleted_stage.id))
      assert not is_nil(deleted_stage)
      assert not is_nil(deleted_stage.deleted_at)

      visible = Enum.find(stages, &(&1.id == visible_stage.id))
      assert not is_nil(visible)
      assert is_nil(visible.deleted_at)
    end

    test "deleted?/1 correctly identifies deleted and non-deleted stages", %{
      soft_deleted_stage: soft_deleted_stage
    } do
      new_application = job_application_fixture(user_fixture())
      visible_stage = job_application_stage_fixture(new_application)

      assert Stages.deleted?(soft_deleted_stage)
      refute Stages.deleted?(visible_stage)
      refute Stages.deleted?(nil)
    end
  end
end
