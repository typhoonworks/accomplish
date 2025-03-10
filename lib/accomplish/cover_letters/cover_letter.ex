defmodule Accomplish.CoverLetters.CoverLetter do
  @moduledoc false

  use Accomplish.Schema
  import Ecto.SoftDelete.Schema

  alias Accomplish.JobApplications.Application

  @permitted ~w(title content status submitted_at)a
  @required ~w(title)a
  @status_values ~w(draft final submitted)a

  @derive {JSON.Encoder,
           except: [:__meta__],
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
    field :content, :string, default: ""
    field :status, Ecto.Enum, values: @status_values, default: :draft
    field :submitted_at, :utc_datetime

    belongs_to :application, Application, foreign_key: :application_id

    timestamps(type: :utc_datetime)
    soft_delete_schema()
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
    |> maybe_set_title(application, attrs)
    |> changeset(attrs)
    |> put_assoc(:application, application)
  end

  @doc false
  def update_changeset(cover_letter, attrs) do
    cover_letter
    |> changeset(attrs)
  end

  defp maybe_set_title(cover_letter, application, attrs) do
    changeset = Ecto.Changeset.change(cover_letter)

    if Map.get(attrs, "title") || Map.get(attrs, :title) do
      changeset
    else
      put_change(
        changeset,
        :title,
        "Cover letter to #{application.role} at #{application.company.name}"
      )
    end
  end
end
