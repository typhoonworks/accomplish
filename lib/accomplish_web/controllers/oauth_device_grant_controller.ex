defmodule AccomplishWeb.OAuthDeviceGrantController do
  @moduledoc """
  Handles the OAuth Device Authorization Grant for applications using this app as an OAuth provider.

  ## Actions

    * `create_device_code/2` - Issues a device code and user code for clients.
    * Additional actions can include polling, revocation, or verification.

  """

  use AccomplishWeb, :controller

  alias Accomplish.OAuth

  @polling_interval_in_seconds 5

  @doc """
  Issues a `device_code` and `user_code` for a client to initiate the Device Authorization Flow.
  """
  def create_device_code(conn, %{"client_id" => client_id, "scope" => scope}) do
    base_verification_uri = AccomplishWeb.Endpoint.url() <> ~p"/auth/device/verify"

    with {:ok, application} <- OAuth.get_application_by_client_id(client_id),
         {:ok, device_grant} <-
           OAuth.create_device_grant(application, String.split(scope, ",")) do
      json(conn, %{
        device_code: device_grant.device_code,
        user_code: device_grant.user_code,
        verification_uri: base_verification_uri,
        verification_uri_complete: "#{base_verification_uri}?user_code=#{device_grant.user_code}",
        expires_in: device_grant.expires_in,
        interval: @polling_interval_in_seconds
      })
    else
      {:error, :application_not_found} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "invalid_client"})

      {:error, %Ecto.Changeset{errors: errors}} ->
        formatted_errors =
          Enum.map(errors, fn {field, {message, _opts}} ->
            %{field: field, message: message}
          end)

        conn
        |> put_status(:bad_request)
        |> json(%{error: "invalid_request", details: formatted_errors})
    end
  end

  @doc """
  Renders the verification page for the user to enter the `user_code`.
  """
  def verify_page(conn, _params) do
    render(conn, "verify.html")
  end

  @doc """
  Verifies the `user_code` and associates the `device_grant` with the authenticated user.
  """
  def verify_user_code(conn, %{"user_code" => user_code}) do
    user = conn.assigns[:current_user]

    with {:ok, device_grant} <- OAuth.get_device_grant_by_user_code(user_code),
         {:ok, _updated_device_grant} <- OAuth.link_device_grant_to_user(device_grant, user.id) do
      conn
      |> put_flash(:info, "Device successfully linked!")
      |> redirect(to: "/dashboard")
    else
      {:error, :device_grant_not_found} ->
        conn
        |> put_flash(:error, "Invalid or expired user code.")
        |> redirect(to: "/auth/device/verify")

      {:error, :already_linked} ->
        conn
        |> put_flash(:error, "This device has already been linked.")
        |> redirect(to: "/auth/device/verify")
    end
  end
end
