defmodule AccomplishWeb.JobApplicationHelpers do
  @moduledoc false

  def format_status(:draft), do: "Draft"
  def format_status(:applied), do: "Applied"
  def format_status(:interviewing), do: "Interviewing"
  def format_status(:offer), do: "Offer"
  def format_status(:rejected), do: "Rejected"
  def format_status(:accepted), do: "Accepted"
  def format_status(:ghosted), do: "Ghosted"

  def format_status(:pending), do: "Pending"
  def format_status(:scheduled), do: "Scheduled"
  def format_status(:in_progress), do: "In Progress"
  def format_status(:completed), do: "Completed"
  def format_status(:skipped), do: "Skipped"

  def status_color(:draft), do: "bg-slate-400"
  def status_color(:applied), do: "bg-green-600"
  def status_color(:interviewing), do: "bg-yellow-600"
  def status_color(:offer), do: "bg-blue-600"
  def status_color(:rejected), do: "bg-red-600"
  def status_color(:ghosted), do: "bg-zinc-600"
  def status_color(:accepted), do: "bg-purple-600"

  def status_color(:pending), do: "bg-yellow-600"
  def status_color(:scheduled), do: "bg-cyan-600"
  def status_color(:in_progress), do: "bg-purple-600"
  def status_color(:skipped), do: "bg-red-600"
  def status_color(:completed), do: "bg-green-600"

  def options_for_application_status do
    [
      %{
        label: "Draft",
        value: :draft,
        icon: "hero-pencil-square",
        color: "text-slate-400",
        shortcut: "1"
      },
      %{
        label: "Applied",
        value: :applied,
        icon: "hero-paper-airplane",
        color: "text-green-600",
        shortcut: "2"
      },
      %{
        label: "Interviewing",
        value: :interviewing,
        icon: "hero-envelope-open",
        color: "text-yellow-600",
        shortcut: "3"
      },
      %{
        label: "Offer",
        value: :offer,
        icon: "hero-hand-thumb-up",
        color: "text-blue-600",
        shortcut: "4"
      },
      %{
        label: "Rejected",
        value: :rejected,
        icon: "hero-hand-thumb-down",
        color: "text-red-600",
        shortcut: "5"
      },
      %{
        label: "Accepted",
        value: :accepted,
        icon: "hero-star",
        color: "text-purple-600",
        shortcut: "6"
      },
      %{
        label: "Ghosted",
        value: :ghosted,
        icon: "hero-face-frown",
        color: "text-zinc-600",
        shortcut: "6"
      }
    ]
  end

  def options_for_application_location do
    [
      %{
        label: "Remote",
        value: :remote,
        icon: "hero-wifi",
        color: "text-zinc-50",
        shortcut: "1"
      },
      %{
        label: "Hybrid",
        value: :hybrid,
        icon: "hero-arrows-right-left",
        color: "text-zinc-50",
        shortcut: "2"
      },
      %{
        label: "On-site",
        value: :on_site,
        icon: "hero-building-office",
        color: "text-zinc-50",
        shortcut: "3"
      }
    ]
  end

  def options_for_stage_status do
    [
      %{
        label: "Pending",
        value: :pending,
        icon: "hero-ellipsis-horizontal-circle",
        color: "text-yellow-600",
        shortcut: "1"
      },
      %{
        label: "Scheduled",
        value: :scheduled,
        icon: "hero-clock",
        color: "text-cyan-600",
        shortcut: "2"
      },
      %{
        label: "In Progress",
        value: :in_progress,
        icon: "hero-play-circle",
        color: "text-purple-600",
        shortcut: "3"
      },
      %{
        label: "Skipped",
        value: :skipped,
        icon: "hero-x-circle",
        color: "text-red-600",
        shortcut: "4"
      },
      %{
        label: "Completed",
        value: :completed,
        icon: "hero-check-circle",
        color: "text-green-600",
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
