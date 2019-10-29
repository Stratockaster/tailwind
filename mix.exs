defmodule Tailwind.MixProject do
  use Mix.Project

  def project do
    [
      app: :tailwind,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # releases: [
      #   prod: [
      #     include_executables_for: [:unix],
      #     applications: [runtime_tools: :permanent]
      #   ]
      # ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tailwind.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/tailwind"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.10"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.6"},
      {:geocalc, "~> 0.5"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
