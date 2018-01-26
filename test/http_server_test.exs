defmodule HttpServerTest do
  use ExUnit.Case
  alias Servy.HttpServer
  alias Servy.HttpClient

  test "Test HttpServer" do
  
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    spawn(HttpServer, :start, [4000])

    assert HttpClient.send_request(request) == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """
  end
end