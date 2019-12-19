defmodule HoconUrlResolverTest do
  use ExUnit.Case

  test "Resolves configuration from internet" do
    url = "https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-1.conf"
    assert HoconUrlResolver.exists?(url) == true
    {:ok, content}= HoconUrlResolver.load(url)
    assert {:ok, %{"a" => "The answer is 42"}} = Hocon.decode(content)
  end

  test "exists?/1" do
    url = "https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-1.conf"
    assert HoconUrlResolver.exists?(url) == true
    url = "https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-2.conf"
    assert HoconUrlResolver.exists?(url) == false
  end

  test "load/1" do
    url = "https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-2.conf"
    assert {:error, "not found"} = HoconUrlResolver.load(url)
  end

  test "Loads a configuration from the internet" do
    assert {:ok, %{"b" => %{"a" => "The answer is 42"}}} == Hocon.decode( ~s( b : { include url\("https://raw.githubusercontent.com/zookzook/hocon-url-resolver/master/test/data/config-1.conf"\) }), url_resolver: HoconUrlResolver )
  end

end
