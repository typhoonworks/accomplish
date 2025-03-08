defmodule AccomplishWeb.ResumeLive do
  use AccomplishWeb, :live_view

  import AccomplishWeb.Layout

  alias Accomplish.Accounts
  alias Accomplish.Profiles

  import AccomplishWeb.Shadowrun.Tooltip

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path}>
      <:page_header>
        <.page_header page_title="Resume">
          <:actions>
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
          </:actions>
        </.page_header>

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
      </:page_header>
    </.layout>
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
      <div class="mt-12">
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
      <div class="space-y-4"></div>
    </section>
    """
  end

  defp render_education(assigns) do
    ~H"""
    <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
      <div class="space-y-4"></div>
    </section>
    """
  end

  def mount(_params, _session, %{assigns: %{live_action: :overview}} = socket) do
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

  def mount(_params, _session, %{assigns: %{live_action: :experience}} = socket) do
    user = socket.assigns.current_user
    profile = Profiles.get_profile_by_user(user.id)
    experiences = Profiles.list_experiences(profile)

    socket =
      socket
      |> assign(page_title: "Resume • Experience")
      |> assign(experiences: experiences)

    {:ok, socket}
  end

  def mount(_params, _session, %{assigns: %{live_action: :education}} = socket) do
    socket =
      socket
      |> assign(page_title: "Resume • Education")

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

  def handle_info({:update_profile_skills, skills}, socket) do
    changes = %{skills: skills}
    update_profile_field(socket, changes)
  end

  def handle_info(%{id: _id, field: field, value: value, form: _form}, socket) do
    changes = %{field => value}
    update_profile_field(socket, changes)
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
end
