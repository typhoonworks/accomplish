defmodule Accomplish.Accounts.NotificationTypes do
  @moduledoc false

  use Accomplish.Schema

  @primary_key false

  @permitted ~w(everything)a
  @required ~w(everything)a

  embedded_schema do
    field :everything, :boolean, default: true
  end

  def changeset(types, attrs \\ %{}) do
    types
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
