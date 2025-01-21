defmodule AccomplishWeb.Plugs.AuthorizeAPIKeyTest do
  use AccomplishWeb.ConnCase, async: true

  alias AccomplishWeb.Plugs.AuthorizeAPIKey

  test "halts with error when basic token is missing", %{conn: conn} do
    conn =
      conn
      |> assign(:api_scope, "repository:read")
      |> AuthorizeAPIKey.call(%{})

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Missing API key."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end

  test "halts with error when basic token is invalid", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Basic invalid_token")
      |> assign(:api_scope, "repository:read")
      |> AuthorizeAPIKey.call(%{})

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Invalid API key."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end

  test "halts with error when API key lacks required scope", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repository:write"])
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> assign(:api_scope, "repository:read")
      |> AuthorizeAPIKey.call(%{})

    assert conn.halted
    assert json_response(conn, 403)["error"]["message"] =~ "Insufficient scope for this API key."
    assert json_response(conn, 403)["error"]["type"] == "invalid_request_error"
  end

  test "passes and assigns authorized user when valid API key with required scope is provided", %{
    conn: conn
  } do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repository:read"])
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> assign(:api_scope, "repository:read")
      |> AuthorizeAPIKey.call(%{})

    refute conn.halted
    assert conn.assigns.authorized_user.id == user.id
  end

  test "passes with wildcard scope", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repository:*"])
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> assign(:api_scope, "repository:read")
      |> AuthorizeAPIKey.call(%{})

    refute conn.halted
    assert conn.assigns.authorized_user.id == user.id
  end

  test "halts with error when trying to access write scope with read-only API key", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repository:read"])
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> assign(:api_scope, "repository:write")
      |> AuthorizeAPIKey.call(%{})

    assert conn.halted
    assert json_response(conn, 403)["error"]["message"] =~ "Insufficient scope for this API key."
    assert json_response(conn, 403)["error"]["type"] == "invalid_request_error"
  end

  test "halts with error when API key is revoked", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repository:read"])
    :ok = Accomplish.Accounts.revoke_api_key(api_key.raw_key)
    authorization = Base.encode64("#{api_key.raw_key}:")

    conn =
      conn
      |> put_req_header("authorization", "Basic #{authorization}")
      |> assign(:api_scope, "repository:read")
      |> AuthorizeAPIKey.call(%{})

    assert conn.halted
    assert json_response(conn, 401)["error"]["message"] =~ "Invalid API key."
    assert json_response(conn, 401)["error"]["type"] == "invalid_request_error"
  end
end
