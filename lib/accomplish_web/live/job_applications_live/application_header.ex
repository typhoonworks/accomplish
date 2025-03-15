defmodule AccomplishWeb.JobApplicationsLive.ApplicationHeader do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications

  alias AccomplishWeb.Components.JobApplicationDialogs.CoverLetterDialog
  alias AccomplishWeb.Components.JobApplicationDialogs.StageDialog

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.StringHelpers
  import AccomplishWeb.Components.JobApplicationMenu
  import AccomplishWeb.EventHandlers.JobApplicationActions
  import AccomplishWeb.EventHandlers.JobApplicationStageActions
  alias AccomplishWeb.NotificationsLive

  def render(assigns) do
    ~H"""
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
          <.dropdown_menu_trigger id={"app-trigger-#{@application.id}"} class="group">
            <.shadow_button type="button" variant="transparent">
              <.lucide_icon name="ellipsis" class="size-5 text-zinc-400" />
            </.shadow_button>
          </.dropdown_menu_trigger>
          <.dropdown_menu_content>
            <.application_menu
              application={@application}
              position="dropdown"
              id={"header-menu-#{@application.id}"}
            />
          </.dropdown_menu_content>
        </.dropdown_menu>
        <.saving_indicator is_saving={false} />
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
      <:actions>
        {live_render(@socket, NotificationsLive,
          id: "user-notifications",
          sticky: true
        )}
      </:actions>
    </.page_header>

    <.live_component
      module={CoverLetterDialog}
      id="cover-letter-dialog"
      application={@application}
      current_user={@current_user}
    />
    <.live_component
      module={StageDialog}
      id="stage-dialog"
      form={@stage_form}
      current_user={@current_user}
    />
    """
  end

  on_mount {AccomplishWeb.Plugs.UserAuth, :mount_current_user}

  def mount(_params, session, socket) do
    application = session["application"]
    view = session["view"]
    changeset = JobApplications.change_stage_form()

    socket =
      socket
      |> assign(application: application)
      |> assign(:view, view)
      |> assign(:stage_form, to_form(changeset))
      |> assign(show_cover_letter_dialog: false)
      |> subscribe_to_user_events()

    {:ok, socket}
  end

  def handle_event("new_cover_letter", _params, socket) do
    {:noreply, handle_cover_letter_create(socket, socket.assigns.application)}
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

  def handle_event(
        "set_current_stage",
        %{"application_id" => application_id, "stage_id" => stage_id},
        socket
      ) do
    {:noreply, handle_set_current_stage(socket, application_id, stage_id)}
  end

  def handle_event(
        "prepare_predefined_stage",
        %{"application_id" => application_id, "title" => title, "type" => type},
        socket
      ) do
    {:noreply, handle_prepare_predefined_stage(socket, application_id, title, type)}
  end

  def handle_event("prepare_new_stage", %{"application_id" => application_id}, socket) do
    {:noreply, handle_prepare_new_stage(socket, application_id)}
  end

  def handle_event("update_application_status", %{"id" => id, "status" => status}, socket) do
    {:noreply, handle_application_status_update(socket, id, status)}
  end

  def handle_event("delete_application", %{"id" => id}, socket) do
    {:noreply, handle_application_delete(socket, id)}
  end

  def handle_info({JobApplications, event}, socket) do
    process_pubsub_event(event, socket)
  end

  def handle_info(%{event: "stage-created", payload: %{success: true}}, socket) do
    {:noreply, put_flash(socket, :info, "Stage added successfully.")}
  end

  defp process_pubsub_event(%{name: "job_application.updated"}, socket) do
    {:noreply, assign_application(socket)}
  end

  defp process_pubsub_event(%{name: "job_application.status_updated"}, socket) do
    {:noreply, assign_application(socket)}
  end

  defp process_pubsub_event(%{name: "job_application.changed_current_stage"}, socket) do
    {:noreply, assign_application(socket)}
  end

  defp process_pubsub_event(%{name: "job_application.stage_added"}, socket) do
    {:noreply, assign_application(socket)}
  end

  def assign_application(socket) do
    applicant = socket.assigns.current_user
    application = socket.assigns.application
    application = JobApplications.get_application!(applicant, application.id, [:stages])
    assign(socket, application: application)
  end

  def subscribe_to_user_events(socket) do
    user = socket.assigns.current_user

    if connected?(socket), do: Accomplish.Events.subscribe(user.id)

    socket
  end
end
