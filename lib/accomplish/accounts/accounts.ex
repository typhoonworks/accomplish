defmodule Accomplish.Accounts do
  @moduledoc """
  The Accounts context.
  """

  use Accomplish.Context

  alias Accomplish.Accounts.{User, UserToken, UserNotifier, ApiKey}

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!("01948340-f09f-7c01-95cf-abbc9bc67ce3")
      %User{}

      iex> get_user!("01948341-403d-7b0d-be8e-701e751fb9a4")
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs, opts \\ []) do
    %User{}
    |> User.registration_changeset(attrs, opts)
    |> Repo.insert()
  end

  @doc """
    Creates a user using data provided by an OAuth provider.

    ## Examples

        iex> create_user_from_oauth(%{email: "user@example.com", username: "username"})
        {:ok, %User{}}

        iex> create_user_from_oauth(%{email: nil, username: "username"})
        {:error, %Ecto.Changeset{}}
  """
  def create_user_from_oauth(attrs, opts \\ []) do
    %User{}
    |> User.oauth_changeset(attrs, opts)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false, validate_email: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs, validate_email: false)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, [context]))
  end

  @doc ~S"""
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_user_update_email_instructions(user, current_email, &url(~p"/settings/email_confirmation/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc ~S"""
  Delivers the confirmation email instructions to the given user.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &url(~p"/confirm_user/#{&1}"))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &url(~p"/confirm_user/#{&1}"))
      {:error, :already_confirmed}

  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc ~S"""
  Delivers the reset password email to the given user.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &url(~p"/password_reset/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## API Keys

  @doc """
  Creates an API key for the given user with the provided attributes.

  ## Examples

      iex> create_api_key(user, %{name: "My API Key"})
      {:ok, %ApiKey{}}

      iex> create_api_key(user, %{name: "Custom Scopes Key", scopes: ["repositories:read", "repositories:write"]})
      {:ok, %ApiKey{}}

      iex> create_api_key(user, %{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_api_key(user, attrs) do
    {raw_key, prefix} = ApiKey.generate_key()
    hashed_key = ApiKey.hash_key(raw_key)

    attrs =
      attrs
      |> Map.merge(%{
        key_hash: hashed_key,
        key_prefix: prefix,
        user_id: user.id
      })

    %ApiKey{}
    |> ApiKey.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, api_key} -> {:ok, Map.put(api_key, :raw_key, raw_key)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Lists all API keys for the given user.

  ## Examples

      iex> list_api_keys(user)
      [%ApiKey{}, ...]

  """
  def list_api_keys(user) do
    Repo.all(from k in ApiKey, where: k.user_id == ^user.id and is_nil(k.revoked_at))
  end

  @doc """
  Finds an active API key by its raw value.

  ## Examples

      iex> find_api_key("raw_key_value")
      {:ok, %ApiKey{}}

      iex> find_api_key("invalid_key")
      {:error, :invalid_api_key}

  """
  def find_api_key(raw_key) do
    hashed_key = ApiKey.hash_key(raw_key)

    query =
      from(k in ApiKey,
        join: user in assoc(k, :user),
        where: k.key_hash == ^hashed_key and is_nil(k.revoked_at),
        preload: [user: user]
      )

    case Repo.one(query) do
      nil -> {:error, :invalid_api_key}
      api_key -> {:ok, api_key}
    end
  end

  @doc """
  Revokes the API key with the given raw key value.

  ## Examples

      iex> revoke_api_key("raw_key_value")
      :ok

      iex> revoke_api_key("invalid_key")
      {:error, :not_found}

  """
  def revoke_api_key(raw_key) do
    hashed_key = ApiKey.hash_key(raw_key)

    query =
      from k in ApiKey,
        where: k.key_hash == ^hashed_key and is_nil(k.revoked_at)

    case Repo.update_all(query, set: [revoked_at: DateTime.utc_now()]) do
      {1, _} -> :ok
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Checks if the API key has the required scope.

  ## Examples

      iex> valid_scope?(api_key, "repo:read")
      true

      iex> valid_scope?(api_key, "repo:write")
      false

  """
  def valid_scope?(%ApiKey{scopes: scopes}, required_scope) do
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
