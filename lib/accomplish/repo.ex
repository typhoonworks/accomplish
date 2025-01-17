defmodule Accomplish.Repo do
  use Ecto.Repo,
    otp_app: :accomplish,
    adapter: Ecto.Adapters.Postgres
end
