defmodule AccomplishWeb.GoBackComponent do
  @moduledoc false

  use AccomplishWeb, :live_component

  def render(assigns) do
    ~H"""
    <button
      id={@id}
      type="button"
      class="flex items-center gap-2 px-2 py-1.5 text-[13px] tracking-tight rounded-md transition-all text-zinc-400 hover:bg-zinc-800 hover:text-zinc-50"
      phx-click="navigate_to_last_tracked"
      phx-target={@myself}
    >
      <.icon name="hero-chevron-left" class="size-4 text-current group-hover:text-zinc-50" />
      <span>Back to app</span>
    </button>
    """
  end

  def handle_event("navigate_to_last_tracked", _params, socket) do
    user_id = socket.assigns.current_user.id
    last_path = AccomplishWeb.NavigationTracker.get_last_path(user_id)

    {:noreply, push_navigate(socket, to: last_path)}
  end
end
