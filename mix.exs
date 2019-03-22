defmodule ElixirHttpClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_http_client,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 4.0"},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
