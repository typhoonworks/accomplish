defmodule Accomplish.JobApplications do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.JobApplications.Application
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
    with {:company_name, true} <- {:company_name, Map.has_key?(attrs, :company_name)},
         {:ok, company} <- Companies.get_or_create(attrs[:company_name]),
         changeset <- Application.create_changeset(company, applicant, attrs),
         {:ok, job_application} <- Repo.insert(changeset) do
      {:ok, job_application}
    else
      {:company_name, false} ->
        {:error,
         %Ecto.Changeset{
           valid?: false,
           errors: [company_name: {"can't be blank", []}],
           data: %Application{}
         }}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def change_application(attrs \\ %{}) do
    %Application{}
    |> Application.changeset(attrs)
  end

  def add_stage(application, attrs) do
    Stage.create_changeset(application, attrs)
    |> Repo.insert()
  end
end
