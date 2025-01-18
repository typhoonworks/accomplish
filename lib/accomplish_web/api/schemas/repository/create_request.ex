defmodule AccomplishWeb.API.Schemas.Repository.CreateRequest do
  @moduledoc """
  Shared schema for Repository creation request, used for both validation and OpenAPI documentation.
  """
  use AccomplishWeb, :open_api_schema

  OpenApiSpex.schema(%{
    title: "Repository Create Request",
    description: "Payload for creating a repository",
    type: :object,
    required: [:name, :default_branch],
    properties: %{
      name: %Schema{type: :string, description: "The name of the repository"},
      default_branch: %Schema{type: :string, description: "The default branch of the repository"},
      git_url: %Schema{type: :string, format: :url, description: "The Git URL of the repository"},
      ssh_url: %Schema{type: :string, format: :url, description: "The SSH URL of the repository"},
      clone_url: %Schema{
        type: :string,
        format: :url,
        description: "The clone URL of the repository"
      }
    },
    example: %{
      name: "accomplish",
      default_branch: "main",
      git_url: "https://github.com/username/repo.git",
      ssh_url: "git@github.com:username/repo.git",
      clone_url: "https://github.com/username/repo.git"
    }
  })
end
