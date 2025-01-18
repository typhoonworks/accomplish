defmodule AccomplishWeb.API.Schemas.Repository.ListResponse do
  @moduledoc """
  OpenAPI schema for the response containing a list of repositories.
  """
  use AccomplishWeb, :open_api_schema

  OpenApiSpex.schema(%{
    title: "Repository.ListResponse",
    description: "Response containing a list of repositories",
    type: :object,
    required: [:repositories],
    properties: %{
      repositories: %Schema{
        type: :array,
        items: AccomplishWeb.API.Schemas.Repository,
        description: "A list of repository objects"
      }
    },
    example: %{
      repositories: [
        %{
          id: 1,
          name: "accomplish",
          default_branch: "main",
          git_url: "git://github.com/rodloboz/accomplish.git",
          ssh_url: "git@github.com:rodloboz/accomplish.git",
          clone_url: "https://github.com/rodloboz/accomplish.git",
          inserted_at: "2023-01-01T12:00:00Z",
          updated_at: "2023-01-01T12:00:00Z"
        },
        %{
          id: 2,
          name: "another-repo",
          default_branch: "develop",
          git_url: "git://github.com/rodloboz/another-repo.git",
          ssh_url: "git@github.com:rodloboz/another-repo.git",
          clone_url: "https://github.com/rodloboz/another-repo.git",
          inserted_at: "2023-01-01T12:00:00Z",
          updated_at: "2023-01-01T12:00:00Z"
        }
      ]
    }
  })
end
