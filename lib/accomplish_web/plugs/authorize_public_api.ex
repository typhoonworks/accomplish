defmodule AccomplishWeb.Plugs.AuthorizePublicAPI do
  @moduledoc """
  Plug for authorizing access to the public API.

  This plug uses Basic authentication to verify API keys and checks
  their scopes against the required scope specified in the `:api_scope` assign.

  The `:api_scope` assign must be set in the router or controller to indicate
  the required scope for the API endpoint.
  """

  import Plug.Conn
  alias Accomplish.Accounts
  alias AccomplishWeb.API.Helpers

  def init(opts), do: opts

  def call(conn, _opts) do
    requested_scope = Map.fetch!(conn.assigns, :api_scope)

    with {:ok, authorization} <- get_authorization_header(conn),
         {:ok, token} <- decode_token(authorization),
         {:ok, api_key} <- extract_api_key(token),
         {:ok, api_key_record} <- Accounts.find_api_key(api_key),
         :ok <- check_scope(api_key_record, requested_scope) do
      assign(conn, :authorized_user, api_key_record.user)
    else
      {:error, :missing_api_key} ->
        Helpers.unauthorized(
          conn,
          "Missing API key. Please provide a valid API key as a Basic token."
        )

      {:error, :unsupported_auth_scheme} ->
        Helpers.unauthorized(
          conn,
          "Unsupported authentication scheme. Only Basic is supported."
        )

      {:error, :invalid_auth_header} ->
        Helpers.unauthorized(
          conn,
          "Invalid authorization header format."
        )

      {:error, :invalid_api_key} ->
        Helpers.unauthorized(
          conn,
          "Invalid API key. Ensure your API key is properly encoded and valid."
        )

      {:error, :insufficient_scope, api_key_record} ->
        Helpers.not_enough_permissions(
          conn,
          "Insufficient scope for this API key. Required: #{requested_scope}. Available: #{Enum.join(api_key_record.scopes, ", ")}"
        )
    end
  end

  defp get_authorization_header(conn) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> encoded] -> {:ok, encoded}
      ["Bearer " <> _] -> {:error, :unsupported_auth_scheme}
      [] -> {:error, :missing_api_key}
      _ -> {:error, :invalid_auth_header}
    end
  end

  defp decode_token(encoded) do
    case Base.decode64(encoded) do
      {:ok, decoded} -> {:ok, decoded}
      :error -> {:error, :invalid_api_key}
    end
  end

  defp extract_api_key(token) do
    case String.split(token, ":") do
      [api_key | _] -> {:ok, api_key}
      _ -> {:error, :invalid_api_key}
    end
  end

  defp check_scope(api_key_record, required_scope) do
    if Accounts.valid_scope?(api_key_record, required_scope) do
      :ok
    else
      {:error, :insufficient_scope, api_key_record}
    end
  end
end
