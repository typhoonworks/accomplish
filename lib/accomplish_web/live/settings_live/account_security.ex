defmodule AccomplishWeb.SettingsLive.AccountSecurity do
  use AccomplishWeb, :live_view

  alias Accomplish.Accounts

  import AccomplishWeb.Layout
  import AccomplishWeb.Shadowrun.Forms

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path} sidebar_context={:settings}>
      <div class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
        <h3 class="text-xl text-zinc-50">Password & Security</h3>

        <section class="mt-12">
          <div class="space-y-4">
            <h2 class="text-lg text-zinc-50">Change Password</h2>
            <.shadow_box>
              <.form
                for={@password_form}
                id="password_form"
                action={~p"/members/log_in?_action=password_updated"}
                method="post"
                phx-change="validate_password"
                phx-submit="update_password"
                phx-trigger-action={@trigger_submit}
                class="md:col-span-2"
              >
                <input
                  name={@password_form[:email].name}
                  type="hidden"
                  id="hidden_member_email"
                  value={@current_email}
                />
                <div class="space-y-6">
                  <div>
                    <.shadow_structured_input
                        field={@password_form[:current_password]}
                        name="current_password"
                        type="password"
                        label="Current password"
                        autocomplete="password"
                        id="current_password_for_password"
                        value={@current_password}
                      />
                  </div>

                  <div>
                    <.shadow_structured_input
                      field={@password_form[:password]}
                      type="password"
                      label="New password"
                      autocomplete="new-password"
                    />
                  </div>

                  <div>
                    <.shadow_structured_input
                      field={@password_form[:password_confirmation]}
                      type="password"
                      label="Confirm new password"
                      autocomplete="new-password"
                    />
                  </div>
                </div>

                <div class="mt-8 flex">
                  <.shadow_button phx-disable-with="Changing...">
                    Save
                  </.shadow_button>
                </div>
              </.form>
            </.shadow_box>
          </div>
        </section>

        <section class="mt-12">
          <div class="space-y-4">
            <h3 class="text-lg text-zinc-50">Change Email</h3>
            <.shadow_box>
              <.form
                for={@email_form}
                id="email_form"
                phx-submit="update_email"
                phx-change="validate_email"
                class="md:col-span-2"
              >
                <div class="space-y-6">
                  <div>
                    <.shadow_structured_input
                      field={@email_form[:email]}
                      type="email"
                      label="Email"
                      autocomplete="email"
                    />
                  </div>

                  <div>
                    <.shadow_structured_input
                      field={@email_form[:current_password]}
                      name="current_password"
                      type="password"
                      label="Current password"
                      autocomplete="password"
                      id="current_password_for_email"
                      value={@email_form_current_password}
                    />
                  </div>
                </div>

                <div class="mt-8 flex">
                  <.shadow_button phx-disable-with="Changing...">
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

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/settings/account/security")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:page_title, "Password & Security")
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/settings/email_confirmation/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
