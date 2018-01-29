defmodule HttpServerTest do
  use ExUnit.Case
  alias Servy.HttpServer
  alias Servy.HttpClient

  # Can only run 1 server test at once. Commented rest out.
  test "Status codes for multiple pages on your website" do
    spawn(HttpServer, :start, [4000])

    url_list = [
      "http://localhost:4000/wildthings",
      "http://localhost:4000/bears",
      "http://localhost:4000/bears/1",
      "http://localhost:4000/wildlife",
      "http://localhost:4000/api/bears"
    ]

    url_list
    |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
  end

  # test "Test Erlang HttpServer" do

  #   request = """
  #   GET /wildthings HTTP/1.1\r
  #   Host: example.com\r
  #   User-Agent: ExampleBrowser/1.0\r
  #   Accept: */*\r
  #   \r
  #   """

  #   spawn(HttpServer, :start, [4000])

  #   assert HttpClient.send_request(request) == """
  #   HTTP/1.1 200 OK\r
  #   Content-Type: text/html\r
  #   Content-Length: 20\r
  #   \r
  #   Bears, Lions, Tigers
  #   """
  # end

  # test "HTTPoison dep with our Erlang HTTPServer" do

  #   spawn(HttpServer, :start, [4000])

  #   {:ok, response} = HTTPoison.get("localhost:4000/wildthings")

  #   assert response.body == "Bears, Lions, Tigers"    

  # end

  # test "Sends 5 concurrent requests and receives messages" do
  #   spawn(HttpServer, :start, [4000])

  #   url = "http://localhost:4000/wildthings"

  #   1..5
  #   |> Enum.map(fn(_) -> Task.async(fn -> HTTPoison.get(url) end) end)
  #   |> Enum.map(&Task.await/1)
  #   |> Enum.map(&assert_successful_response/1)
  # end

  # defp assert_successful_response({:ok, response}) do
  #   assert response.status_code == 200
  #   assert response.body == "Bears, Lions, Tigers"
  # end
end
