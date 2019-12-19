defmodule HoconUrlResolver.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :hocon_url_resolver,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [docs: :docs, coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.12.1", only: :test},
      {:httpoison, "~> 1.6"},
      {:hocon, "~> 0.1.4"}
    ]
  end

  defp description() do
    """
    A Hocon-URL-Resolver which loads configuration from the internet.
    """
  end

  defp package() do
    [maintainers: ["Michael Maier"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/zookzook/hocon-url-resolver"}]
  end

  defp docs() do
    [main: "HoconUrlResolver",
      name: "HOCON",
      extras: ["README.md"],
      source_ref: "#{@version}",
      canonical: "http://hexdocs.pm/hocon_url_resolver",
      source_url: "https://github.com/zookzook/hocon-url-resolver"]
  end
end
