defmodule Accomplish.ProfilesTest do
  use Accomplish.DataCase

  alias Accomplish.Profiles
  alias Accomplish.Profiles.Profile
  alias Accomplish.Profiles.Experience
  alias Accomplish.Profiles.Education

  describe "profiles" do
    @valid_attrs %{
      bio: "I'm a software engineer with 5+ years of experience.",
      headline: "Software Engineer",
      location: "San Francisco, CA",
      website: "https://example.com",
      github: "https://github.com/example",
      linkedin: "https://linkedin.com/in/example",
      skills: ["Elixir", "Phoenix", "PostgreSQL"]
    }
    @update_attrs %{
      bio: "Updated bio with more details about my experience.",
      headline: "Senior Software Engineer",
      location: "Remote",
      skills: ["Elixir", "Phoenix", "PostgreSQL", "GraphQL"]
    }
    @invalid_attrs %{headline: nil}

    setup do
      %{user: user_fixture()}
    end

    test "get_profile_by_user/1 returns the profile for a given user", %{user: user} do
      assert nil == Profiles.get_profile_by_user(user.id)
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
      assert fetched_profile.github == profile.github
      assert fetched_profile.headline == profile.headline
      assert fetched_profile.linkedin == profile.linkedin
      assert fetched_profile.location == profile.location
      assert fetched_profile.skills == profile.skills
      assert fetched_profile.website == profile.website
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
      is_current: false,
      location: "San Francisco, CA"
    }
    @update_exp_attrs %{
      role: "Senior Software Engineer",
      is_current: true,
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
      assert fetched_experience.is_current == experience.is_current
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
      assert experience.is_current == @valid_exp_attrs.is_current
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
      assert experience.is_current == @update_exp_attrs.is_current
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
      assert reloaded_experience.is_current == experience.is_current
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
      current_experience = experience_fixture(profile, %{is_current: true, end_date: nil})
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
      is_current: false,
      description: "Graduated with honors. Senior thesis on distributed systems."
    }
    @update_edu_attrs %{
      degree: "Master of Science",
      field_of_study: "Software Engineering",
      is_current: true,
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
end
