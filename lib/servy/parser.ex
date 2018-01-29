defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n")

    [request_line | header_lines] = String.split(top, "\r\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn line, header_so_far ->
      [key, value] = String.split(line, ": ")
      Map.put(header_so_far, key, value)
    end)
  end

  # # Recursive version
  # def parse_headers([head | tail], headers) do  
  #   [key, value] = String.split(head, ": ")
  #   headers = Map.put(headers, key, value)
  #   parse_headers(tail, headers)
  # end

  # def parse_headers([], headers), do: headers

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  def parse_params("application/json", params_string) do
    Poison.Parser.parse!(params_string)
  end

  def parse_params(_, _), do: %{}
end

# RAW HTTP Request
# request = """ 
# DELETE /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """
