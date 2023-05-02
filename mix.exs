defmodule UeberauthIntercom.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/statuspal/ueberauth_intercom"

  def project do
    [
      app: :ueberauth_intercom,
      version: @version,
      elixir: "~> 1.11",
      name: "Ueberauth Intercom",
      description: "Ueberauth strategy for Intercom authentication.",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      source_url: @url,
      homepage_url: @url,
      package: package(),
      deps: deps(),
      docs: docs()
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
      {:oauth2, "~> 1.0 or ~> 2.1"},
      {:ueberauth, "~> 0.10.5"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: :ueberauth_intercom,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["E.M. Statuspal UG", "Nandor Stanko"],
      licenses: ["MIT"],
      links: %{
        GitHub: @url,
        Changelog: "#{@url}/blob/master/CHANGELOG.md",
        Sponsor: "https://statuspal.io"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @url,
      formatters: ["html"],
      extras: [
        "CHANGELOG.md",
        "LICENSE": [title: "License"],
        "README.md": [title: "Overview"]
      ]
    ]
  end
end
