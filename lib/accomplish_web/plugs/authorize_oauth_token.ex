defmodule AccomplishWeb.Plugs.AuthorizeOAuthToken do
  @moduledoc """
  Plug for authorizing access to OAuth-protected API endpoints using OAuth access tokens.

  This plug validates the OAuth token in the `Authorization` header and checks if it's valid.
  If the token is valid, it assigns the current user and application.
  """

  import Plug.Conn
  alias Accomplish.Accounts
  alias Accomplish.OAuth
  alias AccomplishWeb.API.Helpers

  def init(opts), do: opts

  def call(conn, _opts) do
    requested_scope = Map.fetch!(conn.assigns, :api_scope)

    with {:ok, token} <- get_oauth_token(conn),
         {:ok, access_token} <- OAuth.validate_access_token(token),
         application <- OAuth.get_application!(access_token.application_id),
         :ok <- check_scope(access_token.scopes, requested_scope) do
      user = Accounts.get_user(access_token.user_id)

      conn
      |> assign(:current_oauth_application, application)
      |> assign(:authorized_user, user)
      |> assign(:current_access_token, access_token)
    else
      {:error, :missing_token} ->
        Helpers.unauthorized(conn, "Missing OAuth token.")

      {:error, :insufficient_scope, scopes} ->
        Helpers.not_enough_permissions(
          conn,
          "Insufficient scope for this OAuth token. Required: #{requested_scope}. Available: #{Enum.join(scopes, ", ")}"
        )

      {:error, _reason} ->
        Helpers.unauthorized(conn, "Invalid or expired OAuth token.")
    end
  end

  defp get_oauth_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      _ -> {:error, :missing_token}
    end
  end

  defp check_scope(_, nil), do: :ok

  defp check_scope(scopes, required_scope) do
    if OAuth.valid_scope?(scopes, required_scope) do
      :ok
    else
      {:error, :insufficient_scope, scopes}
    end
  end
end
