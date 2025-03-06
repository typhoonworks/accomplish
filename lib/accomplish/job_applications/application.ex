defmodule Accomplish.JobApplications.Application do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.Accounts.User
  alias Accomplish.JobApplications.Company
  alias Accomplish.JobApplications.Stage

  @permitted ~w(role location status applied_at last_updated_at source job_description notes)a
  @required ~w(role location status)a
  @required_when_not_draft ~w(applied_at)a

  @status_types ~w(draft applied interviewing offer accepted rejected)a
  @location_types ~w(remote hybrid on_site)a

  @derive {JSON.Encoder,
           only: [
             :id,
             :slug,
             :role,
             :company,
             :status,
             :applied_at,
             :last_updated_at,
             :source,
             :job_description,
             :notes,
             :inserted_at,
             :updated_at
           ]}

  schema "job_applications" do
    field :slug, :string
    field :role, :string
    field :location, Ecto.Enum, values: @location_types, default: :remote
    field :status, Ecto.Enum, values: @status_types, default: :applied
    field :applied_at, :utc_datetime
    field :last_updated_at, :utc_datetime
    field :source, :string
    field :job_description, :string
    field :notes, :string
    field :stages_count, :integer, default: 0

    field :lock_version, :integer, default: 1

    belongs_to :applicant, User, foreign_key: :applicant_id

    has_many :stages, Stage, preload_order: [asc: :date]
    belongs_to :current_stage, Stage, foreign_key: :current_stage_id

    embeds_one :company, Company, on_replace: :update

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, @permitted)
    |> cast_embed(:company)
    |> cast_embed(:company, with: &Company.changeset/2, required: true)
    |> common_validations()
  end

  @doc false
  def create_changeset(applicant, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> put_assoc(:applicant, applicant)
  end

  @doc false
  def update_changeset(application, attrs) do
    application |> changeset(attrs)
  end

  def ensure_applied_at(attrs, %__MODULE__{status: :draft, applied_at: nil}) do
    case Map.get(attrs, :status) do
      "draft" -> attrs
      _ -> Map.put(attrs, :applied_at, DateTime.utc_now())
    end
  end

  def ensure_applied_at(attrs, _application), do: attrs

  defp common_validations(changeset) do
    changeset
    |> validate_required(@required)
    |> validate_conditional_requirements()
    |> assoc_constraint(:applicant)
  end

  defp validate_conditional_requirements(%{changes: %{status: :draft}} = changeset), do: changeset

  defp validate_conditional_requirements(changeset) do
    case get_field(changeset, :status) do
      :draft -> changeset
      _other -> validate_required(changeset, @required_when_not_draft)
    end
  end
end
