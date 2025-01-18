defmodule Accomplish.Accounts.ApiKey do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.Accounts.User

  @permitted ~w(name key_hash key_prefix scopes revoked_at user_id)a
  @required ~w(name key_hash key_prefix scopes user_id)a

  schema "api_keys" do
    field :name, :string
    field :key_hash, :string
    field :key_prefix, :string
    field :scopes, {:array, :string}, default: ["default:read"]
    field :revoked_at, :utc_datetime

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> validate_length(:key_prefix, is: 6)
    |> unique_constraint(:key_hash)
  end

  def generate_key do
    raw_key = :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
    key_prefix = String.slice(raw_key, 0, 6)
    {raw_key, key_prefix}
  end

  def hash_key(key) do
    :crypto.hash(:sha256, key) |> Base.encode16(case: :lower)
  end

  def process_key_changeset(%Ecto.Changeset{valid?: true, changes: %{name: name}} = changeset) do
    {raw_key, prefix} = generate_key()
    hashed_key = hash_key(raw_key)

    changeset
    |> put_change(:key_hash, hashed_key)
    |> put_change(:key_prefix, prefix)
    |> put_change(:name, name)
    |> Map.put(:raw_key, raw_key)
  end

  def process_key_changeset(changeset), do: changeset
end
