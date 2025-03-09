defmodule AccomplishWeb.ResumeLive do
  use AccomplishWeb, :live_view

  import AccomplishWeb.Layout

  alias Accomplish.Accounts
  alias Accomplish.Profiles
  alias Accomplish.Profiles.Experience
  alias Accomplish.Profiles.Education

  alias Accomplish.Workers.ExtractResumeData

  import AccomplishWeb.JobApplicationHelpers

  import AccomplishWeb.Shadowrun.Dialog
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu
  import AccomplishWeb.Shadowrun.Tooltip

  @pubsub Accomplish.PubSub
  @notifications_topic "notifications:events"

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title="Resume">
          <:views>
            <.nav_button
              icon="file-text"
              text="Overview"
              href={~p"/resume/overview"}
              active={@live_action == :overview}
            />
            <.nav_button
              icon="laptop"
              text="Experience"
              href={~p"/resume/experience"}
              active={@live_action == :experience}
            />
            <.nav_button
              icon="graduation-cap"
              text="Education"
              href={~p"/resume/education"}
              active={@live_action == :education}
            />
          </:views>
          <:actions>
            <.shadow_button phx-click="import_resume" variant="transparent" class="text-xs">
              <.icon name="hero-plus" class="size-3" /> Import Resume
            </.shadow_button>
          </:actions>
        </.page_header>
      </:page_header>

      <div class="mt-8 w-full">
        <div class="-mx-4 -my-2 sm:-mx-6 lg:-mx-8">
          <%= case @live_action do %>
            <% :overview -> %>
              {render_overview(assigns)}
            <% :experience -> %>
              {render_experience(assigns)}
            <% :education -> %>
              {render_education(assigns)}
          <% end %>
        </div>
      </div>
    </.layout>
    <.dialog
      id="import-resume-dialog"
      position={:center}
      on_cancel={hide_modal("import-resume-dialog")}
      class="w-full max-w-md"
    >
      <.dialog_header>
        <.dialog_title class="text-sm text-zinc-200 font-light">
          <div class="flex items-center gap-2">
            <.icon name="hero-document-text" class="size-4" />
            <p>Import Resume</p>
          </div>
        </.dialog_title>
        <.dialog_description>
          Upload your resume PDF to automatically import your profile information.
          <span class="text-red-400">This will overwrite existing profile data.</span>
        </.dialog_description>
      </.dialog_header>

      <.form
        for={@resume_upload_form}
        id="resume-upload-form"
        phx-submit="import_resume_file"
        phx-change="validate_resume_file"
        class="space-y-4"
      >
        <.dialog_content id="import-resume-content">
          <div class="flex flex-col gap-4 py-2">
            <.live_file_input
              upload={@uploads.resume}
              class="block w-full text-sm text-zinc-400
              file:mr-4 file:py-2 file:px-4
              file:rounded-md file:border-0
              file:text-xs file:font-light
              file:bg-zinc-700 file:text-zinc-200
              hover:file:bg-zinc-600"
            />

            <div :if={Enum.any?(@uploads.resume.errors)} class="text-red-500 text-xs">
              <%= for {_ref, error} <- @uploads.resume.errors do %>
                <p>{error_to_string(error)}</p>
              <% end %>
            </div>
          </div>
        </.dialog_content>

        <.dialog_footer>
          <div class="flex justify-end gap-2">
            <.shadow_button
              type="button"
              variant="secondary"
              phx-click={hide_dialog("import-resume-dialog")}
            >
              Cancel
            </.shadow_button>
            <.shadow_button
              type="submit"
              variant="primary"
              phx-disable-with="Uploading..."
              disabled={@uploads.resume.entries == []}
            >
              Import
            </.shadow_button>
          </div>
        </.dialog_footer>
      </.form>
    </.dialog>
    """
  end

  defp render_overview(assigns) do
    ~H"""
    <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
      <div class="space-y-4 mb-6">
        <.shadow_input
          field={@user_form[:full_name]}
          placeholder="Full name"
          class="text-[25px] tracking-tighter hover:cursor-text"
          phx-blur="save_user_field"
          phx-value-field={@user_form[:full_name].field}
        />
        <div>
          <.shadow_input
            field={@profile_form[:headline]}
            placeholder="Headline"
            class="text-lg tracking-tighter hover:cursor-text"
            phx-blur="save_profile_field"
            phx-value-field={@profile_form[:headline].field}
          />
          <.shadow_input
            field={@profile_form[:location]}
            placeholder="City, Country"
            class="text-sm tracking-tighter hover:cursor-text"
            phx-blur="save_profile_field"
            phx-value-field={@profile_form[:location].field}
          />
        </div>
      </div>
      <div class="flex justify-start gap-2 my-2">
        <.tooltip>
          <.shadow_url_input
            id="profile-website-input"
            class="text-zinc-300 text-xs"
            field={@profile_form[:website_url]}
            placeholder="Enter your website URL"
            form={@profile_form}
          />
          <.tooltip_content side="bottom">
            <p>Set website URL</p>
          </.tooltip_content>
        </.tooltip>
        <.tooltip>
          <.shadow_github_input
            id="github-handle-input"
            class="text-zinc-300 text-xs"
            field={@profile_form[:github_handle]}
            placeholder="Enter GitHub username"
            form={@profile_form}
          />
          <.tooltip_content side="bottom">
            <p>Set GitHub handle</p>
          </.tooltip_content>
        </.tooltip>
        <.tooltip>
          <.shadow_linkedin_input
            id="linkedin-handle-input"
            class="text-zinc-300 text-xs"
            field={@profile_form[:linkedin_handle]}
            placeholder="Enter LinkedIn username"
            form={@profile_form}
          />
          <.tooltip_content side="bottom">
            <p>Set LinkedIn handle</p>
          </.tooltip_content>
        </.tooltip>
      </div>

      <div class="mt-12 space-y-2">
        <h3 class="text-zinc-400">About</h3>
        <.shadow_input
          field={@profile_form[:bio]}
          type="textarea"
          placeholder="Describe your experience, tech stack, and what kind of projects you love working on..."
          class="text-[14px] font-light hover:cursor-text"
          socket={@socket}
          phx-blur="save_profile_field"
          phx-value-field={@profile_form[:bio].field}
        />
      </div>
      <div class="mt-12 space-y-2">
        <h3 class="text-zinc-400">Interests</h3>
        <.shadow_input
          field={@profile_form[:interests]}
          type="textarea"
          placeholder="Share your hobbies, interests, and passions outside of work..."
          class="text-[14px] font-light hover:cursor-text"
          socket={@socket}
          phx-blur="save_profile_field"
          phx-value-field={@profile_form[:interests].field}
        />
      </div>
      <div class="mt-12 space-y-2">
        <.live_component
          module={AccomplishWeb.Components.SkillSelector}
          id="profile-skills"
          profile={@profile}
          skills={@profile.skills}
        />
      </div>
    </section>
    """
  end

  defp render_experience(assigns) do
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
                  field={@experience_forms[experience.id][:role]}
                  placeholder="Job role"
                  class="text-xl tracking-tighter hover:cursor-text"
                  phx-blur="save_experience_field"
                  phx-value-field={@experience_forms[experience.id][:role].field}
                  phx-value-id={experience.id}
                />

                <div>
                  <.shadow_input
                    id={"experience-#{experience.id}-company"}
                    field={@experience_forms[experience.id][:company]}
                    placeholder="Company"
                    class="text-base tracking-tighter hover:cursor-text"
                    phx-blur="save_experience_field"
                    phx-value-field={@experience_forms[experience.id][:company].field}
                    phx-value-id={experience.id}
                  />
                  <.shadow_input
                    id={"experience-#{experience.id}-location"}
                    field={@experience_forms[experience.id][:location]}
                    placeholder="City, Country"
                    class="text-sm text-zinc-400 tracking-tighter hover:cursor-text mt-2"
                    phx-blur="save_experience_field"
                    phx-value-field={@experience_forms[experience.id][:location].field}
                    phx-value-id={experience.id}
                  />
                </div>

                <div class="flex justify-start gap-2">
                  <.tooltip>
                    <.shadow_date_picker
                      label="Start date"
                      id={"experience-#{experience.id}-start-date"}
                      resource_id={experience.id}
                      form={@experience_forms[experience.id]}
                      start_date_field={@experience_forms[experience.id][:start_date]}
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
                      form={@experience_forms[experience.id]}
                      start_date_field={@experience_forms[experience.id][:end_date]}
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
                      field={@experience_forms[experience.id][:employment_type]}
                      prompt="Set employment type"
                      value={@experience_forms[experience.id][:employment_type].value}
                      options={options_for_employment_type()}
                      on_select="save_experience_field"
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
                      field={@experience_forms[experience.id][:workplace_type]}
                      prompt="Set workplace type"
                      value={@experience_forms[experience.id][:workplace_type].value}
                      options={options_for_workplace_type()}
                      on_select="save_experience_field"
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
                field={@experience_forms[experience.id][:description]}
                type="textarea"
                placeholder="List your dev highlights – achievements, impact, and tech you used..."
                class="text-sm font-light hover:cursor-text"
                socket={@socket}
                phx-blur="save_experience_field"
                phx-value-field={@experience_forms[experience.id][:description].field}
                phx-value-id={experience.id}
              />
            </div>
          </div>
        <% end %>
      </div>
    </section>

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
        for={@new_experience_form}
        id="new-experience-form"
        as="experience"
        phx-change="validate_experience"
        phx-submit="save_experience"
      >
        <.dialog_content id="new-experience-content">
          <div class="flex flex-col gap-4">
            <div class="space-y-3">
              <.shadow_input
                field={@new_experience_form[:role]}
                placeholder="Job role"
                class="text-xl tracking-tighter"
                required
              />
              <.shadow_input
                field={@new_experience_form[:company]}
                placeholder="Company"
                class="text-base tracking-tighter"
                required
              />
              <.shadow_input
                field={@new_experience_form[:location]}
                placeholder="City, Country"
                class="text-sm tracking-tighter"
              />
            </div>

            <div class="flex gap-4 mt-2">
              <div class="relative">
                <.shadow_date_picker
                  label="Start date"
                  id="new-experience-start-date"
                  form={@new_experience_form}
                  start_date_field={@new_experience_form[:start_date]}
                  required={true}
                />
              </div>
              <div class="relative">
                <.shadow_date_picker
                  label="End date"
                  id="new-experience-end-date"
                  form={@new_experience_form}
                  start_date_field={@new_experience_form[:end_date]}
                  required={false}
                />
              </div>
              <div class="relative">
                <.shadow_select_input
                  id="employment_type_select-new-experience"
                  field={@new_experience_form[:employment_type]}
                  prompt="Set employment type"
                  value={@new_experience_form[:employment_type].value}
                  options={options_for_employment_type()}
                  on_select="update_experience_employment_type"
                />
              </div>
              <div class="relative">
                <.shadow_select_input
                  id="workplace_type_select-new-experience"
                  field={@new_experience_form[:workplace_type]}
                  prompt="Set workplace type"
                  value={@new_experience_form[:workplace_type].value}
                  options={options_for_workplace_type()}
                  on_select="update_experience_workplace_type"
                />
              </div>
            </div>

            <.shadow_input
              field={@new_experience_form[:description]}
              type="textarea"
              placeholder="List your dev highlights – achievements, impact, and tech you used..."
              class="text-sm font-light"
              socket={@socket}
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
            <.shadow_button
              type="submit"
              variant="primary"
              disabled={!@new_experience_form.source.valid?}
            >
              Add Experience
            </.shadow_button>
          </div>
        </.dialog_footer>
      </.shadow_form>
    </.dialog>
    """
  end

  defp render_education(assigns) do
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
                  field={@education_forms[education.id][:degree]}
                  placeholder="Job degree"
                  class="text-xl tracking-tighter hover:cursor-text"
                  phx-blur="save_education_field"
                  phx-value-field={@education_forms[education.id][:degree].field}
                  phx-value-id={education.id}
                />

                <div>
                  <.shadow_input
                    id={"education-#{education.id}-school"}
                    field={@education_forms[education.id][:school]}
                    placeholder="School"
                    class="text-base tracking-tighter hover:cursor-text"
                    phx-blur="save_education_field"
                    phx-value-field={@education_forms[education.id][:school].field}
                    phx-value-id={education.id}
                  />
                  <.shadow_input
                    id={"education-#{education.id}-field_of_study"}
                    field={@education_forms[education.id][:field_of_study]}
                    placeholder="Field of study"
                    class="text-sm text-zinc-400 tracking-tighter hover:cursor-text mt-2"
                    phx-blur="save_education_field"
                    phx-value-field={@education_forms[education.id][:field_of_study].field}
                    phx-value-id={education.id}
                  />
                </div>

                <div class="flex justify-start gap-2">
                  <.tooltip>
                    <.shadow_date_picker
                      label="Start date"
                      id={"education-#{education.id}-start-date"}
                      resource_id={education.id}
                      form={@education_forms[education.id]}
                      start_date_field={@education_forms[education.id][:start_date]}
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
                      form={@education_forms[education.id]}
                      start_date_field={@education_forms[education.id][:end_date]}
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
                field={@education_forms[education.id][:description]}
                type="textarea"
                placeholder="Share your academic highlights – achievements, skills, and tech you explored..."
                class="text-sm font-light hover:cursor-text"
                socket={@socket}
                phx-blur="save_education_field"
                phx-value-field={@education_forms[education.id][:description].field}
                phx-value-id={education.id}
              />
            </div>
          </div>
        <% end %>
      </div>
    </section>

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
        for={@new_education_form}
        id="new-education-form"
        as="education"
        phx-change="validate_education"
        phx-submit="save_education"
      >
        <.dialog_content id="new-education-content">
          <div class="flex flex-col gap-4">
            <div class="space-y-3">
              <.shadow_input
                field={@new_education_form[:degree]}
                placeholder="Degree"
                class="text-xl tracking-tighter"
                required
              />
              <.shadow_input
                field={@new_education_form[:school]}
                placeholder="School"
                class="text-base tracking-tighter"
                required
              />
              <.shadow_input
                field={@new_education_form[:field_of_study]}
                placeholder="Field of study"
                class="text-sm tracking-tighter"
              />
            </div>

            <div class="flex gap-4 mt-2">
              <div class="relative">
                <.shadow_date_picker
                  label="Start date"
                  id="new-education-start-date"
                  form={@new_education_form}
                  start_date_field={@new_education_form[:start_date]}
                  required={true}
                />
              </div>
              <div class="relative">
                <.shadow_date_picker
                  label="End date"
                  id="new-education-end-date"
                  form={@new_education_form}
                  start_date_field={@new_education_form[:end_date]}
                  required={false}
                />
              </div>
            </div>

            <.shadow_input
              field={@new_education_form[:description]}
              type="textarea"
              placeholder="Describe your responsibilities, achievements, and the technologies you worked with..."
              class="text-sm font-light"
              socket={@socket}
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
            <.shadow_button
              type="submit"
              variant="primary"
              disabled={!@new_education_form.source.valid?}
            >
              Add Education
            </.shadow_button>
          </div>
        </.dialog_footer>
      </.shadow_form>
    </.dialog>
    """
  end

  def mount(params, session, socket) do
    socket =
      socket
      |> subscribe_to_notifications_topic()
      |> assign_uploads()
      |> assign(:resume_upload_form, to_form(%{"file" => nil}))

    mount_action(params, session, socket)
  end

  defp mount_action(_params, _session, %{assigns: %{live_action: :overview}} = socket) do
    user = socket.assigns.current_user
    profile = Profiles.get_profile_by_user(user.id)
    profile_changeset = Profiles.change_profile(profile)
    user_changeset = Accounts.change_user_profile(user)

    socket =
      socket
      |> assign(page_title: "Resume • Overview")
      |> assign(profile: profile)
      |> assign(user_form: to_form(user_changeset))
      |> assign(profile_form: to_form(profile_changeset))

    {:ok, socket}
  end

  defp mount_action(_params, _session, %{assigns: %{live_action: :experience}} = socket) do
    user = socket.assigns.current_user
    profile = Profiles.get_profile_by_user(user.id)
    experiences = Profiles.list_experiences(profile)
    changeset = Profiles.change_experience()

    experience_forms =
      experiences
      |> Enum.map(fn experience ->
        {experience.id, to_form(Profiles.change_experience(experience))}
      end)
      |> Map.new()

    socket =
      socket
      |> assign(page_title: "Resume • Experience")
      |> assign(profile: profile)
      |> assign(new_experience_form: to_form(changeset))
      |> assign(experience_forms: experience_forms)
      |> stream(:experiences, experiences)

    {:ok, socket}
  end

  defp mount_action(_params, _session, %{assigns: %{live_action: :education}} = socket) do
    user = socket.assigns.current_user
    profile = Profiles.get_profile_by_user(user.id)
    educations = Profiles.list_educations(profile)
    changeset = Profiles.change_education()

    education_forms =
      educations
      |> Enum.map(fn education ->
        {education.id, to_form(Profiles.change_education(education))}
      end)
      |> Map.new()

    socket =
      socket
      |> assign(page_title: "Resume • Education")
      |> assign(profile: profile)
      |> assign(new_education_form: to_form(changeset))
      |> assign(education_forms: education_forms)
      |> stream(:educations, educations)

    {:ok, socket}
  end

  def handle_event("save_user_field", %{"field" => field, "value" => value}, socket) do
    user = socket.assigns.current_user
    changes = %{field => value}

    case Accounts.update_user_profile(user, changes) do
      {:ok, updated_user} ->
        form =
          updated_user
          |> Accounts.change_user_profile()
          |> to_form()

        {:noreply,
         socket
         |> assign(user_form: form)}
    end
  end

  def handle_event("save_profile_field", %{"field" => field, "value" => value}, socket) do
    changes = %{field => value}
    update_profile_field(socket, changes)
  end

  def handle_event("open_new_experience_modal", _params, socket) do
    new_experience_form = to_form(Profiles.change_experience())

    {:noreply,
     socket
     |> assign(new_experience_form: new_experience_form)
     |> push_event("js-exec", %{
       to: "#new-experience-modal",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("open_new_education_modal", _params, socket) do
    new_education_form = to_form(Profiles.change_education())

    {:noreply,
     socket
     |> assign(new_education_form: new_education_form)
     |> push_event("js-exec", %{
       to: "#new-education-modal",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("validate_experience", %{"experience" => params}, socket) do
    changeset =
      %Experience{}
      |> Profiles.change_experience(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, new_experience_form: to_form(changeset))}
  end

  def handle_event("validate_education", %{"education" => params}, socket) do
    changeset =
      %Education{}
      |> Profiles.change_education(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, new_education_form: to_form(changeset))}
  end

  def handle_event("update_experience_employment_type", %{"value" => value}, socket) do
    form = socket.assigns.new_experience_form

    updated_changeset =
      Ecto.Changeset.put_change(form.source, :employment_type, value)

    {:noreply, assign(socket, :new_experience_form, to_form(updated_changeset))}
  end

  def handle_event("save_experience", %{"experience" => params}, socket) do
    profile = socket.assigns.profile

    case Profiles.add_experience(profile, params) do
      {:ok, experience} ->
        experience_forms =
          Map.put(
            socket.assigns.experience_forms,
            experience.id,
            to_form(Profiles.change_experience(experience))
          )

        socket =
          socket
          |> assign(experience_forms: experience_forms)
          |> stream_insert(:experiences, experience)
          |> push_event("js-exec", %{
            to: "#new-experience-modal",
            attr: "phx-hide-modal"
          })

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, new_experience_form: to_form(changeset))}
    end
  end

  def handle_event("save_education", %{"education" => params}, socket) do
    profile = socket.assigns.profile

    case Profiles.add_education(profile, params) do
      {:ok, education} ->
        education_forms =
          Map.put(
            socket.assigns.education_forms,
            education.id,
            to_form(Profiles.change_education(education))
          )

        socket =
          socket
          |> assign(education_forms: education_forms)
          |> stream_insert(:educations, education)
          |> push_event("js-exec", %{
            to: "#new-education-modal",
            attr: "phx-hide-modal"
          })

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, new_education_form: to_form(changeset))}
    end
  end

  def handle_event(
        "save_experience_field",
        %{"field" => field, "value" => value, "id" => id},
        socket
      ) do
    experience = Profiles.get_experience!(id)
    changes = %{field => value}
    update_experience_field(socket, experience, changes)
  end

  def handle_event(
        "save_education_field",
        %{"field" => field, "value" => value, "id" => id},
        socket
      ) do
    education = Profiles.get_education!(id)
    changes = %{field => value}
    update_education_field(socket, education, changes)
  end

  def handle_event("delete_experience", %{"id" => id}, socket) do
    experience = Profiles.get_experience!(id)

    case Profiles.remove_experience(experience) do
      {:ok, _deleted_experience} ->
        experience_forms = Map.delete(socket.assigns.experience_forms, id)

        {:noreply,
         socket
         |> assign(experience_forms: experience_forms)
         |> stream_delete(:experiences, experience)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("delete_education", %{"id" => id}, socket) do
    education = Profiles.get_education!(id)

    case Profiles.remove_education(education) do
      {:ok, _deleted_education} ->
        education_forms = Map.delete(socket.assigns.education_forms, id)

        {:noreply,
         socket
         |> assign(education_forms: education_forms)
         |> stream_delete(:educations, education)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("import_resume", _params, socket) do
    resume_upload_form = to_form(%{"file" => nil})

    {:noreply,
     socket
     |> assign(:resume_upload_form, resume_upload_form)
     |> push_event("js-exec", %{
       to: "#import-resume-dialog",
       attr: "phx-show-modal"
     })}
  end

  def handle_event("validate_resume_file", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("import_resume_file", _params, socket) do
    consume_uploaded_entries(socket, :resume, fn %{path: path}, _entry ->
      case Accomplish.PDFExtractor.extract_text_from_file(path) do
        {:ok, %{"text" => text_content}} ->
          %{
            user_id: socket.assigns.current_user.id,
            resume_text: text_content
          }
          |> ExtractResumeData.new()
          |> Oban.insert()

          {:ok, :processed}

        {:error, reason} ->
          {:error, "Failed to extract text from PDF: #{inspect(reason)}"}
      end
    end)

    case uploaded_entries(socket, :resume) do
      {[_entry], []} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resume uploaded successfully. Processing in progress...")
         |> push_event("js-exec", %{
           to: "#import-resume-dialog",
           attr: "phx-hide-modal"
         })}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Error uploading resume. Please try again.")}
    end
  end

  def handle_info({:update_profile_skills, skills}, socket) do
    changes = %{skills: skills}
    update_profile_field(socket, changes)
  end

  def handle_info(%{id: _id, resource_id: nil, date: date, form: form, field: field}, socket) do
    params = Map.put(form.params || %{}, to_string(field), date)

    case form.name do
      "experience" ->
        updated_changeset = Profiles.change_experience(%Experience{}, params)
        {:noreply, assign(socket, new_experience_form: to_form(updated_changeset))}

      "education" ->
        updated_changeset = Profiles.change_education(%Education{}, params)
        {:noreply, assign(socket, new_education_form: to_form(updated_changeset))}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info(
        %{id: _id, resource_id: resource_id, date: date, form: form, field: field},
        socket
      ) do
    params = Map.put(form.params || %{}, to_string(field), date)

    case form.name do
      "experience" ->
        experience = Profiles.get_experience!(resource_id)
        update_experience_field(socket, experience, params)

      "education" ->
        education = Profiles.get_education!(resource_id)
        update_education_field(socket, education, params)

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info(%{id: _id, field: field, value: value, form: _form}, socket) do
    changes = %{field => value}
    update_profile_field(socket, changes)
  end

  def handle_info({Profiles, event}, socket) do
    handle_notification(event, socket)
  end

  defp handle_notification(%{name: "profile.imported"} = event, socket) do
    profile = event.profile

    case socket.assigns.live_action do
      :overview ->
        profile_changeset = Profiles.change_profile(profile)

        {:noreply,
         socket
         |> assign(profile: profile)
         |> assign(profile_form: to_form(profile_changeset))
         |> put_flash(:info, "Profile successfully imported from resume.")}

      :experience ->
        experiences = event.experiences

        experience_forms =
          experiences
          |> Enum.map(fn experience ->
            {experience.id, to_form(Profiles.change_experience(experience))}
          end)
          |> Map.new()

        {:noreply,
         socket
         |> assign(profile: profile)
         |> assign(experience_forms: experience_forms)
         |> stream(:experiences, [], reset: true)
         |> stream(:experiences, experiences)
         |> put_flash(:info, "Work experience successfully imported from resume.")}

      :education ->
        educations = event.educations

        education_forms =
          educations
          |> Enum.map(fn education ->
            {education.id, to_form(Profiles.change_education(education))}
          end)
          |> Map.new()

        {:noreply,
         socket
         |> assign(profile: profile)
         |> assign(education_forms: education_forms)
         |> stream(:educations, [], reset: true)
         |> stream(:educations, educations)
         |> put_flash(:info, "Education successfully imported from resume.")}
    end
  end

  def update_profile_field(socket, changes) do
    profile = socket.assigns.profile

    case Profiles.update_profile(profile, changes) do
      {:ok, updated_profile} ->
        form =
          updated_profile
          |> Profiles.change_profile()
          |> to_form()

        {:noreply,
         socket
         |> assign(profile: updated_profile)
         |> assign(profile_form: form)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def update_experience_field(socket, experience, changes) do
    case Profiles.update_experience(experience, changes) do
      {:ok, updated_experience} ->
        form =
          updated_experience
          |> Profiles.change_experience()
          |> to_form()

        experience_forms = Map.put(socket.assigns.experience_forms, experience.id, form)

        {:noreply,
         socket
         |> assign(experience_forms: experience_forms)
         |> stream_insert(:experiences, updated_experience)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def update_education_field(socket, education, changes) do
    case Profiles.update_education(education, changes) do
      {:ok, updated_education} ->
        form =
          updated_education
          |> Profiles.change_education()
          |> to_form()

        education_forms = Map.put(socket.assigns.education_forms, education.id, form)

        {:noreply,
         socket
         |> assign(education_forms: education_forms)
         |> stream_insert(:educations, updated_education)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  defp subscribe_to_notifications_topic(socket) do
    user = socket.assigns.current_user

    if connected?(socket),
      do: Phoenix.PubSub.subscribe(@pubsub, @notifications_topic <> ":#{user.id}")

    socket
  end

  defp assign_uploads(socket) do
    socket
    |> allow_upload(:resume,
      accept: ~w(.pdf),
      max_entries: 1,
      # 10MB
      max_file_size: 10_000_000
    )
  end

  defp error_to_string(:too_large), do: "File is too large"
  defp error_to_string(:too_many_files), do: "Too many files"
  defp error_to_string(:not_accepted), do: "Unacceptable file type"
  defp error_to_string(error), do: "Error: #{inspect(error)}"
end
