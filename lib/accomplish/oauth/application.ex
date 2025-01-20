defmodule Accomplish.OAuth.Application do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.Scopes

  @permitted ~w(name uid secret redirect_uri scopes confidential)a
  @permitted_update_attrs ~w(name scopes redirect_uri)a
  @required ~w(name uid secret redirect_uri)a

  schema "oauth_applications" do
    field :name, :string
    field :uid, :string
    field :secret, :string
    field :redirect_uri, :string
    field :scopes, {:array, :string}, default: []
    field :confidential, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> common_validations()
    |> unique_constraint(:uid)
  end

  @doc false
  def update_changeset(application, attrs) do
    application
    |> cast(attrs, @permitted_update_attrs)
    |> validate_required([:name])
    |> common_validations()
  end

  @doc false
  def secret_changeset(application, attrs) do
    application
    |> cast(attrs, [:secret])
    |> validate_required([:secret])
    |> case do
      %{changes: %{secret: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :secret, "did not change")
    end
  end

  @doc false
  def generate_uid_and_secret do
    uid = :crypto.strong_rand_bytes(16) |> Base.url_encode64(padding: false)
    secret = :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
    {uid, secret}
  end

  defp common_validations(changeset) do
    changeset
    |> validate_length(:name, min: 3, max: 100)
    |> Validators.validate_url(:redirect_uri)
    |> Scopes.validate_scopes(:scopes)
  end
end
