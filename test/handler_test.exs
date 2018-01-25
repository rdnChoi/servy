defmodule HandlerTest do
  use ExUnit.Case, async: true # Run tests concurrently instead of serially

  import Servy.Handler, only: [handle: 1]

test "GET /pages/faq.md" do
  request = """
  GET /pages/faq HTTP/1.1\r
  Host: example.com\r
  User-Agent: ExampleBrowser/1.0\r
  Accept: */*\r
  \r
  """

  response = handle(request)

  expected_response = """
  HTTP/1.1 200 OK\r
  Content-Type: text/html\r
  Content-Length: 577\r
  \r
  <h1>Frequently Asked Questions</h1>\n<ul>\n<li><p><strong>Have you really seen Bigfoot?</strong></p>\n<p>  Yes! In this <a href=\"https://www.youtube.com/watch?v=v77ijOO8oAk\">totally believable video</a>!</p>\n</li>\n<li><p><strong>No, I mean seen Bigfoot <em>on the refuge</em>?</strong></p>\n<p>  Oh! Not yet, but we’re still looking…</p>\n</li>\n<li><p><strong>Can you just show me some code?</strong></p>\n<p>  Sure! Here’s some Elixir:</p>\n</li>\n</ul>\n<pre><code class=\"elixir\">  [&quot;Bigfoot&quot;, &quot;Yeti&quot;, &quot;Sasquatch&quot;] |&gt; Enum.random()</code></pre>\n
  """

  assert remove_whitespace(response) == remove_whitespace(expected_response) 

end
  

test "POST /api/bears" do
  request = """
  POST /api/bears HTTP/1.1\r
  Host: example.com\r
  User-Agent: ExampleBrowser/1.0\r
  Accept: */*\r
  Content-Type: application/json\r
  Content-Length: 21\r
  \r
  {"name": "Breezly", "type": "Polar"}
  """

  response = handle(request)

  assert response == """
  HTTP/1.1 201 Created\r
  Content-Type: text/html\r
  Content-Length: 35\r
  \r
  Created a Polar bear named Breezly!
  """
end

test "GET /api/bears" do
  request = """
  GET /api/bears HTTP/1.1\r
  Host: example.com\r
  User-Agent: ExampleBrowser/1.0\r
  Accept: */*\r
  \r
  """

  response = handle(request)

  expected_response = """
  HTTP/1.1 200 OK\r
  Content-Type: application/json\r
  Content-Length: 605\r
  \r
  [{"type":"Brown","name":"Teddy","id":1,"hibernating":true},
   {"type":"Black","name":"Smokey","id":2,"hibernating":false},
   {"type":"Brown","name":"Paddington","id":3,"hibernating":false},
   {"type":"Grizzly","name":"Scarface","id":4,"hibernating":true},
   {"type":"Polar","name":"Snow","id":5,"hibernating":false},
   {"type":"Grizzly","name":"Brutus","id":6,"hibernating":false},
   {"type":"Black","name":"Rosie","id":7,"hibernating":true},
   {"type":"Panda","name":"Roscoe","id":8,"hibernating":false},
   {"type":"Polar","name":"Iceman","id":9,"hibernating":true},
   {"type":"Grizzly","name":"Kenai","id":10,"hibernating":false}]
  """

  assert remove_whitespace(response) == remove_whitespace(expected_response)
end

  test "DELETE" do
    request = """
    DELETE /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 403 Forbidden\r
    Content-Type: text/html\r
    Content-Length: 34\r
    \r
    Deleting /wildthings is forbidden!
    """
  end


  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 381\r
    \r
    <h1>All The Bears!</h1>
    
    <ul>
      <li>Brutus - Grizzly</li>
      <li>Iceman - Polar</li>
      <li>Kenai - Grizzly</li>
      <li>Paddington - Brown</li>
      <li>Roscoe - Panda</li>
      <li>Rosie - Black</li>
      <li>Scarface - Grizzly</li>
      <li>Smokey - Black</li>
      <li>Snow - Polar</li>
      <li>Teddy - Brown</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 17\r
    \r
    No /bigfoot here!
    """
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 74\r
    \r
    <h1>Show Bear</h1>
    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 105\r
    \r
    <h1>Clark's Wildthings Refuge</h1>

    <blockquote>
    When we contemplate the whole globe...
    </blockquote>    
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 33\r
    \r
    Created a Brown bear named Baloo!
    """
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end 
end

