defmodule Accomplish.OAuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.OAuth` context.
  """

  @doc """
  Generate an OAuth identity.

  ## Examples

      iex> oauth_identity_fixture()
      %Identity{}

      iex> oauth_identity_fixture(%{provider: "github"})
      %Identity{}
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
      provider: "some provider",
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
