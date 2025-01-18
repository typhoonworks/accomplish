defmodule AccomplishWeb.Plugs.AuthorizePublicAPITest do
  use AccomplishWeb.ConnCase, async: true

  import Accomplish.AccountsFixtures

  test "halts with error when bearer token is missing", %{conn: conn} do
    conn =
      conn
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Missing API key."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end

  test "halts with error when using bearer token authorization", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Bearer invalid_token")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Unsupported authentication scheme."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end

  test "halts with error when basic token is invalid", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Basic invalid_token")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Invalid API key."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end

  test "halts with error when API key lacks required scope", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:write"])
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")

    assert conn.halted
    assert json_response(conn, 403)["error"]["message"] =~ "Insufficient scope for this API key."
    assert json_response(conn, 403)["error"]["type"] == "invalid_request_error"
  end

  test "passes and assigns authorized user when valid API key with required scope is provided", %{
    conn: conn
  } do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:read"])
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")

    refute conn.halted
    assert conn.assigns.authorized_user.id == user.id
  end

  test "passes with wildcard scope", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:*"])
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")

    refute conn.halted
    assert conn.assigns.authorized_user.id == user.id
  end

  test "halts with error when trying to access write scope with read-only API key", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:read"])
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> post(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:write")

    assert conn.halted
    assert json_response(conn, 403)["error"]["message"] =~ "Insufficient scope for this API key."
    assert json_response(conn, 403)["error"]["type"] == "invalid_request_error"
  end

  test "halts with error when API key is revoked", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:read"])
    :ok = Accomplish.Accounts.revoke_api_key(api_key.raw_key)
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Invalid API key."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end
end
