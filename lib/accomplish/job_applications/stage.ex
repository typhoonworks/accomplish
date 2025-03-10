defmodule Accomplish.JobApplications.Stage do
  @moduledoc false

  use Accomplish.Schema
  import Ecto.SoftDelete.Schema

  alias Accomplish.JobApplications.Application

  @permitted ~w(title type status is_final_stage date location notes)a
  @required ~w(title type status)a

  @type_values ~w(screening assessment interview offer)a
  @status_values ~w(pending scheduled in_progress completed skipped)a

  @derive {JSON.Encoder,
           except: [:__meta__],
           only: [
             :id,
             :title,
             :type,
             :status,
             :is_final_stage,
             :date,
             :location,
             :notes,
             :application_id,
             :inserted_at,
             :updated_at
           ]}

  schema "job_application_stages" do
    field :slug, :string
    field :title, :string
    field :type, Ecto.Enum, values: @type_values
    field :status, Ecto.Enum, values: @status_values, default: :pending
    field :is_final_stage, :boolean, default: false
    field :date, :utc_datetime
    field :location, :string
    field :notes, :string

    belongs_to :application, Application, foreign_key: :application_id

    timestamps(type: :utc_datetime)
    soft_delete_schema()
  end

  @doc false
  def changeset(stage, attrs) do
    stage
    |> cast(attrs, @permitted)
    |> common_validations()
  end

  @doc false
  def create_changeset(application, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> put_assoc(:application, application)
  end

  @doc false
  def update_changeset(stage, attrs) do
    stage |> changeset(attrs)
  end

  defp common_validations(changeset) do
    changeset
    |> validate_required(@required)
    |> assoc_constraint(:application)
  end
end
