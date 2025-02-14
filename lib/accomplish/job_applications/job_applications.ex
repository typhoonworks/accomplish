defmodule Accomplish.JobApplications do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.JobApplications.Application
  alias Accomplish.JobApplications.Companies

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
end
