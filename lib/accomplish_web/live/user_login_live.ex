defmodule AccomplishWeb.UserLoginLive do
  use AccomplishWeb, :live_view

  import SaladUI.Form

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.form
        :let={f}
        for={@form}
        id="login_form"
        class="mt-10 space-y-6"
        phx-update="ignore"
        action={~p"/users/log_in"}
        method="post"
      >
        <.form_item>
          <.form_label error={not Enum.empty?(f[:email].errors)}>Email</.form_label>
          <.input field={f[:email]} type="email" required />
        </.form_item>

        <.form_item>
          <.form_label error={not Enum.empty?(f[:password].errors)}>Password</.form_label>
          <.input field={f[:password]} type="password" required />
        </.form_item>

        <.form_item class="flex items-center justify-between">
          <.input field={f[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </.form_item>

        <.button phx-disable-with="Logging in..." class="w-full">
          Log in <span aria-hidden="true">→</span>
        </.button>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
