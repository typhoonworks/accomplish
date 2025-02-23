defmodule Accomplish.JobApplicationsTest do
  use Accomplish.DataCase

  alias Accomplish.JobApplications
  alias Accomplish.JobApplications.Application

  describe "get_application!/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      %{applicant: applicant, application: application}
    end

    test "returns the application with preloaded associations", %{application: application} do
      fetched_application = JobApplications.get_application!(application.id, [:company])
      assert fetched_application.id == application.id
      assert fetched_application.company != nil
    end

    test "raises error when the application is not found" do
      non_existent_id = UUIDv7.generate()

      assert_raise Ecto.NoResultsError, fn ->
        JobApplications.get_application!(non_existent_id)
      end
    end
  end

  describe "list_user_applications/1" do
    setup do
      applicant = user_fixture()

      job_apps = [
        %{
          role: "Software Engineer",
          status: :applied,
          applied_at: DateTime.utc_now(),
          company_name: "Acme Corp"
        },
        %{
          role: "Backend Engineer",
          status: :interviewing,
          applied_at: DateTime.utc_now(),
          company_name: "Globex"
        },
        %{
          role: "Frontend Engineer",
          status: :rejected,
          applied_at: DateTime.utc_now(),
          company_name: "Hooli"
        }
      ]

      for attrs <- job_apps do
        {:ok, _job} = JobApplications.create_application(applicant, attrs)
      end

      %{applicant: applicant}
    end

    test "returns all job applications for the given user", %{applicant: applicant} do
      job_apps = JobApplications.list_user_applications(applicant)

      assert length(job_apps) == 3
      assert Enum.all?(job_apps, fn app -> app.applicant_id == applicant.id end)
    end

    test "returns an empty list when user has no applications" do
      another_user = user_fixture()

      job_apps = JobApplications.list_user_applications(another_user)

      assert job_apps == []
    end
  end

  describe "create_application/2" do
    setup do
      %{applicant: user_fixture()}
    end

    test "creates a job application with valid data", %{applicant: applicant} do
      valid_attrs = %{
        role: "Software Engineer",
        status: :applied,
        applied_at: DateTime.utc_now(),
        company_name: "Tech Corp"
      }

      {:ok, job_application} =
        JobApplications.create_application(applicant, valid_attrs)

      assert job_application.role == "Software Engineer"
      assert job_application.status == :applied
      assert job_application.company.name == "Tech Corp"
      assert job_application.applicant_id == applicant.id
    end

    test "returns an error when company_name is missing", %{applicant: applicant} do
      invalid_attrs = %{}

      {:error, changeset} = JobApplications.create_application(applicant, invalid_attrs)

      assert changeset.valid? == false
      assert "can't be blank" in errors_on(changeset).company_name
    end

    test "returns an error when required fields are missing", %{applicant: applicant} do
      invalid_attrs = %{company_name: "Typhoon"}

      {:error, changeset} = JobApplications.create_application(applicant, invalid_attrs)

      assert changeset.valid? == false
      assert "can't be blank" in errors_on(changeset).role
      assert "can't be blank" in errors_on(changeset).applied_at
    end
  end

  describe "update_application/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      %{applicant: applicant, application: application}
    end

    test "successfully updates an application and broadcasts the diff", %{
      application: application
    } do
      update_attrs = %{role: "Senior Software Engineer", status: :interviewing}

      {:ok, updated_application} = JobApplications.update_application(application, update_attrs)

      assert updated_application.role == "Senior Software Engineer"
      assert updated_application.status == :interviewing
    end

    test "returns an error when given invalid attributes", %{application: application} do
      update_attrs = %{role: nil}
      {:error, changeset} = JobApplications.update_application(application, update_attrs)
      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).role
    end
  end

  describe "delete_application/1" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)

      %{applicant: applicant, application: application}
    end

    test "successfully deletes a job application", %{application: application} do
      assert {:ok, _deleted_application} = JobApplications.delete_application(application.id)

      assert Repo.get(Accomplish.JobApplications.Application, application.id) == nil
    end

    test "returns an error when application is not found" do
      non_existent_id = UUIDv7.generate()

      assert {:error, :not_found} = JobApplications.delete_application(non_existent_id)
    end
  end

  describe "add_stage/2" do
    setup do
      applicant = user_fixture()
      %{application: job_application_fixture(applicant)}
    end

    test "adds a stage to an application", %{application: application} do
      stage_attrs = %{
        title: "Technical Interview",
        type: :interview
      }

      {:ok, stage} = JobApplications.add_stage(application, stage_attrs)

      assert stage.title == "Technical Interview"
      assert stage.type == :interview
      assert stage.application_id == application.id
    end

    test "increments stages_count when a stage is added", %{application: application} do
      assert application.stages_count == 0

      {:ok, _stage} =
        JobApplications.add_stage(application, %{title: "Screening", type: :interview})

      application = Repo.get!(Application, application.id)
      assert application.stages_count == 1
    end

    test "increments stages_count and assigns sequential positions when multiple stages are added",
         %{
           application: application
         } do
      assert application.stages_count == 0

      {:ok, stage1} =
        JobApplications.add_stage(application, %{title: "Screening", type: :interview})

      assert stage1.position == 1

      {:ok, stage2} =
        JobApplications.add_stage(application, %{title: "Technical Interview", type: :interview})

      assert stage2.position == 2

      {:ok, stage3} =
        JobApplications.add_stage(application, %{title: "Final Interview", type: :interview})

      application = Repo.get!(Application, application.id)
      assert application.stages_count == 3
      assert stage3.position == 3
    end

    test "sets current_stage_id when first stage is added", %{application: application} do
      assert application.current_stage_id == nil

      {:ok, stage} =
        JobApplications.add_stage(application, %{title: "Recruiter Screen", type: :screening})

      application = Repo.get!(Application, application.id)
      assert application.current_stage_id == stage.id
    end

    test "does not overwrite current_stage_id when adding more stages", %{
      application: application
    } do
      {:ok, stage1} =
        JobApplications.add_stage(application, %{title: "First Stage", type: :screening})

      initial_stage_id = stage1.id

      {:ok, _stage2} =
        JobApplications.add_stage(application, %{title: "Second Stage", type: :interview})

      application = Repo.get!(Application, application.id)
      assert application.current_stage_id == initial_stage_id
    end

    test "returns an error when required fields are missing", %{application: application} do
      invalid_attrs = %{}

      {:error, changeset} = JobApplications.add_stage(application, invalid_attrs)

      assert changeset.valid? == false
      assert "can't be blank" in errors_on(changeset).title
      assert "can't be blank" in errors_on(changeset).type
    end
  end
end
