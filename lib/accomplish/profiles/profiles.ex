defmodule Accomplish.Profiles do
  @moduledoc """
  The Profiles context.

  This module provides functions to manage user profiles, experiences, and education entries.
  """

  use Accomplish.Context
  alias Accomplish.Profiles.Profile
  alias Accomplish.Profiles.Experience
  alias Accomplish.Profiles.Education
  alias Accomplish.Profiles.Skills

  import Accomplish.Utils.Maps, only: [atomize_keys: 1]

  # ========================
  # Profile Functions
  # ========================

  @doc """
  Gets a profile by user ID.

  ## Examples

      iex> get_profile_by_user(user_id)
      %Profile{}

      iex> get_profile_by_user(non_existent_user_id)
      nil
  """
  def get_profile_by_user(user_id) do
    Repo.get_by(Profile, user_id: user_id)
  end

  @doc """
  Creates or updates a user's profile.

  If the user already has a profile, it is updated with the provided attributes.
  If not, a new profile is created.

  ## Examples

      iex> upsert_profile(user, %{headline: "Software Engineer"})
      {:ok, %Profile{}}

      iex> upsert_profile(user, %{headline: nil})
      {:error, %Ecto.Changeset{}}
  """
  def upsert_profile(user, attrs) do
    case get_profile_by_user(user.id) do
      nil -> create_profile(user, attrs)
      profile -> update_profile(profile, attrs)
    end
  end

  @doc """
  Creates a profile for the given user with the provided attributes.

  ## Examples

      iex> create_profile(user, %{headline: "Software Engineer"})
      {:ok, %Profile{}}

      iex> create_profile(user, %{headline: nil})
      {:error, %Ecto.Changeset{}}
  """
  def create_profile(user, attrs) do
    changeset =
      %Profile{}
      |> Profile.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:user, user)

    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:profile, changeset)
      |> handle_skills_changes([], Map.get(attrs, :skills, []))

    execute_transaction(multi, :profile)
  end

  @doc """
  Updates an existing profile with the provided attributes.

  ## Examples

      iex> update_profile(profile, %{headline: "Updated Headline"})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{headline: nil})
      {:error, %Ecto.Changeset{}}
  """
  def update_profile(%Profile{} = profile, attrs) do
    attrs = atomize_keys(attrs)
    old_skills = profile.skills || []
    new_skills = Map.get(attrs, :skills, old_skills)

    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.update(:profile, Profile.update_changeset(profile, attrs))
      |> handle_skills_changes(old_skills, new_skills)

    execute_transaction(multi, :profile)
  end

  defp handle_skills_changes(multi, old_skills, new_skills) do
    old_skills = old_skills || []
    new_skills = new_skills || []

    if old_skills == new_skills do
      multi
    else
      skills_added = new_skills -- old_skills
      skills_removed = old_skills -- new_skills

      multi
      |> add_skills_operation(
        :increment_skills,
        skills_added,
        &Skills.batch_increment_usage/1,
        :no_skills_added
      )
      |> add_skills_operation(
        :decrement_skills,
        skills_removed,
        &Skills.batch_decrement_usage/1,
        :no_skills_removed
      )
    end
  end

  defp add_skills_operation(multi, operation_name, skills, operation_fn, no_op_result) do
    Ecto.Multi.run(multi, operation_name, fn _repo, _changes ->
      handle_skill_operation(skills, operation_fn, no_op_result)
    end)
  end

  defp handle_skill_operation(skills, operation_fn, no_op_result) do
    if skills != [] do
      case operation_fn.(skills) do
        {count, _} -> {:ok, count}
        error -> error
      end
    else
      {:ok, no_op_result}
    end
  end

  defp execute_transaction(multi, result_key) do
    case Repo.transaction(multi) do
      {:ok, results} -> {:ok, Map.get(results, result_key)}
      {:error, _step, reason, _changes} -> {:error, reason}
    end
  end

  def change_profile(profile \\ %Profile{}, attrs \\ %{}) do
    profile
    |> Profile.changeset(attrs)
  end

  @doc """
  Gets a profile by ID with optional preloads.

  ## Examples

      iex> get_profile!(profile_id)
      %Profile{}

      iex> get_profile!(profile_id, [:experiences, :educations])
      %Profile{experiences: [...], educations: [...]}

      iex> get_profile!(non_existent_profile_id)
      ** (Ecto.NoResultsError)
  """
  def get_profile!(id, preloads \\ []) do
    Profile
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  # ========================
  # Experience Functions
  # ========================

  @doc """
  Gets an experience by ID.

  ## Examples

      iex> get_experience!(experience_id)
      %Experience{}

      iex> get_experience!(non_existent_experience_id)
      ** (Ecto.NoResultsError)
  """
  def get_experience!(id) do
    Repo.get!(Experience, id)
  end

  @doc """
  Adds a work experience to a profile.

  ## Examples

      iex> add_experience(profile, %{company: "Acme Inc", role: "Developer"})
      {:ok, %Experience{}}

      iex> add_experience(profile, %{company: nil})
      {:error, %Ecto.Changeset{}}
  """
  def add_experience(profile, attrs) do
    attrs = atomize_keys(attrs)
    changeset = Experience.create_changeset(profile, attrs)

    Repo.insert(changeset)
  end

  @doc """
  Updates an existing work experience.

  ## Examples

      iex> update_experience(experience, %{role: "Senior Developer"})
      {:ok, %Experience{}}

      iex> update_experience(experience, %{company: nil})
      {:error, %Ecto.Changeset{}}
  """
  def update_experience(experience, attrs) do
    experience
    |> Experience.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Removes a work experience.

  ## Examples

      iex> remove_experience(experience)
      {:ok, %Experience{}}

      iex> remove_experience(non_existent_experience)
      {:error, :not_found}
  """
  def remove_experience(%Experience{} = experience) do
    Repo.delete(experience)
  end

  def remove_experience(id) when is_binary(id) do
    get_and_remove(Experience, id)
  end

  @doc """
  Lists all experiences for a profile.

  ## Examples

      iex> list_experiences(profile)
      [%Experience{}, ...]
  """
  def list_experiences(profile) do
    list_profile_records(Experience, profile.id)
  end

  def change_experience(experience \\ %Experience{}, attrs \\ %{}) do
    experience
    |> Experience.changeset(attrs)
  end

  # ========================
  # Education Functions
  # ========================

  @doc """
  Gets an education entry by ID.

  ## Examples

      iex> get_education!(education_id)
      %Education{}

      iex> get_education!(non_existent_education_id)
      ** (Ecto.NoResultsError)
  """
  def get_education!(id) do
    Repo.get!(Education, id)
  end

  @doc """
  Adds an education entry to a profile.

  ## Examples

      iex> add_education(profile, %{school: "MIT", degree: "BS"})
      {:ok, %Education{}}

      iex> add_education(profile, %{school: nil})
      {:error, %Ecto.Changeset{}}
  """
  def add_education(profile, attrs) do
    attrs = atomize_keys(attrs)
    changeset = Education.create_changeset(profile, attrs)

    Repo.insert(changeset)
  end

  @doc """
  Updates an existing education entry.

  ## Examples

      iex> update_education(education, %{degree: "MS"})
      {:ok, %Education{}}

      iex> update_education(education, %{school: nil})
      {:error, %Ecto.Changeset{}}
  """
  def update_education(education, attrs) do
    education
    |> Education.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Removes an education entry.

  ## Examples

      iex> remove_education(education)
      {:ok, %Education{}}

      iex> remove_education(non_existent_education)
      {:error, :not_found}
  """
  def remove_education(%Education{} = education) do
    Repo.delete(education)
  end

  def remove_education(id) when is_binary(id) do
    get_and_remove(Education, id)
  end

  @doc """
  Lists all education entries for a profile.

  ## Examples

      iex> list_educations(profile)
      [%Education{}, ...]
  """
  def list_educations(profile) do
    list_profile_records(Education, profile.id)
  end

  def change_education(education \\ %Education{}, attrs \\ %{}) do
    education
    |> Education.changeset(attrs)
  end

  # ========================
  # Shared Helper Functions
  # ========================

  defp get_and_remove(schema, id) do
    case Repo.get(schema, id) do
      nil -> {:error, :not_found}
      record -> Repo.delete(record)
    end
  end

  defp list_profile_records(schema, profile_id) do
    query =
      from e in schema,
        where: e.profile_id == ^profile_id,
        order_by: [
          desc: e.start_date,
          asc_nulls_first: e.end_date,
          desc: e.end_date
        ]

    Repo.all(query)
  end
end
