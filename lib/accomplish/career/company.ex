defmodule Accomplish.Career.Company do
  @moduledoc false

  use Accomplish.Schema

  @permitted ~w(name website notes)a
  @required ~w(name)a

  @derive {JSON.Encoder,
           only: [
             :id,
             :name,
             :website,
             :notes,
             :inserted_at,
             :updated_at
           ]}

  schema "companies" do
    field :name, :string
    field :website, :string
    field :notes, :string

    has_many :job_applications, Accomplish.Career.JobApplication

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
    |> validate_format(:website, ~r/^https?:\/\/[\S]+$/, message: "must be a valid URL")
    |> unsafe_validate_unique(:name, Accomplish.Repo)
    |> unique_constraint(:name)
  end
end
