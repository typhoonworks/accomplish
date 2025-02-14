defmodule Accomplish.JobApplications.Stage do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.JobApplications.Application

  @permitted ~w(title type position is_final_stage date location notes)a
  @required ~w(title type position)a

  @type_values [:screening, :assessment, :interview, :offer]

  @derive {JSON.Encoder,
           only: [
             :id,
             :title,
             :type,
             :position,
             :is_final_stage,
             :date,
             :location,
             :notes,
             :application_id,
             :inserted_at,
             :updated_at
           ]}

  schema "job_application_stages" do
    field :title, :string
    field :type, Ecto.Enum, values: @type_values
    field :position, :integer
    field :is_final_stage, :boolean, default: false
    field :date, :utc_datetime
    field :location, :string
    field :notes, :string

    belongs_to :application, Application, foreign_key: :application_id

    timestamps(type: :utc_datetime)
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
    |> validate_number(:position, greater_than_or_equal_to: 1)
    |> unsafe_validate_unique(:position, Accomplish.Repo)
    |> unique_constraint(:position,
      name: :job_application_stages_job_application_id_position_index
    )
    |> assoc_constraint(:application)
  end
end
