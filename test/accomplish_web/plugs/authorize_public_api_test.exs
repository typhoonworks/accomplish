defmodule AccomplishWeb.Plugs.AuthorizePublicAPITest do
  use AccomplishWeb.ConnCase, async: true

  alias AccomplishWeb.Plugs.AuthorizePublicAPI

  test "halts with error when basic token or bearer token is missing", %{conn: conn} do
    conn =
      conn
      |> assign(:api_scope, "repository:read")
      |> AuthorizePublicAPI.call(%{})

    assert conn.halted
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
      |> AuthorizePublicAPI.call(%{})

    refute conn.halted
    assert conn.assigns.authorized_user.id == user.id
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
      |> AuthorizePublicAPI.call(%{})

    refute conn.halted
    assert conn.assigns.authorized_user.id == user.id
  end
end
