defmodule AccomplishWeb.OAuthIntrospectionControllerTest do
  use AccomplishWeb.ConnCase, async: true

  alias Accomplish.Repo
  alias Accomplish.OAuth

  describe "POST /auth/token_info" do
    setup do
      application = oauth_application_fixture()
      user = user_fixture()
      access_token = oauth_access_token_fixture(user, application)
      authorization = "Bearer #{access_token.token}"

      %{
        application: application,
        user: user,
        access_token: access_token,
        authorization: authorization
      }
    end

    test "successfully introspects a valid token", %{
      conn: conn,
      access_token: access_token,
      application: application,
      user: user,
      authorization: authorization
    } do
      conn =
        conn
        |> put_req_header("authorization", authorization)
        |> post(~p"/auth/token_info", %{"token" => access_token.token})

      assert %{
               "active" => true,
               "scope" => "user:read,user:write",
               "client_id" => client_id,
               "username" => username,
               "exp" => _exp
             } = json_response(conn, 200)

      assert client_id == application.uid
      assert username == user.username

      token = OAuth.get_access_token_by_token(access_token.token)
      assert token != nil
    end

    test "returns unauthorized error for an invalid token", %{
      conn: conn,
      authorization: authorization
    } do
      conn =
        conn
        |> put_req_header("authorization", authorization)
        |> post(~p"/auth/token_info", %{"token" => "invalid_token"})

      assert response(conn, 401)
      assert json_response(conn, 401) == %{"error" => "Invalid token"}
    end

    test "returns unauthorized error for a revoked token", %{
      conn: conn,
      access_token: access_token,
      authorization: authorization
    } do
      {:ok, revoked_token} = OAuth.revoke_access_token(access_token)
      assert revoked_token.revoked_at != nil

      conn =
        conn
        |> put_req_header("authorization", authorization)
        |> post(~p"/auth/token_info", %{"token" => revoked_token.token})

      assert response(conn, 401)

      assert json_response(conn, 401) == %{
               "error" => %{
                 "message" => "Invalid or expired OAuth token.",
                 "type" => "invalid_request_error"
               }
             }
    end

    test "returns unauthorized error for an expired token", %{
      conn: conn,
      access_token: access_token,
      authorization: authorization
    } do
      expired_token =
        access_token
        |> Ecto.Changeset.change(
          inserted_at: DateTime.add(DateTime.utc_now(), -7200),
          expires_in: 3600
        )
        |> Repo.update!()

      conn =
        conn
        |> put_req_header("authorization", authorization)
        |> post(~p"/auth/token_info", %{"token" => expired_token.token})

      assert response(conn, 401)

      assert json_response(conn, 401) == %{
               "error" => %{
                 "message" => "Invalid or expired OAuth token.",
                 "type" => "invalid_request_error"
               }
             }
    end
  end

  describe "POST /auth/refresh_token" do
    setup do
      application = oauth_application_fixture()
      user = user_fixture()
      access_token = oauth_access_token_fixture(user, application)

      %{application: application, user: user, access_token: access_token}
    end

    test "successfully refreshes an access token", %{
      conn: conn,
      access_token: access_token
    } do
      conn =
        post(conn, ~p"/auth/refresh_token", %{
          "grant_type" => "refresh_token",
          "refresh_token" => access_token.refresh_token
        })

      assert %{
               "access_token" => new_access_token,
               "token_type" => "Bearer",
               "expires_in" => expires_in,
               "refresh_token" => new_refresh_token,
               "scope" => scopes
             } = json_response(conn, 200)

      assert new_access_token != access_token.token
      assert new_refresh_token != access_token.refresh_token
      assert expires_in > 0
      assert scopes == Enum.join(access_token.scopes, ",")
    end

    test "returns unauthorized for invalid refresh token", %{conn: conn} do
      conn =
        post(conn, ~p"/auth/refresh_token", %{
          "grant_type" => "refresh_token",
          "refresh_token" => "invalid_refresh_token"
        })

      assert response(conn, 401)

      assert json_response(conn, 401) == %{
               "error" => "invalid_grant",
               "error_description" => "Invalid or expired refresh token."
             }
    end

    test "returns bad request for other errors", %{
      conn: conn,
      access_token: access_token
    } do
      expired_token =
        access_token
        |> Ecto.Changeset.change(
          inserted_at: DateTime.add(DateTime.utc_now(), -7200),
          expires_in: 3600
        )
        |> Repo.update!()

      conn =
        post(conn, ~p"/auth/refresh_token", %{
          "grant_type" => "refresh_token",
          "refresh_token" => expired_token.refresh_token
        })

      assert response(conn, 400)
      assert json_response(conn, 400) == %{"error" => "token_expired"}
    end
  end
end
