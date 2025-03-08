defmodule Accomplish.Profiles.Experience do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.Profiles.Profile

  import Accomplish.DateValidators, only: [validate_start_date_before_end_date: 1]

  @permitted ~w(company employment_type role start_date end_date description workplace_type location)a
  @required ~w(company role start_date description)a

  @employment_types ~w(full_time part_time contractor employer_of_record internship)a
  @workplace_types ~w(remote hybrid on_site)a

  @derive {JSON.Encoder,
           only: [
             :id,
             :company,
             :employment_type,
             :workplace_type,
             :role,
             :start_date,
             :end_date,
             :description,
             :location,
             :inserted_at,
             :updated_at
           ]}

  schema "profile_experiences" do
    field :company, :string
    field :employment_type, Ecto.Enum, values: @employment_types, default: nil
    field :workplace_type, Ecto.Enum, values: @workplace_types, default: nil
    field :role, :string
    field :start_date, :date
    field :end_date, :date
    field :description, :string
    field :location, :string

    belongs_to :profile, Profile

    timestamps()
  end

  def create_changeset(profile, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> put_assoc(:profile, profile)
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, @permitted)
    |> common_validations()
  end

  def update_changeset(profile, attrs) do
    profile |> changeset(attrs)
  end

  defp common_validations(changeset) do
    changeset
    |> validate_required(@required)
    |> validate_start_date_before_end_date()
    |> assoc_constraint(:profile)
  end
end
