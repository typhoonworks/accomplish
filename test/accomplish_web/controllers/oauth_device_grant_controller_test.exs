defmodule AccomplishWeb.OAuthDeviceGrantControllerTest do
  use AccomplishWeb.ConnCase, async: true

  alias Accomplish.OAuthFixtures
  alias Accomplish.Repo
  alias Accomplish.OAuth.DeviceGrant

  @valid_scope "user:read,user:write"

  describe "POST /auth/device/code" do
    setup do
      application = OAuthFixtures.oauth_application_fixture()
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
               "interval" => 5
             } = json_response(conn, 200)

      device_grant = Repo.get_by(DeviceGrant, device_code: device_code)
      assert device_grant
      assert device_grant.user_code == user_code
      assert device_grant.expires_in == expires_in
      assert device_grant.application_id == application.id
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
end
