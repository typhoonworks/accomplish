defmodule AccomplishWeb.ResumeLive.ResumeEducation do
  use AccomplishWeb, :live_view

  import AccomplishWeb.Layout

  alias Accomplish.Profiles
  alias Accomplish.Profiles.Education

  import AccomplishWeb.Shadowrun.Dialog
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu
  import AccomplishWeb.Shadowrun.Tooltip

  alias AccomplishWeb.ResumeLive.ResumeHeader

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"

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
          {render_educations(assigns)}
        </div>
      </div>
    </.layout>

    {render_new_education_dialog(assigns)}
    """
  end

  defp render_educations(assigns) do
    ~H"""
    <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
      <div class="space-y-2 mb-8">
        <h2 class="text-xl font-light text-zinc-100">Education</h2>
        <.shadow_button
          phx-click="open_new_education_modal"
          variant="transparent"
          class="text-zinc-300 text-xs"
        >
          <.icon name="hero-plus" class="size-3" /> Add education
        </.shadow_button>
      </div>

      <div id="educations" phx-update="stream" class="space-y-6">
        <%= for {id, education} <- @streams.educations do %>
          <div id={id}>
            <div class="flex justify-between items-start">
              <div class="space-y-2 flex-1">
                <.shadow_input
                  id={"education-#{education.id}-degree"}
                  field={@forms[education.id][:degree]}
                  placeholder="Job degree"
                  class="text-xl tracking-tighter hover:cursor-text"
                  phx-blur="save_field"
                  phx-value-field={@forms[education.id][:degree].field}
                  phx-value-id={education.id}
                />

                <div>
                  <.shadow_input
                    id={"education-#{education.id}-school"}
                    field={@forms[education.id][:school]}
                    placeholder="School"
                    class="text-base tracking-tighter hover:cursor-text"
                    phx-blur="save_field"
                    phx-value-field={@forms[education.id][:school].field}
                    phx-value-id={education.id}
                  />
                  <.shadow_input
                    id={"education-#{education.id}-field_of_study"}
                    field={@forms[education.id][:field_of_study]}
                    placeholder="Field of study"
                    class="text-sm text-zinc-400 tracking-tighter hover:cursor-text mt-2"
                    phx-blur="save_field"
                    phx-value-field={@forms[education.id][:field_of_study].field}
                    phx-value-id={education.id}
                  />
                </div>

                <div class="flex justify-start gap-2">
                  <.tooltip>
                    <.shadow_date_picker
                      label="Start date"
                      id={"education-#{education.id}-start-date"}
                      resource_id={education.id}
                      form={@forms[education.id]}
                      start_date_field={@forms[education.id][:start_date]}
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
                      id={"education-#{education.id}-end-date"}
                      resource_id={education.id}
                      form={@forms[education.id]}
                      start_date_field={@forms[education.id][:end_date]}
                      required={true}
                      variant="transparent"
                    />

                    <.tooltip_content side="bottom">
                      <p>End date</p>
                    </.tooltip_content>
                  </.tooltip>
                </div>
              </div>

              <div class="flex gap-2">
                <.dropdown_menu>
                  <.dropdown_menu_trigger id={"#{education.id}-dropdown-trigger"} class="group">
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
                            phx-click="delete_education"
                            phx-value-id={education.id}
                          >
                            <span>Remove education</span>
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
                id={"education-#{education.id}-description"}
                field={@forms[education.id][:description]}
                type="textarea"
                placeholder="Share your academic highlights – achievements, skills, and tech you explored..."
                class="text-sm font-light hover:cursor-text"
                socket={@socket}
                phx-blur="save_field"
                phx-value-field={@forms[education.id][:description].field}
                phx-value-id={education.id}
                autosave={@autosave}
              />
            </div>
          </div>
        <% end %>
      </div>
    </section>
    """
  end

  def render_new_education_dialog(assigns) do
    ~H"""
    <.dialog
      id="new-education-modal"
      position={:upper_third}
      on_cancel={hide_modal("new-education-modal")}
      class="w-full max-w-xl"
    >
      <.dialog_header>
        <.dialog_title class="text-sm text-zinc-200 font-light">
          <div class="flex items-center gap-2">
            <.lucide_icon name="graduation-cap" class="size-4" />
            <p>Add Education</p>
          </div>
        </.dialog_title>
      </.dialog_header>
      <.shadow_form
        for={@new_form}
        id="new-education-form"
        as="education"
        phx-change="validate_education"
        phx-submit="save_education"
      >
        <.dialog_content id="new-education-content">
          <div class="flex flex-col gap-4">
            <div class="space-y-3">
              <.shadow_input
                field={@new_form[:degree]}
                placeholder="Degree"
                class="text-xl tracking-tighter"
                required
              />
              <.shadow_input
                field={@new_form[:school]}
                placeholder="School"
                class="text-base tracking-tighter"
                required
              />
              <.shadow_input
                field={@new_form[:field_of_study]}
                placeholder="Field of study"
                class="text-sm tracking-tighter"
              />
            </div>

            <div class="flex gap-4 mt-2">
              <div class="relative">
                <.shadow_date_picker
                  label="Start date"
                  id="new-education-start-date"
                  form={@new_form}
                  start_date_field={@new_form[:start_date]}
                  required={true}
                />
              </div>
              <div class="relative">
                <.shadow_date_picker
                  label="End date"
                  id="new-education-end-date"
                  form={@new_form}
                  start_date_field={@new_form[:end_date]}
                  required={false}
                />
              </div>
            </div>

            <.shadow_input
              field={@new_form[:description]}
              type="textarea"
              placeholder="Describe your responsibilities, achievements, and the technologies you worked with..."
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
              phx-click={hide_modal("new-education-modal")}
            >
              Cancel
            </.shadow_button>
            <.shadow_button type="submit" variant="primary" disabled={!@new_form.source.valid?}>
              Add Education
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
    educations = Profiles.list_educations(profile)
    changeset = Profiles.change_education()

    socket =
      socket
      |> assign(page_title: "Resume • Education")
      |> assign(profile: profile)
      |> assign(new_form: to_form(changeset))
      |> assign_forms(educations)
      |> assign(autosave: true)
      |> assign(resume_header_topic: topic)
      |> stream(:educations, educations)
      |> subscribe_to_notifications_topic()

    {:ok, socket}
  end

  def handle_event("open_new_education_modal", _params, socket) do
    new_form = to_form(Profiles.change_education())

    {:noreply,
     socket
     |> assign(new_form: new_form)
     |> push_event("js-exec", %{
       to: "#new-education-modal",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("validate_education", %{"education" => params}, socket) do
    changeset =
      %Education{}
      |> Profiles.change_education(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, new_form: to_form(changeset))}
  end

  def handle_event("save_education", %{"education" => params}, socket) do
    profile = socket.assigns.profile

    case Profiles.add_education(profile, params) do
      {:ok, education} ->
        forms =
          Map.put(
            socket.assigns.forms,
            education.id,
            to_form(Profiles.change_education(education))
          )

        socket =
          socket
          |> assign(forms: forms)
          |> stream_insert(:educations, education)
          |> push_event("js-exec", %{
            to: "#new-education-modal",
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
    experience = Profiles.get_education!(id)
    changes = %{field => value}
    update_field(socket, experience, changes)
  end

  def handle_event("delete_education", %{"id" => id}, socket) do
    education = Profiles.get_education!(id)

    case Profiles.remove_education(education) do
      {:ok, _deleted_education} ->
        forms = Map.delete(socket.assigns.forms, id)

        {:noreply,
         socket
         |> assign(forms: forms)
         |> stream_delete(:educations, education)}

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

    updated_changeset = Profiles.change_education(%Education{}, params)
    {:noreply, assign(socket, new_form: to_form(updated_changeset))}
  end

  def handle_info(
        %{id: _id, resource_id: resource_id, date: date, form: form, field: field},
        socket
      ) do
    params = Map.put(form.params || %{}, to_string(field), date)

    education = Profiles.get_education!(resource_id)
    update_field(socket, education, params)
  end

  def handle_info({Profiles, event}, socket) do
    handle_notification(event, socket)
  end

  defp handle_notification(%{name: "profile.imported"} = event, socket) do
    educations = event.experience

    socket =
      socket
      |> assign(profile: event.profile)
      |> assign_forms(educations)
      |> stream(:educations, [], reset: true)
      |> stream(:educations, educations)
      |> put_flash(:info, "Education successfully imported from resume.")

    {:noreply, socket}
  end

  def update_field(socket, education, changes) do
    show_saving_spinner(socket)

    case Profiles.update_education(education, changes) do
      {:ok, updated_education} ->
        form =
          updated_education
          |> Profiles.change_education()
          |> to_form()

        forms = Map.put(socket.assigns.forms, education.id, form)

        socket =
          socket
          |> assign(forms: forms)
          |> stream_insert(:educations, updated_education)
          |> schedule_hide_spinner()

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, schedule_hide_spinner(socket)}
    end
  end

  defp assign_forms(socket, educations) do
    forms =
      educations
      |> Enum.map(fn education ->
        {education.id, to_form(Profiles.change_education(education))}
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

  defp subscribe_to_notifications_topic(socket) do
    user = socket.assigns.current_user

    if connected?(socket),
      do: Phoenix.PubSub.subscribe(@pubsub, @notifications_topic <> ":#{user.id}")

    socket
  end
end
