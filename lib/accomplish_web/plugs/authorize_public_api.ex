defmodule AccomplishWeb.Plugs.AuthorizePublicAPI do
  @moduledoc """
  Plug for authorizing access to the public API.

  This plug uses Bearer token authentication to verify API keys and checks
  their scopes against the required scope specified in the `:api_scope` assign.

  The `:api_scope` assign must be set in the router or controller to indicate
  the required scope for the API endpoint.
  """

  import Plug.Conn
  alias Accomplish.Accounts
  alias AccomplishWeb.Api.Helpers

  def init(opts), do: opts

  def call(conn, _opts) do
    requested_scope = Map.fetch!(conn.assigns, :api_scope)

    with {:ok, token} <- get_bearer_token(conn),
         {:ok, api_key} <- Accounts.find_api_key(token),
         :ok <- check_scope(api_key, requested_scope) do
      assign(conn, :authorized_user, api_key.user)
    else
      {:error, :missing_api_key} ->
        Helpers.unauthorized(
          conn,
          "Missing API key. Please provide a valid API key as a Bearer token."
        )

      {:error, :invalid_api_key} ->
        Helpers.unauthorized(
          conn,
          "Invalid API key. Ensure your API key has access to the requested resource."
        )

      {:error, :insufficient_scope, api_key} ->
        Helpers.not_enough_permissions(
          conn,
          "Insufficient scope for this API key. Required: #{requested_scope}. Available: #{Enum.join(api_key.scopes, ", ")}"
        )
    end
  end


  defp get_bearer_token(conn) do
    authorization_header =
      conn
      |> get_req_header("authorization")
      |> List.first()

    case authorization_header do
      "Bearer " <> token -> {:ok, String.trim(token)}
      _ -> {:error, :missing_api_key}
    end
  end

  defp check_scope(api_key, required_scope) do
    if Accounts.valid_scope?(api_key, required_scope) do
      :ok
    else
      {:error, :insufficient_scope, api_key}
    end
  end
end
