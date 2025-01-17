defmodule AccomplishWeb.SessionTimezoneController do
  use AccomplishWeb, :controller

  def set(conn, %{"timezone" => timezone}) when is_number(timezone) do
    conn |> put_session(:timezone, timezone) |> json(%{})
  end
end
