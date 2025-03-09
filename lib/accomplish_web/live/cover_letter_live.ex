defmodule AccomplishWeb.CoverLetterLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.CoverLetters

  import AccomplishWeb.StringHelpers
  import AccomplishWeb.CoverLetterHelpers
  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Tooltip

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

      <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
        <div class="space-y-4 mb-6">
          <.shadow_input
            field={@form[:title]}
            placeholder="Cover letter title"
            class="text-[25px] tracking-tighter hover:cursor-text"
            phx-blur="save_field"
            phx-value-field={@form[:title].field}
          />
        </div>
        <div class="flex justify-start gap-2 my-2">
          <.tooltip>
            <.shadow_select_input
              id={"status_select_#{@form.id}"}
              field={@form[:status]}
              prompt="Change status"
              value={@form[:status].value}
              options={options_for_cover_letter_status()}
              on_select="save_field"
              variant="transparent"
            />
            <.tooltip_content side="bottom">
              <p>Change status</p>
            </.tooltip_content>
          </.tooltip>
        </div>
        <div class="mt-12 space-y-2">
          <.shadow_input
            field={@form[:content]}
            type="textarea"
            placeholder="Highlight your skills, experience, and passion for this role..."
            class="text-[14px] font-light hover:cursor-text"
            socket={@socket}
            phx-blur="save_field"
            phx-value-field={@form[:content].field}
          />
        </div>
      </section>
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

  def handle_event("save_field", %{"field" => field, "value" => value}, socket) do
    cover_letter = socket.assigns.cover_letter
    changes = %{field => value}

    case CoverLetters.update_cover_letter(cover_letter, changes) do
      {:ok, updated_cover_letter} ->
        form =
          updated_cover_letter
          |> CoverLetters.change_cover_letter()
          |> to_form()

        {:noreply,
         socket
         |> assign(form: form)}
    end
  end

  defp assign_form(socket, cover_letter) do
    form = CoverLetters.change_cover_letter(cover_letter)
    assign(socket, form: to_form(form))
  end
end
