defmodule AccomplishWeb.CoverLetterHelpers do
  @moduledoc false

  def options_for_cover_letter_status do
    [
      %{
        label: "Draft",
        value: :draft,
        icon: "hero-pencil-square",
        color: "text-slate-400",
        shortcut: "1"
      },
      %{
        label: "Final",
        value: :final,
        icon: "hero-document-check",
        color: "text-green-600",
        shortcut: "2"
      },
      %{
        label: "Submitted",
        value: :interviewing,
        icon: "hero-envelope",
        color: "text-purple-600",
        shortcut: "3"
      }
    ]
  end
end
