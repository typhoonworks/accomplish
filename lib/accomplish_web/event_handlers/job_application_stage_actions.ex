defmodule AccomplishWeb.EventHandlers.JobApplicationStageActions do
  @moduledoc """
  Shared event handlers for job application stage-related actions.

  This module encapsulates common event handling logic for stage operations
  that can be imported into any LiveView that needs to perform these actions.
  """

  use AccomplishWeb, :live_component

  import Phoenix.Component
  alias Phoenix.LiveView.JS

  alias Accomplish.JobApplications
  alias Accomplish.JobApplications.Stage

  @doc """
  Prepares for creating a new stage for an application.

  Sets up the form and shows the dialog.
  """
  def handle_prepare_new_stage(socket, application_id, dialog_id \\ "stage-dialog") do
    changeset = JobApplications.change_stage_form(%{application_id: application_id})

    socket
    |> push_event("js-exec", %{
      to: "##{dialog_id}",
      attr: "phx-show-modal"
    })
  end

  @doc """
  Prepares a predefined stage form based on a template.

  Returns an updated socket with the form assigned and modal shown.
  """
  def handle_prepare_predefined_stage(
        socket,
        application_id,
        title,
        type,
        dialog_id \\ "stage-dialog"
      ) do
    form_params = %{
      title: title,
      type: type,
      application_id: application_id
    }

    changeset = JobApplications.change_stage_form(form_params)

    socket
    |> assign(:stage_form, to_form(changeset))
    |> push_event("js-exec", %{
      to: "##{dialog_id}",
      attr: "phx-show-modal"
    })
  end

  @doc """
  Handles updating a stage status.

  Returns an updated socket with the result of the update operation.
  """
  def handle_stage_status_update(socket, stage_id, status) do
    application = socket.assigns.application

    with %Stage{} = stage <- JobApplications.get_stage!(application, stage_id),
         {:ok, _updated_stage} <-
           JobApplications.update_stage(stage, application, %{status: status}) do
      socket
    else
      nil ->
        put_flash(socket, :error, "Stage not found.")

      {:error, _changeset} ->
        put_flash(socket, :error, "Failed to update stage.")
    end
  end

  @doc """
  Handles deletion of a stage.

  Returns an updated socket with appropriate flash message.
  """
  def handle_stage_delete(socket, stage_id) do
    application = socket.assigns.application

    with stage <- JobApplications.get_stage!(application, stage_id),
         :ok <- JobApplications.delete_stage(stage, application) do
      socket
    else
      _ -> put_flash(socket, :error, "Failed to delete job application stage.")
    end
  end
end
