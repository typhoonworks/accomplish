defmodule AccomplishWeb.SettingsLive.AccountProfile do
  use AccomplishWeb, :live_view

  alias Accomplish.Accounts

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Forms

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path} sidebar_context={:settings}>
      <div class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
        <h3 class="text-xl text-zinc-50">Profile</h3>

        <section class="mt-12">
          <div class="space-y-4">
            <.shadow_box>
              <.form
                for={@form}
                id="profile_form"
                phx-change="validate_profile"
                phx-submit="update_profile"
                class="md:col-span-2"
              >
                <div class="space-y-6">
                  <div>
                    <.shadow_structured_input
                      field={@form[:full_name]}
                      type="text"
                      label="Full name"
                      autocomplete="name"
                      hint="Your full name"
                    />
                  </div>

                  <div>
                    <.shadow_structured_input
                      field={@form[:username]}
                      type="text"
                      label="Username"
                      autocomplete="username"
                      hint="Username may only contain alphanumeric characters or single hyphens, and cannot begin or end with a hyphen."
                    />
                  </div>
                </div>

                <div class="mt-8 flex">
                  <.shadow_button type="submit" phx-disable-with="Saving...">
                    Save
                  </.shadow_button>
                </div>
              </.form>
            </.shadow_box>
          </div>
        </section>
      </div>
    </.layout>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    profile_changeset = Accounts.change_user_profile(user)

    socket =
      socket
      |> assign(:page_title, "Profile")
      |> assign(:form, to_form(profile_changeset))

    {:ok, socket}
  end

  def handle_event("validate_profile", %{"user" => user_params}, socket) do
    form =
      socket.assigns.current_user
      |> Accounts.change_user_profile(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("update_profile", %{"user" => user_params}, socket) do
    user = socket.assigns.current_user

    case Accounts.update_user_profile(user, user_params) do
      {:ok, updated_user} ->
        form =
          updated_user
          |> Accounts.change_user_profile()
          |> to_form()

        {:noreply,
         socket
         |> put_flash(:info, "Profile updated successfully.")
         |> assign(form: form)}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
