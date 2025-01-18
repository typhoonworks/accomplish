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

  def serialize_validation_errors(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.flat_map(fn {field, messages} ->
      Enum.map(messages, fn message ->
        %{
          field: field,
          message: message,
          type: "invalid_request_error",
          code: map_error_to_code(field, message, %{})
        }
      end)
    end)
  end

  def serialize_validation_errors(errors) when is_list(errors) do
    Enum.map(errors, fn {field, {msg, opts}} ->
      %{
        field: field,
        message: msg,
        type: "invalid_request_error",
        code: map_error_to_code(field, msg, opts)
      }
    end)
  end

  defp map_error_to_code(_field, "can't be blank", _opts), do: "parameter_missing"
  defp map_error_to_code(_field, "is invalid", _opts), do: "parameter_invalid"
  defp map_error_to_code(_field, "is too short", _opts), do: "parameter_invalid_string_empty"
  defp map_error_to_code(_field, _msg, _opts), do: "parameter_invalid"

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
