defmodule AccomplishWeb.SettingsLive.ConnectedAccounts do
  use AccomplishWeb, :live_view

  alias Accomplish.Accounts

  import AccomplishWeb.Layout

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path} sidebar_context={:settings}>
      <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
        <div class="space-y-4">
          <h3 class="text-xl text-zinc-50">Connected accounts</h3>
          <.shadow_box>Hello</.shadow_box>
        </div>
      </section>
    </.layout>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Connected accounts")

    {:ok, socket}
  end
end
