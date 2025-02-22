defmodule Accomplish.JobApplications.Stages do
  @moduledoc false

  use Accomplish.Context
  alias Accomplish.Repo
  alias Accomplish.JobApplications.Application
  alias Accomplish.JobApplications.Stage

  def create(application, attrs) do
    Stage.create_changeset(application, attrs)
    |> prepare_changes(fn changeset ->
      position = application.stages_count + 1

      changeset
      |> put_change(:position, position)
      |> update_application_stage_count(application)
    end)
    |> Repo.insert()
  end

  defp update_application_stage_count(changeset, application) do
    query = from a in Application, where: a.id == ^application.id
    changeset.repo.update_all(query, inc: [stages_count: 1])
    changeset
  end
end
