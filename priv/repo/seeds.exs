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
alias Accomplish.{Accounts}

IO.puts("Cleaning up the database...")

tables = [
  "users"
]

for table <- tables do
  Repo.query!("TRUNCATE TABLE #{table} CASCADE")
end

IO.puts("Creating initital user...")

Accounts.register_user(
  %{
    email: "rod@me.local",
    password: "password@123",
    username: "rod"
  },
  min_length: 3
)
