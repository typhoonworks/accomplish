defmodule Accomplish.Accounts.OAuthService do
  @moduledoc """
  Service for handling user authentication and creation through OAuth providers.

  This module integrates with OAuth providers (e.g., GitHub) to handle user authentication
  flows. It supports finding existing users or creating new ones, while linking OAuth
  identities in a transactional manner.

  ## Responsibilities

    - `find_or_create_user_from_oauth/2` - Main function to process OAuth responses,
      either finding an existing user or creating a new one and linking their OAuth identity.
    - `create_user_with_oauth_identity/2` - Handles the transactional creation of a user
      and their associated OAuth identity.

  ## Example Usage

      provider = :github
      auth = %{
        user: %{
          "sub" => "12345",
          "email" => "user@example.com",
          "name" => "John Doe",
          "picture" => "https://example.com/avatar.jpg"
        },
        token: %{
          "access_token" => "abcd1234",
          "refresh_token" => "refresh1234",
          "scope" => "user:read,user:email"
        }
      }

      Accomplish.Accounts.OAuthService.find_or_create_user_from_oauth(provider, auth)

  If the user already exists, their OAuth identity is linked. Otherwise, a new user and
  their OAuth identity are created in a single transaction.
  """

  alias Accomplish.{Accounts, OAuth, Repo, Profiles}
  alias Ecto.Multi

  def find_or_create_user_from_oauth(provider, %{user: oauth_user} = auth) do
    uid = oauth_user["sub"]
    email = oauth_user["email"]

    case Accounts.get_user_by_email(email) do
      nil ->
        create_user_with_oauth_identity(provider, auth)

      user ->
        case OAuth.get_oauth_identity(provider, uid) do
          nil ->
            OAuth.create_oauth_identity(%{
              provider: provider,
              uid: uid,
              access_token: auth.token["access_token"],
              refresh_token: auth.token["refresh_token"],
              expires_at: auth.token["expires_at"],
              scopes: parse_scopes(auth.token["scope"]),
              user_id: user.id
            })

          identity ->
            OAuth.link_identity_to_user(identity, user.id)
        end

        {:ok, user}
    end
  end

  defp create_user_with_oauth_identity(provider, %{user: oauth_user, token: token}) do
    result =
      Multi.new()
      |> Multi.run(:create_user, fn _repo, _context ->
        user_params = user_params(oauth_user)
        Accounts.create_user_from_oauth(user_params)
      end)
      |> Multi.run(:profile, fn _repo, %{create_user: user} ->
        profile_params = extract_profile_params(oauth_user)
        Profiles.upsert_profile(user, profile_params)
      end)
      |> Multi.run(:oauth_identity, fn _repo, %{create_user: user} ->
        attrs = %{
          provider: provider,
          uid: oauth_user["sub"],
          access_token: token["access_token"],
          refresh_token: token["refresh_token"],
          expires_at: token["expires_at"],
          scopes: parse_scopes(token["scope"]),
          user_id: user.id
        }

        case OAuth.create_oauth_identity(attrs) do
          {:ok, identity} -> {:ok, identity}
          {:error, changeset} -> {:error, changeset}
        end
      end)
      |> Repo.transaction()

    case result do
      {:ok, success} -> {:ok, success.create_user}
      {:error, _step, reason, _context} -> {:error, reason}
    end
  end

  defp user_params(oauth_user) do
    %{
      email: oauth_user["email"],
      username: extract_username(oauth_user),
      first_name: extract_first_name(oauth_user),
      last_name: extract_last_name(oauth_user)
    }
  end

  defp extract_first_name(oauth_user) do
    cond do
      oauth_user["given_name"] ->
        oauth_user["given_name"]

      oauth_user["name"] && is_binary(oauth_user["name"]) ->
        oauth_user["name"]
        |> String.split(" ", trim: true)
        |> List.first("")

      true ->
        nil
    end
  end

  defp extract_last_name(oauth_user) do
    cond do
      oauth_user["family_name"] ->
        oauth_user["family_name"]

      oauth_user["name"] && is_binary(oauth_user["name"]) ->
        names = String.split(oauth_user["name"], " ", trim: true)

        case Enum.drop(names, 1) do
          [] -> nil
          rest -> Enum.join(rest, " ")
        end

      true ->
        nil
    end
  end

  defp extract_username(oauth_user) do
    cond do
      oauth_user["preferred_username"] ->
        sanitize_username(oauth_user["preferred_username"])

      oauth_user["login"] ->
        sanitize_username(oauth_user["login"])

      oauth_user["email"] ->
        oauth_user["email"]
        |> String.split("@")
        |> List.first()
        |> String.downcase()
        |> sanitize_username()

      true ->
        generate_random_username()
    end
  end

  defp sanitize_username(username) do
    username
    |> String.downcase()
    |> String.replace("_", "-")
    |> String.replace(~r/[^a-z0-9\-]/, "")
    |> String.replace(~r/^-+|-+$/, "")
  end

  defp generate_random_username do
    base = "user"

    suffix =
      :crypto.strong_rand_bytes(6)
      |> Base.encode16(case: :lower)
      |> String.slice(0..7)

    "#{base}-#{suffix}"
  end

  defp parse_scopes(nil), do: []

  defp parse_scopes(scopes) when is_binary(scopes) do
    scopes
    |> String.split([" ", ","], trim: true)
  end

  defp parse_scopes(scopes), do: scopes

  defp extract_profile_params(oauth_user) do
    github_handle = if oauth_user["login"], do: oauth_user["login"], else: nil

    profile_params = %{}

    profile_params =
      if oauth_user["bio"],
        do: Map.put(profile_params, :bio, oauth_user["bio"]),
        else: profile_params

    profile_params =
      if oauth_user["company"],
        do: Map.put(profile_params, :headline, oauth_user["company"]),
        else: profile_params

    profile_params =
      if oauth_user["location"],
        do: Map.put(profile_params, :location, oauth_user["location"]),
        else: profile_params

    profile_params =
      if oauth_user["blog"] || oauth_user["website"],
        do: Map.put(profile_params, :website_url, oauth_user["blog"] || oauth_user["website"]),
        else: profile_params

    profile_params =
      if github_handle,
        do: Map.put(profile_params, :github_handle, github_handle),
        else: profile_params

    profile_params
  end
end
