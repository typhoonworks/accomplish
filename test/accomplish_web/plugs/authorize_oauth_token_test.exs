defmodule AccomplishWeb.Plugs.AuthorizeOAuthTokenTest do
  use AccomplishWeb.ConnCase, async: true

  alias Accomplish.Repo
  alias AccomplishWeb.Plugs.AuthorizeOAuthToken

  test "halts with error when OAuth token is missing", %{conn: conn} do
    conn =
      conn
      |> assign(:api_scope, "repositories:read")
      |> AuthorizeOAuthToken.call(%{})

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Missing OAuth token."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end

  test "halts with error when OAuth token is invalid", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Bearer invalid_token")
      |> assign(:api_scope, "repositories:read")
      |> AuthorizeOAuthToken.call(%{})

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Invalid or expired OAuth token."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end

  test "halts with error when OAuth token has expired", %{conn: conn} do
    application = oauth_application_fixture()
    user = user_fixture()

    expired_token =
      oauth_access_token_fixture(user, application)
      |> Ecto.Changeset.change(
        inserted_at: DateTime.add(DateTime.utc_now(), -7200),
        expires_in: 3600
      )
      |> Repo.update!()

    authorization = "Bearer #{expired_token.token}"

    conn =
      conn
      |> put_req_header("authorization", authorization)
      |> assign(:api_scope, "repositories:read")
      |> AuthorizeOAuthToken.call(%{})

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Invalid or expired OAuth token."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end

  test "passes and assigns authorized user and application when valid OAuth token is provided", %{
    conn: conn
  } do
    user = user_fixture()
    application = oauth_application_fixture()
    access_token = oauth_access_token_fixture(user, application, %{scopes: ["repository:read"]})

    authorization = "Bearer #{access_token.token}"

    conn =
      conn
      |> put_req_header("authorization", authorization)
      |> assign(:api_scope, "repository:read")
      |> AuthorizeOAuthToken.call(%{})

    refute conn.halted
    assert conn.assigns.authorized_user.id == user.id
    assert conn.assigns.current_oauth_application.id == application.id
    assert conn.assigns.current_access_token.token == access_token.token
  end

  test "halts with error when trying to access a resource with insufficient scope", %{conn: conn} do
    user = user_fixture()
    application = oauth_application_fixture()
    access_token = oauth_access_token_fixture(user, application, scopes: ["user:read"])

    authorization = "Bearer #{access_token.token}"

    conn =
      conn
      |> put_req_header("authorization", authorization)
      |> assign(:api_scope, "repository:read")
      |> AuthorizeOAuthToken.call(%{})

    assert conn.halted

    assert json_response(conn, 403)["error"]["message"] =~
             "Insufficient scope for this OAuth token."

    assert json_response(conn, 403)["error"]["type"] == "invalid_request_error"
  end
end
