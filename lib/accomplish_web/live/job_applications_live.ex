defmodule AccomplishWeb.JobApplicationsLive do
  use AccomplishWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Job Applications
      <:subtitle>Manage your stuff</:subtitle>
    </.header>
    """
  end
end
