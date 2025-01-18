defmodule AccomplishWeb.API.Schemas.Repository do
  @moduledoc "OpenAPI schema for Repository response."

  use AccomplishWeb, :open_api_schema

  OpenApiSpex.schema(%{
    title: "Repository",
    description: "Represents a repository resource.",
    type: :object,
    properties: %{
      id: %Schema{type: :integer, description: "The unique identifier of the repository"},
      name: %Schema{type: :string, description: "The name of the repository"},
      default_branch: %Schema{type: :string, description: "The default branch of the repository"},
      git_url: %Schema{type: :string, format: :url, description: "The Git URL of the repository"},
      ssh_url: %Schema{type: :string, format: :url, description: "The SSH URL of the repository"},
      clone_url: %Schema{
        type: :string,
        format: :url,
        description: "The clone URL of the repository"
      },
      inserted_at: %Schema{
        type: :string,
        format: :"date-time",
        description: "The timestamp when the repository was created"
      },
      updated_at: %Schema{
        type: :string,
        format: :"date-time",
        description: "The timestamp when the repository was last updated"
      }
    },
    example: %{
      id: 1,
      name: "accomplish",
      default_branch: "main",
      git_url: "https://github.com/username/repo.git",
      ssh_url: "git@github.com:username/repo.git",
      clone_url: "https://github.com/username/repo.git",
      inserted_at: "2023-01-01T12:00:00Z",
      updated_at: "2023-01-01T12:00:00Z"
    }
  })
end
