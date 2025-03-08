defmodule Accomplish.Profiles.Education do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.Profiles.Profile

  import Accomplish.DateValidators, only: [validate_start_date_before_end_date: 1]

  @permitted ~w(school degree field_of_study start_date end_date description)a
  @required ~w(school degree field_of_study start_date)a

  @derive {JSON.Encoder,
           only: [
             :id,
             :school,
             :degree,
             :field_of_study,
             :start_date,
             :end_date,
             :description,
             :inserted_at,
             :updated_at
           ]}

  schema "profile_educations" do
    field :school, :string
    field :degree, :string
    field :field_of_study, :string
    field :start_date, :date
    field :end_date, :date
    field :description, :string

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
