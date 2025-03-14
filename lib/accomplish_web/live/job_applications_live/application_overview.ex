defmodule AccomplishWeb.JobApplicationsLive.ApplicationOverview do
  use AccomplishWeb, :live_view

  alias Accomplish.JobApplications

  import AccomplishWeb.Layout
  import AccomplishWeb.JobApplicationHelpers
  import AccomplishWeb.Shadowrun.Accordion
  import AccomplishWeb.Shadowrun.Tooltip

  alias AccomplishWeb.JobApplicationsLive.ApplicationHeader
  alias AccomplishWeb.JobApplicationsLive.ApplicationAside

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"

  def render(assigns) do
    ~H"""
    <.layout flash={@flash} current_user={@current_user} current_path={@current_path}>
      <:page_header>
        {live_render(@socket, ApplicationHeader,
          id: "application-header",
          session: %{"application" => @application, "view" => :overview},
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
          field={@form[:role]}
          placeholder="Job role"
          class="text-[25px] tracking-tighter hover:cursor-text"
          phx-blur="save_field"
          phx-value-field={@form[:role].field}
        />
        <.inputs_for :let={company_f} field={@form[:company]}>
          <.shadow_input
            field={company_f[:name]}
            placeholder="Company name"
            class="text-lg tracking-tighter hover:cursor-text"
            phx-blur="save_field"
            phx-value-field={@form[:name].field}
            phx-value-nested="company"
          />

          <.shadow_url_input
            id="company-website-input"
            class="text-zinc-300 text-xs"
            field={company_f[:website_url]}
            placeholder="Enter company website URL"
            form={company_f}
          />
        </.inputs_for>
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

        <.tooltip>
          <.shadow_select_input
            id={"workplace_type_select_#{@form.id}_overview"}
            field={@form[:workplace_type]}
            prompt="Change workplace type"
            value={@form[:workplace_type].value}
            options={options_for_workplace_type()}
            on_select="save_field"
            variant="transparent"
          />
          <.tooltip_content side="bottom">
            <p>Set workplace type</p>
          </.tooltip_content>
        </.tooltip>

        <.tooltip>
          <.shadow_select_input
            id={"employment_type_select_#{@form.id}_overview"}
            field={@form[:employment_type]}
            prompt="Set employment type"
            value={@form[:employment_type].value}
            options={options_for_employment_type()}
            on_select="save_field"
            variant="transparent"
          />
          <.tooltip_content side="bottom">
            <p>Change employment type</p>
          </.tooltip_content>
        </.tooltip>
      </div>

      <div class="mt-12 space-y-2">
        <.accordion>
          <.accordion_item>
            <.accordion_trigger group="job-description" class="text-zinc-400 text-sm" open={true}>
              <h3 class="text-zinc-400">Job Description</h3>
            </.accordion_trigger>
            <.accordion_content id="job-description-content" group="job-description" class="pt-2">
              <.shadow_input
                field={@form[:job_description]}
                type="textarea"
                placeholder="Provide an overview of the job role..."
                class="text-[14px] font-light hover:cursor-text"
                socket={@socket}
                phx-blur="save_field"
                phx-value-field={@form[:job_description].field}
              />
            </.accordion_content>
          </.accordion_item>
        </.accordion>
      </div>

      <div class="mt-12 space-y-2">
        <.accordion>
          <.accordion_item>
            <.accordion_trigger group="compensation-details" class="text-zinc-400 text-sm" open={true}>
              <h3 class="text-zinc-400">Salary & Compensation</h3>
            </.accordion_trigger>
            <.accordion_content
              id="ompensation-details-content"
              group="compensation-details"
              class="pt-2"
            >
              <.shadow_input
                field={@form[:compensation_details]}
                type="textarea"
                placeholder="Outline salary range, bonuses, equity, and other compensation details..."
                class="text-[14px] font-light hover:cursor-text"
                socket={@socket}
                phx-blur="save_field"
                phx-value-field={@form[:compensation_details].field}
              />
            </.accordion_content>
          </.accordion_item>
        </.accordion>
      </div>

      <div class="mt-12 space-y-2">
        <.accordion>
          <.accordion_item>
            <.accordion_trigger
              group="job-application-notes"
              class="text-zinc-400 text-sm"
              open={true}
            >
              <h3 class="text-zinc-400">Notes</h3>
            </.accordion_trigger>
            <.accordion_content id="job-application-notes" group="job-application-notes" class="pt-2">
              <.shadow_input
                field={@form[:notes]}
                type="textarea"
                placeholder="Write down key details, next moves, or important notes..."
                class="text-[14px] font-light hover:cursor-text"
                socket={@socket}
                phx-blur="save_field"
                phx-value-field={@form[:notes].field}
              />
            </.accordion_content>
          </.accordion_item>
        </.accordion>
      </div>
    </section>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    with {:ok, socket, application} <- fetch_application(socket, slug, [:current_stage, :stages]) do
      socket =
        socket
        |> assign(page_title: "#{application.role} • Overview")
        |> assign(application: application)
        |> assign_form(application)
        |> subscribe_to_notifications_topic()

      {:ok, socket}
    end
  end

  def handle_event(
        "save_field",
        %{"field" => _field, "value" => _value, "nested" => "company"} = params,
        socket
      ) do
    update_field(socket, params)
  end

  def handle_event("save_field", params, socket) do
    update_field(socket, params)
  end

  def handle_info(%{date: date, field: field}, socket) do
    changes = %{"field" => field, "value" => date}
    update_field(socket, changes)
  end

  def handle_info(%{id: _id, field: field, value: value, form: form}, socket) do
    params =
      if String.contains?(form.name, "company") do
        %{"field" => to_string(field), "value" => value, "nested" => "company"}
      else
        %{"field" => to_string(field), "value" => value}
      end

    update_field(socket, params)
  end

  def handle_info({JobApplications, event}, socket) do
    handle_notification(event, socket)
  end

  defp handle_notification(%{name: "job_application.updated"} = event, socket) do
    {:noreply, assign(socket, application: event.application)}
  end

  defp handle_notification(%{name: "job_application.changed_current_stage"} = event, socket) do
    {:noreply, assign(socket, application: event.application)}
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
    form = JobApplications.change_application_form(application)
    assign(socket, form: to_form(form))
  end

  defp update_field(socket, %{"field" => field, "value" => value} = params) do
    application = socket.assigns.application
    form = socket.assigns.form

    changes =
      if Map.get(params, "nested") == "company" do
        %{"company" => Map.put(form.params["company"] || %{}, field, value)}
      else
        %{field => value}
      end

    case JobApplications.update_application(application, changes) do
      {:ok, updated_application} ->
        new_form = JobApplications.change_application_form(updated_application)
        {:noreply, assign(socket, form: to_form(new_form))}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp subscribe_to_notifications_topic(socket) do
    user = socket.assigns.current_user

    if connected?(socket),
      do: Phoenix.PubSub.subscribe(@pubsub, @notifications_topic <> ":#{user.id}")

    socket
  end
end
