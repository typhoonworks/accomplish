defmodule AccomplishWeb.PageController do
  use AccomplishWeb, :controller

  def home(conn, _params) do
    conn
    |> put_layout(html: {AccomplishWeb.Layouts, :landing})
    |> render(:home)
  end
end
