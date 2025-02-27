defmodule Accomplish.JobApplicationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.JobApplications` context.
  """

  alias Accomplish.JobApplications

  def unique_company_name, do: "company-#{System.unique_integer()}"

  @doc """
  Generates a company.
  """
  def company_fixture(attrs \\ %{}) do
    attrs = Enum.into(attrs, %{name: unique_company_name()})

    {:ok, company} =
      Accomplish.JobApplications.Company.create_changeset(attrs)
      |> Accomplish.Repo.insert()

    company
  end

  @doc """
  Generates a job application for a given applicant.
  """
  def job_application_fixture(applicant, attrs \\ %{}) do
    company = company_fixture()

    attrs =
      Enum.into(attrs, %{
        role: "Senior Developer",
        status: :applied,
        applied_at: DateTime.utc_now(),
        company_name: company.name
      })

    {:ok, job_application} = JobApplications.create_application(applicant, attrs)

    job_application
  end

  @doc """
  Generates a job application stage for a given application.
  """
  def job_application_stage_fixture(application, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        title: "Technical Interview",
        type: :interview,
        position: 1,
        is_final_stage: false
      })

    {:ok, stage, _application} = JobApplications.add_stage(application, attrs)

    stage
  end
end
