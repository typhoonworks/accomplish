defmodule Accomplish.Notifications.Notification do
  use Accomplish.Schema

  alias Accomplish.Accounts.User

  @permitted ~w(actor_id actor_type status type event_name source_id source_type navigate_url metadata)a
  @required ~w(actor_id actor_type status type)a

  schema "notifications" do
    field :status, Ecto.Enum, values: [:unread, :read], default: :unread
    field :type, Ecto.Enum, values: [:email, :web]
    field :event_name, :string
    field :navigate_url, :string
    field :metadata, :map, default: %{}

    field :actor_id, :binary_id
    field :actor_type, :string, default: "User"
    field :source_id, :binary_id
    field :source_type, :string

    field :actor, :any, virtual: true
    field :source, :any, virtual: true

    belongs_to :recipient, User, type: :binary_id, foreign_key: :recipient_id

    timestamps(type: :utc_datetime)
  end

  def create_changeset(recipient, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> put_assoc(:recipient, recipient)
  end

  def changeset(notification, attrs) do
    notification
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> assoc_constraint(:recipient)
  end
end
