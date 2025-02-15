defmodule AccomplishWeb.Nav do
  @moduledoc false

  import Phoenix.LiveView, only: [attach_hook: 4]
  import Phoenix.Component, only: [assign: 2]

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:active_tab, :handle_params, &set_active_tab/3)}
  end

  defp set_active_tab(_params, url, socket) do
    {:cont, assign(socket, current_path: URI.parse(url).path)}
  end
end
