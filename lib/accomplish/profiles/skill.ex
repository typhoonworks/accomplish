defmodule Accomplish.Profiles.Skill do
  @moduledoc """
  Schema for storing skills in the system.

  Skills are stored in a normalized form to prevent duplicates like "Reactjs" and "ReactJS"
  being stored as separate skills.
  """
  use Accomplish.Schema

  @derive {JSON.Encoder, only: [:id, :name, :usage_count]}

  schema "profile_skills" do
    field :name, :string
    field :normalized_name, :string
    field :usage_count, :integer, default: 0

    timestamps()
  end

  @permitted ~w(name)a
  @required ~w(name)a

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> normalize_name()
    |> unique_constraint(:normalized_name)
  end

  defp normalize_name(changeset) do
    case get_change(changeset, :name) do
      nil ->
        changeset

      name ->
        normalized =
          name
          |> String.downcase()
          |> String.trim()
          |> String.replace(~r/[^a-z0-9]+/, "")

        put_change(changeset, :normalized_name, normalized)
    end
  end

  @doc """
  Increments the usage count for a skill
  """
  def increment_usage(changeset) do
    current_count = get_field(changeset, :usage_count) || 0
    put_change(changeset, :usage_count, current_count + 1)
  end

  @doc """
  Creates a normalized version of a skill name for lookups
  """
  def normalize_skill_name(name) when is_binary(name) do
    name
    |> String.downcase()
    |> String.trim()
    |> String.replace(~r/[^a-z0-9]+/, "")
  end
end
