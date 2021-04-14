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
      {:oauth2, "~> 1.0 or ~> 2.0"},
      {:ueberauth, "~> 0.6.3"}
    ]
  end

  defp package do
    [
      name: :ueberauth_intercom,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Statuspal AG"],
      licenses: ["MIT"],
      links: %{GitHub: @url}
    ]
  end
end
