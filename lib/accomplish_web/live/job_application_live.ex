defmodule AccomplishWeb.JobApplicationLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.JobApplications.Stage
  alias Accomplish.Activities

  import AccomplishWeb.Layout
  import AccomplishWeb.JobApplicationHelpers
  import AccomplishWeb.Shadowrun.Tooltip
  import AccomplishWeb.Components.Activity
  import AccomplishWeb.Shadowrun.StackedList

  import AccomplishWeb.Components.JobApplications.StageList
  import AccomplishWeb.Components.JobApplications.StageDialog

  @pubsub Accomplish.PubSub
  @activities_topic "activities"
  @notifications_topic "notifications:events"

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_drawer?={true} drawer_open={true}>
          <:title>
            <div class="flex lg:items-center lg:gap-1">
              <.link href={~p"/job_applications/"} class="hidden lg:inline">Job Applications</.link>
              <span class="hidden lg:inline-flex items-center text-zinc-400">
                <.icon name="hero-chevron-right" class="size-3" />
              </span>
              <span class="inline">{@application.role} at {@application.company_name}</span>
            </div>
          </:title>
          <:actions>
            <.nav_button
              icon="file-text"
              text="Overview"
              href={~p"/job_application/#{@application.slug}/overview"}
              active={@live_action == :overview}
            />
            <.nav_button
              icon="layers"
              text="Stages"
              href={~p"/job_application/#{@application.slug}/stages"}
              active={@live_action == :stages}
            />
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
      </:page_drawer>

      <div class="mt-8 w-full">
        <div class="-mx-4 -my-2 sm:-mx-6 lg:-mx-8">
          <%= case @live_action do %>
            <% :overview -> %>
              {render_overview(assigns)}
            <% :stages -> %>
              {render_stages(assigns)}
          <% end %>
        </div>
      </div>
    </.layout>

    <.stage_dialog :if={@live_action == :stages} form={@stage_form} socket={@socket} />
    """
  end

  defp render_overview(assigns) do
    ~H"""
    <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
      <div class="space-y-4">
        <.shadow_input
          field={@form[:role]}
          placeholder="Job role"
          class="text-[25px] tracking-tighter hover:cursor-text"
          phx-blur="save_field"
          phx-value-field={@form[:role].field}
        />

        <p class="text-zinc-300">{@application.company_name}</p>
      </div>

      <div class="flex justify-start gap-2 my-2">
        <.tooltip>
          <.shadow_select_input
            id={"status_select_#{@form.id}_overview"}
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

        <.tooltip>
          <.shadow_date_picker
            label="Applied date"
            id={"date_picker_#{@form.id}_overview"}
            form={@form}
            start_date_field={@form[:applied_at]}
            required={true}
            variant="transparent"
          />

          <.tooltip_content side="bottom">
            <p>Applied date</p>
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

  defp render_stages(assigns) do
    ~H"""
    <section class="max-w-full mx-auto px-6 lg:px-8 mt-8">
      <div class="-mx-4 -my-2 sm:-mx-6 lg:-mx-8">
        <div
          id="stages"
          class="inline-block min-w-full py-2 align-middle"
          phx-hook="AudioMp3"
          data-sounds={@sounds}
        >
          <.stacked_list>
            <%= for status <- @statuses do %>
              <.stage_group
                status={status}
                application={@application}
                stages={@streams[stream_key(status)]}
              />
            <% end %>
          </.stacked_list>
          <%= if @stages_count == 0 do %>
            <div class="mt-36 flex flex-col items-start justify-center gap-4 px-6 py-10 bg-zinc-900 max-w-sm mx-auto text-left">
              <div class="flex items-center justify-center">
                <.icon
                  name="hero-square-3-stack-3d-solid"
                  class="size-12 text-zinc-300/50 icon-reflection"
                />
              </div>

              <div class="space-y-4">
                <h2 class="text-md font-light text-zinc-100">Job Application Stages</h2>
                <p class="text-sm font-light  text-zinc-400 leading-relaxed">
                  Add stages to track your progress through interviews, assessments, and negotiations. Stay organized and move forward with confidence.
                </p>
                <.shadow_button
                  phx-click="prepare_new_stage"
                  phx-value-status="pending"
                  phx-value-modal_id="new-stage-modal"
                >
                  Add a new stage
                </.shadow_button>
              </div>
            </div>
          <% end %>
        </div>
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

  def mount(%{"slug" => slug}, _session, %{assigns: %{live_action: :overview}} = socket) do
    with {:ok, socket, application} <- fetch_application(socket, slug, []) do
      socket =
        socket
        |> assign(application: application)
        |> assign_form(application)
        |> stream_activities(application)
        |> subscribe_to_notifications_topic()

      {:ok, socket}
    end
  end

  def mount(%{"slug" => slug}, _session, %{assigns: %{live_action: :stages}} = socket) do
    preloads = ~w(current_stage stages)a

    with {:ok, socket, application} <- fetch_application(socket, slug, preloads) do
      socket =
        socket
        |> assign(application: application)
        |> assign(stages_count: application.stages_count)
        |> assign_form(application)
        |> assign_new_stage_form(%{application_id: application.id})
        |> assign_statuses()
        |> assign_sounds()
        |> assign_play_sounds(true)
        |> stream_stages(application.stages)
        |> stream_activities(application)
        |> subscribe_to_notifications_topic()

      {:ok, socket}
    end
  end

  def handle_event(
        "prepare_new_stage",
        %{"status" => status},
        socket
      ) do
    application = socket.assigns.application

    {:noreply,
     socket
     |> assign_new_stage_form(%{application_id: application.id, status: status, type: :screening})
     |> push_event("js-exec", %{
       to: "#new-stage-modal",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("update_stage_form_type", %{"value" => value}, socket) do
    form = socket.assigns.stage_form

    changeset =
      Ecto.Changeset.put_change(form.source, :type, value)

    {:noreply, assign(socket, :stage_form, to_form(changeset))}
  end

  def handle_event("update_stage_form_status", %{"value" => value}, socket) do
    form = socket.assigns.stage_form

    changeset =
      Ecto.Changeset.put_change(form.source, :status, value)

    {:noreply, assign(socket, :stage_form, to_form(changeset))}
  end

  def handle_event("validate_stage", %{"stage" => stage_params}, socket) do
    changeset = JobApplications.change_stage_form(stage_params)

    {:noreply, assign(socket, :stage_form, to_form(changeset))}
  end

  def handle_event("save_application", %{"application" => application_params}, socket) do
    case JobApplications.create_application(socket.assigns.current_user, application_params) do
      {:ok, _application} ->
        changeset = JobApplications.change_application_form(%{})

        socket =
          socket
          |> put_flash(:info, "Job application created successfully.")
          |> assign(:form, to_form(changeset))
          |> close_modal("new-job-application")

        {:noreply, socket}

      {:error, changeset} ->
        changeset = %{changeset | action: :insert}
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("save_stage", %{"stage" => stage_params}, socket) do
    application = socket.assigns.application

    case Accomplish.JobApplications.add_stage(application, stage_params) do
      {:ok, _stage, _application} ->
        changeset = JobApplications.change_stage_form(%{})

        socket =
          socket
          |> assign(stage_form: to_form(changeset))
          |> close_modal("new-stage-modal")

        {:noreply, socket}

      {:error, changeset} ->
        changeset = %{changeset | action: :insert}
        {:noreply, assign(socket, stage_form: to_form(changeset))}
    end
  end

  def handle_event("reset_stage_form", %{"id" => modal_id}, socket) do
    changeset = JobApplications.change_stage_form(%{})

    socket =
      socket
      |> assign(:stage_form, to_form(changeset))
      |> close_modal(modal_id)

    {:noreply, socket}
  end

  def handle_event("update_stage_status", %{"id" => stage_id, "status" => status}, socket) do
    application = socket.assigns.application

    with %Stage{} = stage <- JobApplications.get_stage!(application, stage_id),
         {:ok, _updated_stage} <-
           JobApplications.update_stage(stage, application, %{status: status}) do
      {:noreply, socket}
    else
      nil ->
        {:noreply, put_flash(socket, :error, "Stage not found.")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to update stage.")}
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

  def handle_event(
        "set_current_stage",
        %{"application-id" => application_id, "stage-id" => stage_id},
        socket
      ) do
    user = socket.assigns.current_user
    application = JobApplications.get_application!(user, application_id)

    case JobApplications.set_current_stage(application, stage_id) do
      {:ok, _} ->
        {:noreply, assign(socket, :application, application)}

      {:error, :stage_not_found} ->
        {:noreply, put_flash(socket, :error, "Stage not found")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not update stage")}
    end
  end

  def handle_event("delete_stage", %{"id" => stage_id}, socket) do
    with application <- socket.assigns.application,
         stage <- JobApplications.get_stage!(application, stage_id),
         :ok <- JobApplications.delete_stage(stage, application) do
      {:noreply, socket |> maybe_play_sound("swoosh")}
    else
      _ -> {:noreply, put_flash(socket, :error, "Failed to delete job application stage.")}
    end
  end

  def handle_info(%{id: _id, date: date, form: form, field: field}, socket) do
    params = Map.put(form.params || %{}, to_string(field), date)

    case form.name do
      "application" ->
        updated_changeset = Accomplish.JobApplications.change_application_form(params)
        {:noreply, assign(socket, form: to_form(updated_changeset))}

      "stage" ->
        updated_changeset = Accomplish.JobApplications.change_stage_form(params)
        {:noreply, assign(socket, stage_form: to_form(updated_changeset))}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info({JobApplications, event}, socket) do
    handle_notification(event, socket)
  end

  def handle_info({Activities, event}, socket) do
    handle_activity(event, socket)
  end

  defp handle_activity(%{name: "activity.logged"} = event, socket) do
    activity = %{event.activity | entity: event.entity, context: event.context}
    {:noreply, stream_insert(socket, :activities, activity, at: 0)}
  end

  defp handle_activity(_, socket), do: {:noreply, socket}

  defp handle_notification(%{name: "job_application.stage_added"} = event, socket) do
    stage = event.stage
    key = stream_key(stage.status)

    socket =
      socket
      |> assign(:stages_count, event.application.stages_count)
      |> maybe_stream_insert(key, stage)

    {:noreply, socket}
  end

  defp handle_notification(%{name: "job_application.stage_updated"} = event, socket) do
    {:noreply, replace_stage(socket, event.stage, event.diff)}
  end

  defp handle_notification(%{name: "job_application.stage_deleted"} = event, socket) do
    stage = event.stage
    key = stream_key(stage.status)

    socket =
      socket
      |> assign(:stages_count, socket.assigns.stages_count - 1)
      |> maybe_stream_delete(key, stage)

    {:noreply, socket}
  end

  defp handle_notification(_, socket), do: {:noreply, socket}

  defp fetch_application(socket, slug, preloads) do
    applicant = socket.assigns.current_user

    case JobApplications.get_application_by_slug(applicant, slug, preloads) do
      {:ok, application} ->
        {:ok, socket, application}

      :error ->
        {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  defp assign_form(socket, application) do
    form = JobApplications.change_application_form(Map.from_struct(application))
    assign(socket, form: to_form(form))
  end

  defp assign_new_stage_form(socket, attrs) do
    changeset = JobApplications.change_stage_form(attrs)
    assign(socket, :stage_form, to_form(changeset))
  end

  defp assign_statuses(socket) do
    statuses = ~w(completed in_progress scheduled pending skipped)a
    assign(socket, statuses: statuses)
  end

  defp assign_sounds(socket) do
    json =
      JSON.encode!(%{
        swoosh: ~p"/audio/swoosh.mp3"
      })

    assign(socket, :sounds, json)
  end

  defp assign_play_sounds(socket, play_sounds) do
    assign(socket, play_sounds: play_sounds)
  end

  defp maybe_play_sound(socket, sound) do
    %{play_sounds: play_sounds} = socket.assigns

    case play_sounds do
      true -> push_event(socket, "play-sound", %{name: sound})
      _ -> socket
    end
  end

  defp stream_stages(socket, stages) do
    statuses = socket.assigns.statuses
    stages_by_status = Enum.group_by(stages, & &1.status, fn stage -> stage end)

    Enum.reduce(statuses, socket, fn status, socket ->
      stream(socket, stream_key(status), Map.get(stages_by_status, status, []))
    end)
  end

  defp stream_activities(socket, application) do
    if connected?(socket), do: subscribe_to_activities_topic(application.id)
    activities = Activities.list_activities_for_entity_or_context(application)
    stream(socket, :activities, activities)
  end

  defp update_field(socket, field, value) do
    application = socket.assigns.application

    case JobApplications.update_application(application, %{field => value}) do
      {:ok, updated_application} ->
        form = JobApplications.change_application_form(Map.from_struct(updated_application))

        socket =
          socket
          |> assign(application: updated_application)
          |> assign(form: to_form(form))

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp replace_stage(socket, stage, diff) do
    old_status =
      if Map.has_key?(diff, :status) do
        diff[:status][:old]
      else
        stage.status
      end

    old_key = stream_key(old_status)
    new_key = stream_key(stage.status)

    socket
    |> maybe_stream_delete(old_key, stage)
    |> maybe_stream_insert(new_key, stage)
  end

  defp maybe_stream_delete(socket, key, stage) do
    if Map.has_key?(socket.assigns.streams, key) do
      stream_delete(socket, key, stage)
    else
      socket
    end
  end

  defp maybe_stream_insert(socket, key, stage) do
    if socket.assigns.live_action == :stages and stage.status in socket.assigns.statuses do
      stream_insert(socket, key, stage, at: 0)
    else
      socket
    end
  end

  defp subscribe_to_activities_topic(application_id) do
    Phoenix.PubSub.subscribe(@pubsub, @activities_topic <> ":job_application:#{application_id}")

    Phoenix.PubSub.subscribe(
      @pubsub,
      @activities_topic <> ":context:job_application:#{application_id}"
    )
  end

  defp subscribe_to_notifications_topic(socket) do
    user = socket.assigns.current_user

    if connected?(socket),
      do: Phoenix.PubSub.subscribe(@pubsub, @notifications_topic <> ":#{user.id}")

    socket
  end

  defp stream_key(status), do: String.to_atom("stages_#{status}")

  defp close_modal(socket, modal_id) do
    socket
    |> push_event("js-exec", %{
      to: "##{modal_id}",
      attr: "phx-remove"
    })
  end
end
