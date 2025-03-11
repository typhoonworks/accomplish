defmodule AccomplishWeb.Components.JobApplicationDialogs.CoverLetterDialog do
  @moduledoc """
  A reusable LiveComponent for managing cover letter creation dialog.

  This component encapsulates the UI and event handling for the cover letter
  creation dialog, allowing it to be embedded in any LiveView without duplicating
  markup or event handlers.
  """
  use AccomplishWeb, :live_component

  import AccomplishWeb.CoreComponents
  import AccomplishWeb.ShadowrunComponents
  import AccomplishWeb.Shadowrun.Dialog

  alias AccomplishWeb.EventHandlers.ApplicationActions

  def render(assigns) do
    ~H"""
    <div>
      <.dialog
        id={@id}
        position={:center}
        on_cancel={hide_dialog(@id)}
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

        <.dialog_content id={"#{@id}-content"} class="pb-6">
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
            <.shadow_button type="button" variant="secondary" phx-click={hide_dialog(@id)}>
              Cancel
            </.shadow_button>

            <.shadow_button
              type="button"
              variant="primary"
              phx-click="create_ai_cover_letter"
              phx-target={@myself}
            >
              Generate Cover Letter
            </.shadow_button>
          </div>
        </.dialog_footer>
      </.dialog>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("create_ai_cover_letter", _params, socket) do
    application = socket.assigns.application

    {:noreply,
     socket
     |> hide_dialog()
     |> ApplicationActions.handle_ai_cover_letter_create(application)}
  end
end
