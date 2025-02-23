defmodule AccomplishWeb.JobApplicationHelpers do
  @moduledoc false

  def format_status(:applied), do: "Applied"
  def format_status(:interviewing), do: "Interviewing"
  def format_status(:offer), do: "Offer"
  def format_status(:rejected), do: "Rejected"
  def format_status(:accepted), do: "Accepted"

  def status_color(:applied), do: "bg-green-600"
  def status_color(:interviewing), do: "bg-yellow-600"
  def status_color(:offer), do: "bg-blue-600"
  def status_color(:rejected), do: "bg-red-600"
  def status_color(:accepted), do: "bg-purple-600"

  def options_for_application_status do
    [
      %{
        label: "Applied",
        value: :applied,
        icon: "hero-paper-airplane",
        color: "text-green-600",
        shortcut: "1"
      },
      %{
        label: "Interviewing",
        value: :interviewing,
        icon: "hero-envelope-open",
        color: "text-yellow-600",
        shortcut: "2"
      },
      %{
        label: "Offer",
        value: :offer,
        icon: "hero-hand-thumb-up",
        color: "text-blue-600",
        shortcut: "3"
      },
      %{
        label: "Rejected",
        value: :rejected,
        icon: "hero-hand-thumb-down",
        color: "text-red-600",
        shortcut: "4"
      },
      %{
        label: "Accepted",
        value: :accepted,
        icon: "hero-star",
        color: "text-purple-600",
        shortcut: "5"
      }
    ]
  end

  def options_for_stage_type do
    [
      %{
        label: "Screening",
        value: "screening",
        icon: "hero-phone",
        color: "text-zinc-400",
        shortcut: "1"
      },
      %{
        label: "Interview",
        value: "interview",
        icon: "hero-user-group",
        color: "text-zinc-400",
        shortcut: "2"
      },
      %{
        label: "Assessment",
        value: "assessment",
        icon: "hero-document-text",
        color: "text-zinc-400",
        shortcut: "3"
      }
    ]
  end

  def stage_icon(:screening), do: "hero-phone"
  def stage_icon(:interview), do: "hero-user-group"
  def stage_icon(:assessment), do: "hero-document-text"
  def stage_icon(_), do: "hero-light-bulb"
end
