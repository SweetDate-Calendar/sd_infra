defmodule SweetDate.MixProject do
  use Mix.Project

  def project do
    [
      app: :sweet_date,
      version: "0.1.0",
      elixir: "~> 1.17",
      escript: [main_module: SweetDate],
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
      {:ex_json_schema, "~> 0.11.1"},
      {:jason, "~> 1.4"}
      # {:yaml_elixir, "~> 2.11"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
