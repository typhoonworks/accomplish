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
    with {:ok, application} <- OAuth.get_application_by_client_id(client_id),
         {:ok, device_grant} <-
           OAuth.create_device_grant(application, String.split(scope, ",")) do
      json(conn, %{
        device_code: device_grant.device_code,
        user_code: device_grant.user_code,
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
end
