defmodule AccomplishWeb.API.Schemas.ValidationError do
  @moduledoc "Schema for validation errors."

  use AccomplishWeb, :open_api_schema

  OpenApiSpex.schema(%{
    title: "ValidationError",
    description: "Details of a validation error",
    type: :object,
    properties: %{
      errors: %Schema{
        type: :array,
        items: %Schema{
          type: :object,
          properties: %{
            title: %Schema{type: :string, description: "Error title"},
            detail: %Schema{type: :string, description: "Error message"},
            source: %Schema{
              type: :object,
              properties: %{
                pointer: %Schema{type: :string, description: "JSON Pointer to the field"}
              }
            }
          }
        }
      }
    },
    example: %{
      errors: [
        %{
          title: "Invalid value",
          detail: "Missing field: name",
          source: %{pointer: "/name"}
        }
      ]
    }
  })
end
