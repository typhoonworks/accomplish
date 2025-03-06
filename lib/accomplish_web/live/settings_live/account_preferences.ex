defmodule AccomplishWeb.SettingsLive.AccountPreferences do
  use AccomplishWeb, :live_view

  import AccomplishWeb.Layout

  def render(assigns) do
    ~H"""
    <.layout current_user={@current_user} current_path={@current_path} sidebar_context={:settings}>
      <section class="max-w-3xl mx-auto px-6 lg:px-8 mt-24">
        <div class="space-y-4">
          <h3 class="text-xl text-zinc-50">Preferences</h3>
          <.shadow_box>Hello</.shadow_box>
        </div>
      </section>
    </.layout>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Preferences")

    {:ok, socket}
  end
end
