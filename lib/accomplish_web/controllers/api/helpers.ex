defmodule AccomplishWeb.Api.Helpers do
  @moduledoc """
  Helper functions for building consistent API responses.

  This module provides utility functions to handle common HTTP error responses
  such as `401 Unauthorized`, `403 Forbidden`, and others. These helpers
  standardize the format of JSON error messages and ensure the connection is
  halted after the response.
  """

  import Plug.Conn

  def unauthorized(conn, msg) do
    conn
    |> put_status(401)
    |> Phoenix.Controller.json(%{error: msg})
    |> halt()
  end

  def not_enough_permissions(conn, msg) do
    conn
    |> put_status(403)
    |> Phoenix.Controller.json(%{error: msg})
    |> halt()
  end

  def bad_request(conn, msg) do
    conn
    |> put_status(400)
    |> Phoenix.Controller.json(%{error: msg})
    |> halt()
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

  def payment_required(conn, msg) do
    conn
    |> put_status(402)
    |> Phoenix.Controller.json(%{error: msg})
    |> halt()
  end
end
