defmodule AccomplishWeb.API.Helpers do
  @moduledoc """
  Helper functions for building consistent API responses.

  This module provides utility functions to handle:

  - Common HTTP error responses such as `401 Unauthorized`, `403 Forbidden`, etc.,
    with standardized JSON error message formats.
  - Building paginated API responses in a Stripe-like format, including metadata
    such as the resource type, request URL, and pagination status.

  ## Error Responses

  Error responses are structured with an `error` object containing a `message`
  and a `type`, e.g.:

  ```json
  {
    "error": {
      "message": "Unauthorized access.",
      "type": "invalid_request_error"
    }
  }

  ## Paginated Responses

  Paginated responses for lists of objects:

  ```json
  {
    "object": "list",
    "url": "/v1/resources",
    "has_more": false,
    "data": [
      {
        "id": 1,
        "name": "example"
      }
    ]
  }
  ```
  """

  import Plug.Conn

  def unauthorized(conn, msg) do
    conn
    |> put_status(401)
    |> invalid_request_error(msg)
  end

  def not_enough_permissions(conn, msg) do
    conn
    |> put_status(403)
    |> invalid_request_error(msg)
  end

  def bad_request(conn, msg) do
    conn
    |> put_status(400)
    |> invalid_request_error(msg)
  end

  def not_found(conn, msg) do
    conn
    |> put_status(404)
    |> Phoenix.Controller.json(%{error: msg})
    |> halt()
  end

  def too_many_requests(conn, msg) do
    conn
    |> put_status(429)
    |> Phoenix.Controller.json(%{error: msg})
    |> halt()
  end

  def list_response(url, data, has_more) do
    %{
      object: "list",
      url: url,
      has_more: has_more,
      data: data
    }
  end

  defp invalid_request_error(conn, msg) do
    conn
    |> Phoenix.Controller.json(%{
      error: %{
        message: msg,
        type: "invalid_request_error"
      }
    })
    |> halt()
  end
end
