defmodule Accomplish.Profiles.ImporterTest do
  use Accomplish.DataCase, async: true

  alias Accomplish.Profiles
  alias Accomplish.Profiles.Importer

  setup do
    user = user_fixture()
    {:ok, profile} = Profiles.upsert_profile(user, %{bio: "Initial bio"})

    {:ok, %{user: user, profile: profile}}
  end

  describe "import_profile_data/2" do
    test "successfully imports profile data with experiences and education", %{user: user} do
      profile_data = %{
        "profile" => %{
          "headline" => "Software Engineer",
          "bio" => "Experienced developer",
          "location" => "New York, NY",
          "skills" => ["Elixir", "Phoenix", "React"]
        },
        "experiences" => [
          %{
            "company" => "Acme Inc",
            "role" => "Senior Developer",
            "employment_type" => "full_time",
            "start_date" => "2020-01",
            "end_date" => nil,
            "description" => "Lead development team"
          },
          %{
            "company" => "Beta Corp",
            "role" => "Junior Developer",
            "employment_type" => "full_time",
            "start_date" => "2018-06",
            "end_date" => "2019-12",
            "description" => "Built web applications"
          }
        ],
        "education" => [
          %{
            "school" => "Tech University",
            "degree" => "BS",
            "field_of_study" => "Computer Science",
            "start_date" => "2014-09",
            "end_date" => "2018-05"
          }
        ]
      }

      assert {:ok, result} = Importer.import_profile_data(user, profile_data)
      assert %{profile: profile, experiences: experiences, educations: educations} = result

      assert profile.headline == "Software Engineer"
      assert profile.bio == "Experienced developer"
      assert profile.location == "New York, NY"
      assert profile.skills == ["Elixir", "Phoenix", "React"]

      assert length(experiences) == 2
      [exp1, exp2] = experiences
      assert exp1.company == "Acme Inc"
      assert exp1.role == "Senior Developer"
      assert exp1.employment_type == :full_time
      assert exp1.start_date == ~D[2020-01-01]
      assert exp1.end_date == nil

      assert exp2.company == "Beta Corp"
      assert exp2.role == "Junior Developer"
      assert exp2.start_date == ~D[2018-06-01]
      assert exp2.end_date == ~D[2019-12-01]

      assert length(educations) == 1
      [edu] = educations
      assert edu.school == "Tech University"
      assert edu.degree == "BS"
      assert edu.field_of_study == "Computer Science"
      assert edu.start_date == ~D[2014-09-01]
      assert edu.end_date == ~D[2018-05-01]
    end

    test "imports profile with empty experiences and education", %{user: user} do
      profile_data = %{
        "profile" => %{
          "headline" => "Software Engineer",
          "bio" => "Experienced developer",
          "location" => "New York, NY",
          "skills" => ["Elixir", "Phoenix", "React"]
        },
        "experiences" => [],
        "education" => []
      }

      assert {:ok, result} = Importer.import_profile_data(user, profile_data)
      assert %{profile: profile, experiences: experiences, educations: educations} = result

      assert profile.headline == "Software Engineer"

      assert experiences == []
      assert educations == []
    end

    test "updates existing profile with new data", %{user: user, profile: existing_profile} do
      {:ok, _exp} =
        Profiles.add_experience(existing_profile, %{
          company: "Old Company",
          role: "Old Role",
          start_date: ~D[2010-01-01],
          description: "Old description"
        })

      {:ok, _edu} =
        Profiles.add_education(existing_profile, %{
          school: "Old School",
          degree: "Old Degree",
          field_of_study: "Old Field",
          start_date: ~D[2005-01-01]
        })

      profile_data = %{
        "profile" => %{
          "headline" => "Updated Headline",
          "bio" => "Updated bio",
          "location" => "San Francisco, CA",
          "skills" => ["New Skill"]
        },
        "experiences" => [
          %{
            "company" => "New Company",
            "role" => "New Role",
            "start_date" => "2022-01",
            "description" => "New description"
          }
        ],
        "education" => [
          %{
            "school" => "New School",
            "degree" => "New Degree",
            "field_of_study" => "New Field",
            "start_date" => "2020-01"
          }
        ]
      }

      assert {:ok, result} = Importer.import_profile_data(user, profile_data)

      updated_experiences = Profiles.list_experiences(result.profile)
      assert length(updated_experiences) == 1
      assert hd(updated_experiences).company == "New Company"

      updated_educations = Profiles.list_educations(result.profile)
      assert length(updated_educations) == 1
      assert hd(updated_educations).school == "New School"
    end

    test "handles invalid date formats gracefully", %{user: user} do
      profile_data = %{
        "profile" => %{
          "headline" => "Software Engineer"
        },
        "experiences" => [
          %{
            "company" => "Company",
            "role" => "Role",
            "start_date" => "2020-01",
            "end_date" => "invalid-date",
            "description" => "Description"
          }
        ],
        "education" => []
      }

      assert {:ok, result} = Importer.import_profile_data(user, profile_data)
      assert %{experiences: [experience]} = result

      assert experience.end_date == nil
    end

    test "returns error when profile update fails", %{user: user} do
      profile_data = %{
        "profile" => %{
          "website_url" => "invalid-url"
        },
        "experiences" => [],
        "education" => []
      }

      assert {:error, {:import_failed, :profile, changeset}} =
               Importer.import_profile_data(user, profile_data)

      assert "is missing a scheme (e.g. https)" in errors_on(changeset).website_url
    end

    test "returns error when experience creation fails", %{user: user} do
      profile_data = %{
        "profile" => %{
          "headline" => "Software Engineer"
        },
        "experiences" => [
          %{
            "company" => "Company",
            "start_date" => "2020-01",
            "description" => "Description"
          }
        ],
        "education" => []
      }

      assert {:error, {:import_failed, :experiences, :failed_to_import_experiences}} =
               Importer.import_profile_data(user, profile_data)
    end

    test "returns error when education creation fails", %{user: user} do
      profile_data = %{
        "profile" => %{
          "headline" => "Software Engineer"
        },
        "experiences" => [],
        "education" => [
          %{
            "school" => "School",
            "field_of_study" => "Field",
            "start_date" => "2020-01"
          }
        ]
      }

      assert {:error, {:import_failed, :education, :failed_to_import_education}} =
               Importer.import_profile_data(user, profile_data)
    end
  end

  describe "date parsing" do
    test "parses valid dates in YYYY-MM format", %{user: user} do
      profile_data = %{
        "profile" => %{
          "headline" => "Software Engineer"
        },
        "experiences" => [
          %{
            "company" => "Company",
            "role" => "Role",
            "start_date" => "2020-01",
            "end_date" => "2021-12",
            "description" => "Description"
          }
        ],
        "education" => []
      }

      assert {:ok, %{experiences: [experience]}} =
               Importer.import_profile_data(user, profile_data)

      assert experience.start_date == ~D[2020-01-01]
      assert experience.end_date == ~D[2021-12-01]
    end

    test "handles nil dates", %{user: user} do
      profile_data = %{
        "profile" => %{
          "headline" => "Software Engineer"
        },
        "experiences" => [
          %{
            "company" => "Company",
            "role" => "Role",
            "start_date" => "2020-01",
            "end_date" => nil,
            "description" => "Description"
          }
        ],
        "education" => []
      }

      assert {:ok, %{experiences: [experience]}} =
               Importer.import_profile_data(user, profile_data)

      assert experience.start_date == ~D[2020-01-01]
      assert experience.end_date == nil
    end
  end
end
