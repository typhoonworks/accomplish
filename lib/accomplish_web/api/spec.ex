defmodule AccomplishWeb.API.Spec do
  @moduledoc """
  OpenAPI specification for the public API
  """
  alias OpenApiSpex.{Components, Info, OpenApi, Paths, Server}
  alias AccomplishWeb.Router

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        %Server{
          description: "This server",
          url: AccomplishWeb.Endpoint.url(),
          variables: %{}
        }
      ],
      info: %Info{
        title: "Accomplish API",
        version: "1.0-rc"
      },
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "basic_auth" => %OpenApiSpex.SecurityScheme{
            type: "http",
            scheme: "basic",
            description: """
            HTTP basic access authentication using your API key as the username.
            No password is required.

            Example:
            ```
            curl -u YOUR_API_KEY: https://accomplish.dev/api/resource
            ```

            Keep your API keys secure and do not expose them in publicly accessible areas like GitHub or client-side code.
            """
          }
        }
      },
      security: [%{"basic_auth" => []}]
    }
    # Ensure all schemas in components are resolved properly
    |> OpenApiSpex.resolve_schema_modules()
  end
end
