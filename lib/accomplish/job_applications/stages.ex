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

  @doc """
  Gets a stage by ID and application ID. Raises if not found.

  ## Options

  * `:with_deleted` - if true, includes soft-deleted stages in the query (default: false)
  """
  def get!(id, application_id, preloads \\ [], opts \\ []) do
    with_deleted = Keyword.get(opts, :with_deleted, false)

    query =
      from(s in Stage,
        where: s.id == ^id and s.application_id == ^application_id
      )

    result = Repo.one!(query, with_deleted: with_deleted)
    Repo.preload(result, preloads)
  end

  @doc """
  Gets a stage by ID and application ID. Returns nil if not found.

  ## Options

  * `:with_deleted` - if true, includes soft-deleted stages in the query (default: false)
  """
  def get(id, application_id, preloads \\ [], opts \\ []) do
    with_deleted = Keyword.get(opts, :with_deleted, false)

    query =
      from(s in Stage,
        where: s.id == ^id and s.application_id == ^application_id
      )

    case Repo.one(query, with_deleted: with_deleted) do
      nil -> nil
      stage -> Repo.preload(stage, preloads)
    end
  end

  @doc """
  Gets a stage by slug and application ID.

  ## Options

  * `:with_deleted` - if true, includes soft-deleted stages in the query (default: false)
  """
  def get_by_slug(slug, application_id, preloads \\ [], opts \\ []) do
    with_deleted = Keyword.get(opts, :with_deleted, false)

    query =
      from s in Stage,
        where: s.slug == ^slug and s.application_id == ^application_id,
        preload: ^preloads

    case Repo.one(query, with_deleted: with_deleted) do
      nil -> :error
      stage -> {:ok, stage}
    end
  end

  @doc """
  Lists all stages for an application.

  ## Options

  * `:with_deleted` - if true, includes soft-deleted stages in the query (default: false)
  """
  def list_for_application(application_id, preloads \\ [], opts \\ []) do
    with_deleted = Keyword.get(opts, :with_deleted, false)

    query =
      from s in Stage,
        where: s.application_id == ^application_id,
        order_by: [asc: s.position],
        preload: ^preloads

    Repo.all(query, with_deleted: with_deleted)
  end

  @doc """
  Returns information about whether a stage is deleted.
  """
  def deleted?(%Stage{deleted_at: deleted_at}), do: not is_nil(deleted_at)
  def deleted?(_), do: false

  def generate_slug(stage) do
    Slug.slugify(stage.title) |> Slug.add_suffix(stage.id)
  end
end
