defmodule AccomplishWeb.JobApplicationsLive do
  use AccomplishWeb, :live_view
  use LiveSvelte.Components

  alias Accomplish.JobApplications

  import AccomplishWeb.Layout
  import AccomplishWeb.Components.Dialog
  import AccomplishWeb.Components.StackedList

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title="Job Applications">
          <:actions>
            <.nav_button
              icon="hero-rectangle-stack"
              text="All"
              href={~p"/job_applications?filter=all"}
              active={@active_filter == "all"}
            />
            <.nav_button
              icon="hero-play"
              text="Active"
              href={~p"/job_applications?filter=active"}
              active={@active_filter == "active"}
            />
          </:actions>
        </.page_header>
      </:page_header>

      <div class="mt-8 w-full">
        <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle">
            <.stacked_list>
              <%= for {status, applications} <- @applications_by_status do %>
                <.list_header>
                  <div class="flex items-center gap-2">
                    <div class={"h-3 w-3 rounded-full #{status_color(status)}"}></div>
                    <h2 class="text-sm tracking-tight text-zinc-300">
                      {format_status(status)}
                    </h2>
                  </div>
                  <button
                    class="text-zinc-400 hover:text-zinc-200"
                    phx-click={show_modal("new-job-application")}
                    phx-value-status={status}
                  >
                    <.icon class="text-current size-4" name="hero-plus" />
                  </button>
                </.list_header>

                <.list_content>
                  <%= for application <- applications do %>
                    <.list_item clickable={true} href="#">
                      <p class="text-[13px] text-zinc-300 leading-tight">
                        {application.company.name}
                        <span class="text-zinc-400">• {application.role}</span>
                      </p>
                      <p class="text-[13px] text-zinc-400 leading-tight"></p>
                      <p class="text-[13px] text-zinc-400 leading-tight text-right">
                        {formatted_relative_time(application.applied_at)}
                      </p>
                    </.list_item>
                  <% end %>
                </.list_content>
              <% end %>
            </.stacked_list>
          </div>
        </div>
      </div>
    </.layout>

    <.dialog
      id="new-job-application"
      on_cancel={hide_modal("new-job-application")}
      class="w-full max-w-xs sm:max-w-md md:max-w-lg lg:max-w-xl xl:max-w-2xl"
    >
      <.dialog_header>
        <.dialog_title>New Job Application</.dialog_title>
        <.dialog_description>
          Fill in the details to create a new job application.
        </.dialog_description>
      </.dialog_header>

      <.InlineEditor
        id="job-title-editor"
        placeholder="Role"
        classList="text-zinc-300 text-md font-semibold"
        socket={@socket}
        phx-hook="FocusEditorHook"
        phx-value-target="job-title-editor"
      />

      <.dialog_footer>
        <.button phx-disable-with="Saving application..." class="w-full btn-primary">
          Save
        </.button>
      </.dialog_footer>
    </.dialog>
    """
  end

  def mount(params, _session, socket) do
    active_filter = params["filter"] || "active"
    user = socket.assigns.current_user
    applications = JobApplications.list_user_applications(user, active_filter)

    status_priority = %{
      offer: 1,
      interviewing: 2,
      applied: 3,
      rejected: 4
    }

    applications_by_status =
      applications
      |> Enum.group_by(& &1.status)
      |> Enum.sort_by(fn {status, _} -> Map.get(status_priority, status, 999) end)

    changeset = JobApplications.change_application(%{})

    socket =
      assign(socket,
        page_title: "Job Applications",
        active_filter: active_filter,
        applications_by_status: applications_by_status,
        changeset: changeset,
        form: %{}
      )

    {:ok, socket}
  end

  def handle_event("validate_application", %{"application" => application_params}, socket) do
    changeset = JobApplications.change_application(application_params)
    {:noreply, assign(socket, changeset: changeset, form: application_params)}
  end

  def handle_event("save_application", %{"application" => application_params}, socket) do
    case JobApplications.create_application(socket.assigns.current_user, application_params) do
      {:ok, _application} ->
        {:noreply,
         socket
         |> put_flash(:info, "Job application created successfully.")
         |> assign(:changeset, JobApplications.change_application(%{}))
         |> push_event("phx-hide-modal", %{id: "new-job-application"})}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp format_status(:applied), do: "Applied"
  defp format_status(:interviewing), do: "Interviewing"
  defp format_status(:offer), do: "Offer"
  defp format_status(:rejected), do: "Rejected"

  defp status_color(:applied), do: "bg-green-600"
  defp status_color(:interviewing), do: "bg-yellow-600"
  defp status_color(:offer), do: "bg-blue-500"
  defp status_color(:rejected), do: "bg-red-600"
end
