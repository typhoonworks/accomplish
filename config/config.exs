# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :accomplish,
  ecto_repos: [Accomplish.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :accomplish, AccomplishWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: AccomplishWeb.ErrorHTML, json: AccomplishWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Accomplish.PubSub,
  live_view: [signing_salt: "06XrdAbm"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :accomplish, Accomplish.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required) - Replaced by LiveSvelte
# config :esbuild,
#   version: "0.17.11",
#   accomplish: [
#     args:
#       ~w(js/app.ts --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
#     cd: Path.expand("../assets", __DIR__),
#     env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
#   ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  accomplish: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configure SaladUI
config :salad_ui, :error_translator_function, {AccomplishWeb.CoreComponents, :translate_error}

# Configure ExcellentMigrations
config :excellent_migrations, skip_checks: [:raw_sql_executed]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use the native JSON for JSON parsing in Phoenix
config :phoenix, :json_library, JSON

if config_env() in [:dev] do
  import_config ".env.exs"
end

# Configures OAuth with Assent
config :accomplish, :assent_providers,
  github: %{
    client_id: System.get_env("GITHUB_CLIENT_ID"),
    client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
    strategy: Assent.Strategy.Github,
    redirect_uri: "http://localhost:4000/auth/github/callback"
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
