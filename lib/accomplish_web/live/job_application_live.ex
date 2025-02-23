defmodule AccomplishWeb.JobApplicationLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications

  import AccomplishWeb.Layout

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title={"#{@application.role} @ #{@application.company.name}"}>
        </.page_header>
      </:page_header>
    </.layout>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    applicant = socket.assigns.current_user

    case JobApplications.get_application_by_slug(applicant, slug, [
           :company,
           :current_stage,
           :stages
         ]) do
      {:ok, application} ->
        {:ok, assign(socket, application: application)}

      :error ->
        {:ok, push_navigate(socket, to: "~p/job_applications")}
    end
  end
end
