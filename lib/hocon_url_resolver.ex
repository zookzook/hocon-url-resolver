defmodule HoconUrlResolver do
  @moduledoc """
  This module is responsible for loading resources from the internet.

  It uses the `HTTPoison` client to fetch the configuration. It is used with `Hocon` to include URL configuration by using
  the module with the Keyword `:url_resolver`:

  ## Example

      iex> Hocon.decode( ~s( b : { include url\("https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-1.conf"\) }), url_resolver: HoconUrlResolver )
      {:ok, %{"b" => %{"a" => "The answer is 42"}}}

  """

  @behaviour Hocon.Resolver

  @doc """
  Returns `true` if `resource` exists.

  ## Example
      iex> HoconUrlResolver.exists?("https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-2.conf")
      false
      iex> HoconUrlResolver.exists?("https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-1.conf")
      true

  """
  @spec exists?(Path.t()) :: boolean
  def exists?(url) do
    case HTTPoison.head(url) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> true
      {:ok, %HTTPoison.Response{status_code: 404}} -> false
      {:error, _}                                  -> false
    end
  end

  @doc """
  Returns a tuple with the content of the `resource`

  ## Example
      iex> HoconUrlResolver.load("https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-2.conf")
      {:error, "not found"}
      iex> HoconUrlResolver.load("https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-1.conf")
      {:ok, "{\\n  a : \\"The answer is 42\\"\\n}"}
  """
  @spec load(Path.t()) :: {:ok, binary} | {:error, File.posix}
  def load(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}}             -> {:error, "not found"}
      {:error, %HTTPoison.Error{reason: reason}}                -> {:error, reason}
    end
  end

end