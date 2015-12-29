defmodule TableRex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :table_rex,
      name: "table_rex",
      source_url: "https://github.com/djm/table_rex",
      version: "0.1.0",
      elixir: "~> 1.1",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      docs: [
        logo: "assets/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
  end
end
