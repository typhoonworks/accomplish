defmodule AccomplishWeb.JobApplicationsLive do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications
  alias Accomplish.JobApplications.Application
  alias Accomplish.URLValidators

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Dialog
  import AccomplishWeb.Shadowrun.StackedList

  import AccomplishWeb.Components.JobApplications.List
  import AccomplishWeb.Components.JobApplications.StageDialog

  import AccomplishWeb.JobApplicationHelpers

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title="Job Applications">
          <:actions>
            <.nav_button
              icon="archive"
              text="All"
              href={~p"/job_applications?filter=all"}
              active={@filter == "all"}
            />
            <.nav_button
              icon="mail-check"
              text="Active"
              href={~p"/job_applications?filter=active"}
              active={@filter == "active"}
            />
            <.nav_button
              icon="square-pen"
              text="Draft"
              href={~p"/job_applications?filter=draft"}
              active={@filter == "draft"}
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
                    Add a new application
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
        id="application"
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
              <.inputs_for :let={company_f} field={@form[:company]}>
                <.shadow_input
                  field={company_f[:name]}
                  placeholder="Company name"
                  class="text-base tracking-tighter"
                />
              </.inputs_for>
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

              <.shadow_select_input
                id="application-location-select"
                field={@form[:location]}
                prompt="Change job location type"
                value={@form[:location].value}
                options={options_for_application_location()}
                on_select="update_application_form_location"
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
            <.shadow_button type="button" variant="secondary" phx-click="open_import_dialog">
              Import from URL
            </.shadow_button>
            <.shadow_button type="submit" variant="primary" disabled={!@form.source.valid?}>
              Create application
            </.shadow_button>
          </div>
        </.dialog_footer>
      </.shadow_form>
    </.dialog>

    <.dialog
      id="import-job-url-dialog"
      position={:center}
      on_cancel={hide_modal("import-job-url-dialog")}
      class="w-full max-w-md"
    >
      <.dialog_header>
        <.dialog_title class="text-sm text-zinc-200 font-light">
          <div class="flex items-center gap-2">
            <.icon name="hero-link" class="size-4" />
            <p>Import Job from URL</p>
          </div>
        </.dialog_title>
        <.dialog_description>
          Paste a job listing URL to import the details automatically
        </.dialog_description>
      </.dialog_header>

      <.form
        for={@job_posting_form}
        id="job-posting-form"
        phx-submit="import_from_url"
        phx-change="validate_job_url"
        class="space-y-4"
      >
        <.dialog_content id="import-url-content">
          <div class="flex flex-col gap-4 py-2">
            <.shadow_input
              id="job-posting-url-input"
              type="url"
              class="text-zinc-300 text-xs"
              field={@job_posting_form[:url]}
              placeholder="https://example.com/jobs/12345"
              required={true}
            />
          </div>
        </.dialog_content>

        <.dialog_footer>
          <div class="flex justify-end gap-2">
            <.shadow_button
              type="button"
              variant="secondary"
              phx-click={hide_dialog("import-job-url-dialog")}
            >
              Cancel
            </.shadow_button>
            <.shadow_button
              type="submit"
              variant="primary"
              phx-disable-with="Importing..."
              disabled={!@job_posting_form.source.valid?}
            >
              Import
            </.shadow_button>
          </div>
        </.dialog_footer>
      </.form>
    </.dialog>

    <.stage_dialog form={@stage_form} socket={@socket} />
    """
  end

  def mount(params, _session, socket) do
    user = socket.assigns.current_user

    if connected?(socket), do: subscribe_to_notifications_topic(user.id)

    filter = params["filter"] || "active"

    applications =
      JobApplications.list_applications(user, filter, [:current_stage, :stages])

    statuses = visible_statuses(filter)

    applications_by_status =
      for status <- statuses, into: %{} do
        {status, Enum.filter(applications, &(&1.status == status))}
      end

    # Create proper changeset for the job posting form
    job_posting_changeset =
      {%{}, %{url: :string}}
      |> Ecto.Changeset.cast(%{url: ""}, [:url])
      |> Ecto.Changeset.validate_required([:url])

    socket =
      socket
      |> assign(:page_title, "Job Applications")
      |> assign_sounds()
      |> assign_play_sounds(true)
      |> assign(:filter, filter)
      |> assign_new_form()
      |> assign(:stage_form, to_form(JobApplications.change_stage_form()))
      |> assign(:job_posting_form, to_form(job_posting_changeset, as: :job_posting_form))
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

  def handle_event("open_import_dialog", _params, socket) do
    job_posting_changeset =
      {%{}, %{url: :string}}
      |> Ecto.Changeset.cast(%{url: ""}, [:url])
      |> Ecto.Changeset.validate_required([:url])

    job_posting_form = to_form(job_posting_changeset, as: :job_posting_form)

    {:noreply,
     socket
     |> assign(:job_posting_form, job_posting_form)
     |> push_event("js-exec", %{
       to: "#new-job-application",
       attr: "phx-hide-modal"
     })
     |> push_event("js-exec", %{
       to: "#import-job-url-dialog",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("validate_job_url", %{"job_posting_form" => %{"url" => url}}, socket) do
    changeset =
      {%{}, %{url: :string}}
      |> Ecto.Changeset.cast(%{url: url}, [:url])
      |> Ecto.Changeset.validate_required([:url])
      |> URLValidators.validate_url(:url)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, job_posting_form: to_form(changeset, as: :job_posting_form))}
  end

  def handle_event("import_from_url", %{"job_posting_form" => %{"url" => url}}, socket) do
    changeset =
      {%{}, %{url: :string}}
      |> Ecto.Changeset.cast(%{url: url}, [:url])
      |> URLValidators.validate_url(:url)

    if changeset.valid? do
      %{
        job_posting_url: url,
        applicant_id: socket.assigns.current_user.id
      }
      |> AccomplishWeb.Workers.CreateJobApplicationFromUrl.new()
      |> Oban.insert()

      socket =
        socket
        |> put_flash(:info, "Job import started. You'll be notified when it's ready.")
        |> push_event("js-exec", %{
          to: "#import-job-url-dialog",
          attr: "phx-hide-modal"
        })

      {:noreply, socket}
    else
      {:noreply,
       assign(socket,
         job_posting_form:
           to_form(changeset |> Map.put(:action, :validate), as: :job_posting_form)
       )}
    end
  end

  def handle_event("update_application_form_status", %{"value" => value}, socket) do
    {:noreply, socket |> assign_application_form_status(value)}
  end

  def handle_event("update_application_form_location", %{"value" => value}, socket) do
    {:noreply, socket |> assign_application_form_location(value)}
  end

  def handle_event("update_application_status", %{"id" => id, "status" => status}, socket) do
    user = socket.assigns.current_user

    with %Application{} = application <- JobApplications.get_application!(user, id),
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

  def handle_event("validate_application", %{"application" => application_params}, socket) do
    changeset =
      JobApplications.change_application_form(%Application{}, application_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save_application", %{"application" => application_params}, socket) do
    case JobApplications.create_application(socket.assigns.current_user, application_params) do
      {:ok, _application} ->
        changeset = JobApplications.change_application_form(%Application{}, %{})

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
    changeset = JobApplications.change_application_form(%Application{}, %{})

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
        has_applications = JobApplications.count_applications(user) > 0

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
    user = socket.assigns.current_user
    application = JobApplications.get_application!(user, stage_params["application_id"])

    case Accomplish.JobApplications.add_stage(application, stage_params) do
      {:ok, _stage, _application} ->
        {:noreply,
         socket
         |> insert_application(user, application)
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

  def handle_event(
        "set_current_stage",
        %{"application-id" => application_id, "stage-id" => stage_id},
        socket
      ) do
    user = socket.assigns.current_user
    application = JobApplications.get_application!(user, application_id)

    case JobApplications.set_current_stage(application, stage_id) do
      {:ok, _} ->
        {:noreply, insert_application(socket, user, application)}

      {:error, :stage_not_found} ->
        {:noreply, put_flash(socket, :error, "Stage not found")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not update stage")}
    end
  end

  def handle_info(%{id: _id, date: date, form: form, field: field}, socket) do
    params = Map.put(form.params || %{}, to_string(field), date)

    case form.name do
      "application" ->
        updated_changeset = JobApplications.change_application_form(%Application{}, params)
        {:noreply, assign(socket, form: to_form(updated_changeset))}

      "stage" ->
        updated_changeset = JobApplications.change_stage_form(params)
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

  defp handle_notification(%{name: "job_application.created"} = event, socket) do
    socket =
      socket
      |> assign(:has_applications, true)
      |> maybe_insert_new_application(event.application)

    {:noreply, socket}
  end

  defp handle_notification(%{name: "job_application.updated"} = event, socket) do
    user = socket.assigns.current_user

    application =
      JobApplications.get_application!(user, event.application.id, [:current_stage, :stages])

    {:noreply, replace_application(socket, application, event.diff)}
  end

  defp handle_notification(_, socket), do: {:noreply, socket}

  defp subscribe_to_notifications_topic(user_id) do
    Phoenix.PubSub.subscribe(@pubsub, @notifications_topic <> ":#{user_id}")
  end

  defp insert_application(socket, user, application) do
    updated_application =
      JobApplications.get_application!(user, application.id, [:current_stage, :stages])

    key = stream_key(updated_application.status)
    stream_insert(socket, key, updated_application)
  end

  defp maybe_insert_new_application(socket, application) do
    key = stream_key(application.status)

    if application.status in socket.assigns.statuses do
      stream_insert(socket, key, application, at: 0)
    else
      socket
    end
  end

  defp replace_application(socket, application, diff) do
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
    changeset = JobApplications.change_application_form(%Application{}, %{})

    assign(socket, :form, to_form(changeset))
  end

  defp assign_application_form_status(socket, status) do
    form = socket.assigns.form

    updated_changeset =
      Ecto.Changeset.put_change(form.source, :status, status)

    assign(socket, :form, to_form(updated_changeset))
  end

  defp assign_application_form_location(socket, location) do
    form = socket.assigns.form

    updated_changeset =
      Ecto.Changeset.put_change(form.source, :location, location)

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

  defp visible_statuses("all") do
    ~w(accepted offer interviewing applied draft rejected ghosted)a
  end

  defp visible_statuses("active") do
    ~w(offer interviewing applied)a
  end

  defp visible_statuses("draft") do
    ~w(draft)a
  end
end
