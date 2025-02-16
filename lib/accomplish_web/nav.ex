defmodule AccomplishWeb.Nav do
  @moduledoc false

  import Phoenix.LiveView, only: [attach_hook: 4]
  import Phoenix.Component, only: [assign: 2]

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:current_path, :handle_params, &set_current_path/3)}
  end

  defp set_current_path(_params, url, socket) do
    {:cont, assign(socket, current_path: URI.parse(url).path)}
  end
end
