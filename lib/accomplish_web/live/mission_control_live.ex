defmodule AccomplishWeb.MissionControlLive do
  use AccomplishWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Mission Control
      <:subtitle>Manage your stuff</:subtitle>
    </.header>
    """
  end
end
