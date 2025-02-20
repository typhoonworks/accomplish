defmodule Accomplish.JobApplicationsTest do
  use Accomplish.DataCase

  alias Accomplish.JobApplications

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
        type: :interview,
        position: 1,
        is_final_stage: false
      }

      {:ok, stage} = JobApplications.add_stage(application, stage_attrs)

      assert stage.title == "Technical Interview"
      assert stage.type == :interview
      assert stage.position == 1
      assert stage.is_final_stage == false
      assert stage.application_id == application.id
    end

    test "returns an error when required fields are missing", %{application: application} do
      invalid_attrs = %{}

      {:error, changeset} = JobApplications.add_stage(application, invalid_attrs)

      assert changeset.valid? == false
      assert "can't be blank" in errors_on(changeset).title
      assert "can't be blank" in errors_on(changeset).type
      assert "can't be blank" in errors_on(changeset).position
    end
  end
end
