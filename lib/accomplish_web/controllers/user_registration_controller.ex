defmodule AccomplishWeb.UserRegistrationController do
  use AccomplishWeb, :controller

  alias Accomplish.Accounts
  alias Accomplish.Accounts.User
  alias AccomplishWeb.Plugs.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})

    conn
    |> put_layout(html: {AccomplishWeb.Layouts, :auth})
    |> render(:new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/confirm_user/#{&1}")
          )

        conn
        |> put_flash(:info, "Account created successfully!")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
