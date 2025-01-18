defmodule AccomplishWeb.API.Helpers do
  @moduledoc """
  Helper functions for building consistent API responses.

  This module provides utility functions to handle:

  - Common HTTP error responses such as `401 Unauthorized`, `403 Forbidden`, etc.,
    with standardized JSON error message formats.
  - Building paginated API responses in a Stripe-like format, including metadata
    such as the resource type, request URL, and pagination status.
  - Serializing validation errors for API responses.
  """

  import Plug.Conn

  alias AccomplishWeb.ErrorMapper

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

  def unprocessable_entity(conn, errors) do
    conn
    |> put_status(422)
    |> Phoenix.Controller.json(%{errors: errors})
  end

  def serialize_validation_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.flat_map(fn {field, messages} ->
      Enum.map(messages, fn message ->
        %{
          title: "Invalid value",
          source: %{"pointer" => "/#{field}"},
          detail: ErrorMapper.translate_ecto_message_to_openapi(message, field)
        }
      end)
    end)
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
