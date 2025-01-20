defmodule Accomplish.OAuth.DeviceGrant do
  @moduledoc """
  Schema for OAuth Device Grants, used in the Device Authorization Grant flow.
  """

  use Accomplish.Schema

  alias Accomplish.Accounts.User
  alias Accomplish.OAuth.Application
  alias Accomplish.OAuth.Token
  alias Accomplish.Scopes

  @permitted ~w(device_code user_code expires_in scopes last_polling_at user_id application_id)a
  @permitted_update_attrs ~w(last_polling_at expires_in)a
  @required ~w(device_code user_code expires_in scopes application_id)a

  schema "oauth_device_grants" do
    field :device_code, :string
    field :user_code, :string
    field :expires_in, :integer
    field :last_polling_at, :utc_datetime_usec
    field :revoked_at, :utc_datetime_usec
    field :scopes, {:array, :string}, default: []

    belongs_to :user, User
    belongs_to :application, Application

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(device_grant, attrs) do
    device_grant
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> validate_token_lengths()
    |> validate_expiration()
    |> Scopes.validate_scopes(:scopes)
    |> unique_constraint(:device_code)
    |> unique_constraint(:user_code)
    |> assoc_constraint(:application)
    |> assoc_constraint(:user)
  end

  @doc false
  def update_changeset(device_grant, attrs) do
    device_grant
    |> cast(attrs, @permitted_update_attrs)
    |> validate_last_polling_at()
  end

  @doc false
  def revoke_changeset(device_grant, attrs) do
    device_grant
    |> cast(attrs, [:revoked_at, :expires_in])
    |> validate_required([:revoked_at, :expires_in])
    |> validate_change(:expires_in, fn _, value ->
      if value == 0, do: [], else: [{:expires_in, "must be set to 0 for revocation"}]
    end)
  end

  @doc false
  def link_changeset(device_grant, attrs) do
    device_grant
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> assoc_constraint(:user)
  end

  defp validate_token_lengths(changeset) do
    changeset
    |> validate_length(:device_code, min: 32)
    |> validate_length(:user_code, min: 6)
  end

  defp validate_expiration(changeset) do
    validate_change(changeset, :expires_in, fn _, value ->
      if value > 0, do: [], else: [{:expires_in, "must be greater than zero"}]
    end)
  end

  defp validate_last_polling_at(changeset) do
    validate_change(changeset, :last_polling_at, fn _, value ->
      if DateTime.compare(value, DateTime.utc_now()) != :gt,
        do: [],
        else: [{:last_polling_at, "cannot be in the future"}]
    end)
  end

  @doc false
  def generate_tokens do
    device_code = Token.generate(32)
    user_code = Token.generate_user_code(6)
    {device_code, user_code}
  end
end
