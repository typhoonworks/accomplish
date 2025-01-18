defmodule AccomplishWeb.API.RepositoriesController do
  @moduledoc false

  use AccomplishWeb, :controller

  # Dummy implementation for the `index` action
  def index(conn, _params) do
    json(conn, %{"message" => "Index action placeholder"})
  end

  # Dummy implementation for the `create_repository` action
  def create_repository(conn, _params) do
    json(conn, %{"message" => "Create repository placeholder"})
  end
end
