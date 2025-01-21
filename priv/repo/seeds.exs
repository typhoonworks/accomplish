# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Accomplish.Repo.insert!(%Accomplish.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Accomplish.Repo
alias Accomplish.Accounts

IO.puts("Cleaning up the database...")

tables = [
  "api_keys",
  "users",
  "oauth_applications"
]

for table <- tables do
  Repo.query!("TRUNCATE TABLE #{table} CASCADE")
end

IO.puts("Creating OAuth application...")

attrs = %{
  name: "Accomplish CLI",
  redirect_uri: "http://127.0.0.1:8000/callback",
  confidential: true,
  scopes: ["user:read", "user:write"],
  # 90 days
  token_ttl: 90 * 24 * 60 * 60
}

{:ok, app} = Accomplish.OAuth.create_application(attrs)

IO.puts("Creating initial user...")

{:ok, user} =
  Accounts.register_user(
    %{
      email: "rod@me.local",
      password: "password@123",
      username: "rod"
    },
    min_length: 3
  )

if Mix.env() == :dev do
  IO.puts("Generating API key for development environment...")

  dev_api_scopes = ~w(
    repositories:read
    repositories:write
  )

  {:ok, api_key} =
    Accounts.create_api_key(user, %{name: "Development API Key", scopes: dev_api_scopes})

  IO.puts("""
  =====================================
  OAuth Application for Development:
  Client ID: #{app.uid}
  Secret: #{app.secret}
  =====================================

    You can use the following curl command to trigger device auth flows

    ```
    curl -X POST http://localhost:4000/auth/device/code \
    -H "Content-Type: application/json" \
    -d '{
      "client_id": "#{app.uid}",
      "scope": "user:read,user:write"
    }'
    ```
  """)

  IO.puts("""
  =====================================
  API Key for Development:
  #{api_key.raw_key}
  =====================================
  """)
end
