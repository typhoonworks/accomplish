defmodule AccomplishWeb.JobApplicationsLive.ApplicationDocuments do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.CoverLetters

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.StackedList
  import AccomplishWeb.Components.JobApplications.DocumentList

  alias AccomplishWeb.JobApplicationsLive.ApplicationHeader
  alias AccomplishWeb.JobApplicationsLive.ApplicationAside

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        {live_render(@socket, ApplicationHeader,
          id: "application-header",
          session: %{"application" => @application, "view" => :documents},
          sticky: true
        )}
      </:page_header>

      <:page_drawer>
        {live_render(@socket, ApplicationAside,
          id: "application-aside",
          session: %{"application" => @application},
          sticky: true
        )}
      </:page_drawer>

      <div class="mt-8 w-full">
        <div>
          <div
            id="documents"
            class="inline-block min-w-full py-2 align-middle"
            phx-hook="AudioMp3"
            data-sounds={@sounds}
          >
            <.stacked_list>
              <.document_group
                type="cover_letter"
                documents={@streams.cover_letters}
                application={@application}
              />
            </.stacked_list>
          </div>
        </div>
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
    with {:ok, socket, application} <- fetch_application(socket, slug, :stages),
         cover_letters <- CoverLetters.list_cover_letters_for_application(application.id) do
      socket =
        socket
        |> assign(page_title: "#{application.role} • Documents")
        |> assign(application: application)
        |> subscribe_to_notifications_topic()
        |> assign_sounds()
        |> assign_play_sounds(true)
        |> stream(:cover_letters, cover_letters)

      {:ok, socket}
    end
  end

  def handle_event("delete_document", %{"id" => id, "type" => "cover_letter"}, socket) do
    application = socket.assigns.application

    case CoverLetters.delete_cover_letter(application, id) do
      {:ok, cover_letter} ->
        socket =
          socket
          |> stream_delete(:cover_letters, cover_letter)
          |> maybe_play_sound("swoosh")

        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete cover letter.")}
    end
  end

  def handle_info({JobApplications, event}, socket) do
    handle_notification(event, socket)
  end

  def handle_info({CoverLetters, event}, socket) do
    handle_notification(event, socket)
  end

  defp handle_notification(%{name: "job_application.updated"} = event, socket) do
    {:noreply, assign(socket, application: event.application)}
  end

  defp handle_notification(%{name: "cover_letter.created"} = event, socket) do
    {:noreply, stream_insert(socket, :cover_letters, event.cover_letter)}
  end

  defp handle_notification(%{name: "cover_letter.updated"} = event, socket) do
    {:noreply, stream_insert(socket, :cover_letters, event.cover_letter)}
  end

  defp handle_notification(%{name: "cover_letter.deleted"} = event, socket) do
    {:noreply, stream_delete(socket, :cover_letters, event.cover_letter)}
  end

  defp handle_notification(_, socket), do: {:noreply, socket}

  defp fetch_application(socket, slug, preloads) do
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

  defp assign_sounds(socket) do
    json =
      JSON.encode!(%{
        swoosh: ~p"/audio/swoosh.mp3"
      })

    assign(socket, :sounds, json)
  end

  defp assign_play_sounds(socket, play_sounds) do
    assign(socket, play_sounds: play_sounds)
  end

  defp maybe_play_sound(socket, sound) do
    %{play_sounds: play_sounds} = socket.assigns

    case play_sounds do
      true -> push_event(socket, "play-sound", %{name: sound})
      _ -> socket
    end
  end
end
