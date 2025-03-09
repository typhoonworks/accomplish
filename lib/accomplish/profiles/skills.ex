defmodule Accomplish.Profiles.Skills do
  @moduledoc """
  The Skills context.

  Provides functions to manage and suggest skills across the application.
  """

  use Accomplish.Context
  alias Accomplish.Profiles.Skill

  @doc """
  Returns a list of popular or matching skills based on the query.

  ## Examples

      iex> suggest_skills("react")
      [%Skill{name: "React", ...}, %Skill{name: "React Native", ...}]
  """
  def suggest_skills(query \\ nil, limit \\ 5) do
    cond do
      is_nil(query) ->
        fetch_popular_skills(limit)

      query == "" ->
        fetch_popular_skills(limit)

      true ->
        search_skills(query, normalized_query(query), limit)
    end
  end

  defp fetch_popular_skills(limit) do
    Repo.all(
      from s in Skill,
        order_by: [desc: s.usage_count],
        limit: ^limit
    )
  end

  defp search_skills(query, normalized_query, limit) do
    Repo.all(
      from s in Skill,
        where: ilike(s.name, ^"#{query}%"),
        or_where: ilike(s.normalized_name, ^"#{normalized_query}%"),
        order_by: [desc: s.usage_count],
        limit: ^limit
    )
  end

  defp normalized_query(query) do
    Skill.normalize_skill_name(query)
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
    case find_skill_by_name(name) do
      nil ->
        create_new_skill(name)

      skill ->
        increment_skill(skill)
    end
  end

  @doc """
  Creates a skill by name if it doesn't exist.
  If the skill already exists, returns it without modification.

  ## Examples

      iex> create_skill("React")
      %Skill{name: "React", ...}
  """
  def create_skill(name) when is_binary(name) do
    case find_skill_by_name(name) do
      nil -> create_new_skill(name)
      skill -> skill
    end
  end

  @doc """
  Increments the usage count for a skill identified by its name.

  If the skill is found by its normalized name, increments the usage count and returns the updated skill.
  If no skill is found, returns an error tuple.
  """
  def increment_skill_usage(skill_name) when is_binary(skill_name) do
    case find_skill_by_name(skill_name) do
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
  Batch increments the usage count for a list of skill names.
  """
  def batch_increment_usage(skill_names) when is_list(skill_names) do
    skill_names
    |> normalize_skill_names()
    |> update_usage_count(1)
  end

  @doc """
  Batch decrements the usage count for a list of skill names,
  ensuring that the usage count never drops below 0.
  """
  def batch_decrement_usage(skill_names) when is_list(skill_names) do
    skill_names
    |> normalize_skill_names()
    |> update_usage_count_with_floor(0, -1)
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

  @doc """
  Filters a list of skill names to only include those that exist in the database.
  """
  def filter_existing_skills(skill_names) when is_list(skill_names) do
    normalized_names = Enum.map(skill_names, &Skill.normalize_skill_name/1)

    Repo.all(
      from s in Skill,
        where: s.normalized_name in ^normalized_names,
        select: s.normalized_name
    )
  end

  # Private helper functions

  defp find_skill_by_name(name) when is_binary(name) do
    normalized_name = Skill.normalize_skill_name(name)
    Repo.get_by(Skill, normalized_name: normalized_name)
  end

  defp create_new_skill(name) do
    %Skill{}
    |> Skill.changeset(%{name: name})
    |> Repo.insert()
    |> case do
      {:ok, skill} -> skill
      {:error, _} -> nil
    end
  end

  defp increment_skill(skill) do
    skill
    |> Skill.changeset(%{})
    |> Skill.increment_usage()
    |> Repo.update()
    |> case do
      {:ok, updated_skill} -> updated_skill
      {:error, _} -> skill
    end
  end

  defp normalize_skill_names(skill_names) do
    Enum.map(skill_names, &Skill.normalize_skill_name/1)
  end

  defp update_usage_count(normalized_names, change) do
    from(s in Skill, where: s.normalized_name in ^normalized_names)
    |> Repo.update_all(inc: [usage_count: change])
  end

  defp update_usage_count_with_floor(normalized_names, floor, change) do
    from(s in Skill,
      where: s.normalized_name in ^normalized_names,
      update: [set: [usage_count: fragment("GREATEST(usage_count + ?, ?)", ^change, ^floor)]]
    )
    |> Repo.update_all([])
  end
end
