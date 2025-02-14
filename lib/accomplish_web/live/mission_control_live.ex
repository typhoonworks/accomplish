defmodule AccomplishWeb.MissionControlLive do
  use AccomplishWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Missiong Control
      <:subtitle>Manage your stuff</:subtitle>
    </.header>
    """
  end
end
