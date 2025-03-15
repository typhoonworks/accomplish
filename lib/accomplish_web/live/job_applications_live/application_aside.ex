defmodule AccomplishWeb.JobApplicationsLive.ApplicationAside do
  use AccomplishWeb, :live_view

  alias Accomplish.Activities
  alias Accomplish.CoverLetters
  alias Accomplish.JobApplications

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Tooltip

  import AccomplishWeb.JobApplicationHelpers

  import AccomplishWeb.Components.Activity

  def render(assigns) do
    ~H"""
    <.page_drawer drawer_open={true}>
      <:drawer_content>
        <div class="px-4 sm:px-6 py-6">
          <h3 class="text-sm/6 font-semibold text-zinc-400">Details</h3>

          <div class="mt-2 grid grid-cols-[max-content_1fr] gap-x-6 gap-y-2 text-sm items-center">
            <div class="text-zinc-400 text-xs flex self-end py-1">Status</div>

            <div class="flex items-center gap-2 h-8">
              <.tooltip>
                <.shadow_select_input
                  id={"status_select_#{@form.id}_drawer"}
                  field={@form[:status]}
                  prompt="Change application status"
                  value={@form[:status].value}
                  options={options_for_application_status()}
                  on_select="save_field"
                  variant="transparent"
                />
                <.tooltip_content side="bottom">
                  <p>Change application status</p>
                </.tooltip_content>
              </.tooltip>
            </div>

            <div class="text-zinc-400 text-xs flex self-end py-1">Applied date</div>
            <div class="flex items-center gap-2 h-8">
              <.tooltip>
                <.shadow_date_picker
                  label="Applied date"
                  id={"date_picker_#{@form.id}_drawer"}
                  form={@form}
                  start_date_field={@form[:applied_at]}
                  required={true}
                  variant="transparent"
                  position="left"
                />

                <.tooltip_content side="bottom">
                  <p>Applied date</p>
                </.tooltip_content>
              </.tooltip>
            </div>
          </div>
        </div>

        <.separator />

        <div class="px-4 sm:px-6 py-6">
          <h3 class="mb-6 text-sm/6 font-semibold text-zinc-400">Activity</h3>

          <.activity_feed activities={@streams.activities} />
        </div>
      </:drawer_content>
    </.page_drawer>
    """
  end

  defp activity_feed(assigns) do
    ~H"""
    <div class="flow-root">
      <ul id="activitvies" role="list" class="-mb-8" phx-update="stream">
        <.activity :for={{dom_id, activity} <- @activities} id={dom_id} activity={activity} />
      </ul>
    </div>
    """
  end

  on_mount {AccomplishWeb.Plugs.UserAuth, :mount_current_user}

  def mount(_params, session, socket) do
    application = session["application"]

    socket =
      socket
      |> assign(application: application)
      |> assign_form(application)
      |> stream_activities(application)
      |> subscribe_to_user_events()

    {:ok, socket}
  end

  def handle_event("save_field", %{"field" => field, "value" => value}, socket) do
    application = socket.assigns.application
    changes = %{field => value}

    case JobApplications.update_application(application, changes) do
      {:ok, updated_application} ->
        new_form = JobApplications.change_application_form(updated_application)
        {:noreply, assign(socket, form: to_form(new_form))}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_info(%{id: _id, date: date, form: form, field: field}, socket) do
    params = Map.put(form.params || %{}, to_string(field), date)

    updated_changeset =
      JobApplications.change_application_form(
        socket.assigns.application,
        Map.merge(socket.assigns.form.params || %{}, params)
      )

    {:noreply, assign(socket, form: to_form(updated_changeset))}
  end

  def handle_info({CoverLetters, _event}, socket) do
    {:noreply, socket}
  end

  def handle_info({Activities, event}, socket) do
    process_pubsub_activity(event, socket)
  end

  def handle_info({JobApplications, event}, socket) do
    process_pubsub_event(event, socket)
  end

  defp process_pubsub_activity(%{name: "activity.logged"} = event, socket) do
    activity = %{event.activity | entity: event.entity, context: event.context}
    {:noreply, stream_insert(socket, :activities, activity, at: 0)}
  end

  defp process_pubsub_activity(_, socket), do: {:noreply, socket}

  defp process_pubsub_event(%{name: "job_application.updated"} = event, socket) do
    {:noreply, assign(socket, application: event.application)}
  end

  defp process_pubsub_event(_, socket), do: {:noreply, socket}

  defp assign_form(socket, application) do
    form = JobApplications.change_application_form(application)
    assign(socket, form: to_form(form))
  end

  defp stream_activities(socket, application) do
    if connected?(socket), do: subscribe_to_activities(application)
    activities = Activities.list_activities_for_entity_or_context(application)
    stream(socket, :activities, activities)
  end

  defp subscribe_to_activities(application) do
    Activities.subscribe({:entity, application})
    Activities.subscribe({:context, application})
  end

  def subscribe_to_user_events(socket) do
    user = socket.assigns.current_user

    if connected?(socket), do: Accomplish.Events.subscribe(user.id)

    socket
  end
end
