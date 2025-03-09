defmodule Accomplish.CoverLettersTest do
  use Accomplish.DataCase

  alias Accomplish.CoverLetters
  alias Accomplish.CoverLetters.CoverLetter

  describe "get_cover_letter!/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      cover_letter = cover_letter_fixture(application)
      %{applicant: applicant, application: application, cover_letter: cover_letter}
    end

    test "returns the cover letter with the given id", %{cover_letter: cover_letter} do
      fetched_cover_letter = CoverLetters.get_cover_letter!(cover_letter.id)
      assert fetched_cover_letter.id == cover_letter.id
      assert fetched_cover_letter.title == cover_letter.title
      assert fetched_cover_letter.content == cover_letter.content
      assert fetched_cover_letter.status == cover_letter.status
    end

    test "returns the cover letter with preloaded associations", %{cover_letter: cover_letter} do
      fetched_cover_letter =
        CoverLetters.get_cover_letter!(cover_letter.id, preloads: :application)

      assert fetched_cover_letter.application.id == cover_letter.application_id
    end

    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        CoverLetters.get_cover_letter!(UUIDv7.generate())
      end
    end
  end

  describe "list_cover_letters_for_application/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      other_application = job_application_fixture(applicant)

      # Create multiple cover letters for the application
      cover_letter1 = cover_letter_fixture(application, %{title: "First Cover Letter"})
      cover_letter2 = cover_letter_fixture(application, %{title: "Second Cover Letter"})

      # Create a cover letter for another application
      other_cover_letter = cover_letter_fixture(other_application)

      %{
        applicant: applicant,
        application: application,
        other_application: other_application,
        cover_letter1: cover_letter1,
        cover_letter2: cover_letter2,
        other_cover_letter: other_cover_letter
      }
    end

    test "returns all cover letters for the given application", %{
      application: application,
      cover_letter1: cover_letter1,
      cover_letter2: cover_letter2
    } do
      cover_letters = CoverLetters.list_cover_letters_for_application(application.id)

      assert length(cover_letters) == 2
      assert Enum.any?(cover_letters, fn cl -> cl.id == cover_letter1.id end)
      assert Enum.any?(cover_letters, fn cl -> cl.id == cover_letter2.id end)
    end

    test "returns cover letters ordered by inserted_at in descending order", %{
      application: application,
      cover_letter1: cover_letter1,
      cover_letter2: cover_letter2
    } do
      # Ensure cover_letter1 is older than cover_letter2
      older_cover_letter =
        cover_letter1
        |> Ecto.Changeset.change(inserted_at: DateTime.add(cover_letter2.inserted_at, -1, :day))
        |> Repo.update!()

      cover_letters = CoverLetters.list_cover_letters_for_application(application.id)

      [first, second] = cover_letters
      assert first.id == cover_letter2.id
      assert second.id == older_cover_letter.id
    end

    test "returns an empty list when application has no cover letters" do
      application = job_application_fixture(user_fixture())

      assert CoverLetters.list_cover_letters_for_application(application.id) == []
    end

    test "preloads associations when specified", %{application: application} do
      cover_letters =
        CoverLetters.list_cover_letters_for_application(application.id, [:application])

      assert Enum.all?(cover_letters, fn cl ->
               cl.application.id == application.id
             end)
    end
  end

  describe "create_cover_letter/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      %{applicant: applicant, application: application}
    end

    test "with valid data creates a cover letter", %{application: application} do
      valid_attrs = %{
        title: "Application for Software Engineer",
        content: "I am writing to apply for the Software Engineer position.",
        status: :draft
      }

      assert {:ok, %CoverLetter{} = cover_letter} =
               CoverLetters.create_cover_letter(application, valid_attrs)

      assert cover_letter.title == valid_attrs.title
      assert cover_letter.content == valid_attrs.content
      assert cover_letter.status == :draft
      assert cover_letter.application_id == application.id
    end

    test "with invalid data returns error changeset", %{application: application} do
      invalid_attrs = %{title: nil, content: nil, status: nil}

      assert {:error, %Ecto.Changeset{}} =
               CoverLetters.create_cover_letter(application, invalid_attrs)
    end
  end

  describe "update_cover_letter/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      cover_letter = cover_letter_fixture(application)
      %{applicant: applicant, application: application, cover_letter: cover_letter}
    end

    test "with valid data updates the cover letter", %{cover_letter: cover_letter} do
      update_attrs = %{
        title: "Updated Cover Letter Title",
        content: "This is the updated content for my cover letter."
      }

      assert {:ok, %CoverLetter{} = updated_cover_letter} =
               CoverLetters.update_cover_letter(cover_letter, update_attrs)

      assert updated_cover_letter.title == update_attrs.title
      assert updated_cover_letter.content == update_attrs.content
      assert updated_cover_letter.status == cover_letter.status
    end

    test "with invalid data returns error changeset", %{cover_letter: cover_letter} do
      invalid_attrs = %{title: nil, content: nil}

      assert {:error, %Ecto.Changeset{}} =
               CoverLetters.update_cover_letter(cover_letter, invalid_attrs)

      assert cover_letter.title == CoverLetters.get_cover_letter!(cover_letter.id).title
      assert cover_letter.content == CoverLetters.get_cover_letter!(cover_letter.id).content
    end
  end

  describe "submit_cover_letter/1" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      cover_letter = cover_letter_fixture(application)
      %{applicant: applicant, application: application, cover_letter: cover_letter}
    end

    test "changes the status to submitted and sets submitted_at", %{cover_letter: cover_letter} do
      assert cover_letter.status == :draft
      assert cover_letter.submitted_at == nil

      assert {:ok, submitted_cover_letter} = CoverLetters.submit_cover_letter(cover_letter)

      assert submitted_cover_letter.status == :submitted
      assert submitted_cover_letter.submitted_at != nil
    end
  end

  describe "delete_cover_letter/1" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      cover_letter = cover_letter_fixture(application)
      %{applicant: applicant, application: application, cover_letter: cover_letter}
    end

    test "deletes the cover letter", %{cover_letter: cover_letter} do
      assert {:ok, %CoverLetter{}} = CoverLetters.delete_cover_letter(cover_letter)

      assert_raise Ecto.NoResultsError, fn ->
        CoverLetters.get_cover_letter!(cover_letter.id)
      end
    end
  end

  describe "change_cover_letter/2" do
    setup do
      applicant = user_fixture()
      application = job_application_fixture(applicant)
      cover_letter = cover_letter_fixture(application)
      %{applicant: applicant, application: application, cover_letter: cover_letter}
    end

    test "returns a cover letter changeset", %{cover_letter: cover_letter} do
      assert %Ecto.Changeset{} = changeset = CoverLetters.change_cover_letter(cover_letter)
      assert changeset.valid?
    end

    test "allows setting valid attributes", %{cover_letter: cover_letter} do
      attrs = %{title: "New Title", content: "New Content"}

      changeset = CoverLetters.change_cover_letter(cover_letter, attrs)

      assert changeset.valid?
      assert get_change(changeset, :title) == "New Title"
      assert get_change(changeset, :content) == "New Content"
    end

    test "validates required attributes", %{cover_letter: cover_letter} do
      attrs = %{title: nil}

      changeset = CoverLetters.change_cover_letter(cover_letter, attrs)

      refute changeset.valid?
      assert %{title: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
