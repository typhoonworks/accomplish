defmodule Accomplish.JobApplications.ImporterTest do
  use Accomplish.DataCase, async: true

  alias Accomplish.JobApplications.Importer

  setup do
    user = user_fixture()
    {:ok, user: user}
  end

  describe "import_job_details/2" do
    test "successfully imports job details with valid data", %{user: user} do
      job_details = %{
        "source_url" => "https://example.com/job/123",
        "role" => "Software Developer",
        "apply_url" => "https://company.com/apply",
        "job_description" => "Exciting job opportunity",
        "employment_type" => "full_time",
        "workplace_type" => "remote",
        "compensation_details" => "Competitive salary",
        "company" => %{
          "name" => "Acme Corp",
          "website_url" => "https://acme.com"
        }
      }

      assert {:ok, application} = Importer.import_job_details(user, job_details)

      assert application.role == "Software Developer"
      assert application.source == "https://example.com/job/123"
      assert application.apply_url == "https://company.com/apply"
      assert application.job_description == "Exciting job opportunity"
      assert application.employment_type == :full_time
      assert application.workplace_type == :remote
      assert application.compensation_details == "Competitive salary"
      assert application.company.name == "Acme Corp"
      assert application.company.website_url == "https://acme.com"
      assert application.status == :draft
    end

    test "imports job details with missing optional fields", %{user: user} do
      job_details = %{
        "source_url" => "https://example.com/job/456",
        "apply_url" => "https://company.com/apply",
        "job_description" => "Job description",
        "employment_type" => "part_time",
        "workplace_type" => "hybrid",
        "compensation_details" => "Details",
        "company" => %{
          "website_url" => "https://company.com"
        }
      }

      assert {:ok, application} = Importer.import_job_details(user, job_details)
      assert application.role == "Unknown Role"
      assert application.company.name == "Unknown Company"
    end

    test "normalizes invalid URL for apply_url to nil", %{user: user} do
      job_details = %{
        "source_url" => "https://example.com/job/789",
        "role" => "Tester",
        "apply_url" => "invalid-url",
        "job_description" => "Test job",
        "employment_type" => "internship",
        "workplace_type" => "on_site",
        "compensation_details" => "Stipend",
        "company" => %{
          "name" => "Test Company",
          "website_url" => "https://test.com"
        }
      }

      assert {:ok, application} = Importer.import_job_details(user, job_details)
      assert application.apply_url == nil
    end

    test "normalizes enum fields for employment_type and workplace_type", %{user: user} do
      job_details = %{
        "source_url" => "https://example.com/job/101",
        "role" => "Engineer",
        "apply_url" => "https://apply.com",
        "job_description" => "Engineering job",
        "employment_type" => "Full Time",
        "workplace_type" => "Hybrid",
        "compensation_details" => "Competitive",
        "company" => %{
          "name" => "Engineering Inc",
          "website_url" => "https://engineering.com"
        }
      }

      assert {:ok, application} = Importer.import_job_details(user, job_details)
      assert application.employment_type == :full_time
      assert application.workplace_type == :hybrid
    end

    test "returns error when company creation fails due to missing required fields", %{user: user} do
      job_details = %{}

      assert {:error, {:import_failed, changeset}} =
               Importer.import_job_details(user, job_details)

      assert "can't be blank" in errors_on(changeset).workplace_type
    end

    test "returns error when invalid enum value provided for workplace_type", %{user: user} do
      job_details = %{
        "source_url" => "https://example.com/job/222",
        "role" => "Designer",
        "apply_url" => "https://apply.com",
        "job_description" => "Design job",
        "employment_type" => "full_time",
        "workplace_type" => "invalid",
        "compensation_details" => "Competitive",
        "company" => %{
          "name" => "Design Co",
          "website_url" => "https://designco.com"
        }
      }

      assert {:error, {:import_failed, changeset}} =
               Importer.import_job_details(user, job_details)

      assert "can't be blank" in errors_on(changeset).workplace_type
    end
  end
end
