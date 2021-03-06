defmodule Homunculus.MixProject do
  use Mix.Project

  def project do
    [
      app: :born_from_a_bottle_bot,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets, :ssl, :plug_cowboy],
      mod: {Homunculus, []},
      env: [base_url: then(System.fetch_env!("TOKEN"), fn token -> "https://api.telegram.org" <> "/bot#{token}" end)]
    ]
    
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:rot13, "~> 0.1.0"},
      {:mangadexapiv5wrapper, git: "https://github.com/Yi-Jiahe/mangadex_api_v5_wrapper.git", tag: "v0.1.0"}
    ]
  end
end
