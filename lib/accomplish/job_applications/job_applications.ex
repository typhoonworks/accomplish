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
  alias Accomplish.Slug

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"
  @events_topic "events:all"
  @active_statuses ~w(applied interviewing offer)a

  def get_application!(applicant, id, preloads \\ []) do
    from(a in Application,
      where: a.id == ^id and a.applicant_id == ^applicant.id,
      preload: ^preloads
    )
    |> Repo.one!()
  end

  def get_application_by_slug(applicant, slug, preloads \\ []) do
    query =
      from a in Application,
        where: a.slug == ^slug and a.applicant_id == ^applicant.id,
        preload: ^preloads

    case Repo.one(query) do
      nil -> :error
      application -> {:ok, application}
    end
  end

  def list_applications(applicant, filter \\ "all", preloads \\ []) do
    query =
      from a in Application,
        where: a.applicant_id == ^applicant.id,
        preload: ^([:company] ++ preloads)

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

  def count_applications(user, filter \\ "all") do
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
         {:ok, company} <- Companies.get_or_create(form_changeset.changes.company_name) do
      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :application,
        Application.create_changeset(company, applicant, form_changeset.changes)
      )
      |> Ecto.Multi.run(:update_slug, fn repo, %{application: application} ->
        updated_application = repo.get!(Application, application.id) |> repo.preload(:company)
        slug = generate_slug(updated_application)

        repo.update(Ecto.Changeset.change(updated_application, slug: slug))
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{application: _application, update_slug: updated_application}} ->
          broadcast_application_created(updated_application, company)
          {:ok, updated_application}

        {:error, :application, changeset, _} ->
          {:error, changeset}

        {:error, :update_slug, changeset, _} ->
          {:error, changeset}
      end
    end
  end

  def update_application(%Application{} = application, attrs) do
    old_status = application.status
    changeset = Application.update_changeset(application, attrs)

    case Repo.update(changeset) do
      {:ok, updated_application} ->
        diff = update_diff(application, changeset)
        broadcast_application_updated(updated_application, application.company, diff)

        if old_status != updated_application.status do
          broadcast_application_status_updated(
            updated_application,
            old_status,
            updated_application.status
          )
        end

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

  def get_stage!(application, stage_id) do
    Stages.get!(stage_id, application.id)
  end

  def get_stage_by_slug(application, slug, preloads \\ []) do
    Stages.get_by_slug(slug, application.id, preloads)
  end

  def add_stage(application, attrs) do
    attrs = Accomplish.Utils.Maps.key_to_atom(attrs)

    latest_position =
      from(s in Stage,
        where: s.application_id == ^application.id,
        select: max(s.position)
      )
      |> Repo.one()
      |> Kernel.||(0)

    position = latest_position + 1
    stage_changeset = Stage.create_changeset(application, Map.put(attrs, :position, position))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:stage, stage_changeset)
    |> Ecto.Multi.run(:update_slug, fn repo, %{stage: stage} ->
      slug = Stages.generate_slug(stage)

      repo.update(Ecto.Changeset.change(stage, slug: slug))
    end)
    |> Ecto.Multi.run(:update_application, fn repo, %{stage: stage} ->
      actual_stage_count =
        from(s in Stage,
          where: s.application_id == ^application.id,
          select: count()
        )
        |> repo.one()

      application
      |> Ecto.Changeset.change(stages_count: actual_stage_count)
      |> maybe_set_current_stage(stage, actual_stage_count)
      |> repo.update()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_slug: stage}} ->
        updated_application = Repo.get!(Application, application.id)
        broadcast_stage_added(updated_application, stage)
        {:ok, stage, updated_application}

      {:error, :stage, changeset, _} ->
        {:error, changeset}

      {:error, :application, changeset, _} ->
        {:error, changeset}

      {:error, :update_slug, changeset, _} ->
        {:error, changeset}
    end
  end

  def update_stage(%Stage{} = stage, application, attrs) do
    old_status = stage.status
    changeset = Stage.update_changeset(stage, attrs)

    case Repo.update(changeset) do
      {:ok, updated_stage} ->
        diff = update_diff(stage, changeset)
        broadcast_stage_updated(updated_stage, application, diff)

        if old_status != updated_stage.status do
          broadcast_stage_status_updated(
            updated_stage,
            application,
            old_status,
            updated_stage.status
          )
        end

        {:ok, updated_stage}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def set_current_stage(application, stage_id) do
    with old_stage <-
           if(application.current_stage_id,
             do: Stages.get(application.current_stage_id, application.id),
             else: nil
           ),
         %Stage{} = new_stage <- Stages.get(stage_id, application.id),
         {:ok, updated_application} <-
           Repo.update(Ecto.Changeset.change(application, current_stage_id: new_stage.id)) do
      broadcast_current_stage_updated(updated_application, old_stage, new_stage)
      {:ok, updated_application}
    else
      nil -> {:error, :stage_not_found}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp maybe_set_current_stage(changeset, stage, actual_stage_count) do
    if actual_stage_count == 1 do
      Ecto.Changeset.change(changeset, current_stage_id: stage.id)
    else
      changeset
    end
  end

  defp generate_slug(application) do
    [application.role, application.company.name]
    |> Slug.slugify()
    |> Slug.add_suffix(application.id)
  end

  defp update_diff(original, changeset) do
    Enum.reduce(changeset.changes, %{}, fn {field, new_value}, acc ->
      old_value = Map.get(original, field)
      Map.put(acc, field, %{old: old_value, new: new_value})
    end)
  end

  defp broadcast_application_created(application, company) do
    broadcast!(
      %Events.NewJobApplication{
        application: application,
        company: company
      },
      application.applicant_id
    )
  end

  defp broadcast_application_updated(application, company, diff) do
    broadcast!(
      %Events.JobApplicationUpdated{
        application: application,
        company: company,
        diff: diff
      },
      application.applicant_id
    )
  end

  defp broadcast_application_status_updated(application, old_status, new_status) do
    broadcast!(
      %Events.JobApplicationStatusUpdated{
        application: application,
        from: old_status,
        to: new_status
      },
      application.applicant_id
    )
  end

  defp broadcast_application_deleted(application) do
    broadcast!(
      %Events.JobApplicationDeleted{
        application: application
      },
      application.applicant_id
    )
  end

  defp broadcast_stage_added(application, stage) do
    broadcast!(
      %Events.JobApplicationNewStage{
        application: application,
        stage: stage
      },
      application.applicant_id
    )
  end

  defp broadcast_current_stage_updated(application, old_stage, new_stage) do
    broadcast!(
      %Events.JobApplicationCurrentStageUpdated{
        application: application,
        from: old_stage,
        to: new_stage
      },
      application.applicant_id
    )
  end

  defp broadcast_stage_updated(stage, application, diff) do
    broadcast!(
      %Events.JobApplicationStageUpdated{
        stage: stage,
        application: application,
        diff: diff
      },
      application.applicant_id
    )
  end

  defp broadcast_stage_status_updated(stage, application, old_status, new_status) do
    broadcast!(
      %Events.JobApplicationStageStatusUpdated{
        stage: stage,
        application: application,
        from: old_status,
        to: new_status
      },
      application.applicant_id
    )
  end

  defp broadcast!(msg, user_id) do
    Phoenix.PubSub.broadcast!(@pubsub, @notifications_topic <> ":#{user_id}", {__MODULE__, msg})
    Phoenix.PubSub.broadcast!(@pubsub, @events_topic, {__MODULE__, msg})
  end
end
