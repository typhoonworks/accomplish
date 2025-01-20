defmodule Accomplish.OAuth do
  @moduledoc """
  The OAuth context for managing OAuth identities associated with users.
  """

  import Ecto.Query, warn: false
  alias Accomplish.Repo
  alias Accomplish.OAuth.Application
  alias Accomplish.OAuth.Identity

  @doc """
  Returns a list of OAuth applications.

  ## Examples

      iex> list_applications()
      [%Application{}, ...]
  """
  def list_applications, do: Repo.all(Application)

  @doc """
  Gets a single OAuth application.

  ## Examples

      iex> get_application!("01948340-f09f-7c01-95cf-abbc9bc67ce3")
      %User{}

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
  Returns the list of oauth_identities for a given user.

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
end
