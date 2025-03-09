defmodule Accomplish.MixProject do
  use Mix.Project

  def project do
    [
      app: :accomplish,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      rustler_crates: rustler_crates(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.github": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Accomplish.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:anthropix, "~> 0.6"},
      {:assent, "~> 0.3.0"},
      {:bandit, "~> 1.5"},
      {:bcrypt_elixir, "~> 3.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dotenv_parser, "~> 2.0", only: [:dev, :test]},
      {:dns_cluster, "~> 0.1.1"},
      {:ecto_sql, "~> 3.10"},
      {:ecto_soft_delete, "~> 2.0"},
      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test, runtime: false},
      {:finch, "~> 0.13"},
      {:floki, ">= 0.30.0"},
      {:fun_with_flags, "~> 1.12"},
      {:fun_with_flags_ui, "~> 1.0"},
      {:gettext, "~> 0.26"},
      {:goal, "~> 1.1"},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:live_svelte, "~> 0.15.0"},
      {:lucide_live_view, github: "typhoonworks/lucide_live_view", branch: "main"},
      {:oban, "~> 2.19"},
      {:oban_web, "~> 2.11"},
      {:open_api_spex, "~> 3.21"},
      {:phoenix, "~> 1.7.18"},
      {:phoenix_ecto, "~> 4.5"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:req, "~> 0.5.0"},
      {:rustler, "~> 0.36.1", runtime: false},
      {:salad_ui, "~> 0.14"},
      {:swoosh, "~> 1.5"},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:timex, "~> 3.7"},
      {:tw_merge, "~> 0.1.0"},
      {:uuidv7, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd --cd assets npm install"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "test.coverage": ["test --warnings-as-errors", "coveralls.html"],
      "assets.typecheck": ["cmd npm --prefix assets run typecheck"],
      "assets.lint": [
        "cmd --cd assets npx eslint .",
        "cmd --cd assets npx stylelint '**/*.{css,scss,svelte}'"
      ],
      "assets.format": [
        "cmd --cd assets npx prettier --write .",
        "cmd --cd assets npx stylelint --fix '**/*.{css,scss,svelte}'"
      ],
      "assets.deploy": [
        "tailwind accomplish --minify",
        "cmd --cd assets node build.js --deploy",
        "phx.digest"
      ]
    ]
  end

  defp rustler_crates do
    [
      pdf_extractor: [
        path: "native/pdf_extractor",
        mode: :release,
        features: []
      ]
    ]
  end
end
