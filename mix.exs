defmodule Hexerss.MixProject do
  use Mix.Project

  def project do
    [
      app: :hexerss,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Hexerss.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.18"},
      {:con_cache, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:etag_plug, "~> 1.0"},
      {:exsync, "~> 0.2", only: :dev}
    ]
  end
end
