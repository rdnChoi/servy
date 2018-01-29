defmodule Servy.HttpServer do
  @doc """
  Starts the server on the given `port` of localhost.
  """
  # Port 0 - 1023 reserved for Operating System
  def start(port) when is_integer(port) and port > 1023 do
    # Creates a socket to listen for client connections.
    # `listen_socket` is bound to the listening socket.
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    # Socket options (don't worry about these details):
    # `:binary` - open the socket in "binary" mode and deliver data as binaries
    # `packet: :raw` - deliver the entire binary without doing any packet handling
    # `active: false` - receive data when we're ready by calling `:gen_tcp.recv/2`
    # `reuseaddr: true` - allows reusing the address if the listener crashes

    IO.puts("\n🎧  Listening for connection requests on port #{port}...\n")

    accept_loop(listen_socket)
  end

  @doc """
  Accepts client connections on the `listen_socket`.
  """
  def accept_loop(listen_socket) do
    IO.puts("⌛️  Waiting to accept a client connection...\n")

    # Suspends (blocks) and waits for a client connection. When a connection 
    # is accepted, `client_socket` is bound to a new client socket.
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    IO.puts("⚡️  Connection accepted!\n")

    # Receives the request and sends a response over the client socket.
    pid = spawn(fn -> serve(client_socket) end)

    # Assigns Controlling Process to pid (from gen_tcp.accept). This ensures web socket is closed if serve dies (say from error).
    :ok = :gen_tcp.controlling_process(client_socket, pid)

    # Loop back to wait and accept the next connection.
    accept_loop(listen_socket)
  end

  @doc """
  Receives the request on the `client_socket` and 
  sends a response back over the same socket.
  """
  def serve(client_socket) do
    IO.puts("#{inspect(self())}: Working on it!")

    client_socket
    |> read_request
    |> Servy.Handler.handle()
    |> write_response(client_socket)
  end

  @doc """
  Receives a request on the `client_socket`.
  """
  def read_request(client_socket) do
    # all available bytes
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    IO.puts("➡️  Received request:\n")
    IO.puts(request)

    request
  end

  @doc """
  Returns a generic HTTP response.
  """
  def generate_response(_request) do
    """
    HTTP/1.1 200 OK\r
    Content-Type: text/plain\r
    Content-Length: 6\r
    \r
    Hello!
    """
  end

  @doc """
  Sends the `response` over the `client_socket`.
  """
  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    IO.puts("⬅️  Sent response:\n")
    IO.puts(response)

    # Closes the client socket, ending the connection.
    # Does not close the listen socket!
    :gen_tcp.close(client_socket)
  end
end

# **Erlang Code** - HTTP Web Server Socket
# server() ->
#     {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0}, 
#                                         {active, false}]),
#     {ok, Sock} = gen_tcp:accept(LSock),
#     {ok, Bin} = do_recv(Sock, []),
#     ok = gen_tcp:close(Sock),
#     ok = gen_tcp:close(LSock),
#     Bin.

# **Elixir Code - Translated*
# defmodule Servy.Http Server do
#   def server do
#     {:ok, lsock} = :gen_tcp.listen(5678, [:binary, {:packet, 0}, 
#                                         {:active, false}])
#     {:ok, sock} = :gen_tcp.accept(lsock)
#     {:ok, bin} = :gen_tcp.recv(sock, 0)
#     # send code
#     :ok = :gen_tcp.close(sock)
#     :ok = :gen_tcp.close(lsock)
#     bin
#   end
# end

# Here's a summary of things to keep in mind when transcoding Erlang to Elixir:

# Erlang atoms start with a lowercase letter, whereas Elixir atoms start with a colon (:). For example, ok in Erlang becomes :ok in Elixir.

# Erlang variables start with an uppercase letter, whereas Elixir variables start with a lowercase letter. For example, Socket in Erlang becomes socket in Elixir.

# Erlang modules are always referenced as atoms. For example, gen_tcp in Erlang becomes :gen_tcp in Elixir.

# Function calls in Erlang use a colon (:) whereas function calls in Elixir always us a dot (.). For example, gen_tcp:listen in Erlang becomes :gen_tcp.listen in Elixir. (Replace the colon with a dot.)

# Last, but by no means least, it's important to note that Erlang strings aren't the same as Elixir strings. In Erlang, a double-quoted string is a list of characters 
# whereas in Elixir a double-quoted string is a sequence of bytes (a binary). Thus, double-quoted Erlang and Elixir strings aren't compatible. So if an Erlang function takes a 
# string argument, you can't pass it an Elixir string. Instead, Elixir has a character list which you can create using single-quotes rather than double-quotes. For example, 'hello' is a list of characters that's compatible with the Erlang string "hello".
