defmodule Accomplish.JobApplicationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.JobApplications` context.
  """

  alias Accomplish.JobApplications
  alias Accomplish.Repo

  @doc """
  Generates a job application for a given applicant.
  """
  def job_application_fixture(applicant, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        role: "Senior Developer",
        status: :applied,
        applied_at: DateTime.utc_now(),
        company_name: "Typhoon Works"
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

  @doc """
  Generates a soft-deleted job application stage for a given application.
  """
  def soft_deleted_job_application_stage_fixture(application, attrs \\ %{}) do
    stage = job_application_stage_fixture(application, attrs)
    {:ok, soft_deleted_stage} = Repo.soft_delete(stage)
    soft_deleted_stage
  end
end
