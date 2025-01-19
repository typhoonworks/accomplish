defmodule AccomplishWeb.OAuthController do
  @moduledoc """
  Handles OAuth authentication requests and callbacks.

  This controller manages the OAuth flow for third-party providers such as GitHub.
  It includes actions to start the OAuth process (`request/2`) and handle the
  callback after authentication (`callback/2`).

  ## Actions

    * `request/2` - Initiates the OAuth authorization by redirecting the user
      to the provider's authentication page.
    * `callback/2` - Handles the callback from the provider and either logs in
      the user or displays an error message.

  ## Example Flow

    1. User visits `/auth/github`.
    2. Redirects to GitHub for authentication.
    3. Upon successful authentication, GitHub redirects back to
       `/auth/github/callback` with a code and state.
    4. The `callback/2` action processes the response, retrieves the user's
       information, and logs them in or shows an error.

  This module uses the Assent library for handling OAuth strategies.
  """

  use AccomplishWeb, :controller

  alias Assent.Strategy.Github
  alias Accomplish.Accounts.OAuthService
  alias AccomplishWeb.Plugs.UserAuth

  @provider :github

  def request(conn, _params) do
    config = provider_config(@provider)

    case Github.authorize_url(config) do
      {:ok, %{url: url, session_params: session_params}} ->
        conn
        |> put_session(:session_params, session_params)
        |> redirect(external: url)

      {:error, _error} ->
        conn
        |> put_flash(
          :error,
          "Failed to start the authentication process. Please try again later."
        )
        |> redirect(to: "/")
    end
  end

  def callback(conn, %{"provider" => provider} = params) do
    config = provider_config(String.to_atom(provider))
    session_params = get_session(conn, :session_params)

    if session_params == nil do
      conn
      |> put_flash(:error, "Session expired or invalid. Please try again.")
      |> redirect(to: "/")
    else
      config =
        config
        |> Keyword.put(:session_params, session_params)

      with {:ok, auth} <- Github.callback(config, params),
           {:ok, user} <-
             OAuthService.find_or_create_user_from_oauth(provider, auth) do
        conn
        |> UserAuth.log_in_user(user)
        |> put_flash(:info, "Welcome to Accomplish!")
        |> redirect(to: "/")
      else
        {:error, _reason} ->
          conn
          |> put_flash(:error, "Authentication failed. Please try again later.")
          |> redirect(to: "/")
      end
    end
  end

  defp provider_config(provider) do
    Application.get_env(:accomplish, :assent_providers)[provider]
    |> Enum.into([])
  end
end
