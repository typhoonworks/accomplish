defmodule Accomplish.JobApplications do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.JobApplications.Application
  alias Accomplish.JobApplications.ApplicationForm
  alias Accomplish.JobApplications.Companies
  alias Accomplish.JobApplications.Stage
  alias Accomplish.JobApplications.Stages
  alias Accomplish.JobApplications.Events

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"
  @active_statuses ~w(applied interviewing offer)a

  def get_application!(id, preloads \\ []),
    do: Application |> Repo.get!(id) |> Repo.preload(preloads)

  def list_user_applications(user, filter \\ "all") do
    query =
      from a in Application,
        where: a.applicant_id == ^user.id,
        preload: [:company]

    query =
      case filter do
        "active" ->
          from a in query, where: a.status in ^@active_statuses

        _ ->
          query
      end

    query = from a in query, order_by: [desc: a.applied_at]

    Repo.all(query)
  end

  def count_user_applications(user, filter \\ "all") do
    query =
      from a in Application,
        where: a.applicant_id == ^user.id

    query =
      case filter do
        "active" ->
          from a in query, where: a.status in ^@active_statuses

        _ ->
          query
      end

    Repo.aggregate(query, :count, :id)
  end

  def create_application(applicant, attrs) do
    with {:ok, form_changeset} <- validate_application_form(attrs),
         {:ok, company} <- Companies.get_or_create(form_changeset.changes.company_name),
         changeset <- Application.create_changeset(company, applicant, form_changeset.changes),
         {:ok, job_application} <- Repo.insert(changeset) do
      broadcast_application_created(job_application, company)
      {:ok, job_application}
    else
      {:error, changeset} -> {:error, changeset}
    end
  end

  def update_application(%Application{} = application, attrs) do
    changeset = Application.update_changeset(application, attrs)

    case Repo.update(changeset) do
      {:ok, updated_application} ->
        diff = update_diff(application, changeset)
        broadcast_application_updated(updated_application, application.company, diff)
        {:ok, updated_application}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_application(application_id) do
    with %Application{} = application <- Repo.get(Application, application_id),
         {:ok, _} <-
           Repo.transaction(fn ->
             Repo.delete!(application)
             broadcast_application_deleted(application)
           end) do
      {:ok, application}
    else
      nil -> {:error, :not_found}
      {:error, e} -> {:error, e}
      _ -> {:error, :unexpected_error}
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

  def change_stage_form(attrs \\ %{}) do
    %Stage{} |> Stage.changeset(attrs)
  end

  def broadcast_application_created(job_application, company) do
    broadcast!(%Events.NewJobApplication{
      name: "job_application:created",
      application: job_application,
      company: company
    })
  end

  defp broadcast_application_updated(job_application, company, diff) do
    broadcast!(%Events.JobApplicationUpdated{
      name: "job_application:updated",
      application: job_application,
      company: company,
      diff: diff
    })
  end

  defp broadcast_application_deleted(application) do
    broadcast!(%Events.JobApplicationDeleted{
      name: "job_application:deleted",
      application: application
    })
  end

  def add_stage(application, attrs) do
    Stages.create(application, attrs)
  end

  defp update_diff(original, changeset) do
    Enum.reduce(changeset.changes, %{}, fn {field, new_value}, acc ->
      old_value = Map.get(original, field)
      Map.put(acc, field, %{old: old_value, new: new_value})
    end)
  end

  defp broadcast!(msg) do
    Phoenix.PubSub.broadcast!(@pubsub, @notifications_topic, {__MODULE__, msg})
  end
end
