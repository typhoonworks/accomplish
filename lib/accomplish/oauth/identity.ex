defmodule Accomplish.OAuth.Identity do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.Accounts.User

  @providers ~w(github)
  @permitted ~w(uid provider scopes user_id access_token refresh_token expires_at user_id)a
  @required ~w(uid provider scopes)a

  schema "oauth_identities" do
    field :uid, :string
    field :provider, :string
    field :access_token, :string
    field :refresh_token, :string
    field :expires_at, :utc_datetime
    field :scopes, {:array, :string}, default: []

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(oauth_identity, attrs) do
    oauth_identity
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> validate_inclusion(:provider, @providers)
    |> assoc_constraint(:user)
    |> unique_constraint([:provider, :uid])
  end
end
