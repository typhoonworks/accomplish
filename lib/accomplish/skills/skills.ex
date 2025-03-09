defmodule Accomplish.Skills do
  @moduledoc """
  The Skills context.

  Provides functions to manage and suggest skills across the application.
  """

  use Accomplish.Context
  alias Accomplish.Skills.Skill

  @doc """
  Returns a list of popular or matching skills based on the query.

  ## Examples

      iex> suggest_skills("react")
      [%Skill{name: "React", ...}, %Skill{name: "React Native", ...}]
  """
  def suggest_skills(query \\ nil, limit \\ 10) do
    query = prepare_query(query)

    cond do
      is_nil(query) or query == "" ->
        # Return popular skills if no query
        Repo.all(
          from s in Skill,
            order_by: [desc: s.usage_count],
            limit: ^limit
        )

      true ->
        normalized_query = Skill.normalize_skill_name(query)

        Repo.all(
          from s in Skill,
            where: ilike(s.name, ^"#{query}%"),
            or_where: ilike(s.normalized_name, ^"#{normalized_query}%"),
            order_by: [desc: s.usage_count],
            limit: ^limit
        )
    end
  end

  @doc """
  Finds or creates skills based on the provided names.

  This is useful when adding multiple skills at once to a profile.

  ## Examples

      iex> find_or_create_skills(["React", "JavaScript"])
      [%Skill{name: "React", ...}, %Skill{name: "JavaScript", ...}]
  """
  def find_or_create_skills(skill_names) when is_list(skill_names) do
    skill_names
    |> Enum.map(&find_or_create_skill/1)
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  Finds or creates a skill by name.

  If the skill already exists (by normalized name), its usage count is incremented.
  If not, a new skill is created.

  ## Examples

      iex> find_or_create_skill("React")
      %Skill{name: "React", ...}
  """
  def find_or_create_skill(name) when is_binary(name) do
    normalized_name = Skill.normalize_skill_name(name)

    case Repo.get_by(Skill, normalized_name: normalized_name) do
      nil ->
        %Skill{}
        |> Skill.changeset(%{name: name})
        |> Repo.insert()
        |> case do
          {:ok, skill} -> skill
          {:error, _} -> nil
        end

      skill ->
        skill
        |> Skill.changeset(%{})
        |> Skill.increment_usage()
        |> Repo.update()
        |> case do
          {:ok, updated_skill} -> updated_skill
          {:error, _} -> skill
        end
    end
  end

  def create_skill(name) when is_binary(name) do
    normalized_name = Skill.normalize_skill_name(name)

    case Repo.get_by(Skill, normalized_name: normalized_name) do
      nil ->
        %Skill{}
        |> Skill.changeset(%{name: name})
        |> Repo.insert()
        |> case do
          {:ok, skill} -> skill
          {:error, _} -> nil
        end

      skill ->
        skill
    end
  end

  @doc """
  Increments the usage count for a skill identified by its name.

  If the skill is found by its normalized name, increments the usage count and returns the updated skill.
  If no skill is found, returns an error tuple.
  """
  def increment_skill_usage(skill_name) when is_binary(skill_name) do
    normalized_name = Skill.normalize_skill_name(skill_name)

    case Repo.get_by(Skill, normalized_name: normalized_name) do
      nil ->
        {:error, :skill_not_found}

      skill ->
        skill
        |> Skill.changeset(%{})
        |> Skill.increment_usage()
        |> Repo.update()
    end
  end

  @doc """
  Lists all available skills.

  ## Examples

      iex> list_skills()
      [%Skill{...}, ...]
  """
  def list_skills do
    Repo.all(from s in Skill, order_by: [desc: s.usage_count])
  end

  @doc """
  Gets a skill by ID.

  ## Examples

      iex> get_skill!(123)
      %Skill{...}
  """
  def get_skill!(id), do: Repo.get!(Skill, id)

  defp prepare_query(query) when is_nil(query), do: nil
  defp prepare_query(query) when is_binary(query), do: String.trim(query)
end
