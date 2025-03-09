defmodule Accomplish.ProfilesTest do
  use Accomplish.DataCase

  alias Accomplish.Profiles
  alias Accomplish.Profiles.Profile
  alias Accomplish.Profiles.Experience
  alias Accomplish.Profiles.Education
  alias Accomplish.Profiles.Skills
  alias Accomplish.Profiles.Skill

  describe "profiles" do
    @valid_attrs %{
      bio: "I'm a software engineer with 5+ years of experience.",
      headline: "Software Engineer",
      location: "San Francisco, CA",
      website_url: "https://example.com",
      github_handle: "https://github.com/example",
      linkedin_handle: "https://linkedin.com/in/example",
      skills: ["Elixir", "Phoenix", "PostgreSQL"]
    }
    @update_attrs %{
      bio: "Updated bio with more details about my experience.",
      headline: "Senior Software Engineer",
      location: "Lisbon, Portugal",
      skills: ["Elixir", "Phoenix", "PostgreSQL", "GraphQL"]
    }
    @invalid_attrs %{website_url: "invalid-url"}

    setup do
      %{user: user_fixture()}
    end

    test "get_profile_by_user/1 returns the profile for a given user", %{user: user} do
      profile = profile_fixture(user)
      assert %Profile{} = fetched_profile = Profiles.get_profile_by_user(user.id)
      assert profile.id == fetched_profile.id
    end

    test "upsert_profile/2 creates a profile when none exists", %{user: user} do
      assert {:ok, %Profile{} = profile} = Profiles.upsert_profile(user, @valid_attrs)
      assert profile.headline == @valid_attrs.headline
      assert profile.bio == @valid_attrs.bio
      assert profile.location == @valid_attrs.location
      assert profile.skills == @valid_attrs.skills
    end

    test "upsert_profile/2 updates a profile when one exists", %{user: user} do
      {:ok, profile} = Profiles.upsert_profile(user, @valid_attrs)
      assert {:ok, %Profile{} = updated_profile} = Profiles.upsert_profile(user, @update_attrs)
      assert updated_profile.id == profile.id
      assert updated_profile.headline == @update_attrs.headline
      assert updated_profile.bio == @update_attrs.bio
      assert updated_profile.skills == @update_attrs.skills
    end

    test "upsert_profile/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Profiles.upsert_profile(user, @invalid_attrs)
    end

    test "get_profile!/1 returns the profile with given id", %{user: user} do
      profile = profile_fixture(user)
      fetched_profile = Profiles.get_profile!(profile.id)

      assert fetched_profile.id == profile.id
      assert fetched_profile.bio == profile.bio
      assert fetched_profile.github_handle == profile.github_handle
      assert fetched_profile.headline == profile.headline
      assert fetched_profile.linkedin_handle == profile.linkedin_handle
      assert fetched_profile.location == profile.location
      assert fetched_profile.skills == profile.skills
      assert fetched_profile.website_url == profile.website_url
    end

    test "get_profile!/2 preloads associations", %{user: user} do
      profile = profile_fixture(user)
      experience = experience_fixture(profile)
      education = education_fixture(profile)

      loaded_profile = Profiles.get_profile!(profile.id, [:experiences, :educations])
      assert [%Experience{}] = loaded_profile.experiences
      assert [%Education{}] = loaded_profile.educations
      assert List.first(loaded_profile.experiences).id == experience.id
      assert List.first(loaded_profile.educations).id == education.id
    end
  end

  describe "experiences" do
    @valid_exp_attrs %{
      company: "Acme Inc",
      role: "Software Engineer",
      description: "Developed and maintained web applications using Elixir and Phoenix.",
      start_date: ~D[2020-01-01],
      end_date: ~D[2022-12-31],
      location: "San Francisco, CA"
    }
    @update_exp_attrs %{
      role: "Senior Software Engineer",
      end_date: nil
    }
    @invalid_exp_attrs %{company: nil, role: nil}

    setup do
      user = user_fixture()
      profile = profile_fixture(user)
      %{profile: profile}
    end

    test "get_experience!/1 returns the experience with given id", %{profile: profile} do
      experience = experience_fixture(profile)
      fetched_experience = Profiles.get_experience!(experience.id)

      assert fetched_experience.id == experience.id
      assert fetched_experience.company == experience.company
      assert fetched_experience.description == experience.description
      assert fetched_experience.end_date == experience.end_date
      assert fetched_experience.location == experience.location
      assert fetched_experience.profile_id == experience.profile_id
      assert fetched_experience.role == experience.role
      assert fetched_experience.start_date == experience.start_date
    end

    test "add_experience/2 with valid data creates a experience", %{profile: profile} do
      assert {:ok, %Experience{} = experience} =
               Profiles.add_experience(profile, @valid_exp_attrs)

      assert experience.company == @valid_exp_attrs.company
      assert experience.role == @valid_exp_attrs.role
      assert experience.description == @valid_exp_attrs.description
      assert experience.start_date == @valid_exp_attrs.start_date
      assert experience.end_date == @valid_exp_attrs.end_date
      assert experience.location == @valid_exp_attrs.location
    end

    test "add_experience/2 with invalid data returns error changeset", %{profile: profile} do
      assert {:error, %Ecto.Changeset{}} = Profiles.add_experience(profile, @invalid_exp_attrs)
    end

    test "update_experience/2 with valid data updates the experience", %{profile: profile} do
      experience = experience_fixture(profile)

      assert {:ok, %Experience{} = experience} =
               Profiles.update_experience(experience, @update_exp_attrs)

      assert experience.role == @update_exp_attrs.role
      assert experience.end_date == @update_exp_attrs.end_date
    end

    test "update_experience/2 with invalid data returns error changeset", %{profile: profile} do
      experience = experience_fixture(profile)

      assert {:error, %Ecto.Changeset{}} =
               Profiles.update_experience(experience, @invalid_exp_attrs)

      reloaded_experience = Profiles.get_experience!(experience.id)

      assert reloaded_experience.id == experience.id
      assert reloaded_experience.company == experience.company
      assert reloaded_experience.description == experience.description
      assert reloaded_experience.end_date == experience.end_date
      assert reloaded_experience.location == experience.location
      assert reloaded_experience.profile_id == experience.profile_id
      assert reloaded_experience.role == experience.role
      assert reloaded_experience.start_date == experience.start_date
    end

    test "remove_experience/1 deletes the experience", %{profile: profile} do
      experience = experience_fixture(profile)
      assert {:ok, %Experience{}} = Profiles.remove_experience(experience)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_experience!(experience.id) end
    end

    test "remove_experience/1 with id deletes the experience", %{profile: profile} do
      experience = experience_fixture(profile)
      assert {:ok, %Experience{}} = Profiles.remove_experience(experience.id)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_experience!(experience.id) end
    end

    test "remove_experience/1 with nonexistent id returns error", %{profile: _profile} do
      assert {:error, :not_found} = Profiles.remove_experience(UUIDv7.generate())
    end

    test "list_experiences/1 returns all experiences for a profile", %{profile: profile} do
      experience = experience_fixture(profile)
      current_experience = experience_fixture(profile, %{end_date: nil})
      assert experiences = Profiles.list_experiences(profile)
      assert length(experiences) == 2
      assert List.first(experiences).id == current_experience.id
      assert List.last(experiences).id == experience.id
    end
  end

  describe "educations" do
    @valid_edu_attrs %{
      school: "University of Example",
      degree: "Bachelor of Science",
      field_of_study: "Computer Science",
      start_date: ~D[2016-09-01],
      end_date: ~D[2020-05-31],
      description: "Graduated with honors. Senior thesis on distributed systems."
    }
    @update_edu_attrs %{
      degree: "Master of Science",
      field_of_study: "Software Engineering",
      end_date: nil
    }
    @invalid_edu_attrs %{school: nil, degree: nil}

    setup do
      user = user_fixture()
      profile = profile_fixture(user)
      %{profile: profile}
    end

    test "get_education!/1 returns the education with given id", %{profile: profile} do
      education = education_fixture(profile)
      fetched_education = Profiles.get_education!(education.id)

      assert fetched_education.id == education.id
      assert fetched_education.degree == education.degree
      assert fetched_education.description == education.description
      assert fetched_education.end_date == education.end_date
      assert fetched_education.field_of_study == education.field_of_study
      assert fetched_education.profile_id == education.profile_id
      assert fetched_education.school == education.school
      assert fetched_education.start_date == education.start_date
    end

    test "add_education/2 with valid data creates an education entry", %{profile: profile} do
      assert {:ok, %Education{} = education} = Profiles.add_education(profile, @valid_edu_attrs)
      assert education.school == @valid_edu_attrs.school
      assert education.degree == @valid_edu_attrs.degree
      assert education.field_of_study == @valid_edu_attrs.field_of_study
      assert education.start_date == @valid_edu_attrs.start_date
      assert education.end_date == @valid_edu_attrs.end_date
      assert education.description == @valid_edu_attrs.description
    end

    test "add_education/2 with invalid data returns error changeset", %{profile: profile} do
      assert {:error, %Ecto.Changeset{}} = Profiles.add_education(profile, @invalid_edu_attrs)
    end

    test "update_education/2 with valid data updates the education", %{profile: profile} do
      education = education_fixture(profile)

      assert {:ok, %Education{} = education} =
               Profiles.update_education(education, @update_edu_attrs)

      assert education.degree == @update_edu_attrs.degree
      assert education.field_of_study == @update_edu_attrs.field_of_study
      assert education.end_date == @update_edu_attrs.end_date
    end

    test "update_education/2 with invalid data returns error changeset", %{profile: profile} do
      education = education_fixture(profile)

      assert {:error, %Ecto.Changeset{}} =
               Profiles.update_education(education, @invalid_edu_attrs)

      reloaded_education = Profiles.get_education!(education.id)

      assert education.id == reloaded_education.id
      assert education.degree == reloaded_education.degree
      assert education.school == reloaded_education.school
      assert education.start_date == reloaded_education.start_date
      assert education.end_date == reloaded_education.end_date
      assert education.description == reloaded_education.description
      assert education.field_of_study == reloaded_education.field_of_study
    end

    test "remove_education/1 deletes the education", %{profile: profile} do
      education = education_fixture(profile)
      assert {:ok, %Education{}} = Profiles.remove_education(education)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_education!(education.id) end
    end

    test "remove_education/1 with id deletes the education", %{profile: profile} do
      education = education_fixture(profile)
      assert {:ok, %Education{}} = Profiles.remove_education(education.id)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_education!(education.id) end
    end

    test "remove_education/1 with nonexistent id returns error", %{profile: _profile} do
      assert {:error, :not_found} = Profiles.remove_education(UUIDv7.generate())
    end

    test "list_educations/1 returns all educations for a profile", %{profile: profile} do
      education = education_fixture(profile)
      assert [listed_education] = Profiles.list_educations(profile)
      assert listed_education.id == education.id
    end
  end

  describe "profile skills usage tracking" do
    setup do
      %{user: user_fixture()}
    end

    test "create_profile increments skills usage count", %{user: user} do
      skills = ["Elixir", "Phoenix", "PostgreSQL"]
      Enum.each(skills, &Skills.create_skill/1)

      {:ok, _} = Profiles.upsert_profile(user, %{skills: skills})

      Enum.each(skills, fn skill ->
        normalized_skill = Skill.normalize_skill_name(skill)
        skill_record = Repo.get_by(Skill, normalized_name: normalized_skill)

        assert skill_record, "Skill #{skill} should exist"
        assert skill_record.usage_count > 0, "Usage count for #{skill} should be incremented"
      end)
    end

    test "update_profile increments and decrements skills usage count", %{user: user} do
      skills = ["Elixir", "Phoenix", "GraphQL", "React"]
      Enum.each(skills, &Skills.create_skill/1)

      initial_skills = ["Elixir", "Phoenix"]
      {:ok, _profile} = Profiles.upsert_profile(user, %{skills: initial_skills})

      Enum.each(initial_skills, fn skill ->
        normalized_skill = Skill.normalize_skill_name(skill)
        skill_record = Repo.get_by(Skill, normalized_name: normalized_skill)
        assert skill_record.usage_count > 0
      end)

      updated_skills = ["Elixir", "GraphQL", "React"]
      {:ok, _updated_profile} = Profiles.upsert_profile(user, %{skills: updated_skills})

      Enum.each(["GraphQL", "React"], fn skill ->
        normalized_skill = Skill.normalize_skill_name(skill)
        skill_record = Repo.get_by(Skill, normalized_name: normalized_skill)

        assert skill_record, "Skill #{skill} should exist"
        assert skill_record.usage_count > 0, "Usage count for #{skill} should be incremented"
      end)

      Enum.each(["Phoenix"], fn skill ->
        normalized_skill = Skill.normalize_skill_name(skill)
        skill_record = Repo.get_by(Skill, normalized_name: normalized_skill)

        assert skill_record, "Skill #{skill} should exist"
        assert skill_record.usage_count == 0, "Usage count for #{skill} should be decremented"
      end)

      elixir_skill = Repo.get_by(Skill, normalized_name: Skill.normalize_skill_name("Elixir"))
      assert elixir_skill.usage_count > 0
    end

    test "profile update with empty skills does not affect usage count", %{user: user} do
      initial_skills = ["Elixir", "Phoenix"]

      # Ensure skills exist first
      Enum.each(initial_skills, fn skill ->
        Skills.create_skill(skill)
      end)

      {:ok, _profile} = Profiles.upsert_profile(user, %{skills: initial_skills})

      initial_counts =
        Enum.map(initial_skills, fn skill ->
          normalized_skill = Skill.normalize_skill_name(skill)
          skill_record = Repo.get_by!(Skill, normalized_name: normalized_skill)
          {skill, skill_record.usage_count}
        end)
        |> Map.new()

      {:ok, _updated_profile} = Profiles.upsert_profile(user, %{headline: "Updated Headline"})

      Enum.each(initial_skills, fn skill ->
        normalized_skill = Skill.normalize_skill_name(skill)
        skill_record = Repo.get_by!(Skill, normalized_name: normalized_skill)

        assert skill_record.usage_count == initial_counts[skill],
               "Usage count for #{skill} should remain unchanged"
      end)
    end

    test "profile update with non-existent skills doesn't fail", %{user: user} do
      existing_skills = ["Elixir", "Phoenix"]
      Enum.each(existing_skills, &Skills.create_skill/1)

      {:ok, _profile} = Profiles.upsert_profile(user, %{skills: existing_skills})

      mixed_skills = ["Elixir", "NonExistentSkill1", "PostgreSQL", "NonExistentSkill2"]

      {:ok, updated_profile} = Profiles.upsert_profile(user, %{skills: mixed_skills})

      assert Enum.sort(updated_profile.skills) == Enum.sort(mixed_skills)

      elixir_skill = Repo.get_by!(Skill, normalized_name: Skill.normalize_skill_name("Elixir"))
      assert elixir_skill.usage_count > 0
    end
  end
end
