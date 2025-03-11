defmodule AccomplishWeb.CoverLetterHelpers do
  @moduledoc """
  Provides helper functions for cover letter-related views.
  """

  @doc """
  Returns a list of options for cover letter status dropdown.
  """
  def options_for_cover_letter_status do
    [
      %{
        label: "Draft",
        value: "draft",
        icon: "hero-document-text",
        color: "text-zinc-400",
        shortcut: "1"
      },
      %{
        label: "Final",
        value: "final",
        icon: "hero-document-check",
        color: "text-blue-400",
        shortcut: "2"
      },
      %{
        label: "Submitted",
        value: "submitted",
        icon: "hero-paper-airplane",
        color: "text-green-400",
        shortcut: "3"
      }
    ]
  end
end
