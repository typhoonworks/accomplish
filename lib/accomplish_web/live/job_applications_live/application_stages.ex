defmodule AccomplishWeb.JobApplicationsLive.ApplicationStages do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.JobApplications.Stage

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.StackedList

  import AccomplishWeb.Components.JobApplications.StageList
  import AccomplishWeb.Components.JobApplications.StageDialog

  alias AccomplishWeb.JobApplicationsLive.ApplicationHeader
  alias AccomplishWeb.JobApplicationsLive.ApplicationAside

  def render(assigns) do
    ~H"""
    <.layout flash={@flash} current_user={@current_user} current_path={@current_path}>
      <:page_header>
        {live_render(@socket, ApplicationHeader,
          id: "application-header",
          session: %{"application" => @application, "view" => :stages},
          sticky: true
        )}
      </:page_header>

      <:page_drawer>
        {live_render(@socket, ApplicationAside,
          id: "application-aside",
          session: %{"application" => @application},
          sticky: true
        )}
      </:page_drawer>

      <div class="mt-8 w-full">
        <div class="-mx-4 -my-2 sm:-mx-6 lg:-mx-8">
          {render_stages(assigns)}
        </div>
      </div>
    </.layout>

    <.stage_dialog form={@stage_form} socket={@socket} />
    """
  end

  defp render_stages(assigns) do
    ~H"""
    <section class="max-w-full mx-auto px-6 lg:px-8 mt-8">
      <div>
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

  def mount(%{"slug" => slug}, _session, socket) do
    preloads = ~w(current_stage stages)a

    with {:ok, socket, application} <- fetch_application(socket, slug, preloads) do
      socket =
        socket
        |> assign(page_title: "#{application.role} • Stages")
        |> assign(application: application)
        |> assign(stages_count: application.stages_count)
        |> assign(show_cover_letter_dialog: false)
        |> assign_stage_form(%{application_id: application.id})
        |> assign_statuses()
        |> assign_sounds()
        |> assign_play_sounds(true)
        |> stream_stages(application.stages)
        |> subscribe_to_user_events()

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
     |> assign_stage_form(%{application_id: application.id, status: status, type: :screening})
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

  def handle_event("save_stage", %{"stage" => stage_params}, socket) do
    application = socket.assigns.application

    case JobApplications.add_stage(application, stage_params) do
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

  def handle_event("reset_form", %{"id" => modal_id}, socket) do
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

  def handle_event(
        "set_current_stage",
        %{"application_id" => application_id, "stage_id" => stage_id},
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

    updated_changeset =
      JobApplications.change_stage_form(
        Map.merge(socket.assigns.stage_form.params || %{}, params)
      )

    {:noreply, assign(socket, stage_form: to_form(updated_changeset))}
  end

  def handle_info({JobApplications, event}, socket) do
    process_pubsub_event(event, socket)
  end

  defp process_pubsub_event(%{name: "job_application.updated"} = event, socket) do
    {:noreply, assign(socket, application: event.application)}
  end

  defp process_pubsub_event(%{name: "job_application.stage_added"} = event, socket) do
    stage = event.stage
    key = stream_key(stage.status)

    socket =
      socket
      |> assign(:stages_count, event.application.stages_count)
      |> maybe_stream_insert(key, stage)

    {:noreply, socket}
  end

  defp process_pubsub_event(%{name: "job_application.stage_updated"} = event, socket) do
    {:noreply, replace_stage(socket, event.stage, event.diff)}
  end

  defp process_pubsub_event(%{name: "job_application.stage_deleted"} = event, socket) do
    stage = event.stage
    key = stream_key(stage.status)

    socket =
      socket
      |> assign(:stages_count, socket.assigns.stages_count - 1)
      |> maybe_stream_delete(key, stage)

    {:noreply, socket}
  end

  defp process_pubsub_event(_, socket), do: {:noreply, socket}

  defp fetch_application(socket, slug, preloads) do
    applicant = socket.assigns.current_user

    case JobApplications.get_application_by_slug(applicant, slug, preloads) do
      {:ok, application} ->
        {:ok, socket, application}

      :error ->
        {:ok, push_navigate(socket, to: ~p"/job_applications")}
    end
  end

  defp assign_stage_form(socket, attrs) do
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
    if stage.status in socket.assigns.statuses do
      stream_insert(socket, key, stage, at: -1)
    else
      socket
    end
  end

  defp stream_key(status), do: String.to_atom("stages_#{status}")

  defp close_modal(socket, modal_id) do
    socket
    |> push_event("js-exec", %{
      to: "##{modal_id}",
      attr: "phx-remove"
    })
  end

  def subscribe_to_user_events(socket) do
    user = socket.assigns.current_user

    if connected?(socket), do: Accomplish.Events.subscribe(user.id)

    socket
  end
end
