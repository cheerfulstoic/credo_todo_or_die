defmodule CredoTodoOrDie.MixProject do
  use Mix.Project

  def project do
    [
      app: :credo_todo_or_die,
      version: "0.4.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Exploding TODO/FIXME/etc... notes as a credo check",
      package: package(),
      source_url: "https://github.com/cheerfulstoic/credo_todo_or_die"
    ]
  end

  def package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cheerfulstoic/credo_todo_or_die"},
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
      {:tzdata, "~> 1.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:httpoison, "~> 1.7"}
    ]
  end
end
