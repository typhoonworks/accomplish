defmodule Accomplish.Accounts.NotificationSettings do
  use Accomplish.Schema

  alias Accomplish.Accounts.NotificationTypes

  @primary_key false

  @permitted ~w(sounds)a
  @required ~w(sounds)a

  embedded_schema do
    field :sounds, :boolean, default: true

    embeds_one :email, NotificationTypes, on_replace: :update
    embeds_one :web, NotificationTypes, on_replace: :update
  end

  def changeset(settings, attrs \\ %{}) do
    settings
    |> cast(attrs, @permitted)
    |> cast_embed(:email)
    |> cast_embed(:web)
    |> validate_required(@required)
  end
end
