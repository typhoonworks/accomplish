defmodule Accomplish.CoverLettersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accomplish.CoverLetters` context.
  """

  alias Accomplish.CoverLetters

  @doc """
  Generates a cover letter for a given job application.
  """
  def cover_letter_fixture(application, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        title: "Cover Letter for #{application.role}",
        content:
          "This is a sample cover letter for a job application at #{application.company.name}.",
        status: :draft
      })

    {:ok, cover_letter} = CoverLetters.create_cover_letter(application, attrs)

    cover_letter
  end

  @doc """
  Generates a submitted cover letter for a given job application.
  """
  def submitted_cover_letter_fixture(application, attrs \\ %{}) do
    cover_letter = cover_letter_fixture(application, attrs)
    {:ok, submitted_cover_letter} = CoverLetters.submit_cover_letter(cover_letter)

    submitted_cover_letter
  end
end
