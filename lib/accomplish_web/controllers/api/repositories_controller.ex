defmodule AccomplishWeb.API.RepositoriesController do
  @moduledoc """
  Controller for managing repositories.
  """

  use AccomplishWeb, :api_controller

  alias Accomplish.Repositories

  def index(conn, _params) do
    user = conn.assigns.authorized_user

    repositories =
      user
      |> Repositories.list_repositories()

    json(conn, %{repositories: repositories})
  end

  operation :create_repository,
    summary: "Create a new repository",
    request_body: {"Repository creation", "application/json", Schemas.Repository.CreateRequest},
    responses: %{
      201 => {"Repository", "application/json", Schemas.Repository},
      422 => {"Validation errors", "application/json", Schemas.ValidationError}
  }

  def create_repository(conn = %{body_params: attrs}, _params) do
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
  end
end
