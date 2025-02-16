defmodule AccomplishWeb.JobApplicationsLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  import AccomplishWeb.Components.StackedList

  def render(assigns) do
    ~H"""
    <div class="mt-8 w-full">
      <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="inline-block min-w-full py-2 align-middle">
          <.stacked_list>
            <%= for {status, applications} <- @applications_by_status do %>
              <.list_header>
                <div class="flex items-center gap-2">
                  <div class={"h-3 w-3 rounded-full #{status_color(status)}"}></div>
                  <h2 class="text-sm tracking-tight text-zinc-300">
                    {format_status(status)}
                  </h2>
                </div>
                <button class="text-zinc-400 hover:text-zinc-200">
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                    <path d="M8.75 4C8.75 3.58579 8.41421 3.25 8 3.25C7.58579 3.25 7.25 3.58579 7.25 4V7.25H4C3.58579 7.25 3.25 7.58579 3.25 8C3.25 8.41421 3.58579 8.75 4 8.75H7.25V12C7.25 12.4142 7.58579 12.75 8 12.75C8.41421 12.75 8.75 12.4142 8.75 12V8.75H12C12.4142 8.75 12.75 8.41421 12.75 8C12.75 7.58579 12.4142 7.25 12 7.25H8.75V4Z">
                    </path>
                  </svg>
                </button>
              </.list_header>

              <.list_content>
                <%= for application <- applications do %>
                  <.list_item clickable={true} href="#">
                    <p class="text-[13px] text-zinc-300 leading-tight">
                      {application.company.name}
                      <span class="text-zinc-400">• {application.role}</span>
                    </p>
                    <p class="text-[13px] text-zinc-400 leading-tight"></p>
                    <p class="text-[13px] text-zinc-400 leading-tight text-right">
                      {formatted_relative_time(application.applied_at)}
                    </p>
                  </.list_item>
                <% end %>
              </.list_content>
            <% end %>
          </.stacked_list>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    applications = JobApplications.list_user_applications(user)

    status_priority = %{
      # 🔵 Highest priority
      offer: 1,
      # 🟡 Actively in process
      interviewing: 2,
      # 🟢 Initial state
      applied: 3,
      # 🔴 Trash these at the bottom
      rejected: 4
    }

    applications_by_status =
      applications
      |> Enum.group_by(& &1.status)
      # Default 999 for unknowns
      |> Enum.sort_by(fn {status, _} -> Map.get(status_priority, status, 999) end)

    socket =
      assign(socket,
        page_title: "Job Applications",
        applications_by_status: applications_by_status
      )

    {:ok, socket}
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
