defmodule Accomplish.JobApplications.Company do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.JobApplications.Application

  @permitted ~w(name)a
  @required ~w(name)a

  @derive {JSON.Encoder,
           only: [
             :id,
             :name,
             :inserted_at,
             :updated_at
           ]}

  schema "companies" do
    field :name, :string

    has_many :job_applications, Application

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, @permitted)
    |> common_validations()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{} |> changeset(attrs)
  end

  @doc false
  def update_changeset(company, attrs) do
    company |> changeset(attrs)
  end

  defp common_validations(changeset) do
    changeset
    |> validate_required(@required)
    |> unsafe_validate_unique(:name, Accomplish.Repo)
    |> unique_constraint(:name)
  end
end
