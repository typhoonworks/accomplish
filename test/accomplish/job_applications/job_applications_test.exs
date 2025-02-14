defmodule Accomplish.JobApplicationsTest do
  use Accomplish.DataCase

  alias Accomplish.JobApplications

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
end
