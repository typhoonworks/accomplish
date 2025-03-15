defmodule AccomplishWeb.InboxLive do
  use AccomplishWeb, :live_view

  import AccomplishWeb.Layout

  def render(assigns) do
    ~H"""
    <.layout flash={@flash} current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title="Inbox" />
      </:page_header>
    </.layout>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: "Inbox")

    {:ok, socket}
  end
end
