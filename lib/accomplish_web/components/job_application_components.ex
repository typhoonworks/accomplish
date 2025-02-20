defmodule AccomplishWeb.Components.JobApplicationComponents do
  @moduledoc false

  use Phoenix.Component

  import AccomplishWeb.CoreComponents
  import AccomplishWeb.Shadowrun.Menu
  import AccomplishWeb.Shadowrun.StackedList
  import AccomplishWeb.TimeHelpers

  def application_group(assigns) do
    ~H"""
    <.list_header>
      <div class="flex items-center gap-2">
        <div class={"h-3 w-3 rounded-full #{status_color(@status)}"}></div>
        <h2 class="text-sm tracking-tight text-zinc-300">
          {format_status(@status)}
        </h2>
      </div>
      <button
        class="text-zinc-400 hover:text-zinc-200"
        phx-click="prepare_new_application"
        phx-value-status={@status}
        phx-value-modal_id="new-job-application"
      >
        <.icon class="text-current size-4" name="hero-plus" />
      </button>
    </.list_header>
    <.list_content>
      <div id={"#{@status}-container"} phx-update="stream">
        <div
          :for={{dom_id, application} <- @applications}
          id={dom_id}
          data-menu={"context-menu-#{application.id}"}
          phx-hook="ContextMenu"
        >
          <.list_item clickable={true} href="#">
            <p class="text-[13px] text-zinc-300 leading-tight">
              {application.company.name}
              <span class="text-zinc-400">• {application.role}</span>
            </p>
            <p class="text-[13px] text-zinc-400 leading-tight"></p>
            <p class="text-[13px] text-zinc-400 leading-tight text-right">
              {formatted_relative_time(application.applied_at)}
            </p>

            <.menu id={"context-menu-#{application.id}"} class="hidden w-56 text-zinc-300 bg-zinc-900">
              <.menu_group>
                <.menu_item phx-click="delete_application" phx-value-id={application.id}>
                  <div class="w-full flex items-center gap-2">
                    <.icon name="hero-trash" class="size-4" />
                    <span>Delete</span>
                    <.menu_shortcut>
                      <span>⌘⌫</span>
                    </.menu_shortcut>
                  </div>
                </.menu_item>
              </.menu_group>
            </.menu>
          </.list_item>
        </div>
      </div>
    </.list_content>
    """
  end

  defp format_status(:applied), do: "Applied"
  defp format_status(:interviewing), do: "Interviewing"
  defp format_status(:offer), do: "Offer"
  defp format_status(:rejected), do: "Rejected"

  defp status_color(:applied), do: "bg-green-600"
  defp status_color(:interviewing), do: "bg-yellow-600"
  defp status_color(:offer), do: "bg-blue-500"
  defp status_color(:rejected), do: "bg-red-600"
end
