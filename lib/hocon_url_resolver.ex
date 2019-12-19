defmodule HoconUrlResolver do
  @moduledoc """
  This module is responsible for loading resources from internet.
  """

  @behaviour Hocon.Resolver

  @doc """
  Returns `true` if `resource` exists.

  ## Example
      iex> HoconUrlResolver.exists?("https://where")
      false
      iex> HoconUrlResolver.exists?("https://where")
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
      iex> HoconUrlResolver.load("app.conf")
      {:error, :enoent}
      iex> HoconUrlResolver.load("./test/data/include-1.conf")
      {:ok, "{ x : 10, y : ${a.x} }"}
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