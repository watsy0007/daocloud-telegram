defmodule DaocloudTelegram.Mixfile do
  use Mix.Project

  def project do
    [
      app: :daocloud_telegram,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger], mod: { DaocloudTelegram.Application, [] }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.13"}
    ]
  end
end
