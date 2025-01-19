defmodule AccomplishWeb.API.CLIControllerTest do
  use AccomplishWeb.ConnCase, async: true

  alias Accomplish.Accounts.CliToken

  describe "initiate_login/2" do
    test "generates a verification URL and token for CLI", %{conn: conn} do
      cli_version = "1.0.0"

      conn =
        post(conn, ~p"/api/cli/auth/initiate", %{"cli_version" => cli_version})

      assert %{"verification_url" => verification_url, "token" => raw_token} =
               json_response(conn, 200)

      assert String.contains?(verification_url, "http://localhost:4000/users/log_in?cli_token=")
      assert String.contains?(verification_url, raw_token)

      {:ok, decoded_token} = Base.url_decode64(raw_token, padding: false)
      hashed_token = :crypto.hash(:sha256, decoded_token) |> Base.encode16(case: :lower)
      assert Accomplish.Repo.get_by(CliToken, token: hashed_token)
    end

    test "returns 400 when cli_version is not provided", %{conn: conn} do
      conn = post(conn, ~p"/api/cli/auth/initiate", %{})

      assert json_response(conn, 400) == %{"error" => "cli_version is required"}
    end
  end
end
