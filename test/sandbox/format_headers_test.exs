defmodule Sandbox.FormatHeadersTest do
  use ExUnit.Case
  
  test "Format Response Headers to a single function" do
    headers = %{ resp_headers: %{"A" => "1", "B" => "2" } }

    formatted_response = Servy.Handler.format_response_headers(headers)

    assert formatted_response == "B: 2\r\nA: 1\r"
  end
end