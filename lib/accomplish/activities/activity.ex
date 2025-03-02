defmodule Accomplish.Activities.Activity do
  @moduledoc """
  Represents an activity log entry for tracking changes in job applications and other related entities.
  """

  use Accomplish.Schema

  @permitted ~w(actor_id actor_type action entity_id entity_type context_id context_type metadata occurred_at)a
  @required ~w(actor_id action entity_id entity_type occurred_at)a

  @derive {JSON.Encoder,
           only: [
             :id,
             :actor_id,
             :actor_type,
             :action,
             :entity_id,
             :entity_type,
             :context_id,
             :context_type,
             :metadata,
             :occurred_at,
             :inserted_at
           ]}

  schema "activities" do
    field :actor_id, :binary_id
    field :actor_type, :string, default: "User"
    field :action, :string
    field :metadata, :map, default: %{}

    field :entity_id, :binary_id
    field :entity_type, :string

    field :context_id, :binary_id
    field :context_type, :string

    field :actor, :any, virtual: true
    field :entity, :any, virtual: true
    field :context, :any, virtual: true

    field :occurred_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc """
  Creates a changeset for an activity record.
  """
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
