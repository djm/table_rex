defmodule TableRex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :table_rex,
      name: "table_rex",
      source_url: "https://github.com/djm/table_rex",
      description: "Generate configurable text-based tables for display (ASCII & more)",
      version: "3.0.0",
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:earmark, ">= 0.0.0", only: :docs},
      {:ex_doc, ">= 0.0.0", only: :docs},
    ]
  end

  defp docs do
    [logo: "assets/logo.png"]
  end

  defp package do
    [
      maintainers: ["Darian Moody"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/djm/table_rex"}
    ]
  end
end
