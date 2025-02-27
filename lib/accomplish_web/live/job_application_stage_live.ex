defmodule AccomplishWeb.JobApplicationStageLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications

  import AccomplishWeb.Layout

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title={@stage.title} page_drawer?={true} drawer_open={true} />
      </:page_header>

      <:page_drawer>
        <.page_drawer drawer_open={true}>
          <:drawer_content>
            <div class="text-sm text-zinc-50">
              <p>This is the drawer content specific to Stage.</p>
            </div>
          </:drawer_content>
        </.page_drawer>
      </:page_drawer>
    </.layout>
    """
  end

  def mount(%{"application_slug" => application_slug, "slug" => slug}, _session, socket) do
    applicant = socket.assigns.current_user

    with {:ok, application} <-
           JobApplications.get_application_by_slug(applicant, application_slug),
         {:ok, stage} <- JobApplications.get_stage_by_slug(application, slug) do
      socket =
        socket
        |> assign(application: application)
        |> assign(stage: stage)

      {:ok, socket}
    else
      :error -> {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end
end
