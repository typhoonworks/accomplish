defmodule AccomplishWeb.API.RepositoriesController do
  @moduledoc """
  Controller for managing repositories.
  """

  use AccomplishWeb, :controller
  use Goal

  alias Accomplish.Repositories
  alias AccomplishWeb.API.Helpers

  def index(conn, _params) do
    user = conn.assigns.authorized_user

    repositories =
      user
      |> Repositories.list_repositories()

    json(conn, %{repositories: repositories})
  end

  def create_repository(conn, params) do
    with {:ok, attrs} <- validate(:create_repository, params) do
      user = conn.assigns.authorized_user

      case Repositories.create_repository(user, attrs) do
        {:ok, repository} ->
          conn
          |> put_status(:created)
          |> json(repository)

        {:error, changeset} ->
          errors = Helpers.serialize_validation_errors(changeset)
          Helpers.unprocessable_entity(conn, errors)
      end
    else
      {:error, changeset} ->
        errors = Helpers.serialize_validation_errors(changeset)
        Helpers.unprocessable_entity(conn, errors)
    end
  end

  defparams :create_repository do
    required :name, :string, min: 1, description: "The name of the repository"
    required :default_branch, :string, description: "The default branch of the repository"
    optional :git_url, :string, format: :url, description: "The Git URL of the repository"
    optional :ssh_url, :string, format: :url, description: "The SSH URL of the repository"
    optional :clone_url, :string, format: :url, description: "The clone URL of the repository"
  end
end
