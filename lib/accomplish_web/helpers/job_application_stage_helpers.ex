defmodule AccomplishWeb.JobApplicationStageHelpers do
  @moduledoc false

  def format_status(:pending), do: "Pending"
  def format_status(:scheduled), do: "Scheduled"
  def format_status(:in_progress), do: "In Progress"
  def format_status(:completed), do: "Completed"
  def format_status(:skipped), do: "Skipped"

  def status_color(:pending), do: "bg-yellow-600"
  def status_color(:scheduled), do: "bg-cyan-600"
  def status_color(:in_progress), do: "bg-purple-600"
  def status_color(:skipped), do: "bg-red-600"
  def status_color(:completed), do: "bg-green-600"

  def options_for_stage_status do
    [
      %{
        label: "Pending",
        value: :applied,
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
end
