defmodule Accomplish.Profiles.Experience do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.Profiles.Profile

  import Accomplish.DateValidators, only: [validate_start_date_before_end_date: 1]

  @permitted ~w(profile_id company role start_date end_date description location is_current)a
  @required ~w(profile_id company role start_date)a

  @derive {JSON.Encoder,
           only: [
             :id,
             :company,
             :role,
             :start_date,
             :end_date,
             :description,
             :location,
             :is_current,
             :inserted_at,
             :updated_at
           ]}

  schema "profile_experiences" do
    field :company, :string
    field :role, :string
    field :start_date, :date
    field :end_date, :date
    field :is_current, :boolean, default: false
    field :description, :string
    field :location, :string

    belongs_to :profile, Profile

    timestamps()
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
