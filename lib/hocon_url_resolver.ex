defmodule HoconUrlResolver do
  @moduledoc """
  This module is responsible for loading file resources.

  By implementing the behaviour `Hocon.Resolver` it is possible to replace this module. For example to load the resource
  from a database or from an url.
  """

  @behaviour Hocon.Resolver

  @doc """
  Returns `true` if `resource` exists.

  ## Example
      iex> Hocon.FileResolver.exists?("app.conf")
      false
      iex> Hocon.FileResolver.exists?("./test/data/include-1.conf")
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
      iex> Hocon.FileResolver.load("app.conf")
      {:error, :enoent}
      iex> Hocon.FileResolver.load("./test/data/include-1.conf")
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