defmodule Accomplish.CoverLetters.CoverLetter do
  @moduledoc false

  use Accomplish.Schema

  alias Accomplish.JobApplications.Application

  @permitted ~w(title content status submitted_at)a
  @required ~w(title content)a
  @status_values ~w(draft final submitted)a

  @derive {JSON.Encoder,
           only: [
             :id,
             :title,
             :content,
             :status,
             :submitted_at,
             :application_id,
             :inserted_at,
             :updated_at
           ]}

  schema "cover_letters" do
    field :title, :string
    field :content, :string
    field :status, Ecto.Enum, values: @status_values, default: :draft
    field :submitted_at, :utc_datetime

    belongs_to :application, Application, foreign_key: :application_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cover_letter, attrs) do
    cover_letter
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> assoc_constraint(:application)
  end

  @doc false
  def create_changeset(application, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> put_assoc(:application, application)
  end

  @doc false
  def update_changeset(cover_letter, attrs) do
    cover_letter
    |> changeset(attrs)
  end
end
