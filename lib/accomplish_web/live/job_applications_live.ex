defmodule AccomplishWeb.JobApplicationsLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.JobApplications.Application

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Dialog
  import AccomplishWeb.Shadowrun.StackedList
  import AccomplishWeb.Components.JobApplicationComponents

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"

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
              active={@filter == "all"}
            />
            <.nav_button
              icon="hero-play"
              text="Active"
              href={~p"/job_applications?filter=active"}
              active={@filter == "active"}
            />
          </:actions>
        </.page_header>
      </:page_header>

      <div class="mt-8 w-full">
        <div class="-mx-4 -my-2 sm:-mx-6 lg:-mx-8">
          <div
            id="applications"
            class="inline-block min-w-full py-2 align-middle"
            phx-hook="AudioMp3"
            data-sounds={@sounds}
          >
            <.stacked_list>
              <%= for status <- @statuses do %>
                <.application_group status={status} applications={@streams[stream_key(status)]} />
              <% end %>
            </.stacked_list>
            <%= if !@has_applications do %>
              <div class="mt-36 flex flex-col items-start justify-center gap-4 px-6 py-10 bg-zinc-900 max-w-sm mx-auto text-left">
                <div class="flex items-center justify-center">
                  <.icon name="hero-envelope-solid" class="size-12 text-zinc-300/50 icon-reflection" />
                </div>

                <div class="space-y-4">
                  <h2 class="text-md font-light text-zinc-100">Job Applications</h2>
                  <p class="text-sm font-light  text-zinc-400 leading-relaxed">
                    Track and manage your job applications. Keep everything organized in one place for easy access and progress tracking.
                  </p>
                  <.shadow_button
                    phx-click="prepare_new_application"
                    phx-value-status="applied"
                    phx-value-modal_id="new-job-application"
                  >
                    Add your first application
                  </.shadow_button>
                </div>
              </div>
            <% end %>
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
                on_select="update_application_form_status"
              />

              <.shadow_date_picker
                label="Applied date"
                id={"#{@form.id}-date_picker"}
                form={@form}
                start_date_field={@form[:applied_at]}
                required={true}
              />
            </div>

            <.separator />

            <div class="space-y-3 mt-4">
              <.shadow_input
                field={@form[:notes]}
                type="textarea"
                placeholder="Write down key details, next moves, or important notes..."
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
              phx-click="reset_application_form"
              phx-value-id="new-job-application"
            >
              Cancel
            </.shadow_button>
            <.shadow_button type="submit" variant="primary" disabled={!@form.source.valid?}>
              Create application
            </.shadow_button>
          </div>
        </.dialog_footer>
      </.shadow_form>
    </.dialog>

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
        for={@stage_form}
        id="stage_form"
        as="stage"
        phx-change="validate_stage"
        phx-submit="save_stage"
      >
        <input type="hidden" name="stage[application_id]" value={@stage_form[:application_id].value} />

        <.dialog_content id="new-stage-content">
          <div class="flex flex-col gap-2">
            <div class="space-y-3 mb-2">
              <.shadow_input
                field={@stage_form[:title]}
                placeholder="Stage title (e.g., 'Technical Interview', 'Final Round')"
                class="text-xl tracking-tighter"
              />
            </div>

            <div class="flex justify-start gap-2 mb-2">
              <.shadow_select_input
                id="stage-type-select"
                field={@stage_form[:type]}
                prompt="Select stage type"
                value={@stage_form[:type].value}
                options={options_for_stage_type()}
                on_select="update_stage_form_type"
              />

              <.shadow_date_picker
                label="Date"
                id={"#{@stage_form.id}-date_picker"}
                form={@stage_form}
                start_date_field={@stage_form[:date]}
                max={Date.utc_today() |> Date.add(365)}
                required={false}
              />
            </div>

            <.separator />

            <div class="space-y-3 mt-4">
              <.shadow_input
                field={@stage_form[:notes]}
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

  def mount(params, _session, socket) do
    if connected?(socket), do: subscribe_to_notifications_topic()

    filter = params["filter"] || "active"
    user = socket.assigns.current_user

    applications =
      JobApplications.list_user_applications(user, filter, [:current_stage])

    statuses = visible_statuses(filter)

    applications_by_status =
      for status <- statuses, into: %{} do
        {status, Enum.filter(applications, &(&1.status == status))}
      end

    socket =
      socket
      |> assign(:page_title, "Job Applications")
      |> assign_sounds()
      |> assign_play_sounds(true)
      |> assign(:filter, filter)
      |> assign_new_form()
      |> assign(:stage_form, to_form(JobApplications.change_stage_form()))
      |> assign(:applications_by_status, applications_by_status)
      |> assign(:statuses, statuses)
      |> assign(:has_applications, applications != [])
      |> stream_applications(applications_by_status)

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

  def handle_event("update_application_form_status", %{"value" => value}, socket) do
    {:noreply, socket |> assign_application_form_status(value)}
  end

  def handle_event("update_application_status", %{"id" => id, "status" => status}, socket) do
    with %Application{} = application <- JobApplications.get_application!(id, :company),
         {:ok, _updated_application} <-
           JobApplications.update_application(application, %{status: status}) do
      {:noreply, socket}
    else
      nil ->
        {:noreply, put_flash(socket, :error, "Application not found.")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to update application.")}
    end
  end

  def handle_event("validate_application", %{"application_form" => application_params}, socket) do
    changeset = JobApplications.change_application_form(application_params)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save_application", %{"application_form" => application_params}, socket) do
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

  def handle_event("reset_application_form", %{"id" => modal_id}, socket) do
    changeset = JobApplications.change_application_form(%{})

    socket =
      socket
      |> assign(:form, to_form(changeset))
      |> close_modal(modal_id)

    {:noreply, socket}
  end

  def handle_event("delete_application", %{"id" => id}, socket) do
    user = socket.assigns.current_user

    case JobApplications.delete_application(id) do
      {:ok, application} ->
        key = stream_key(application.status)
        has_applications = JobApplications.count_user_applications(user) > 0

        socket =
          socket
          |> assign(:has_applications, has_applications)
          |> maybe_stream_delete(key, application)
          |> maybe_play_sound("swoosh")

        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete job application.")}
    end
  end

  def handle_event("prepare_new_stage", %{"application-id" => application_id}, socket) do
    changeset = JobApplications.change_stage_form(%{application_id: application_id})

    {:noreply,
     socket
     |> assign(:stage_form, to_form(changeset))
     |> push_event("js-exec", %{
       to: "#new-stage-modal",
       attr: "phx-show-modal"
     })}
  end

  def handle_event(
        "prepare_predefined_stage",
        %{"application-id" => application_id, "title" => title, "type" => type},
        socket
      ) do
    form_params = %{
      title: title,
      type: type,
      application_id: application_id
    }

    changeset = JobApplications.change_stage_form(form_params)

    {:noreply,
     socket
     |> assign(:stage_form, to_form(changeset))
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

  def handle_event("validate_stage", %{"stage" => stage_params}, socket) do
    changeset = JobApplications.change_stage_form(stage_params)

    {:noreply, assign(socket, :stage_form, to_form(changeset))}
  end

  def handle_event("save_stage", %{"stage" => stage_params}, socket) do
    application = JobApplications.get_application!(stage_params["application_id"])

    case Accomplish.JobApplications.add_stage(application, stage_params) do
      {:ok, _stage} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stage added successfully.")
         |> push_event("js-exec", %{
           to: "#new-stage-modal",
           attr: "phx-remove"
         })
         |> close_modal("new-stage-modal")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to add stage.")}
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

  def handle_info(%{id: _id, date: date, form: form}, socket) do
    params = Map.put(form.params || %{}, "applied_at", date)
    updated_changeset = Accomplish.JobApplications.change_application_form(params)

    {:noreply, assign(socket, form: to_form(updated_changeset))}
  end

  def handle_info({JobApplications, event}, socket) do
    handle_event(event, socket)
  end

  defp handle_event(%{name: "job_application:created"} = event, socket) do
    socket =
      socket
      |> assign(:has_applications, true)
      |> insert_new_application(event.application, event.company)

    {:noreply, socket}
  end

  defp handle_event(%{name: "job_application:updated"} = event, socket) do
    {:noreply, replace_application(socket, event.application, event.company, event.diff)}
  end

  defp handle_event(_, socket), do: {:noreply, socket}

  defp subscribe_to_notifications_topic do
    Phoenix.PubSub.subscribe(@pubsub, @notifications_topic)
  end

  defp insert_new_application(socket, application, company) do
    application = %Application{application | company: company}
    key = stream_key(application.status)
    stream_insert(socket, key, application, at: 0)
  end

  defp replace_application(socket, application, company, diff) do
    application = %Application{application | company: company}

    old_status =
      if Map.has_key?(diff, :status) do
        diff[:status][:old]
      else
        application.status
      end

    old_key = stream_key(old_status)
    new_key = stream_key(application.status)

    socket
    |> maybe_stream_delete(old_key, application)
    |> maybe_stream_insert(new_key, application)
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

  defp stream_applications(socket, applications) do
    Enum.reduce(applications, socket, fn {status, apps}, socket ->
      stream(socket, stream_key(status), apps)
    end)
  end

  defp maybe_stream_delete(socket, key, application) do
    if Map.has_key?(socket.assigns.streams, key) do
      stream_delete(socket, key, application)
    else
      socket
    end
  end

  defp maybe_stream_insert(socket, key, application) do
    if application.status in socket.assigns.statuses do
      stream_insert(socket, key, application, at: 0)
    else
      socket
    end
  end

  defp stream_key(status), do: String.to_atom("applications_#{status}")

  defp close_modal(socket, modal_id) do
    socket
    |> push_event("js-exec", %{
      to: "##{modal_id}",
      attr: "phx-remove"
    })
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
      },
      %{
        label: "Accepted",
        value: "accepted",
        icon: "hero-star",
        color: "text-purple-600",
        shortcut: "5"
      }
    ]
  end

  defp options_for_stage_type do
    [
      %{
        label: "Screening",
        value: "screening",
        icon: "hero-phone",
        color: "text-zinc-400",
        shortcut: "1"
      },
      %{
        label: "Interview",
        value: "interview",
        icon: "hero-user-group",
        color: "text-zinc-400",
        shortcut: "2"
      },
      %{
        label: "Assessment",
        value: "assessment",
        icon: "hero-document-text",
        color: "text-zinc-400",
        shortcut: "3"
      }
    ]
  end

  defp visible_statuses("all") do
    ~w(accepted offer interviewing applied rejected)a
  end

  defp visible_statuses("active") do
    ~w(offer interviewing applied)a
  end
end
