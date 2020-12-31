defmodule TableRex.Mixfile do
  use Mix.Project

  @source_url "https://github.com/djm/table_rex"
  @version "3.0.0"

  def project do
    [
      app: :table_rex,
      name: "table_rex",
      description: "Generate configurable text-based tables for display (ASCII & more)",
      version: @version,
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
      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end

  defp docs do
    [
      logo: "assets/logo.png",
      source_url: @source_url,
      source_ref: "v#{@version}",
      extras: ["CHANGELOG.md"]
    ]
  end

  defp package do
    [
      maintainers: ["Darian Moody"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      exclude_patterns: [".DS_Store"]
    ]
  end
end
