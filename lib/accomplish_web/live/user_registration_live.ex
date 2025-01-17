defmodule AccomplishWeb.UserRegistrationLive do
  use AccomplishWeb, :live_view

  alias Accomplish.Accounts
  alias Accomplish.Accounts.User

  import SaladUI.Form

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Log in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.form
        :let={f}
        for={@form}
        id="registration_form"
        class="mt-10 space-y-6"
        phx-submit="save"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.form_item>
          <.form_label error={not Enum.empty?(f[:email].errors)}>Email</.form_label>
          <.input field={f[:email]} type="email" phx-debounce="500" />
        </.form_item>

        <.form_item>
          <.form_label error={not Enum.empty?(f[:password].errors)}>Password</.form_label>
          <.input field={f[:password]} type="password" phx-debounce="500" />
          <%!-- <.form_message field={f[:password]} /> --%>
          <.form_description>
            Password must be between 12 and 72 characters long.
          </.form_description>
        </.form_item>

        <.form_item>
          <.form_label error={not Enum.empty?(f[:username].errors)}>Username</.form_label>
          <.input field={f[:username]} type="text" phx-debounce="500" />
          <.form_description>
            Username may only contain alphanumeric characters or single hyphens, and cannot begin or end with a hyphen.
          </.form_description>
        </.form_item>
        <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
