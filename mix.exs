defmodule Servy.Mixfile do
  use Mix.Project

  def project do
    [
      app: :servy,
      description: "A humble HTTP Server",
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Servy, []}, # OTP will call THIS modules start function when it starts the application.
      env: [port: 3000] 
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:earmark, "~> 1.2"},
      {:httpoison, "~> 1.0"}
    ]
  end
end
