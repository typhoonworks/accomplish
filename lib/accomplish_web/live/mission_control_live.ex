defmodule AccomplishWeb.MissionControlLive do
  use AccomplishWeb, :live_view

  import AccomplishWeb.Layout

  alias AccomplishWeb.NotificationsLive

  def render(assigns) do
    ~H"""
    <.layout flash={@flash} current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title="Mission Control">
          <:actions>
            {live_render(@socket, NotificationsLive,
              id: "user-notifications",
              sticky: true
            )}
          </:actions>
        </.page_header>
      </:page_header>

      <div class="p-6 space-y-6">
        <h1 class="text-xl font-semibold text-zinc-100">Flash Message Examples</h1>

        <div class="space-y-4">
          <.shadow_button phx-click="show_info">Show Info Flash</.shadow_button>
          <.shadow_button phx-click="show_success" variant="primary">
            Show Success Flash
          </.shadow_button>
          <.shadow_button phx-click="show_warning">Show Warning Flash</.shadow_button>
          <.shadow_button phx-click="show_error">Show Error Flash</.shadow_button>
        </div>
      </div>
    </.layout>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: "Mission Control")

    {:ok, socket}
  end

  def handle_event("show_info", _, socket) do
    {:noreply, put_flash(socket, :info, "This is an info message")}
  end

  def handle_event("show_success", _, socket) do
    {:noreply, put_flash(socket, :success, "This is a success message")}
  end

  def handle_event("show_warning", _, socket) do
    {:noreply, put_flash(socket, :warning, "This is a warning message")}
  end

  def handle_event("show_error", _, socket) do
    socket =
      socket
      |> put_flash(:title, "Custom Error")
      |> put_flash(:error, "This is an error message")

    {:noreply, socket}
  end
end
