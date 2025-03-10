defmodule AccomplishWeb.JobApplicationsLive.ApplicationHeader do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.CoverLetters

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Dialog
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu

  import AccomplishWeb.StringHelpers

  def render(assigns) do
    ~H"""
    <div>
      <.page_header page_drawer?={true} drawer_open={true}>
        <:title>
          <div class="flex lg:items-center lg:gap-1">
            <.link href={~p"/job_applications/"} class="hidden lg:inline">Job Applications</.link>
            <span class="hidden lg:inline-flex items-center text-zinc-400">
              <.icon name="hero-chevron-right" class="size-3" />
            </span>
            <span class="inline">
              {truncate(@application.role, length: 20)} at {@application.company.name}
            </span>
          </div>
        </:title>
        <:menu>
          <.dropdown_menu>
            <.dropdown_menu_trigger id={"#{@application.id}-dropdown-trigger"} class="group">
              <.shadow_button type="button" variant="transparent">
                <.lucide_icon name="ellipsis" class="size-5 text-zinc-400" />
              </.shadow_button>
            </.dropdown_menu_trigger>
            <.dropdown_menu_content>
              <.menu class="w-56 text-zinc-300 bg-zinc-800">
                <.menu_group>
                  <.menu_item class="text-sm">
                    <button type="button" phx-click="new_cover_letter" class="flex items-center gap-2">
                      <.lucide_icon name="square-pen" class="size-4 text-zinc-400" />
                      <span>Write cover letter</span>
                    </button>
                    <.menu_shortcut>⌘W</.menu_shortcut>
                  </.menu_item>
                  <.menu_item class="text-sm">
                    <button
                      type="button"
                      phx-click="open_cover_letter_dialog"
                      class="flex items-center gap-2"
                    >
                      <.lucide_icon name="sparkles" class="size-4 text-zinc-400" />
                      <span>Generate cover letter</span>
                    </button>
                    <.menu_shortcut>⌘G</.menu_shortcut>
                  </.menu_item>
                  <.menu_separator />
                  <.menu_item class="text-sm">
                    <button
                      type="button"
                      phx-click="delete_application"
                      phx-value-id={@application.id}
                      class="flex items-center gap-2"
                    >
                      <.lucide_icon name="trash-2" class="size-4 text-zinc-400" />
                      <span>Delete application</span>
                    </button>
                    <.menu_shortcut>⌘D</.menu_shortcut>
                  </.menu_item>
                </.menu_group>
              </.menu>
            </.dropdown_menu_content>
          </.dropdown_menu>
        </:menu>

        <:views>
          <.nav_button
            icon="file-text"
            text="Overview"
            href={~p"/job_application/#{@application.slug}/overview"}
            active={@view == :overview}
          />
          <.nav_button
            icon="layers"
            text="Stages"
            href={~p"/job_application/#{@application.slug}/stages"}
            active={@view == :stages}
          />
          <.nav_button
            icon="files"
            text="Documents"
            href={~p"/job_application/#{@application.slug}/documents"}
            active={@view == :documents}
          />
        </:views>
      </.page_header>

      {render_cover_letter_dialog(assigns)}
    </div>
    """
  end

  defp render_cover_letter_dialog(assigns) do
    ~H"""
    <.dialog
      id="cover-letter-dialog"
      position={:center}
      on_cancel={hide_dialog("cover-letter-dialog")}
      class="w-full max-w-md max-h-[90vh] overflow-hidden"
    >
      <.dialog_header>
        <.dialog_title class="text-sm text-zinc-200 font-light">
          <div class="flex items-center gap-2">
            <.lucide_icon name="sparkles" class="size-4 text-purple-400" />
            <p>AI Cover Letter Generator</p>
          </div>
        </.dialog_title>
        <.dialog_description>
          Let AI create a personalized cover letter based on your profile and job details.
        </.dialog_description>
      </.dialog_header>

      <.dialog_content id="cover-letter-content" class="pb-6">
        <div class="flex flex-col gap-4 py-4">
          <p class="text-zinc-300 text-sm">
            I'll create a personalized cover letter for your application to
            <span class="font-semibold">{@application.role}</span>
            at <span class="font-semibold"><%= @application.company.name %></span>.
          </p>
          <p class="text-zinc-300 text-sm">
            The letter will be tailored based on your profile information and the job details.
          </p>
        </div>
      </.dialog_content>

      <.dialog_footer>
        <div class="flex justify-end gap-2">
          <.shadow_button
            type="button"
            variant="secondary"
            phx-click={hide_dialog("cover-letter-dialog")}
          >
            Cancel
          </.shadow_button>

          <.shadow_button type="button" variant="primary" phx-click="create_ai_cover_letter">
            Generate Cover Letter
          </.shadow_button>
        </div>
      </.dialog_footer>
    </.dialog>
    """
  end

  on_mount {AccomplishWeb.Plugs.UserAuth, :mount_current_user}

  def mount(_params, session, socket) do
    application = session["application"]
    view = session["view"]

    socket =
      socket
      |> assign(application: application)
      |> assign(:view, view)
      |> assign(show_cover_letter_dialog: false)

    {:ok, socket}
  end

  def handle_event("new_cover_letter", _params, socket) do
    application = socket.assigns.application
    {:ok, cover_letter} = CoverLetters.create_cover_letter(application)

    {:noreply,
     socket
     |> push_navigate(
       to: ~p"/job_application/#{application.slug}/cover_letter/#{cover_letter.id}"
     )}
  end

  def handle_event("open_cover_letter_dialog", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_cover_letter_dialog, true)
     |> push_event("js-exec", %{
       to: "#cover-letter-dialog",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("create_ai_cover_letter", _params, socket) do
    application = socket.assigns.application

    {:ok, cover_letter} =
      CoverLetters.create_cover_letter(application, %{title: "AI-generated Cover Letter"})

    {:noreply,
     socket
     |> push_navigate(
       to:
         ~p"/job_application/#{application.slug}/cover_letter/#{cover_letter.id}?ai_generate=true"
     )}
  end

  def handle_event("delete_application", %{"id" => id}, socket) do
    case JobApplications.delete_application(id) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Job application deleted successfully.")
         |> push_navigate(to: ~p"/job_applications")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Could not delete job application.")}
    end
  end
end
