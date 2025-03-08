defmodule Accomplish.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.Profiles` context.
  """

  alias Accomplish.Profiles

  @doc """
  Generates a profile for a user.

  ## Examples

      iex> profile_fixture(user)
      %Accomplish.Profiles.Profile{}

      iex> profile_fixture(user, %{headline: "Custom headline"})
      %Accomplish.Profiles.Profile{}
  """
  def profile_fixture(user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        headline: "Software Engineer",
        bio:
          "Experienced software engineer with a passion for building high-quality applications.",
        skills: ["Elixir", "Ruby", "GraphQL"],
        location: "Lisbon, Portugal",
        website_url: "https://example.com",
        github_handle: "jacksparrow",
        linkedin_handle: "jacksparrow"
      })

    {:ok, profile} = Profiles.upsert_profile(user, attrs)
    profile
  end

  @doc """
  Generates a work experience for a profile.

  ## Examples

      iex> experience_fixture(profile)
      %Accomplish.Profiles.Experience{}

      iex> experience_fixture(profile, %{company: "Custom Company"})
      %Accomplish.Profiles.Experience{}
  """
  def experience_fixture(profile, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        company: "Acme Inc",
        role: "Software Engineer",
        description: "Developed and maintained web applications using Elixir and Phoenix.",
        start_date: ~D[2020-01-01],
        end_date: ~D[2022-12-31],
        location: "San Francisco, CA"
      })

    {:ok, experience} = Profiles.add_experience(profile, attrs)
    experience
  end

  @doc """
  Generates a current work experience for a profile.

  ## Examples

      iex> current_experience_fixture(profile)
      %Accomplish.Profiles.Experience{}
  """
  def current_experience_fixture(profile, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        company: "Current Company",
        role: "Senior Software Engineer",
        description: "Leading development of new features and mentoring junior developers.",
        start_date: ~D[2023-01-01],
        end_date: nil,
        workplace_type: "Remote"
      })

    {:ok, experience} = Profiles.add_experience(profile, attrs)
    experience
  end

  @doc """
  Generates an education entry for a profile.

  ## Examples

      iex> education_fixture(profile)
      %Accomplish.Profiles.Education{}

      iex> education_fixture(profile, %{school: "Custom University"})
      %Accomplish.Profiles.Education{}
  """
  def education_fixture(profile, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        school: "University of Example",
        degree: "Bachelor of Science",
        field_of_study: "Computer Science",
        start_date: ~D[2016-09-01],
        end_date: ~D[2020-05-31],
        description: "Graduated with honors. Senior thesis on distributed systems."
      })

    {:ok, education} = Profiles.add_education(profile, attrs)
    education
  end

  @doc """
  Generates a current education entry for a profile.

  ## Examples

      iex> current_education_fixture(profile)
      %Accomplish.Profiles.Education{}
  """
  def current_education_fixture(profile, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        school: "Graduate University",
        degree: "Master of Science",
        field_of_study: "Software Engineering",
        start_date: ~D[2023-09-01],
        end_date: nil,
        description: "Focusing on advanced software architecture and design patterns."
      })

    {:ok, education} = Profiles.add_education(profile, attrs)
    education
  end

  @doc """
  Sets up a complete profile with experiences and education.

  ## Examples

      iex> profile = setup_complete_profile(user)
      %{
        profile: %Accomplish.Profiles.Profile{},
        experiences: [%Accomplish.Profiles.Experience{}, ...],
        educations: [%Accomplish.Profiles.Education{}, ...]
      }
  """
  def setup_complete_profile(user, attrs \\ %{}) do
    profile = profile_fixture(user, attrs)

    experiences = [
      current_experience_fixture(profile),
      experience_fixture(profile, %{
        company: "Previous Company",
        role: "Software Developer",
        start_date: ~D[2018-06-01],
        end_date: ~D[2022-12-31]
      })
    ]

    educations = [
      education_fixture(profile, %{
        school: "University of Example",
        degree: "Bachelor of Science",
        field_of_study: "Computer Science",
        start_date: ~D[2014-09-01],
        end_date: ~D[2018-05-31]
      })
    ]

    %{
      profile: profile,
      experiences: experiences,
      educations: educations
    }
  end
end
