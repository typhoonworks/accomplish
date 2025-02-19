defmodule AccomplishWeb.JobApplicationsLive do
  use AccomplishWeb, :live_view
  use LiveSvelte.Components

  alias Accomplish.JobApplications

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadownrun.Dialog
  import AccomplishWeb.Shadownrun.StackedList

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
                    phx-click="prepare_new_application"
                    phx-value-status={status}
                    phx-value-modal_id="new-job-application"
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
      position={:upper_third}
      on_cancel={hide_modal("new-job-application")}
      class="w-full max-w-xs sm:max-w-md md:max-w-lg lg:max-w-xl xl:max-w-2xl"
    >
      <.dialog_header>
        <.dialog_title class="text-sm text-zinc-200 font-light">
          <div class="flex items-center gap-2">
            <.icon name="hero-envelope" class="size-4" />
            <p>New Job Application</p>
          </div>
        </.dialog_title>
      </.dialog_header>
      <.shadow_form
        for={@form}
        id="application_form"
        as="application"
        phx-change="validate_application"
        phx-submit="save_application"
      >
        <.dialog_content id="new-job-application-content">
          <div class="flex flex-col gap-2">
            <div class="space-y-3 mb-2">
              <.shadow_input
                field={@form[:role]}
                placeholder="Job role"
                class="text-xl tracking-tighter"
              />
              <.shadow_input
                field={@form[:company_name]}
                placeholder="Company name"
                class="text-base tracking-tighter"
              />
            </div>

            <div class="flex justify-start gap-2 mb-2">
              <.shadow_select_input
                id="application-status-select"
                field={@form[:status]}
                prompt="Change application status"
                value={@form[:status].value}
                options={options_for_application_status()}
                on_select="update_application_status"
              />
            </div>

            <.separator />

            <div class="space-y-3 mt-4">
              <.shadow_input
                field={@form[:notes]}
                type="textarea"
                placeholder="Write down key details, next moves, or important notes..."
                class="text-base tracking-tighter"
              />
            </div>
          </div>
        </.dialog_content>

        <.dialog_footer>
          <div class="flex justify-end gap-2">
            <.shadow_button
              type="button"
              variant="secondary"
              phx-click="reset_application_form"
              phx-value-id="new-job-application"
            >
              Cancel
            </.shadow_button>
            <.shadow_button type="submit" variant="primary">Create application</.shadow_button>
          </div>
        </.dialog_footer>
      </.shadow_form>
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

    socket =
      socket
      |> assign(:page_title, "Job Applications")
      |> assign(:active_filter, active_filter)
      |> assign(:applications_by_status, applications_by_status)
      |> assign_new_form()

    {:ok, socket}
  end

  def handle_event(
        "prepare_new_application",
        %{"status" => status, "modal_id" => modal_id},
        socket
      ) do
    {:noreply,
     socket
     |> assign_new_form()
     |> assign_application_form_status(status)
     |> push_event("js-exec", %{
       to: "##{modal_id}",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("update_application_status", %{"value" => value}, socket) do
    {:noreply, socket |> assign_application_form_status(value)}
  end

  def handle_event("validate_application", %{"application_form" => application_params}, socket) do
    changeset = JobApplications.change_application_form(application_params)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save_application", %{"application_form" => application_params}, socket) do
    case JobApplications.create_application(socket.assigns.current_user, application_params) do
      {:ok, _application} ->
        changeset = JobApplications.change_application_form(%{})

        {:noreply,
         socket
         |> put_flash(:info, "Job application created successfully.")
         |> assign(:form, to_form(changeset))
         |> push_event("phx-hide-modal", %{id: "new-job-application"})}

      {:error, changeset} ->
        changeset = %{changeset | action: :insert}
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("reset_application_form", %{"id" => modal_id}, socket) do
    changeset = JobApplications.change_application_form(%{})

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))
     |> push_event("js-exec", %{
       to: "##{modal_id}",
       attr: "phx-remove"
     })}
  end

  defp assign_new_form(socket) do
    changeset = JobApplications.change_application_form(%{})

    assign(socket, :form, to_form(changeset))
  end

  defp assign_application_form_status(socket, status) do
    form = socket.assigns.form

    updated_changeset =
      Ecto.Changeset.put_change(form.source, :status, status)

    assign(socket, :form, to_form(updated_changeset))
  end

  defp format_status(:applied), do: "Applied"
  defp format_status(:interviewing), do: "Interviewing"
  defp format_status(:offer), do: "Offer"
  defp format_status(:rejected), do: "Rejected"

  defp status_color(:applied), do: "bg-green-600"
  defp status_color(:interviewing), do: "bg-yellow-600"
  defp status_color(:offer), do: "bg-blue-500"
  defp status_color(:rejected), do: "bg-red-600"

  defp options_for_application_status do
    [
      %{
        label: "Applied",
        value: "applied",
        icon: "hero-paper-airplane",
        color: "text-green-600",
        shortcut: "1"
      },
      %{
        label: "Interviewing",
        value: "interviewing",
        icon: "hero-envelope-open",
        color: "text-yellow-600",
        shortcut: "2"
      },
      %{
        label: "Offer",
        value: "offer",
        icon: "hero-hand-thumb-up",
        color: "text-blue-600",
        shortcut: "3"
      },
      %{
        label: "Rejected",
        value: "rejected",
        icon: "hero-hand-thumb-down",
        color: "text-red-600",
        shortcut: "4"
      }
    ]
  end
end
