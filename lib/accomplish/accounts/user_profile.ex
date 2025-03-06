defmodule Accomplish.Accounts.UserProfile do
  use Accomplish.Schema

  @primary_key false

  @permitted ~w(headline bio)a
  @required ~w(headline)a

  embedded_schema do
    field :headline, :string
    field :bio, :string
  end

  def changeset(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
