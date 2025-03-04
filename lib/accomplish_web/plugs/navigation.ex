defmodule AccomplishWeb.Plugs.Navigation do
  @moduledoc """
  Handles navigation state tracking for the application.
  Tracks the current path for all LiveViews and records navigation history
  for tracked sessions.
  """

  import Phoenix.LiveView, only: [attach_hook: 4]
  import Phoenix.Component, only: [assign: 2]

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:current_path, :handle_params, &set_current_path/3)}
  end

  def on_mount(:track_history, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:navigation_history, :handle_params, &record_navigation_history/3)}
  end

  defp set_current_path(_params, url, socket) do
    {:cont, assign(socket, current_path: URI.parse(url).path)}
  end

  defp record_navigation_history(_params, url, socket) do
    if socket.assigns.current_user && Phoenix.LiveView.connected?(socket) do
      path = URI.parse(url).path
      user_id = socket.assigns.current_user.id

      AccomplishWeb.NavigationTracker.record_path(user_id, path)
    end

    {:cont, socket}
  end
end
