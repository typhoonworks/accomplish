defmodule AccomplishWeb.MissionControlLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications

  import AccomplishWeb.Layout
  import AccomplishWeb.TimeHelpers

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title="Mission Control" />
      </:page_header>

      <div class="w-full h-full">
        <div class="sm:-mx-6 lg:-mx-8 h-full">
          <.live_component
            module={AccomplishWeb.Components.JobApplicationTimeline}
            id="application-timeline"
            applications={@applications}
            timezone={@timezone}
          />
        </div>
      </div>
    </.layout>
    """
  end

  def mount(_params, session, socket) do
    user = socket.assigns.current_user
    timezone = get_timezone(socket, session)
    applications = JobApplications.list_applications(user, limit: 10, preload: [:company])

    socket =
      socket
      |> assign(page_title: "Mission Control")
      |> assign(:timezone, timezone)
      |> assign(:applications, applications)

    {:ok, socket}
  end
end
