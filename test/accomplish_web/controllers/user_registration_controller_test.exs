defmodule AccomplishWeb.UserRegistrationControllerTest do
  use AccomplishWeb.ConnCase, async: true

  import Accomplish.AccountsFixtures

  describe "GET /signup" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, ~p"/signup")
      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ ~p"/login"
      assert response =~ ~p"/signup"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(~p"/signup")

      assert redirected_to(conn) == ~p"/dashboard"
    end
  end

  describe "POST /signup" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, ~p"/signup", %{
          "user" => valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/dashboard"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ ~p"/settings"
      assert response =~ ~p"/logout"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, ~p"/signup", %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
