defmodule Accomplish.Accounts.User do
  @moduledoc false

  use Accomplish.Schema
  alias Accomplish.Accounts.ApiKey
  alias Accomplish.Accounts.NotificationSettings
  alias Accomplish.Accounts.UserProfile
  alias Accomplish.OAuth

  @profile_fields ~w(
    first_name
    last_name
    username
  )a

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :full_name, :string, virtual: true

    field :username, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :current_password, :string, virtual: true, redact: true
    field :confirmed_at, :utc_datetime

    has_many :api_keys, ApiKey
    has_many :oauth_identities, OAuth.Identity, foreign_key: :user_id

    embeds_one :profile, UserProfile, on_replace: :update
    embeds_one :notification_settings, NotificationSettings, on_replace: :update

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> downcase_username()
    |> validate_email(opts)
    |> validate_password(opts)
    |> validate_username(opts)
  end

  def notification_settings_changeset(user, _attrs) do
    user
    |> cast_embed(:notification_settings)
  end

  def profile_changeset(user, attrs, opts \\ []) do
    attrs = process_full_name(attrs)

    user
    |> cast(attrs, @profile_fields)
    |> downcase_username()
    |> validate_username(opts)
    |> cast_embed(:profile)
    |> maybe_set_full_name()
  end

  @doc """
    A user changeset for OAuth-based registration.

    This changeset is designed specifically for users created via OAuth providers
    (e.g., GitHub, Google). Since OAuth users typically do not provide a password during
    registration, a placeholder password is set to satisfy database constraints.

    ## Options

      * `:validate_email` - Validates the uniqueness of the email. If uniqueness validation
        is not required (e.g., when validating in a LiveView form before submitting), this
        option can be set to `false`. Defaults to `true`.

      * `:validate_username` - Ensures the username meets format and length requirements.
        Defaults to `true`.

    ## Attributes

    The function casts the following attributes:
      * `:email` - The email address of the user (required).
      * `:username` - The username for the user (required).

    ## Example

        iex> changeset = oauth_changeset(%User{}, %{email: "user@example.com", username: "username"})
        %Ecto.Changeset{
          valid?: true,
          changes: %{
            email: "user@example.com",
            username: "username",
            hashed_password: "$2b$12$..."
          }
        }

    The `hashed_password` field is set using a predefined placeholder value.

    ## Notes

    - `set_placeholder_password/1` ensures that OAuth users have a hashed password
      even though they won't authenticate with it. This placeholder prevents database
      constraints from being violated.
    - The changeset uses `validate_email/2` and `validate_username/2` to enforce uniqueness
      and format rules, if configured.
  """
  def oauth_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :username])
    |> downcase_username()
    |> set_placeholder_password()
    |> validate_email(opts)
    |> validate_username(opts)
  end

  defp set_placeholder_password(changeset) do
    placeholder_password = "oauth_user_placeholder"
    hashed_placeholder = Bcrypt.hash_pwd_salt(placeholder_password)

    changeset
    |> put_change(:hashed_password, hashed_placeholder)
    |> delete_change(:password)
  end

  defp validate_username(changeset, opts) do
    min_length = Keyword.get(opts, :min_length, 4)

    changeset
    |> validate_required([:username])
    |> validate_format(:username, ~r/^(?!-)[a-z0-9-]{1,39}(?<!-)$/)
    |> validate_length(:username, min: min_length, max: 39)
    |> maybe_validate_unique_username(opts)
  end

  defp downcase_username(changeset) do
    if username = get_change(changeset, :username) do
      put_change(changeset, :username, String.downcase(username))
    else
      changeset
    end
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # Examples of additional password validation:
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_username(changeset, opts) do
    if Keyword.get(opts, :validate_username, true) do
      changeset
      |> unsafe_validate_unique(:username, Accomplish.Repo)
      |> unique_constraint(:username)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Accomplish.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Accomplish.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    changeset = cast(changeset, %{current_password: password}, [:current_password])

    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  def display_name(user) do
    cond do
      user.first_name && user.last_name -> "#{user.first_name} #{user.last_name}"
      user.first_name -> user.first_name
      true -> user.username
    end
  end

  defp maybe_set_full_name(changeset) do
    if get_change(changeset, :full_name) do
      changeset
    else
      user = changeset.data
      first = get_field(changeset, :first_name) || user.first_name || ""
      last = get_field(changeset, :last_name) || user.last_name || ""

      full_name =
        [first, last]
        |> Enum.reject(&(is_nil(&1) || &1 == ""))
        |> Enum.join(" ")
        |> String.trim()

      put_change(changeset, :full_name, full_name)
    end
  end

  defp process_full_name(%{"full_name" => full_name} = attrs)
       when is_binary(full_name) and full_name != "" do
    names = String.split(full_name, " ", trim: true)

    first_name = List.first(names, "")

    last_name =
      case Enum.drop(names, 1) do
        [] -> nil
        rest -> Enum.join(rest, " ")
      end

    attrs
    |> Map.delete("full_name")
    |> Map.put("first_name", first_name)
    |> Map.put("last_name", last_name)
  end

  defp process_full_name(%{full_name: full_name} = attrs)
       when is_binary(full_name) and full_name != "" do
    process_full_name(%{"full_name" => full_name} |> Map.merge(Map.drop(attrs, [:full_name])))
  end

  defp process_full_name(attrs), do: attrs
end
