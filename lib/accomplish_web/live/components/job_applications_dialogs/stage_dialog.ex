defmodule AccomplishWeb.Components.JobApplicationDialogs.StageDialog do
  @moduledoc """
  A reusable LiveComponent for managing job application stage creation dialog.

  This component encapsulates the UI and event handling for the stage creation
  dialog, allowing it to be embedded in any LiveView without duplicating
  markup or event handlers.
  """
  use AccomplishWeb, :live_component

  import AccomplishWeb.CoreComponents
  import AccomplishWeb.ShadowrunComponents
  import AccomplishWeb.Shadowrun.Dialog
  import AccomplishWeb.JobApplicationHelpers

  alias Accomplish.JobApplications

  def render(assigns) do
    ~H"""
    <div>
      <.dialog
        id={@id}
        position={:upper_third}
        on_cancel={hide_dialog(@id)}
        class="w-full max-w-xs sm:max-w-md md:max-w-lg lg:max-w-xl xl:max-w-2xl"
      >
        <.dialog_header>
          <.dialog_title class="text-sm text-zinc-200 font-light">
            <div class="flex items-center gap-2">
              <.icon name="hero-envelope-open" class="size-4" />
              <p>New Job Application Stage</p>
            </div>
          </.dialog_title>
        </.dialog_header>

        <.shadow_form
          for={@form}
          id="stage_form"
          as="stage"
          phx-change="validate_stage"
          phx-submit="save_stage"
          phx-target={@myself}
        >
          <input type="hidden" name="stage[application_id]" value={@form[:application_id].value} />

          <.dialog_content id={"#{@id}-content"}>
            <div class="flex flex-col gap-2">
              <div class="space-y-3 mb-2">
                <.shadow_input
                  field={@form[:title]}
                  placeholder="Stage title (e.g., 'Technical Interview', 'Final Round')"
                  class="text-xl tracking-tighter"
                />
              </div>

              <div class="flex justify-start gap-2 mb-2">
                <.shadow_select_input
                  id="stage-type-select"
                  field={@form[:type]}
                  prompt="Select stage type"
                  value={@form[:type].value}
                  options={options_for_stage_type()}
                  on_select="update_stage_form_type"
                  phx-target={@myself}
                />

                <.shadow_date_picker
                  label="Date"
                  id={"#{@form.id}-date_picker"}
                  form={@form}
                  start_date_field={@form[:date]}
                  max={Date.utc_today() |> Date.add(365)}
                  required={false}
                />

                <.shadow_select_input
                  id="stage-status-select"
                  field={@form[:status]}
                  prompt="Select stage status"
                  value={@form[:status].value}
                  options={options_for_stage_status()}
                  on_select="update_stage_form_status"
                  phx-target={@myself}
                />
              </div>

              <.separator />

              <div class="space-y-3 mt-4">
                <.shadow_input
                  field={@form[:notes]}
                  type="textarea"
                  placeholder="Key details, next steps, or important notes for this stage..."
                  class="text-base tracking-tighter"
                  socket={@socket}
                />
              </div>
            </div>
          </.dialog_content>

          <.dialog_footer>
            <div class="flex justify-end gap-2">
              <.shadow_button
                type="button"
                variant="secondary"
                phx-click="reset_form"
                phx-target={@myself}
              >
                Cancel
              </.shadow_button>
              <.shadow_button type="submit" variant="primary">
                Add Stage
              </.shadow_button>
            </div>
          </.dialog_footer>
        </.shadow_form>
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

  def handle_event("validate_stage", %{"stage" => stage_params}, socket) do
    changeset =
      JobApplications.change_stage_form(stage_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: Phoenix.Component.to_form(changeset))}
  end

  def handle_event("save_stage", %{"stage" => stage_params}, socket) do
    user = socket.assigns.current_user
    application = JobApplications.get_application!(user, stage_params["application_id"])

    case JobApplications.add_stage(application, stage_params) do
      {:ok, _stage, _application} ->
        changeset = JobApplications.change_stage_form(%{})

        {:noreply,
         socket
         |> assign(form: Phoenix.Component.to_form(changeset))
         |> put_flash(:info, "Stage added successfully.")
         |> push_event("js-exec", %{
           to: "#stage-dialog",
           attr: "phx-remove"
         })
         |> close_modal("stage-dialog")
         |> push_event("stage-created", %{success: true})}

      {:error, changeset} ->
        {:noreply, assign(socket, form: Phoenix.Component.to_form(changeset))}
    end
  end

  def handle_event("update_stage_form_type", %{"value" => value}, socket) do
    form = socket.assigns.form
    changeset = Ecto.Changeset.put_change(form.source, :type, value)

    {:noreply, assign(socket, form: Phoenix.Component.to_form(changeset))}
  end

  def handle_event("update_stage_form_status", %{"value" => value}, socket) do
    form = socket.assigns.form
    changeset = Ecto.Changeset.put_change(form.source, :status, value)

    {:noreply, assign(socket, form: Phoenix.Component.to_form(changeset))}
  end

  def handle_event("reset_form", _params, socket) do
    changeset = JobApplications.change_stage_form(%{})

    {:noreply,
     socket
     |> assign(form: Phoenix.Component.to_form(changeset))
     |> close_modal("stage-dialog")}
  end

  defp close_modal(socket, modal_id) do
    socket
    |> push_event("js-exec", %{
      to: "##{modal_id}",
      attr: "phx-remove"
    })
  end
end
