defmodule AccomplishWeb.JobApplicationLive do
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
              <.link href={~p"/job_applications/"} class="hidden lg:inline">Job Applications</.link>
              <span class="hidden lg:inline-flex items-center text-zinc-400">
                <.icon name="hero-chevron-right" class="size-3" />
              </span>
              <span class="inline">{@application.role} at {@application.company.name}</span>
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

        <p class="text-zinc-300">{@application.company.name}</p>
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
    <div>
      <h3 class="text-lg font-semibold">Stages</h3>
      <ul>
        <%= for stage <- @application.stages do %>
          <li class="border-b py-2">{stage.title}</li>
        <% end %>
      </ul>
    </div>
    """
  end

  defp activity_feed(assigns) do
    ~H"""
    <div class="flow-root">
      <ul role="list" class="-mb-8">
        <.activity :for={{dom_id, activity} <- @activities} id={dom_id} activity={activity} />
      </ul>
    </div>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    applicant = socket.assigns.current_user

    case JobApplications.get_application_by_slug(applicant, slug, [
           :company,
           :current_stage,
           :stages
         ]) do
      {:ok, application} ->
        if connected?(socket), do: subscribe_to_activities_topic(application.id)

        form = JobApplications.change_application_form(Map.from_struct(application))
        activities = Activities.list_activities_for_target(application)

        socket =
          socket
          |> assign(application: application)
          |> assign(form: to_form(form))
          |> stream(:activities, activities)

        {:ok, socket}

      :error ->
        {:ok, push_navigate(socket, to: ~p"/job_applications")}
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

  def handle_info({:new_activity, activity}, socket) do
    {:noreply, stream_insert(socket, :activities, activity, at: 0)}
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

  defp subscribe_to_activities_topic(target_id) do
    Phoenix.PubSub.subscribe(@pubsub, @activities_topic <> ":#{target_id}")
  end
end
