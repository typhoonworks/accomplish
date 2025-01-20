defmodule Accomplish.OAuth.AccessToken do
  @moduledoc """
  Schema for OAuth Access Tokens.
  """

  use Accomplish.Schema

  alias Accomplish.Accounts.User
  alias Accomplish.OAuth.Application
  alias Accomplish.OAuth.Token
  alias Accomplish.Scopes

  @permitted ~w(token refresh_token expires_in scopes revoked_at previous_refresh_token user_id application_id)a
  @required ~w(token expires_in application_id)a

  schema "oauth_access_tokens" do
    field :token, :string
    field :refresh_token, :string
    field :expires_in, :integer
    field :scopes, {:array, :string}, default: []
    field :revoked_at, :utc_datetime
    field :previous_refresh_token, :string, default: ""

    belongs_to :user, User
    belongs_to :application, Application

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(access_token, attrs) do
    access_token
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> validate_length(:token, min: 32)
    |> validate_expiration()
    |> Scopes.validate_scopes(:scopes)
    |> unique_constraint(:token)
    |> unique_constraint(:refresh_token)
    |> assoc_constraint(:user)
    |> assoc_constraint(:application)
  end

  @doc false
  def revoke_changeset(access_token, attrs) do
    access_token
    |> cast(attrs, [:revoked_at])
    |> validate_required([:revoked_at])
    |> case do
      %{changes: %{revoked_at: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :revoked_at, "did not change")
    end
  end

  @doc false
  def generate_token do
    Token.generate()
  end

  @doc false
  def generate_refresh_token do
    Token.generate_refresh_token()
  end

  defp validate_expiration(changeset) do
    validate_change(changeset, :expires_in, fn _, value ->
      if value > 0, do: [], else: [{:expires_in, "must be greater than zero"}]
    end)
  end
end
