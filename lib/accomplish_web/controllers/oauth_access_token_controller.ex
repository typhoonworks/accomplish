defmodule AccomplishWeb.OAuthAccessTokenController do
  @moduledoc """
  OAuth 2.0 Introspection endpoint for validating access tokens.

  It checks whether the token is valid, revoked, expired, and retrieves information about the token such as its scopes and subject.
  """

  use AccomplishWeb, :controller

  alias Accomplish.OAuth

  def token_info(conn, %{"token" => token}) do
    with {:ok, access_token} <- get_access_token(token),
         {:ok, access_token} <- OAuth.validate_access_token(access_token.token),
         {:ok, access_token} <- OAuth.preload_access_token_associations(access_token) do
      expiration_time = DateTime.add(access_token.inserted_at, access_token.expires_in)
      unix_timestamp_exp = DateTime.to_unix(expiration_time)

      conn
      |> put_status(:ok)
      |> json(%{
        active: true,
        scope: Enum.join(access_token.scopes, ","),
        client_id: access_token.application.uid,
        username: access_token.user.username,
        exp: unix_timestamp_exp
      })
    else
      {:error, :invalid_token} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid token"})

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: to_string(reason)})
    end
  end

  defp get_access_token(token) do
    case OAuth.get_access_token_by_token(token) do
      nil -> {:error, :invalid_token}
      access_token -> {:ok, access_token}
    end
  end

  def refresh_token(conn, %{"grant_type" => "refresh_token", "refresh_token" => refresh_token}) do
    case OAuth.refresh_access_token(refresh_token) do
      {:ok, new_access_token} ->
        json(conn, %{
          access_token: new_access_token.token,
          token_type: "Bearer",
          expires_in: new_access_token.expires_in,
          refresh_token: new_access_token.refresh_token,
          scope: Enum.join(new_access_token.scopes, ",")
        })

      {:error, :invalid_token} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
          error: "invalid_grant",
          error_description: "Invalid or expired refresh token."
        })

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: to_string(reason)})
    end
  end

  def refresh_token(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "invalid_request", message: "Missing required parameters."})
  end
end
