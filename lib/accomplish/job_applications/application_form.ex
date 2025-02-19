defmodule Accomplish.JobApplications.ApplicationForm do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @permitted ~w(role source applied_at company_name status notes)a
  @required ~w(role company_name status applied_at)a

  @status_types [:applied, :interviewing, :offer, :accepted, :rejected]

  embedded_schema do
    field :role, :string
    field :source, :string
    field :status, Ecto.Enum, values: @status_types, default: :applied
    field :notes, :string
    field :applied_at, :utc_datetime
    field :company_name, :string, virtual: true
  end

  @doc "Changeset for job application form"
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> validate_length(:role, min: 2)
  end
end
