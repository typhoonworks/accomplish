defmodule AccomplishWeb.Plugs.AuthorizePublicAPITest do
  use AccomplishWeb.ConnCase, async: true

  alias AccomplishWeb.Plugs.AuthorizePublicAPI

  import Accomplish.AccountsFixtures
  # import Accomplish.RepositoriesFixtures

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(AccomplishWeb.Router)

    {:ok, conn: conn}
  end

  test "halts with error when bearer token is missing", %{conn: conn} do
    conn =
      conn
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")
      |> AuthorizePublicAPI.call(nil)

    assert conn.halted
    assert json_response(conn, 401)["error"] =~ "Missing API key."
  end

  test "halts with error when bearer token is invalid", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Bearer invalid_token")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")
      |> AuthorizePublicAPI.call(nil)

    assert conn.halted
    assert json_response(conn, 401)["error"] =~ "Invalid API key."
  end

  test "halts with error when API key lacks required scope", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:write"])

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{api_key.raw_key}")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")
      |> AuthorizePublicAPI.call(nil)

    assert conn.halted
    assert json_response(conn, 403)["error"] =~ "Insufficient scope for this API key."
  end

  test "passes and assigns authorized user when valid API key with required scope is provided", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:read"])

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{api_key.raw_key}")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")
      |> AuthorizePublicAPI.call(nil)

    refute conn.halted
    assert conn.assigns.authorized_user.id == user.id
  end

  test "passes with wildcard scope", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:*"])

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{api_key.raw_key}")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")
      |> AuthorizePublicAPI.call(nil)

    refute conn.halted
    assert conn.assigns.authorized_user.id == user.id
  end

  test "halts with error when trying to access write scope with read-only API key", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:read"])

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{api_key.raw_key}")
      |> post(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:write")
      |> AuthorizePublicAPI.call(nil)

    assert conn.halted
    assert json_response(conn, 403)["error"] =~ "Insufficient scope for this API key."
  end

  test "halts with error when API key is revoked", %{conn: conn} do
    user = user_fixture()
    api_key = api_key_fixture(user, scopes: ["repositories:read"])
    :ok = Accomplish.Accounts.revoke_api_key(api_key.raw_key)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{api_key.raw_key}")
      |> get(~p"/api/v1/repositories")
      |> assign(:api_scope, "repositories:read")
      |> AuthorizePublicAPI.call(nil)

    assert conn.halted
    assert json_response(conn, 401)["error"] =~ "Invalid API key."
  end
end
