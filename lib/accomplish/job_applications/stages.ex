defmodule Accomplish.JobApplications.Stages do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.JobApplications.Application
  alias Accomplish.JobApplications.Stage

  @stages [
    %{title: "Recruiter Screen", type: :screening, is_final_stage: false},
    %{title: "Technical Interview", type: :interview, is_final_stage: false},
    %{title: "Live Coding", type: :assessment, is_final_stage: false},
    %{title: "Take-Home Assignment", type: :assessment, is_final_stage: false},
    %{title: "System Design", type: :interview, is_final_stage: false},
    %{title: "Final Interview", type: :interview, is_final_stage: true}
  ]

  def predefined_stages, do: @stages

  def create(application, attrs) do
    Stage.create_changeset(application, attrs)
    |> prepare_changes(fn changeset ->
      position = application.stages_count + 1

      changeset
      |> put_change(:position, position)
      |> update_application(application)
    end)
    |> Repo.insert()
  end

  defp update_application(changeset, application) do
    query = from a in Application, where: a.id == ^application.id

    update_fields =
      []
      |> increment_stage_count()
      |> maybe_set_current_stage(application, changeset)

    if update_fields != [] do
      changeset.repo.update_all(query, update_fields)
    end

    changeset
  end

  defp increment_stage_count(update_fields) do
    Keyword.put(update_fields, :inc, stages_count: 1)
  end

  defp maybe_set_current_stage(update_fields, %{stages_count: 0}, changeset) do
    Keyword.put(update_fields, :set, current_stage_id: changeset.data.id)
  end

  defp maybe_set_current_stage(update_fields, _application, _changeset), do: update_fields
end
