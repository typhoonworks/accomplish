defmodule AccomplishWeb.MissionControlLive do
  use AccomplishWeb, :live_view

  def render(assigns) do
    ~H"""
    """
  end

  def mount(_params, _session, socket) do
    socket =
      assign(socket, page_title: "Mission Control")

    {:ok, socket}
  end
end
