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
        items: %Schema{
          type: :object,
          required: [:id, :name, :default_branch, :git_url, :ssh_url, :clone_url],
          properties: %{
            id: %Schema{
              type: :integer,
              description: "Unique identifier of the repository",
              example: 1
            },
            name: %Schema{
              type: :string,
              description: "Repository name",
              example: "accomplish"
            },
            default_branch: %Schema{
              type: :string,
              description: "Default branch of the repository",
              example: "main"
            },
            git_url: %Schema{
              type: :string,
              description: "Git URL of the repository",
              example: "git://github.com/rodloboz/accomplish.git"
            },
            ssh_url: %Schema{
              type: :string,
              description: "SSH URL of the repository",
              example: "git@github.com:rodloboz/accomplish.git"
            },
            clone_url: %Schema{
              type: :string,
              description: "Clone URL of the repository",
              example: "https://github.com/rodloboz/accomplish.git"
            }
          }
        },
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
          clone_url: "https://github.com/rodloboz/accomplish.git"
        },
        %{
          id: 2,
          name: "another-repo",
          default_branch: "develop",
          git_url: "git://github.com/rodloboz/another-repo.git",
          ssh_url: "git@github.com:rodloboz/another-repo.git",
          clone_url: "https://github.com/rodloboz/another-repo.git"
        }
      ]
    }
  })
end
