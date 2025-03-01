defmodule Accomplish.JobApplications.Stages do
  @moduledoc false

  use Accomplish.Context

  alias Accomplish.JobApplications.Stage
  alias Accomplish.Slug

  @stages [
    %{title: "Recruiter Screen", type: :screening, is_final_stage: false},
    %{title: "Technical Interview", type: :interview, is_final_stage: false},
    %{title: "Live Coding", type: :assessment, is_final_stage: false},
    %{title: "Take-Home Assignment", type: :assessment, is_final_stage: false},
    %{title: "System Design", type: :interview, is_final_stage: false},
    %{title: "Final Interview", type: :interview, is_final_stage: true},
    %{title: "Offer Negotiation", type: :offer, is_final_stage: true}
  ]

  def predefined_stages, do: @stages

  def get!(id, application_id, preloads \\ []) do
    Stage
    |> Repo.get_by!(id: id, application_id: application_id)
    |> Repo.preload(preloads)
  end

  def get(id, application_id, preloads \\ []) do
    Stage
    |> Repo.get_by(id: id, application_id: application_id)
    |> Repo.preload(preloads)
  end

  def get_by_slug(slug, application_id, preloads \\ []) do
    query =
      from s in Stage,
        where: s.slug == ^slug and s.application_id == ^application_id,
        preload: ^preloads

    case Repo.one(query) do
      nil -> :error
      stage -> {:ok, stage}
    end
  end

  def generate_slug(stage) do
    Slug.slugify(stage.title) |> Slug.add_suffix(stage.id)
  end
end
