defmodule AccomplishWeb.EventHandlers.JobApplicationActions do
  @moduledoc """
  Shared event handlers for job job application-related actions.

  This module encapsulates common event handling logic that can be imported
  into any LiveView that needs to perform job application actions.
  """

  use AccomplishWeb, :live_component

  alias Accomplish.JobApplications
  alias Accomplish.CoverLetters
  alias Accomplish.TokenCache

  @endpoint AccomplishWeb.Endpoint
  @router AccomplishWeb.Router

  import Phoenix.VerifiedRoutes

  @doc """
  Handles deletion of a job application.

  Returns an updated socket with appropriate flash message and navigation.
  """
  def handle_application_delete(socket, id) do
    case JobApplications.delete_application(id) do
      {:ok, _} ->
        socket
        |> put_flash(:info, "Job application deleted successfully.")
        |> push_navigate(to: ~p"/job_applications")

      {:error, _} ->
        put_flash(socket, :error, "Could not delete job application.")
    end
  end

  @doc """
  Creates a new cover letter for an application.

  Returns an updated socket with navigation to the new cover letter.
  """
  def handle_cover_letter_create(socket, application) do
    case CoverLetters.create_cover_letter(application) do
      {:ok, cover_letter} ->
        socket
        |> push_navigate(
          to: ~p"/job_application/#{application.slug}/cover_letter/#{cover_letter.id}"
        )

      {:error, _} ->
        put_flash(socket, :error, "Could not create cover letter.")
    end
  end

  @doc """
  Creates a new AI-generated cover letter and navigates to it with the AI generation flag.
  """
  def handle_ai_cover_letter_create(socket, application, user) do
    case CoverLetters.create_cover_letter(application, %{title: "AI-generated Cover Letter"}) do
      {:ok, cover_letter} ->
        token = TokenCache.generate_token(%{user_id: user.id, cover_letter_id: cover_letter.id})

        socket
        |> push_navigate(
          to:
            ~p"/job_application/#{application.slug}/cover_letter/#{cover_letter.id}?token=#{token}"
        )

      {:error, _} ->
        put_flash(socket, :error, "Could not create AI cover letter.")
    end
  end

  @doc """
  Updates a job application status.

  Returns an updated socket with the result of the update operation.
  """
  def handle_application_status_update(socket, id, status) do
    user = socket.assigns.current_user

    with %JobApplications.Application{} = application <-
           JobApplications.get_application!(user, id),
         {:ok, _updated_application} <-
           JobApplications.update_application(application, %{status: status}) do
      socket
    else
      nil ->
        put_flash(socket, :error, "Application not found.")

      {:error, _changeset} ->
        put_flash(socket, :error, "Failed to update application.")
    end
  end

  @doc """
  Sets the current stage for an application.

  Returns an updated socket with the result of the operation.
  """
  def handle_set_current_stage(socket, application_id, stage_id) do
    user = socket.assigns.current_user
    application = JobApplications.get_application!(user, application_id)

    case JobApplications.set_current_stage(application, stage_id) do
      {:ok, _updated_application} ->
        socket

      {:error, :stage_not_found} ->
        put_flash(socket, :error, "Stage not found")

      {:error, _changeset} ->
        put_flash(socket, :error, "Could not update stage")
    end
  end
end
