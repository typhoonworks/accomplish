defmodule Accomplish.JobApplications.ApplicationForm do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @permitted ~w(role source applied_at company_name status notes)a
  @required ~w(role company_name status)a
  @required_when_not_draft ~w(applied_at)a

  @status_types ~w(draft applied interviewing offer accepted rejected)a

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
    |> validate_conditional_requirements()
  end

  defp validate_conditional_requirements(%{changes: %{status: :draft}} = changeset), do: changeset

  defp validate_conditional_requirements(changeset) do
    case get_field(changeset, :status) do
      :draft -> changeset
      _other -> validate_required(changeset, @required_when_not_draft)
    end
  end
end
