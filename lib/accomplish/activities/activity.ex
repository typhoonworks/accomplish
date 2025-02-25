defmodule Accomplish.Activities.Activity do
  @moduledoc """
  Represents an activity log entry for tracking changes in job applications and other related entities.
  """

  use Accomplish.Schema

  @permitted ~w(actor_id actor_type action target_id target_type metadata)a
  @required ~w(actor_id action target_id target_type)a

  @derive {JSON.Encoder,
           only: [
             :id,
             :actor_id,
             :actor_type,
             :action,
             :target_id,
             :target_type,
             :metadata,
             :inserted_at
           ]}

  schema "activities" do
    field :actor_id, :binary_id
    field :actor_type, :string, default: "User"
    field :action, :string
    field :metadata, :map, default: %{}

    field :target_id, :binary_id
    field :target_type, :string

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
