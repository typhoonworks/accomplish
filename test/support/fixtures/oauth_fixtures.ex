defmodule Accomplish.OAuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.OAuth` context.
  """

  @valid_scopes ["user:read", "user:write"]

  def unique_name, do: "application-#{System.unique_integer()}"

  @doc """
  Generate an OAuth application.
  """
  def oauth_application_fixture(attrs \\ %{}) do
    {:ok, application} =
      attrs
      |> Enum.into(%{
        name: unique_name(),
        redirect_uri: "https://example.com/callback",
        scopes: @valid_scopes,
        confidential: true
      })
      |> Accomplish.OAuth.create_application()

    application
  end

  @doc """
  Generates an OAuth access grant.
  """
  def oauth_access_grant_fixture(user, application, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        token: Accomplish.OAuth.AccessGrant.generate_token(),
        expires_in: 3600,
        redirect_uri: "https://example.com/callback",
        scopes: @valid_scopes
      })

    {:ok, access_grant} = Accomplish.OAuth.create_access_grant(user, application, attrs)

    access_grant
  end

  @doc """
  Generates an OAuth access token.
  """
  def oauth_access_token_fixture(user, application, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        token: Accomplish.OAuth.AccessToken.generate_token(),
        refresh_token: Accomplish.OAuth.AccessToken.generate_refresh_token(),
        expires_in: 3600,
        scopes: @valid_scopes
      })

    {:ok, access_token} = Accomplish.OAuth.create_access_token(user, application, attrs)
    access_token
  end

  @doc """
  Generates an OAuth device grant.
  """
  def oauth_device_grant_fixture(application, scopes \\ @valid_scopes) do
    {:ok, device_grant} = Accomplish.OAuth.create_device_grant(application, scopes)
    device_grant
  end

  @doc """
  Generate an OAuth identity.
  """
  def oauth_identity_fixture(attrs \\ %{}) do
    {:ok, oauth_identity} =
      attrs
      |> valid_oauth_identity_attributes()
      |> Accomplish.OAuth.create_oauth_identity()

    oauth_identity
  end

  @doc """
  Returns valid attributes for creating an OAuth identity.

  This function can be reused in tests for customizing attributes.

  ## Examples

      iex> valid_oauth_identity_attributes()
      %{
        access_token: "some access_token",
        expires_at: ~U[2025-01-18 13:18:00Z],
        provider: "some provider",
        refresh_token: "some refresh_token",
        scopes: ["option1", "option2"],
        uid: "some uid"
      }

      iex> valid_oauth_identity_attributes(%{provider: "github"})
      %{
        access_token: "some access_token",
        expires_at: ~U[2025-01-18 13:18:00Z],
        provider: "github",
        refresh_token: "some refresh_token",
        scopes: ["option1", "option2"],
        uid: "some uid"
      }
  """
  def valid_oauth_identity_attributes(overrides \\ %{}) do
    %{
      access_token: "some access_token",
      expires_at: ~U[2025-01-18 13:18:00Z],
      provider: "github",
      refresh_token: "some refresh_token",
      scopes: ["option1", "option2"],
      uid: "some uid"
    }
    |> Map.merge(overrides)
    |> maybe_add_user(overrides)
  end

  defp maybe_add_user(attrs, %{user: %Accomplish.Accounts.User{id: id}}) do
    Map.put(attrs, :user_id, id)
  end

  defp maybe_add_user(attrs, _overrides), do: attrs
end
