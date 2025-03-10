defmodule AccomplishWeb.JobApplicationsLive.ApplicationDocuments do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.CoverLetters

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.StackedList

  alias AccomplishWeb.JobApplications.ApplicationHeader
  alias AccomplishWeb.JobApplicationsLive.ApplicationAside

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.live_component
          module={ApplicationHeader}
          id="application-header"
          application={@application}
          current_user={@current_user}
          view={:documents}
        />
      </:page_header>

      <:page_drawer>
        {live_render(@socket, ApplicationAside,
          id: "application-aside",
          session: %{"application" => @application},
          sticky: true
        )}
      </:page_drawer>

      <div class="mt-8 w-full">
        <.stacked_list>
          {render_documents(assigns)}
        </.stacked_list>
      </div>
    </.layout>
    """
  end

  def render_documents(assigns) do
    ~H"""
    <div
      id="cover-letters-group"
      class="hidden opacity-0 translate-y-2 transition-transform duration-300"
      phx-hook="StackedList"
    >
      <.list_header>
        <div class="flex items-center gap-2">
          <div class="h-3 w-3 rounded-full bg-amber-600"></div>
          <h2 class="text-sm tracking-tight text-zinc-300">
            Cover letters
          </h2>
        </div>
      </.list_header>
      <.list_content>
        <div id="cover-letters-container">
          <div
            :for={cover_letter <- @cover_letters}
            id={cover_letter.id}
            data-menu={"context-menu-#{cover_letter.id}"}
            phx-hook="ContextMenu"
          >
            <.list_item href={
              ~p"/job_application/#{@application.slug}/cover_letter/#{cover_letter.id}"
            }>
              <div class="flex items-center gap-2">
                <%!-- <.application_status_select application={application} /> --%>
                <p class="text-[13px] text-zinc-300 leading-tight">
                  {cover_letter.title}
                </p>
              </div>

              <p class="hidden lg:block text-[13px] text-zinc-400 leading-tight text-right truncate">
              </p>

              <p class="text-[13px] text-zinc-400 leading-tight text-right w-24">
                {cover_letter.inserted_at && formatted_relative_time(cover_letter.inserted_at)}
              </p>
            </.list_item>
          </div>
        </div>
      </.list_content>
    </div>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    with {:ok, socket, application} <- fetch_application(socket, slug),
         cover_letters <- CoverLetters.list_cover_letters_for_application(application.id) do
      socket =
        socket
        |> assign(page_title: "#{application.role} • Documents")
        |> assign(application: application)
        |> assign(:cover_letters, cover_letters)
        |> subscribe_to_notifications_topic()

      {:ok, socket}
    end
  end

  def handle_info({JobApplications, event}, socket) do
    handle_notification(event, socket)
  end

  def handle_info({CoverLetters, _}, socket) do
    {:noreply, socket}
  end

  defp handle_notification(%{name: "job_application.updated"} = event, socket) do
    {:noreply, assign(socket, application: event.application)}
  end

  defp handle_notification(_, socket), do: {:noreply, socket}

  defp fetch_application(socket, slug, preloads \\ []) do
    applicant = socket.assigns.current_user

    case JobApplications.get_application_by_slug(applicant, slug, preloads) do
      {:ok, application} ->
        {:ok, socket, application}

      :error ->
        {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  defp subscribe_to_notifications_topic(socket) do
    user = socket.assigns.current_user

    if connected?(socket),
      do: Phoenix.PubSub.subscribe(@pubsub, @notifications_topic <> ":#{user.id}")

    socket
  end
end
