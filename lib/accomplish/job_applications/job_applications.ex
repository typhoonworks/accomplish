defmodule Accomplish.JobApplications do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.JobApplications.Application
  alias Accomplish.JobApplications.ApplicationForm
  alias Accomplish.JobApplications.Companies
  alias Accomplish.JobApplications.Stage

  def list_user_applications(user, filter \\ "all") do
    query =
      from a in Application,
        where: a.applicant_id == ^user.id,
        preload: [:company]

    query =
      case filter do
        "active" ->
          active_statuses = [:applied, :interviewing, :offer]
          from a in query, where: a.status in ^active_statuses

        _ ->
          query
      end

    Repo.all(query)
  end

  def create_application(applicant, attrs) do
    with {:ok, form_changeset} <- validate_application_form(attrs),
         {:ok, company} <- Companies.get_or_create(form_changeset.changes.company_name),
         changeset <- Application.create_changeset(company, applicant, form_changeset.changes),
         {:ok, job_application} <- Repo.insert(changeset) do
      {:ok, job_application}
    else
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp validate_application_form(attrs) do
    changeset = change_application_form(attrs)

    if changeset.valid? do
      {:ok, changeset}
    else
      {:error, changeset}
    end
  end

  def change_application_form(attrs \\ %{}) do
    ApplicationForm.changeset(attrs)
  end

  def add_stage(application, attrs) do
    Stage.create_changeset(application, attrs)
    |> Repo.insert()
  end
end
