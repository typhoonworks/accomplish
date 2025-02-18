defmodule AccomplishWeb.MissionControlLive do
  use AccomplishWeb, :live_view
  use LiveSvelte.Components

  import AccomplishWeb.Layout

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title="Mission Control" />
      </:page_header>

      <.InlineEditor
        id="job-title-editor"
        placeholder="Role"
        classList="text-zinc-300 text-md font-semibold"
        socket={@socket}
        phx-hook="FocusEditorHook"
        phx-value-target="job-title-editor"
      />
    </.layout>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      assign(socket, page_title: "Mission Control", number: 5)

    {:ok, socket}
  end

  def handle_event("set_number", %{"number" => number}, socket) do
    {:noreply, assign(socket, :number, number)}
  end
end
