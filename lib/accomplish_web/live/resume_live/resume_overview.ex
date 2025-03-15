defmodule AccomplishWeb.ResumeLive.ResumeOverview do
  use AccomplishWeb, :live_view

  alias Accomplish.Accounts
  alias Accomplish.Profiles

  import AccomplishWeb.Layout
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
          {render_overview(assigns)}
        </div>
      </div>
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
          autosave={@autosave}
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
          autosave={@autosave}
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

  def mount(_params, _session, socket) do
    topic = "resume_header:#{socket.id}"
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
      |> assign(autosave: true)
      |> assign(resume_header_topic: topic)
      |> subscribe_to_user_events()

    {:ok, socket}
  end

  def handle_event("save_user_field", %{"field" => field, "value" => value}, socket) do
    show_saving_spinner(socket)

    user = socket.assigns.current_user
    changes = %{field => value}

    case Accounts.update_user_profile(user, changes) do
      {:ok, updated_user} ->
        form =
          updated_user
          |> Accounts.change_user_profile()
          |> to_form()

        socket =
          socket
          |> assign(user_form: form)
          |> schedule_hide_spinner()

        {:noreply, socket}

      _ ->
        {:noreply, schedule_hide_spinner(socket)}
    end
  end

  def handle_event("save_profile_field", %{"field" => field, "value" => value}, socket) do
    changes = %{field => value}
    update_profile_field(socket, changes)
  end

  def handle_info(:hide_spinner, socket) do
    Phoenix.PubSub.broadcast(
      @pubsub,
      socket.assigns.resume_header_topic,
      {:set_saving, false}
    )

    {:noreply, socket}
  end

  def handle_info({:update_profile_skills, skills}, socket) do
    changes = %{skills: skills}
    update_profile_field(socket, changes)
  end

  def handle_info(%{id: _id, field: field, value: value, form: _form}, socket) do
    changes = %{field => value}
    update_profile_field(socket, changes)
  end

  def handle_info({Profiles, event}, socket) do
    process_pubsub_event(event, socket)
  end

  defp process_pubsub_event(%{name: "profile.imported"} = event, socket) do
    profile = event.profile
    profile_changeset = Profiles.change_profile(profile)

    socket =
      socket
      |> assign(profile: profile)
      |> assign(profile_form: to_form(profile_changeset))
      |> put_flash(:info, "Profile successfully imported from resume.")

    {:noreply, socket}
  end

  def update_profile_field(socket, changes) do
    show_saving_spinner(socket)

    profile = socket.assigns.profile

    case Profiles.update_profile(profile, changes) do
      {:ok, updated_profile} ->
        form =
          updated_profile
          |> Profiles.change_profile()
          |> to_form()

        socket =
          socket
          |> assign(profile: updated_profile)
          |> assign(profile_form: form)
          |> schedule_hide_spinner()

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, schedule_hide_spinner(socket)}
    end
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
