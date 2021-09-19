defmodule CredoTodoOrDie.MixProject do
  use Mix.Project

  def project do
    [
      app: :credo_todo_or_die,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:timex, "~> 3.7"},
      {:tzdata, "~> 1.1"}
    ]
  end
end
