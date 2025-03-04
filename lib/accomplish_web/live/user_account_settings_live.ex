defmodule AccomplishWeb.UserAccountSettingsLive do
  use AccomplishWeb, :live_view

  import AccomplishWeb.Layout

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path} sidebar_context={:settings}>
      <h3>Account Preferences</h3>
    </.layout>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      assign(socket, page_title: "Preferences")

    {:ok, socket}
  end
end
