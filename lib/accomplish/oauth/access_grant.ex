defmodule Accomplish.OAuth.AccessGrant do
  @moduledoc """
  Schema for OAuth Access Grants, used for authorization flows.
  """

  use Accomplish.Schema

  alias Accomplish.Accounts.User
  alias Accomplish.OAuth.Application
  alias Accomplish.Scopes

  @permitted ~w(token expires_in redirect_uri scopes revoked_at user_id application_id)a
  @required ~w(token expires_in redirect_uri scopes user_id application_id)a

  schema "oauth_access_grants" do
    field :token, :string
    field :expires_in, :integer
    field :redirect_uri, :string
    field :scopes, {:array, :string}, default: []
    field :revoked_at, :utc_datetime

    belongs_to :user, User
    belongs_to :application, Application

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(access_grant, attrs) do
    access_grant
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> validate_length(:token, min: 32)
    |> validate_expiration()
    |> Validators.validate_url(:redirect_uri)
    |> Scopes.validate_scopes(:scopes)
    |> unique_constraint(:token)
    |> assoc_constraint(:user)
    |> assoc_constraint(:application)
  end

  @doc false
  def revoke_changeset(application, attrs) do
    application
    |> cast(attrs, [:revoked_at])
    |> validate_required([:revoked_at])
    |> case do
      %{changes: %{revoked_at: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :revoked_at, "did not change")
    end
  end

  @doc false
  def generate_token do
    :crypto.strong_rand_bytes(24)
    |> Base.url_encode64(padding: false)
    |> String.slice(0, 32)
  end

  defp validate_expiration(changeset) do
    validate_change(changeset, :expires_in, fn _, value ->
      if value > 0, do: [], else: [{:expires_in, "must be greater than zero"}]
    end)
  end
end
