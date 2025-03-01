defmodule AccomplishWeb.Components.JobApplications.StageDialog do
  @moduledoc false

  use Phoenix.Component

  import AccomplishWeb.CoreComponents
  import AccomplishWeb.ShadowrunComponents
  import AccomplishWeb.Shadowrun.Dialog
  import AccomplishWeb.JobApplicationHelpers

  def stage_dialog(assigns) do
    ~H"""
    <.dialog
      id="new-stage-modal"
      position={:upper_third}
      on_cancel={hide_modal("new-stage-modal")}
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
      >
        <input type="hidden" name="stage[application_id]" value={@form[:application_id].value} />

        <.dialog_content id="new-stage-content">
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
              phx-click="reset_stage_form"
              phx-value-id="new-stage-modal"
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
    """
  end
end
