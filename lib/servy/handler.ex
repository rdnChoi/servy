defmodule Servy.Handler do
  # import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  # import Servy.Parser, only: [parse: 1]

  # Prefer 'alias' to 'import' as it requires you use the leaf name when calling the function. This reduces ambiguity with only a slight inconvience.
  alias Servy.Plugins
  alias Servy.FileHandler
  alias Servy.Parser
  alias Servy.Conv # Struct
  alias Servy.BearController
  alias Servy.PagesController
  alias Servy.View
  alias Servy.FourOhFourCounter
  alias Servy.SensorServer

  @moduledoc """
  Handles HTTP Requests.
  """
  # Absolute path of pages folder
  @pages_path Path.expand("../../pages", __DIR__)

  @doc "Transforms request into a response"
  def handle(request) do
    request
    |> Parser.parse()
    |> Plugins.rewrite_path()
    |> Plugins.log()
    |> route
    |> Plugins.track()
    |> put_content_length
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/pledges/new"} = conv) do
    Servy.PledgeController.new(conv)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    sensor_data = SensorServer.get_sensor_data()
    
    %{conv | status: 200, resp_body: inspect(sensor_data)}
    
    View.render(conv, "sensors.eex", snapshots: sensor_data.snapshots, location: sensor_data.location)
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.API.BearController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy.API.BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> FileHandler.handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> FileHandler.handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    PagesController.show(conv, file)
  end

  def route(%Conv{method: "DELETE"} = conv) do
    BearController.delete(conv)
  end

  def route(%Conv{method: "GET", path: "/404s"} = conv) do
    counts = FourOhFourCounter.get_counts()

    %{conv | status: 200, resp_body: inspect(counts)}
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  # ----- End of Routes ------

  def put_content_length(conv) do
    cont_length = Map.put(conv.resp_headers, "Content-Length", byte_size(conv.resp_body))

    %{conv | resp_headers: cont_length}
  end

  def format_response(%Conv{} = conv) do
    # Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.resp_body}
    """
  end

  def format_response_headers(conv) do
    for {key, value} <- conv.resp_headers do
      "#{key}: #{value}\r"
    end
    |> Enum.sort(&(&1 >= &2))
    |> Enum.join("\n")
  end
end

# # Raw HTTP *Request* Example
# request = """ 
# DELETE /wildthings HTTP/1.1/r/n
# Host: example.com/r/n
# User-Agent: ExampleBrowser/1.0/r/n
# Accept: */*/r/n
# /r/n
# """

# Raw HTTP *Request* Details:
# Method PATH HTTP_Protocol
# Key/Value Pairs - Host: URL.com - Host and URL we are getting request from
# Software making request - Browser typically
# Accept - Details media it will accept from request
# Body - No body here
# BLANK LINE - IMPORTANT 

# Raw HTTP *Response* Example
# expeted_response = """
# HTTP/1.1 200 OK/r/n
# Content-Type: text/html/r/n
# Content-Length: 20/r/n
# /r/n
# Bears, Lions, Tigers/r/n
# """
# *Response* Details:
# HTTP Version - Status Code - Reason Phrase
# Media Type 
# Content Length
# BLANK LINE to Separate Body
# Body content
