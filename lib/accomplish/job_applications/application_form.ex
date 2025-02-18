defmodule Accomplish.JobApplications.ApplicationForm do
  use Ecto.Schema
  import Ecto.Changeset

  @permitted ~w(role source applied_at company_name)a
  @required ~w(role company_name applied_at)a

  embedded_schema do
    field :role, :string
    field :source, :string
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
