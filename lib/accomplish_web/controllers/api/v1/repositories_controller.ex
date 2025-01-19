defmodule AccomplishWeb.API.V1.RepositoriesController do
  @moduledoc """
  Controller for managing repositories.
  """

  use AccomplishWeb, :public_api_controller

  alias Accomplish.Repositories

  operation(:index,
    summary: "List all repositories",
    tags: ["Repositories"],
    responses: %{
      200 => {"List of repositories", "application/json", Schemas.Repository.ListResponse}
    }
  )

  def index(conn, _params) do
    user = conn.assigns.authorized_user

    repositories =
      user
      |> Repositories.list_repositories()

    json(conn, %{repositories: repositories})
  end

  operation(:create_repository,
    summary: "Create a new repository",
    tags: ["Repositories"],
    request_body: {"Repository creation", "application/json", Schemas.Repository.CreateRequest},
    responses: %{
      201 => {"Repository", "application/json", Schemas.Repository},
      422 => {"Validation errors", "application/json", Schemas.ValidationError}
    }
  )

  def create_repository(%{private: %{open_api_spex: %{body_params: body_params}}} = conn, _params) do
    user = conn.assigns.authorized_user

    case Repositories.create_repository(user, body_params) do
      {:ok, repository} ->
        conn
        |> put_status(:created)
        |> json(repository)

      {:error, changeset} ->
        errors = Helpers.serialize_validation_errors(changeset)
        Helpers.unprocessable_entity(conn, errors)
    end
  end
end
