defmodule Accomplish.RepositoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.Repositories` context.
  """

  alias Accomplish.Repositories

  @doc """
  Generate a repository for a given owner.
  """
  def repository_fixture(owner, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "sample-repo",
        default_branch: "main",
        git_url: "https://github.com/#{owner.username}/sample-repo.git",
        ssh_url: "git@github.com:#{owner.username}/sample-repo.git",
        clone_url: "https://github.com/#{owner.username}/sample-repo.git"
      })

    {:ok, repository} = Repositories.create_repository(owner, attrs)

    repository
  end
end
