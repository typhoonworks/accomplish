defmodule Accomplish.OAuth do
  @moduledoc """
  The OAuth context for managing OAuth identities associated with users.
  """

  import Ecto.Query, warn: false
  alias Accomplish.Repo
  alias Accomplish.OAuth.Identity

  @doc """
  Returns the list of oauth_identities for a given user.

  ## Examples

      iex> list_oauth_identities(user)
      [%Identity{}, ...]
  """
  def list_oauth_identities(user) do
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
end
