defmodule AccomplishWeb.Components.Activity do
  @moduledoc false

  use Phoenix.Component
  import AccomplishWeb.CoreComponents
  import AccomplishWeb.ShadowrunComponents
  import AccomplishWeb.TimeHelpers

  def activity(assigns) do
    ~H"""
    <li id={@id} class="relative pb-8 group last:pb-0">
      <span
        class="absolute left-4 top-4 -ml-px h-full w-px bg-zinc-200 group-last:hidden"
        aria-hidden="true"
      >
      </span>

      <div class="relative flex space-x-3">
        <div>
          <span class={[
            "flex size-8 items-center justify-center rounded-full  ring-1 ring-zinc-50",
            activity_color(@activity.action)
          ]}>
            <.icon name={activity_icon(@activity.action)} class="size-4 text-zinc-50" />
          </span>
        </div>
        <div class="flex min-w-0 flex-1 justify-between space-x-4 pt-1.5">
          <div>
            <p class="text-xs text-zinc-500">
              <.activity_message activity={@activity} action={@activity.action} /> •
              <time datetime={formatted_full_date(@activity.inserted_at)}>
                {formatted_relative_time(@activity.inserted_at)}
              </time>
            </p>
          </div>
          <div class="whitespace-nowrap text-right text-xs text-zinc-500"></div>
        </div>
      </div>
    </li>
    """
  end

  defp activity_message(%{action: "job_application.created"} = assigns) do
    ~H"""
    Applied to <span class="text-zinc-50">{@activity.entity.role}</span>
    at <span class="text-zinc-50">{@activity.entity.company.name}</span>
    """
  end

  defp activity_message(%{action: "job_application.status_updated"} = assigns) do
    assigns =
      assigns
      |> assign_new(:from, fn -> assigns[:activity].metadata["from"] end)
      |> assign_new(:to, fn -> assigns[:activity].metadata["to"] end)

    ~H"""
    Status changed from
    <.shadow_pill class={status_color(@from)}>{@from}</.shadow_pill>
    to
    <.shadow_pill class={status_color(@to)}>{@to}</.shadow_pill>
    """
  end

  defp activity_message(%{action: "job_application.stage_added"} = assigns) do
    ~H"""
    Added stage <span class="text-zinc-50">{@activity.entity.title}</span>
    """
  end

  defp activity_message(%{action: "job_application.stage_updated"} = assigns) do
    ~H"""
    Current stage changed from <span class="text-zinc-50">{@activity.metadata["from"]}</span>
    to <span class="text-zinc-50">{@activity.metadata["to"]}</span>
    """
  end

  defp activity_message(%{action: "job_application.stage_status_updated"} = assigns) do
    assigns =
      assigns
      |> assign_new(:from, fn -> assigns[:activity].metadata["from"] end)
      |> assign_new(:to, fn -> assigns[:activity].metadata["to"] end)

    ~H"""
    <span class="text-zinc-50">{@activity.entity.title}</span>
    moved to
    <.shadow_pill class={status_color(@to)}>{@to}</.shadow_pill>
    """
  end

  defp activity_message(%{action: "job_application.stage_deleted"} = assigns) do
    ~H"""
    Removed stage <span class="text-zinc-50">{@activity.entity.title}</span>
    """
  end

  defp activity_color("job_application.created"), do: "bg-green-600"
  defp activity_color("job_application.updated"), do: "bg-blue-600"
  defp activity_color("job_application.stage_updated"), do: "bg-zinc-600"
  defp activity_color(_), do: "bg-zinc-900"

  @activity_icons %{
    "job_application.created" => "hero-paper-airplane-solid",
    "job_application.stage_added" => "hero-square-3-stack-3d-solid",
    "job_application.stage_updated" => "hero-square-3-stack-3d-solid",
    "job_application.stage_deleted" => "hero-square-3-stack-3d-solid"
  }

  defp activity_icon(event) do
    Map.get(@activity_icons, event, "hero-user-solid")
  end

  def status_color("draft"), do: "border-slate-600"
  def status_color("accepted"), do: "border-purple-600"
  def status_color("offer"), do: "border-blue-600"
  def status_color("applied"), do: "border-green-600"
  def status_color("interviewing"), do: "border-yellow-600"
  def status_color("rejected"), do: "border-red-600"
  def status_color("ghosted"), do: "border-zinc-600"
  def status_color(_), do: "border-zinc-200"
end
