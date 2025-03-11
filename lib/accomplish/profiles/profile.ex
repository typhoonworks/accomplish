defmodule Accomplish.Profiles.Profile do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.Accounts.User
  alias Accomplish.Profiles.Experience
  alias Accomplish.Profiles.Education

  @permitted ~w(bio headline location website_url github_handle linkedin_handle skills interests)a
  @required []

  @derive {JSON.Encoder,
           except: [:__meta__],
           only: [
             :id,
             :bio,
             :headline,
             :location,
             :website_url,
             :github_handle,
             :linkedin_handle,
             :skills,
             :interests,
             :inserted_at,
             :updated_at
           ]}

  schema "profiles" do
    field :bio, :string
    field :headline, :string
    field :location, :string
    field :website_url, :string
    field :github_handle, :string
    field :linkedin_handle, :string
    field :skills, {:array, :string}, default: []
    field :interests, :string

    belongs_to :user, User

    has_many :experiences, Experience
    has_many :educations, Education

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
    |> URLValidators.validate_url(:website_url, strict: false)
    |> assoc_constraint(:user)
  end
end
