defmodule Accomplish.Repositories do
  @moduledoc """
  The Repositories context.

  This module provides an interface to manage and interact with repositories
  within the application, including creating, updating, and querying repositories.
  """

  use Accomplish.Context
  alias Accomplish.Repositories.Repository

  @doc """
   Lists all repositories owned by a specific user.
  """
  def list_repositories(owner, preloads \\ []) do
    query =
      from r in Repository,
        where: r.owner_id == ^owner.id,
        preload: ^preloads

    Repo.all(query)
  end

  @doc """
  Gets a repository by ID.

  Returns `nil` if the repository does not exist.
  """
  def get_repository(id) do
    Repo.get(Repository, id)
  end

  @doc """
  Creates a repository.

  Accepts the owner (user) and a map of attributes.
  """
  def create_repository(owner, attrs) do
    Repository.create_changeset(owner, attrs) |> Repo.insert()
  end

  @doc """
  Updates a repository.

  Accepts the repository and a map of attributes.
  """
  def update_repository(repository, attrs) do
    repository
    |> Repository.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a repository.

  Accepts the repository to delete.
  """
  def delete_repository(repository) do
    Repo.delete(repository)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking repository changes.

  Useful for pre-validating changes.
  """
  def change_repository(repository, attrs \\ %{}) do
    Repository.changeset(repository, attrs)
  end
end
