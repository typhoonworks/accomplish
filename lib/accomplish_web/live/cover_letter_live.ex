defmodule AccomplishWeb.CoverLetterLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.CoverLetters

  import AccomplishWeb.StringHelpers
  import AccomplishWeb.Layout

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header>
          <:title>
            <div class="flex lg:items-center lg:gap-1">
              <.link href={~p"/job_application/#{@application.slug}/stages"} class="hidden lg:inline">
                <span class="inline">{@application.role} at {@application.company.name}</span>
              </.link>
              <span class="hidden lg:inline-flex items-center text-zinc-400">
                <.icon name="hero-chevron-right" class="size-3" />
              </span>
              <span class="inline">
                {truncate(@cover_letter.title, length: 20)}
              </span>
            </div>
          </:title>
        </.page_header>
      </:page_header>
    </.layout>
    """
  end

  def mount(%{"application_slug" => application_slug, "id" => id}, _session, socket) do
    applicant = socket.assigns.current_user

    with {:ok, application} <-
           JobApplications.get_application_by_slug(applicant, application_slug),
         cover_letter <- CoverLetters.get_application_cover_letter!(application, id) do
      socket =
        socket
        |> assign(page_title: cover_letter.title)
        |> assign(application: application)
        |> assign(cover_letter: cover_letter)
        |> assign_form(cover_letter)

      {:ok, socket}
    else
      :error -> {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  defp assign_form(socket, cover_letter) do
    form = CoverLetters.change_cover_letter(cover_letter)
    assign(socket, form: to_form(form))
  end
end
