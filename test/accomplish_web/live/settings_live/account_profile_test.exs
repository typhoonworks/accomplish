defmodule AccomplishWeb.SettingsLive.AccountProfileTest do
  use AccomplishWeb.ConnCase, async: true

  alias Accomplish.Accounts
  import Phoenix.LiveViewTest
  import Accomplish.AccountsFixtures

  describe "Settings account profile page" do
    test "renders settings account profile page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/settings/account/profile")

      assert html =~ "Profile"
      assert html =~ "Full name"
      assert html =~ "Username"
    end

    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/settings/account/profile")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/login"
      assert %{"error" => "You must log in to access this page."} = flash
    end
  end

  describe "update profile form" do
    setup %{conn: conn} do
      user =
        user_fixture(%{
          username: "johndoe"
        })

      %{conn: log_in_user(conn, user), user: user}
    end

    test "renders the existing user profile data", %{conn: conn, user: user} do
      {:ok, lv, html} = live(conn, ~p"/settings/account/profile")

      assert html =~ "Full name"
      assert html =~ "Username"

      assert has_element?(lv, ~s|input[value="#{user.username}"]|)
    end

    test "updates profile with valid data", %{conn: conn, user: user} do
      {:ok, lv, _html} = live(conn, ~p"/settings/account/profile")

      new_full_name = "Jane Smith"
      new_username = "janesmith"

      result =
        lv
        |> form("#profile_form", %{
          "user" => %{
            "full_name" => new_full_name,
            "username" => new_username
          }
        })
        |> render_submit()

      assert result =~ "Jane Smith"

      updated_user = Accounts.get_user!(user.id)
      assert updated_user.first_name == "Jane"
      assert updated_user.last_name == "Smith"
      assert updated_user.username == "janesmith"
    end

    test "updates only the first name when last name is not provided", %{conn: conn, user: user} do
      {:ok, lv, _html} = live(conn, ~p"/settings/account/profile")

      result =
        lv
        |> form("#profile_form", %{
          "user" => %{
            "full_name" => "Alice",
            "username" => user.username
          }
        })
        |> render_submit()

      assert result =~ "Alice"

      updated_user = Accounts.get_user!(user.id)
      assert updated_user.first_name == "Alice"
      assert updated_user.last_name == nil
    end

    test "handles multi-word last names correctly", %{conn: conn, user: user} do
      {:ok, lv, _html} = live(conn, ~p"/settings/account/profile")

      result =
        lv
        |> form("#profile_form", %{
          "user" => %{
            "full_name" => "Robert Van Winkle",
            "username" => user.username
          }
        })
        |> render_submit()

      assert result =~ "Robert Van Winkle"

      updated_user = Accounts.get_user!(user.id)
      assert updated_user.first_name == "Robert"
      assert updated_user.last_name == "Van Winkle"
    end

    test "renders errors with invalid username (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/settings/account/profile")

      result =
        lv
        |> element("#profile_form")
        |> render_change(%{
          "user" => %{
            "full_name" => "Valid Name",
            "username" => "invalid username with spaces"
          }
        })

      assert result =~ "has invalid format"
    end

    test "renders errors with invalid username (phx-submit)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/settings/account/profile")

      result =
        lv
        |> form("#profile_form", %{
          "user" => %{
            "full_name" => "Valid Name",
            "username" => "-invalid-"
          }
        })
        |> render_submit()

      assert result =~ "Profile"
      assert result =~ "has invalid format"
    end

    test "validates username length", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/settings/account/profile")

      result =
        lv
        |> form("#profile_form", %{
          "user" => %{
            "full_name" => "Valid Name",
            "username" => "abc"
          }
        })
        |> render_submit()

      assert result =~ "should be at least 4 character(s)"
    end

    test "prevents duplicate usernames", %{conn: conn} do
      other_user = user_fixture(%{username: "takenname"})

      {:ok, lv, _html} = live(conn, ~p"/settings/account/profile")

      result =
        lv
        |> form("#profile_form", %{
          "user" => %{
            "full_name" => "Valid Name",
            "username" => other_user.username
          }
        })
        |> render_submit()

      assert result =~ "has already been taken"
    end
  end
end
