defmodule AccomplishWeb.JobApplicationStageLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.Activities

  import AccomplishWeb.Layout
  import AccomplishWeb.JobApplicationHelpers
  import AccomplishWeb.Shadowrun.Tooltip
  import AccomplishWeb.Components.Activity

  @pubsub Accomplish.PubSub
  @activities_topic "activities"

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_drawer?={true} drawer_open={true}>
          <:title>
            <div class="flex lg:items-center lg:gap-1">
              <.link href={~p"/job_application/#{@application.slug}/stages"} class="hidden lg:inline">
                <span class="inline">{@application.role} at {@application.company.name}</span>
              </.link>
              <span class="hidden lg:inline-flex items-center text-zinc-400">
                <.icon name="hero-chevron-right" class="size-3" />
              </span>
              <span class="inline">{@stage.title}</span>
            </div>
          </:title>
          <:actions>
            <.nav_button icon="files" text="Documents" href="#" active={@live_action == :documents} />
          </:actions>
        </.page_header>
      </:page_header>

      <:page_drawer>
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
                      prompt="Change stage status"
                      value={@form[:status].value}
                      options={options_for_stage_status()}
                      on_select="save_field"
                      variant="transparent"
                    />
                    <.tooltip_content side="bottom">
                      <p>Change stage status</p>
                    </.tooltip_content>
                  </.tooltip>
                </div>

                <div class="text-zinc-400 text-xs flex self-end py-1">Date</div>

                <div class="flex items-center gap-2 h-8">
                  <.tooltip>
                    <.shadow_date_picker
                      label="Date"
                      id={"date_picker_#{@form.id}_drawer"}
                      form={@form}
                      start_date_field={@form[:date]}
                      required={true}
                      variant="transparent"
                      position="left"
                    />

                    <.tooltip_content side="bottom">
                      <p>Date</p>
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
      </:page_drawer>

      <div class="mt-8 w-full">
        <div class="-mx-4 -my-2 sm:-mx-6 lg:-mx-8">
          {render_overview(assigns)}
        </div>
      </div>
    </.layout>
    """
  end

  defp render_overview(assigns) do
    ~H"""
    <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
      <div class="space-y-4">
        <.shadow_input
          field={@form[:title]}
          placeholder="Stage title"
          class="text-[25px] tracking-tighter hover:cursor-text"
          phx-blur="save_field"
          phx-value-field={@form[:title].field}
        />
      </div>

      <div class="flex justify-start gap-2 my-2">
        <.tooltip>
          <.shadow_select_input
            id={"status_select_#{@form.id}_overview"}
            field={@form[:status]}
            prompt="Change stage status"
            value={@form[:status].value}
            options={options_for_stage_status()}
            on_select="save_field"
            variant="transparent"
          />
          <.tooltip_content side="bottom">
            <p>Change stage status</p>
          </.tooltip_content>
        </.tooltip>

        <.tooltip>
          <.shadow_date_picker
            label="Date"
            id={"date_picker_#{@form.id}_overview"}
            form={@form}
            start_date_field={@form[:date]}
            required={true}
            variant="transparent"
          />

          <.tooltip_content side="bottom">
            <p>Date</p>
          </.tooltip_content>
        </.tooltip>
      </div>

      <div class="mt-12 space-y-2">
        <h3 class="text-zinc-400">Notes</h3>
        <.shadow_input
          field={@form[:notes]}
          type="textarea"
          placeholder="Write down key details, next moves, or important notes..."
          class="text-[14px] font-light hover:cursor-text"
          socket={@socket}
          phx-blur="save_field"
          phx-value-field={@form[:notes].field}
        />
      </div>
    </section>
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

  def mount(%{"application_slug" => application_slug, "slug" => slug}, _session, socket) do
    applicant = socket.assigns.current_user

    with {:ok, application} <-
           JobApplications.get_application_by_slug(applicant, application_slug),
         {:ok, stage} <- JobApplications.get_stage_by_slug(application, slug) do
      socket =
        socket
        |> assign(application: application)
        |> assign(stage: stage)
        |> assign_form(stage)
        |> stream_activities(stage)

      {:ok, socket}
    else
      :error -> {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  def handle_event("save_field", %{"field" => field_name, "value" => value}, socket) do
    form = socket.assigns.form

    field_name =
      case String.to_existing_atom(field_name) do
        atom when is_atom(atom) -> atom
        _ -> nil
      end

    case form[field_name] do
      %Phoenix.HTML.FormField{field: actual_field} ->
        update_field(socket, actual_field, value)

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info(%{id: _id, field: field_name, date: date, form: _form}, socket) do
    update_field(socket, field_name, date)
    {:noreply, socket}
  end

  def handle_info({Activities, event}, socket) do
    handle_activity(event, socket)
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp handle_activity(%{name: "activity.logged"} = event, socket) do
    activity = %{event.activity | entity: event.entity, context: event.context}
    {:noreply, stream_insert(socket, :activities, activity, at: 0)}
  end

  defp handle_activity(_, socket), do: {:noreply, socket}

  defp assign_form(socket, stage) do
    form = JobApplications.change_stage_form(Map.from_struct(stage))
    assign(socket, form: to_form(form))
  end

  defp stream_activities(socket, stage) do
    if connected?(socket), do: subscribe_to_activities_topic(stage.id)
    activities = Activities.list_activities_for_entity_or_context(stage)
    stream(socket, :activities, activities)
  end

  defp update_field(socket, field, value) do
    application = socket.assigns.application
    stage = socket.assigns.stage

    case JobApplications.update_stage(stage, application, %{field => value}) do
      {:ok, updated_stage} ->
        socket =
          socket
          |> assign(stage: updated_stage)
          |> assign_form(updated_stage)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp subscribe_to_activities_topic(stage_id) do
    Phoenix.PubSub.subscribe(@pubsub, @activities_topic <> ":job_application_stage:#{stage_id}")
  end
end
