defmodule AccomplishWeb.Plugs.AdminAuth do
  import Plug.Conn
  import Phoenix.Controller

  def require_admin_user(conn, _opts) do
    if conn.assigns[:current_user] && conn.assigns[:current_user].role == :admin do
      conn
    else
      conn
      |> put_flash(:error, "You must be an admin to access this page.")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
