defmodule AccomplishWeb.OAuthDeviceGrantControllerTest do
  use AccomplishWeb.ConnCase, async: true

  import Accomplish.AccountsFixtures
  import Accomplish.OAuthFixtures
  alias Accomplish.Repo
  alias Accomplish.OAuth.DeviceGrant
  alias Accomplish.OAuth

  @valid_scope "user:read,user:write"

  describe "POST /auth/device/code" do
    setup do
      application = oauth_application_fixture()
      %{application: application}
    end

    test "successfully issues device and user codes", %{conn: conn, application: application} do
      conn =
        post(conn, ~p"/auth/device/code", %{
          "client_id" => application.uid,
          "scope" => @valid_scope
        })

      assert %{
               "device_code" => device_code,
               "user_code" => user_code,
               "expires_in" => expires_in,
               "interval" => 5,
               "verification_uri" => verification_uri,
               "verification_uri_complete" => verification_uri_complete
             } = json_response(conn, 200)

      device_grant = Repo.get_by(DeviceGrant, device_code: device_code)
      assert device_grant
      assert device_grant.user_code == user_code
      assert device_grant.expires_in == expires_in
      assert device_grant.application_id == application.id

      base_uri = AccomplishWeb.Endpoint.url() <> ~p"/auth/device/verify"
      assert verification_uri == base_uri
      assert verification_uri_complete == "#{base_uri}?user_code=#{user_code}"
    end

    test "returns unauthorized error for invalid client_id", %{conn: conn} do
      conn =
        post(conn, ~p"/auth/device/code", %{
          "client_id" => "invalid_client_id",
          "scope" => @valid_scope
        })

      assert response(conn, 401)
      assert json_response(conn, 401) == %{"error" => "invalid_client"}
    end

    test "returns bad request error for invalid scope", %{conn: conn, application: application} do
      conn =
        post(conn, ~p"/auth/device/code", %{
          "client_id" => application.uid,
          "scope" => "read:user"
        })

      assert response(conn, 400)
      assert %{"error" => "invalid_request", "details" => _details} = json_response(conn, 400)
    end

    test "does not duplicate device codes for multiple requests", %{
      conn: conn,
      application: application
    } do
      conn =
        post(conn, ~p"/auth/device/code", %{
          "client_id" => application.uid,
          "scope" => @valid_scope
        })

      assert %{"device_code" => device_code1} = json_response(conn, 200)

      conn =
        post(conn, ~p"/auth/device/code", %{
          "client_id" => application.uid,
          "scope" => @valid_scope
        })

      assert %{"device_code" => device_code2} = json_response(conn, 200)

      # Ensure the device codes are unique
      assert device_code1 != device_code2
    end
  end

  describe "GET /auth/device/verify" do
    setup do
      %{user: user_fixture()}
    end

    test "redirects if user is not logged in", %{conn: conn} do
      conn = get(conn, ~p"/auth/device/verify")
      assert redirected_to(conn) == ~p"/users/log_in"
    end

    test "renders the verification page without a user_code", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/auth/device/verify")
      assert html_response(conn, 200) =~ "Enter the user code below to link your device."
    end

    test "renders the verification page with a prepopulated user_code", %{conn: conn, user: user} do
      user_code = "ABC123"

      conn =
        conn |> log_in_user(user) |> get(~p"/auth/device/verify", %{"user_code" => user_code})

      assert html_response(conn, 200) =~ "Enter the user code below to link your device."
      assert html_response(conn, 200) =~ "value=\"#{String.at(user_code, 0)}\""
    end
  end

  describe "POST /auth/device/verify" do
    setup do
      application = oauth_application_fixture()
      device_grant = oauth_device_grant_fixture(application, ["user:read", "user:write"])
      user = user_fixture()
      %{application: application, device_grant: device_grant, user: user}
    end

    test "redirects if user is not logged in", %{conn: conn} do
      conn = get(conn, ~p"/auth/device/verify")
      assert redirected_to(conn) == ~p"/users/log_in"
    end

    test "successfully links a device", %{
      conn: conn,
      application: application,
      device_grant: device_grant,
      user: user
    } do
      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/auth/device/verify", %{"user_code" => device_grant.user_code})

      assert redirected_to(conn) ==
               "#{application.redirect_uri}?device_code=#{device_grant.device_code}"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Device successfully linked"
    end

    test "shows an error for invalid or expired user_code", %{conn: conn, user: user} do
      conn =
        conn |> log_in_user(user) |> post(~p"/auth/device/verify", %{"user_code" => "INVALID"})

      assert redirected_to(conn) == ~p"/auth/device/verify"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "Invalid or expired user code"
    end

    test "shows an error for an already-linked device", %{
      conn: conn,
      device_grant: device_grant,
      user: user
    } do
      {:ok, _} = OAuth.link_device_grant_to_user(device_grant, user.id)

      conn =
        conn
        |> log_in_user(user)
        |> post(~p"/auth/device/verify", %{"user_code" => device_grant.user_code})

      assert redirected_to(conn) == ~p"/auth/device/verify"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "This device has already been linked"
    end
  end

  describe "POST /token" do
    setup do
      application = oauth_application_fixture()
      user = user_fixture()
      %{application: application, user: user}
    end

    test "successfully issues an access token", %{
      conn: conn,
      application: application,
      user: user
    } do
      {:ok, device_grant} =
        oauth_device_grant_fixture(application, ["user:read", "user:write"])
        |> OAuth.link_device_grant_to_user(user.id)

      conn =
        post(conn, ~p"/auth/device/token", %{
          "device_code" => device_grant.device_code
        })

      assert %{
               "access_token" => access_token,
               "token_type" => "Bearer",
               "expires_in" => expires_in,
               "refresh_token" => refresh_token,
               "scope" => "user:read,user:write"
             } = json_response(conn, 200)

      access_token_record = OAuth.get_access_token_by_token(access_token)

      assert access_token_record
      assert access_token_record.application_id == application.id
      assert access_token_record.user_id == user.id
      assert access_token_record.scopes == ["user:read", "user:write"]
      assert access_token_record.refresh_token == refresh_token
      assert access_token_record.expires_in == expires_in
    end

    test "returns unauthorized for an unauthorized device grant", %{
      conn: conn,
      application: application
    } do
      device_grant = oauth_device_grant_fixture(application, ["user:read", "user:write"])

      conn =
        post(conn, ~p"/auth/device/token", %{
          "device_code" => device_grant.device_code
        })

      assert response(conn, 401)
      assert json_response(conn, 401) == %{"error" => "authorization_pending"}
    end

    test "returns bad request for an expired device grant", %{
      conn: conn,
      application: application
    } do
      device_grant =
        oauth_device_grant_fixture(application, ["user:read", "user:write"])
        |> Ecto.Changeset.change(inserted_at: DateTime.add(DateTime.utc_now(), -601))
        |> Repo.update!()

      conn =
        post(conn, ~p"/auth/device/token", %{
          "device_code" => device_grant.device_code
        })

      assert response(conn, 400)
      assert json_response(conn, 400) == %{"error" => "expired_token"}
    end

    test "returns bad request for an invalid device_code", %{conn: conn} do
      conn =
        post(conn, ~p"/auth/device/token", %{
          "device_code" => "invalid-code"
        })

      assert response(conn, 400)
      assert json_response(conn, 400) == %{"error" => "not_found"}
    end
  end
end
