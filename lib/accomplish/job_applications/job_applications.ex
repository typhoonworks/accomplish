# defmodule Accomplish.JobApplications do
#   @moduledoc """
#   The JobApplications context.

#   This module provides an interface for managing job applications.
#   """

#   use Accomplish.Context
#   alias Accomplish.Repo
#   alias Accomplish.JobApplications.{Application, Company, Stage}

#   @doc """
#   Creates a job application, automatically creating the company if needed.
#   """
#   def create_application(applicant, attrs) do
#     Repo.transaction(fn ->
#       initial_changeset =
#         %Application{}
#         |> Application.changeset(attrs)

#       if initial_changeset.valid? do
#         company_name =
#           attrs
#           |> Map.get(:company_name, Map.get(attrs, "company_name", nil))
#           |> case do
#             nil ->
#               Repo.rollback(%Ecto.Changeset{
#                 valid?: false,
#                 errors: [company_name: {"can't be blank", []}]
#               })

#             name ->
#               name
#           end

#         company =
#           Repo.get_by(Company, name: company_name) ||
#             Company.create_changeset(%{name: company_name})
#             |> Repo.insert!()

#         Application.create_changeset(company, applicant, attrs)
#         |> Repo.insert!()
#       else
#         Repo.rollback(initial_changeset)
#       end
#     end)
#   end

#   @doc """
#   Adds a new stage to a job application.
#   """
#   def add_stage(application, attrs) do
#     Stage.create_changeset(application, attrs)
#     |> Repo.insert()
#   end

#   defp get_or_create_company(name) do
#     with {:error, :no_team} <- get_by_owner(user) do
#       case create_my_team(user) do
#         {:ok, team} ->
#           {:ok, team}

#         {:error, :exists_already} ->
#           get_by_owner(user)
#       end
#     end
#   end
# end
