defmodule Accomplish.Accounts.PreferenceSettings do
  use Accomplish.Schema

  @primary_key false

  @permitted ~w()a
  @required ~w()a

  embedded_schema do
  end

  def changeset(settings, attrs \\ %{}) do
    settings
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
