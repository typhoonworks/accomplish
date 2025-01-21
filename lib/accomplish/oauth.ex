defmodule Accomplish.OAuth do
  @moduledoc """
  The OAuth context for managing OAuth identities associated with users.
  """

  import Ecto.Query, warn: false
  alias Accomplish.Repo
  alias Accomplish.OAuth.{Application, AccessGrant, AccessToken, DeviceGrant, Identity}

  @ttl_access_token 3600

  @doc """
  Returns a list of OAuth applications.

  ## Examples

      iex> list_applications()
      [%Application{}, ...]
  """
  def list_applications, do: Repo.all(Application)

  @doc """
  Fetches an OAuth application by its `client_id` (stored as the `uid`).

  ## Examples

      iex> get_application_by_client_id("client-id-123")
      {:ok, %Application{}}

      iex> get_application_by_client_id("invalid-id")
      {:error, :application_not_found}
  """
  def get_application_by_client_id(client_id) do
    case Repo.get_by(Application, uid: client_id) do
      nil -> {:error, :application_not_found}
      application -> {:ok, application}
    end
  end

  @doc """
  Gets a single OAuth application.

  ## Examples

      iex> get_application!("01948340-f09f-7c01-95cf-abbc9bc67ce3")
      %Application{}

      iex> get_application!("01948341-403d-7b0d-be8e-701e751fb9a4")
      ** (Ecto.NoResultsError)

  """
  def get_application!(id), do: Repo.get!(Application, id)

  @doc """
  Creates a new OAuth application.

  ## Examples

      iex> create_application(%{name: "My App", redirect_uri: "https://example.com"})
      {:ok, %Application{}}

      iex> create_oauth_application(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_application(attrs) do
    {uid, secret} = Application.generate_uid_and_secret()
    attrs = Map.merge(%{uid: uid, secret: secret}, attrs)

    %Application{}
    |> Application.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an existing OAuth application.

  Only allows updating specific fields like `name` and `scopes`.

  ## Examples

      iex> update_application(application, %{name: "New Name"})
      {:ok, %Application{}}

      iex> update_application(application, %{uid: "new-uid"})
      {:error, %Ecto.Changeset{}}
  """
  def update_application(%Application{} = application, attrs) do
    application
    |> Application.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an OAuth application.

  ## Examples

      iex> delete_application(application)
      {:ok, %Application{}}

      iex> delete_application(application)
      {:error, %Ecto.Changeset{}}
  """
  def delete_application(%Application{} = application) do
    Repo.delete(application)
  end

  @doc """
  Regenerates the secret for an existing OAuth application.

  ## Examples

      iex> regenerate_application_secret(application)
      {:ok, %Application{}}

      iex> regenerate_application_secret(application)
      {:error, %Ecto.Changeset{}}
  """
  def regenerate_application_secret(%Application{} = application) do
    {_, secret} = Application.generate_uid_and_secret()

    application
    |> Application.secret_changeset(%{secret: secret})
    |> Repo.update()
  end

  @doc """
  Lists all access grants for a user.

  ## Examples

      iex> list_access_grants(user.id)
      [%AccessGrant{}, ...]

  """
  def list_access_grants(user_id) do
    Repo.all(from ag in AccessGrant, where: ag.user_id == ^user_id)
  end

  @doc """
  Gets a single access grant by token.

  ## Examples

      iex> get_access_grant_by_token("some_token")
      %AccessGrant{}

      iex> get_access_grant_by_token("invalid_token")
      nil
  """
  def get_access_grant_by_token(token) do
    Repo.get_by(AccessGrant, token: token)
  end

  @doc """
  Creates an access grant.

  ## Examples

      iex> create_access_grant(user, application, %{token: "some_token", ...})
      {:ok, %AccessGrant{}}

      iex> create_access_grant(user, application, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_access_grant(user, application, attrs) do
    attrs =
      attrs
      |> Map.merge(%{
        application_id: application.id,
        user_id: user.id
      })

    %AccessGrant{}
    |> AccessGrant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Revokes an access grant.

  ## Examples

      iex> revoke_access_grant(access_grant)
      {:ok, %AccessGrant{}}

      iex> revoke_access_grant(access_grant)
      {:error, %Ecto.Changeset{}}
  """
  def revoke_access_grant(access_grant) do
    access_grant
    |> AccessGrant.revoke_changeset(%{revoked_at: DateTime.utc_now()})
    |> Repo.update()
  end

  @doc """
  Returns all access tokens for a user.
  """
  def list_access_tokens(user) do
    Repo.all(from t in AccessToken, where: t.user_id == ^user.id)
  end

  @doc """
  Finds an access token by its token value.
  """
  def get_access_token_by_token(token) do
    Repo.get_by(AccessToken, token: token)
  end

  @doc """
  Finds an access token by its refresh token value.
  """
  defp get_refresh_token(token) do
    case Repo.get_by(AccessToken, refresh_token: token) do
      nil -> {:error, :invalid_token}
      record -> {:ok, record}
    end
  end

  @doc """
  Creates an OAuth access token.
  """
  def create_access_token(user, application, attrs) do
    attrs =
      attrs
      |> Map.put_new(:token, AccessToken.generate_token())
      |> Map.put_new(:refresh_token, AccessToken.generate_refresh_token())
      |> Map.put(:application_id, application.id)
      |> maybe_put_user(user)

    %AccessToken{}
    |> AccessToken.changeset(attrs)
    |> Repo.insert()
  end

  defp maybe_put_user(attrs, nil), do: attrs
  defp maybe_put_user(attrs, user), do: Map.put(attrs, :user_id, user.id)

  @doc """
  Revokes the existing access token and issues a new one using a refresh token.

  Returns:
    - `{:ok, new_access_token}` if successful.
    - `{:error, reason}` if the refresh token is invalid, expired, or revoked.
  """
  def refresh_access_token(refresh_token) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:refresh_token_record, fn _repo, _changes ->
      get_refresh_token(refresh_token)
    end)
    |> Ecto.Multi.run(:access_token, fn _repo, %{refresh_token_record: refresh_token_record} ->
      preload_access_token_associations(refresh_token_record)
    end)
    |> Ecto.Multi.run(:validate_access_token, fn _repo, %{access_token: access_token} ->
      validate_access_token_validity(access_token)
    end)
    |> Ecto.Multi.run(:validate_refresh_token, fn _repo, %{access_token: access_token} ->
      validate_refresh_token(refresh_token, access_token.previous_refresh_token)
    end)
    |> Ecto.Multi.update(:revoke_access_token, fn %{access_token: access_token} ->
      AccessToken.revoke_changeset(access_token, %{revoked_at: DateTime.utc_now()})
    end)
    |> Ecto.Multi.insert(:new_access_token, fn %{access_token: access_token} ->
      %AccessToken{}
      |> AccessToken.changeset(%{
        token: AccessToken.generate_token(),
        refresh_token: AccessToken.generate_refresh_token(),
        application_id: access_token.application_id,
        user_id: access_token.user_id,
        scopes: access_token.scopes,
        expires_in: @ttl_access_token,
        previous_refresh_token: refresh_token
      })
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{new_access_token: new_access_token}} ->
        {:ok, new_access_token}

      {:error, _step, reason, _changes} ->
        {:error, reason}
    end
  end

  defp preload_access_token_associations(%AccessToken{} = access_token) do
    case Repo.preload(access_token, [:user, :application]) do
      %AccessToken{} = preloaded_access_token ->
        {:ok, preloaded_access_token}

      _ ->
        {:error, :failed_to_preload}
    end
  end

  defp validate_refresh_token(refresh_token, previous_refresh_token) do
    cond do
      previous_refresh_token == "" ->
        {:ok, :valid}

      refresh_token == previous_refresh_token ->
        {:ok, :valid}

      true ->
        {:error, :invalid_refresh_token}
    end
  end

  @doc """
  Revokes an access token by setting its `revoked_at` field.
  """
  def revoke_access_token(%AccessToken{} = access_token) do
    access_token
    |> AccessToken.revoke_changeset(%{revoked_at: DateTime.utc_now()})
    |> Repo.update()
  end

  @doc """
  Checks is the access token is valid.
  """
  def validate_access_token(token) do
    case get_access_token_by_token(token) do
      nil ->
        {:error, :invalid_token}

      access_token ->
        case validate_access_token_validity(access_token) do
          {:ok, :valid} -> {:ok, access_token}
          error -> error
        end
    end
  end

  defp validate_access_token_validity(%AccessToken{} = access_token) do
    expiration_time = DateTime.add(access_token.inserted_at, access_token.expires_in)
    current_time = DateTime.utc_now()

    cond do
      not is_nil(access_token.revoked_at) ->
        {:error, :token_revoked}

      DateTime.compare(current_time, expiration_time) == :gt ->
        {:error, :token_expired}

      true ->
        {:ok, :valid}
    end
  end

  @doc """
  Creates a new device grant.
  """
  def create_device_grant(application, scopes) do
    {device_code, user_code} = DeviceGrant.generate_tokens()
    expires_in_seconds = 600

    attrs = %{
      device_code: device_code,
      user_code: user_code,
      expires_in: expires_in_seconds,
      application_id: application.id,
      scopes: scopes
    }

    %DeviceGrant{}
    |> DeviceGrant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Finds a device grant by `device_code`.
  """
  def get_device_grant_by_device_code(device_code, preloads \\ []) do
    DeviceGrant
    |> Repo.get_by(device_code: device_code)
    |> maybe_preload(preloads)
  end

  defp maybe_preload(nil, _preloads), do: nil
  defp maybe_preload(device_grant, preloads), do: Repo.preload(device_grant, preloads)

  @doc """
  Finds a device grant by `user_code`.
  """
  def get_device_grant_by_user_code(user_code, preloads \\ []) do
    query =
      from dg in DeviceGrant,
        where: dg.user_code == ^user_code and is_nil(dg.revoked_at),
        preload: ^preloads

    case Repo.one(query) do
      nil -> {:error, :device_grant_not_found}
      device_grant -> {:ok, device_grant}
    end
  end

  @doc """
  Links a device grant to a user.
  """
  def link_device_grant_to_user(device_grant, user_id) do
    if device_grant.user_id do
      {:error, :already_linked}
    else
      device_grant
      |> DeviceGrant.link_changeset(%{user_id: user_id})
      |> Repo.update()
    end
  end

  @doc """
  Fetches and verifies a device grant by device_code and ensures it has been authorized by a user.

  Returns:
    - `{:ok, device_grant}` if authorized and valid.
    - `{:error, :not_found}` if the device grant doesn't exist.
    - `{:error, :unauthorized}` if the user hasn't authorized the grant.
    - `{:error, :expired}` if the grant has expired.
    - `{:error, :revoked}` if the grant has been revoked.
  """
  def get_authorized_device_grant(device_code) do
    case get_device_grant_by_device_code(device_code, [:application, :user]) do
      nil ->
        {:error, :not_found}

      %DeviceGrant{
        user_id: nil,
        revoked_at: nil,
        inserted_at: inserted_at,
        expires_in: expires_in
      } ->
        now = DateTime.utc_now()
        expiration_time = DateTime.add(inserted_at, expires_in)

        if DateTime.compare(now, expiration_time) == :gt do
          {:error, :expired}
        else
          {:error, :unauthorized}
        end

      %DeviceGrant{revoked_at: revoked_at} when not is_nil(revoked_at) ->
        {:error, :revoked}

      %DeviceGrant{} = device_grant ->
        {:ok, device_grant}
    end
  end

  @doc """
  Updates a device grant.
  """
  def update_device_grant(%DeviceGrant{} = device_grant, attrs) do
    device_grant
    |> DeviceGrant.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Revokes a device grant by setting its `revoked_at` field
  """
  def revoke_device_grant(%DeviceGrant{} = device_grant) do
    device_grant
    |> DeviceGrant.revoke_changeset(%{revoked_at: DateTime.utc_now(), expires_in: 0})
    |> Repo.update()
  end

  @doc """
  Validates the device grant.
  Returns:
  - `:ok` if the grant is authorized.
  - `{:error, :unauthorized}` if the user has not authorized the grant.
  - `{:error, :expired}` if the grant has expired.
  """
  def validate_device_grant(%DeviceGrant{
        user_id: nil,
        expires_in: expires_in,
        inserted_at: inserted_at
      }) do
    if DateTime.diff(DateTime.utc_now(), inserted_at) > expires_in do
      {:error, :expired}
    else
      {:error, :unauthorized}
    end
  end

  def validate_device_grant(%DeviceGrant{
        user_id: user_id,
        expires_in: expires_in,
        inserted_at: inserted_at
      })
      when not is_nil(user_id) do
    if DateTime.diff(DateTime.utc_now(), inserted_at) > expires_in do
      {:error, :expired}
    else
      :ok
    end
  end

  @doc """
  Returns the list of oauth_identities for a user.

  ## Examples

      iex> list_identities(user)
      [%Identity{}, ...]
  """
  def list_identities(user) do
    Repo.all(from o in Identity, where: o.user_id == ^user.id)
  end

  @doc """
  Gets a single OAuth identity by provider and UID.

  Returns `nil` if no identity is found.

  ## Examples

      iex> get_oauth_identity("github", "12345")
      %Identity{}

      iex> get_oauth_identity("google", "67890")
      nil
  """
  def get_oauth_identity(provider, uid) do
    Repo.get_by(Identity, provider: provider, uid: uid)
  end

  @doc """
  Gets a single OAuth identity for a specific user by provider and UID.

  Returns `nil` if no identity is found.

  ## Examples

      iex> get_oauth_identity_for_user(user.id, "github", "12345")
      %Identity{}

      iex> get_oauth_identity_for_user(user.id, "google", "67890")
      nil
  """
  def get_oauth_identity_for_user(user_id, provider, uid) do
    Repo.get_by(Identity, user_id: user_id, provider: provider, uid: uid)
  end

  @doc """
  Creates an OAuth identity.

  If a `user_id` is provided, the identity will be associated with the specified user.

  ## Examples

      iex> create_oauth_identity(%{provider: "github", uid: "12345"}, user.id)
      {:ok, %Identity{}}

      iex> create_oauth_identity(%{provider: "google", uid: "67890"})
      {:ok, %Identity{}}

      iex> create_oauth_identity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_oauth_identity(attrs, user_id \\ nil) do
    attrs =
      if user_id do
        Map.put(attrs, :user_id, user_id)
      else
        attrs
      end

    %Identity{}
    |> Identity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an existing OAuth identity.

  ## Examples

      iex> update_oauth_identity(oauth_identity, %{access_token: "new_token"})
      {:ok, %Identity{}}

      iex> update_oauth_identity(oauth_identity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_oauth_identity(%Identity{} = oauth_identity, attrs) do
    oauth_identity
    |> Identity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an OAuth identity.

  ## Examples

      iex> delete_oauth_identity(oauth_identity)
      {:ok, %Identity{}}

      iex> delete_oauth_identity(oauth_identity)
      {:error, %Ecto.Changeset{}}
  """
  def delete_oauth_identity(%Identity{} = oauth_identity) do
    Repo.delete(oauth_identity)
  end

  @doc """
  Links an existing OAuth identity to a user by updating the `user_id` field.

  ## Examples

      iex> link_identity_to_user(oauth_identity, user.id)
      {:ok, %Identity{}}

      iex> link_identity_to_user(oauth_identity, nil)
      {:error, %Ecto.Changeset{}}
  """
  def link_identity_to_user(%Identity{} = identity, user_id) do
    identity
    |> Identity.changeset(%{user_id: user_id})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking OAuth identity changes.

  ## Examples

      iex> change_oauth_identity(oauth_identity)
      %Ecto.Changeset{data: %Identity{}}

      iex> change_oauth_identity(oauth_identity, %{provider: "github"})
      %Ecto.Changeset{data: %Identity{}}
  """
  def change_oauth_identity(%Identity{} = oauth_identity, attrs \\ %{}) do
    Identity.changeset(oauth_identity, attrs)
  end

  @doc """
  Checks if the API key has the required scope.

  ## Examples

      iex> valid_scope?(api_key, "repo:read")
      true

      iex> valid_scope?(api_key, "repo:write")
      false

  """
  def valid_scope?(scopes, required_scope) do
    Enum.any?(scopes, fn scope ->
      matches_scope?(scope, required_scope) || matches_wildcard_scope?(scope, required_scope)
    end)
  end

  defp matches_scope?(scope, required_scope) do
    scope == required_scope
  end

  defp matches_wildcard_scope?(scope, required_scope) do
    String.starts_with?(required_scope, String.trim_trailing(scope, "*"))
  end
end
