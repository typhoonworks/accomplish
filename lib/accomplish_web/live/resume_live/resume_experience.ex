defmodule AccomplishWeb.ResumeLive.ResumeExperience do
  use AccomplishWeb, :live_view

  import AccomplishWeb.Layout

  alias Accomplish.Profiles
  alias Accomplish.Profiles.Experience

  import AccomplishWeb.JobApplicationHelpers

  import AccomplishWeb.Shadowrun.Dialog
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu
  import AccomplishWeb.Shadowrun.Tooltip

  alias AccomplishWeb.ResumeLive.ResumeHeader

  @pubsub Accomplish.PubSub

  def render(assigns) do
    ~H"""
    <.layout flash={@flash} current_user={@current_user} current_path={@current_path}>
      <:page_header>
        {live_render(@socket, ResumeHeader,
          id: "resume-header",
          session: %{
            "view" => @live_action,
            "topic" => @resume_header_topic
          },
          sticky: true
        )}
      </:page_header>

      <div class="mt-8 w-full">
        <div class="-mx-4 -my-2 sm:-mx-6 lg:-mx-8">
          {render_experiences(assigns)}
        </div>
      </div>
    </.layout>

    {render_new_experience_dialog(assigns)}
    """
  end

  defp render_experiences(assigns) do
    ~H"""
    <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
      <div class="space-y-2 mb-8">
        <h2 class="text-xl font-light text-zinc-100">Work Experience</h2>
        <.shadow_button
          phx-click="open_new_experience_modal"
          variant="transparent"
          class="text-zinc-300 text-xs"
        >
          <.icon name="hero-plus" class="size-3" /> Add experience
        </.shadow_button>
      </div>

      <div id="experiences" phx-update="stream" class="space-y-6">
        <%= for {id, experience} <- @streams.experiences do %>
          <div id={id}>
            <div class="flex justify-between items-start">
              <div class="space-y-2 flex-1">
                <.shadow_input
                  id={"experience-#{experience.id}-role"}
                  field={@forms[experience.id][:role]}
                  placeholder="Job role"
                  class="text-xl tracking-tighter hover:cursor-text"
                  phx-blur="save_field"
                  phx-value-field={@forms[experience.id][:role].field}
                  phx-value-id={experience.id}
                />

                <div>
                  <.shadow_input
                    id={"experience-#{experience.id}-company"}
                    field={@forms[experience.id][:company]}
                    placeholder="Company"
                    class="text-base tracking-tighter hover:cursor-text"
                    phx-blur="save_field"
                    phx-value-field={@forms[experience.id][:company].field}
                    phx-value-id={experience.id}
                  />
                  <.shadow_input
                    id={"experience-#{experience.id}-location"}
                    field={@forms[experience.id][:location]}
                    placeholder="City, Country"
                    class="text-sm text-zinc-400 tracking-tighter hover:cursor-text mt-2"
                    phx-blur="save_field"
                    phx-value-field={@forms[experience.id][:location].field}
                    phx-value-id={experience.id}
                  />
                </div>

                <div class="flex justify-start gap-2">
                  <.tooltip>
                    <.shadow_date_picker
                      label="Start date"
                      id={"experience-#{experience.id}-start-date"}
                      resource_id={experience.id}
                      form={@forms[experience.id]}
                      start_date_field={@forms[experience.id][:start_date]}
                      required={true}
                      variant="transparent"
                    />

                    <.tooltip_content side="bottom">
                      <p>Start date</p>
                    </.tooltip_content>
                  </.tooltip>
                  <.tooltip>
                    <.shadow_date_picker
                      label="End date"
                      id={"experience-#{experience.id}-end-date"}
                      resource_id={experience.id}
                      form={@forms[experience.id]}
                      start_date_field={@forms[experience.id][:end_date]}
                      required={true}
                      variant="transparent"
                    />

                    <.tooltip_content side="bottom">
                      <p>End date</p>
                    </.tooltip_content>
                  </.tooltip>
                  <.tooltip>
                    <.shadow_select_input
                      id={"employment_type_select-#{experience.id}"}
                      resource_id={experience.id}
                      field={@forms[experience.id][:employment_type]}
                      prompt="Set employment type"
                      value={@forms[experience.id][:employment_type].value}
                      options={options_for_employment_type()}
                      on_select="save_field"
                      variant="transparent"
                    />
                    <.tooltip_content side="bottom">
                      <p>Change employment type</p>
                    </.tooltip_content>
                  </.tooltip>
                  <.tooltip>
                    <.shadow_select_input
                      id={"workplace_type_select-#{experience.id}"}
                      resource_id={experience.id}
                      field={@forms[experience.id][:workplace_type]}
                      prompt="Set workplace type"
                      value={@forms[experience.id][:workplace_type].value}
                      options={options_for_workplace_type()}
                      on_select="save_field"
                      variant="transparent"
                    />
                    <.tooltip_content side="bottom">
                      <p>Change workplace type</p>
                    </.tooltip_content>
                  </.tooltip>
                </div>
              </div>

              <div class="flex gap-2">
                <.dropdown_menu>
                  <.dropdown_menu_trigger id={"#{experience.id}-dropdown-trigger"} class="group">
                    <.shadow_button type="button" variant="transparent">
                      <.lucide_icon name="ellipsis" class="size-4 text-zinc-400" />
                    </.shadow_button>
                  </.dropdown_menu_trigger>
                  <.dropdown_menu_content>
                    <.menu class="w-56 text-zinc-300 bg-zinc-800">
                      <.menu_group>
                        <.menu_item class="text-sm">
                          <button
                            type="button"
                            phx-click="delete_experience"
                            phx-value-id={experience.id}
                          >
                            <span>Remove experience</span>
                          </button>
                          <.menu_shortcut>⌘D</.menu_shortcut>
                        </.menu_item>
                      </.menu_group>
                    </.menu>
                  </.dropdown_menu_content>
                </.dropdown_menu>
              </div>
            </div>

            <div class="mt-6">
              <.shadow_input
                id={"experience-#{experience.id}-description"}
                field={@forms[experience.id][:description]}
                type="textarea"
                placeholder="List your dev highlights – achievements, impact, and tech you used..."
                class="text-sm font-light hover:cursor-text"
                socket={@socket}
                phx-blur="save_field"
                phx-value-field={@forms[experience.id][:description].field}
                phx-value-id={experience.id}
                autosave={@autosave}
              />
            </div>
          </div>
        <% end %>
      </div>
    </section>
    """
  end

  def render_new_experience_dialog(assigns) do
    ~H"""
    <.dialog
      id="new-experience-modal"
      position={:upper_third}
      on_cancel={hide_modal("new-experience-modal")}
      class="w-full max-w-xl"
    >
      <.dialog_header>
        <.dialog_title class="text-sm text-zinc-200 font-light">
          <div class="flex items-center gap-2">
            <.lucide_icon name="laptop" class="size-4" />
            <p>Add Work Experience</p>
          </div>
        </.dialog_title>
      </.dialog_header>
      <.shadow_form
        for={@new_form}
        id="new-experience-form"
        as="experience"
        phx-change="validate_experience"
        phx-submit="save_experience"
      >
        <.dialog_content id="new-experience-content">
          <div class="flex flex-col gap-4">
            <div class="space-y-3">
              <.shadow_input
                field={@new_form[:role]}
                placeholder="Job role"
                class="text-xl tracking-tighter"
                required
              />
              <.shadow_input
                field={@new_form[:company]}
                placeholder="Company"
                class="text-base tracking-tighter"
                required
              />
              <.shadow_input
                field={@new_form[:location]}
                placeholder="City, Country"
                class="text-sm tracking-tighter"
              />
            </div>

            <div class="flex gap-4 mt-2">
              <div class="relative">
                <.shadow_date_picker
                  label="Start date"
                  id="new-experience-start-date"
                  form={@new_form}
                  start_date_field={@new_form[:start_date]}
                  required={true}
                />
              </div>
              <div class="relative">
                <.shadow_date_picker
                  label="End date"
                  id="new-experience-end-date"
                  form={@new_form}
                  start_date_field={@new_form[:end_date]}
                  required={false}
                />
              </div>
              <div class="relative">
                <.shadow_select_input
                  id="employment_type_select-new-experience"
                  field={@new_form[:employment_type]}
                  prompt="Set employment type"
                  value={@new_form[:employment_type].value}
                  options={options_for_employment_type()}
                  on_select="update_employment_type"
                />
              </div>
              <div class="relative">
                <.shadow_select_input
                  id="workplace_type_select-new-experience"
                  field={@new_form[:workplace_type]}
                  prompt="Set workplace type"
                  value={@new_form[:workplace_type].value}
                  options={options_for_workplace_type()}
                  on_select="update_workplace_type"
                />
              </div>
            </div>

            <.shadow_input
              field={@new_form[:description]}
              type="textarea"
              placeholder="List your dev highlights – achievements, impact, and tech you used..."
              class="text-sm font-light"
              socket={@socket}
              autosave={@autosave}
            />
          </div>
        </.dialog_content>

        <.dialog_footer>
          <div class="flex justify-end gap-2">
            <.shadow_button
              type="button"
              variant="secondary"
              phx-click={hide_modal("new-experience-modal")}
            >
              Cancel
            </.shadow_button>
            <.shadow_button type="submit" variant="primary" disabled={!@new_form.source.valid?}>
              Add Experience
            </.shadow_button>
          </div>
        </.dialog_footer>
      </.shadow_form>
    </.dialog>
    """
  end

  def mount(_params, _session, socket) do
    topic = "resume_header:#{socket.id}"
    user = socket.assigns.current_user
    profile = Profiles.get_profile_by_user(user.id)
    experiences = Profiles.list_experiences(profile)
    changeset = Profiles.change_experience()

    socket =
      socket
      |> assign(page_title: "Resume • Experience")
      |> assign(profile: profile)
      |> assign(new_form: to_form(changeset))
      |> assign_forms(experiences)
      |> assign(autosave: true)
      |> assign(resume_header_topic: topic)
      |> stream(:experiences, experiences)
      |> subscribe_to_user_events()

    {:ok, socket}
  end

  def handle_event("open_new_experience_modal", _params, socket) do
    new_form = to_form(Profiles.change_experience())

    {:noreply,
     socket
     |> assign(new_form: new_form)
     |> push_event("js-exec", %{
       to: "#new-experience-modal",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("validate_experience", %{"experience" => params}, socket) do
    changeset =
      %Experience{}
      |> Profiles.change_experience(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, new_form: to_form(changeset))}
  end

  def handle_event("update_employment_type", %{"value" => value}, socket) do
    form = socket.assigns.new_form

    updated_changeset =
      Ecto.Changeset.put_change(form.source, :employment_type, value)

    {:noreply, assign(socket, :new_form, to_form(updated_changeset))}
  end

  def handle_event("update_workplace_type", %{"value" => value}, socket) do
    form = socket.assigns.new_form

    updated_changeset =
      Ecto.Changeset.put_change(form.source, :workplace_type, value)

    {:noreply, assign(socket, :new_form, to_form(updated_changeset))}
  end

  def handle_event("save_experience", %{"experience" => params}, socket) do
    profile = socket.assigns.profile

    case Profiles.add_experience(profile, params) do
      {:ok, experience} ->
        forms =
          Map.put(
            socket.assigns.forms,
            experience.id,
            to_form(Profiles.change_experience(experience))
          )

        socket =
          socket
          |> assign(forms: forms)
          |> stream_insert(:experiences, experience)
          |> push_event("js-exec", %{
            to: "#new-experience-modal",
            attr: "phx-hide-modal"
          })

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, new_form: to_form(changeset))}
    end
  end

  def handle_event(
        "save_field",
        %{"field" => field, "value" => value, "id" => id},
        socket
      ) do
    experience = Profiles.get_experience!(id)
    changes = %{field => value}
    update_field(socket, experience, changes)
  end

  def handle_event("delete_experience", %{"id" => id}, socket) do
    experience = Profiles.get_experience!(id)

    case Profiles.remove_experience(experience) do
      {:ok, _deleted_experience} ->
        forms = Map.delete(socket.assigns.forms, id)

        {:noreply,
         socket
         |> assign(forms: forms)
         |> stream_delete(:experiences, experience)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_info(:hide_spinner, socket) do
    Phoenix.PubSub.broadcast(
      @pubsub,
      socket.assigns.resume_header_topic,
      {:set_saving, false}
    )

    {:noreply, socket}
  end

  def handle_info(%{id: _id, resource_id: nil, date: date, form: form, field: field}, socket) do
    params = Map.put(form.params || %{}, to_string(field), date)

    updated_changeset = Profiles.change_experience(%Experience{}, params)
    {:noreply, assign(socket, new_form: to_form(updated_changeset))}
  end

  def handle_info(
        %{id: _id, resource_id: resource_id, date: date, form: form, field: field},
        socket
      ) do
    params = Map.put(form.params || %{}, to_string(field), date)

    experience = Profiles.get_experience!(resource_id)
    update_field(socket, experience, params)
  end

  def handle_info({Profiles, event}, socket) do
    process_pubsub_event(event, socket)
  end

  defp process_pubsub_event(%{name: "profile.imported"} = event, socket) do
    experiences = event.experience

    socket =
      socket
      |> assign(profile: event.profile)
      |> assign_forms(experiences)
      |> stream(:experiences, [], reset: true)
      |> stream(:experiences, experiences)
      |> put_flash(:info, "Work experience successfully imported from resume.")

    {:noreply, socket}
  end

  def update_field(socket, experience, changes) do
    show_saving_spinner(socket)

    case Profiles.update_experience(experience, changes) do
      {:ok, updated_experience} ->
        form =
          updated_experience
          |> Profiles.change_experience()
          |> to_form()

        forms = Map.put(socket.assigns.forms, experience.id, form)

        socket =
          socket
          |> assign(forms: forms)
          |> stream_insert(:experiences, updated_experience)
          |> schedule_hide_spinner()

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, schedule_hide_spinner(socket)}
    end
  end

  defp assign_forms(socket, experiences) do
    forms =
      experiences
      |> Enum.map(fn experience ->
        {experience.id, to_form(Profiles.change_experience(experience))}
      end)
      |> Map.new()

    assign(socket, forms: forms)
  end

  def show_saving_spinner(socket) do
    Phoenix.PubSub.broadcast(
      @pubsub,
      socket.assigns.resume_header_topic,
      {:set_saving, true}
    )
  end

  def schedule_hide_spinner(socket) do
    Process.send_after(self(), :hide_spinner, 500)
    socket
  end

  def subscribe_to_user_events(socket) do
    user = socket.assigns.current_user

    if connected?(socket), do: Accomplish.Events.subscribe(user.id)

    socket
  end
end
