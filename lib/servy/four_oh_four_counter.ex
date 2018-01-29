defmodule Servy.FourOhFourCounter do
  @server :FourOhFourCounter_Server

  # Internal Client Processes

  def bump_count(path) do
    # Takes in a status = 404 PATH and adds a +1 to the counter for that PATH 
    send(@server, {self(), :bump_count, path})

    receive do
      {:response, status} ->
        status
    end
  end

  def get_count(path) do
    # Args - PATH
    # Returns total count for PATH
    send(@server, {self(), :get_count, path})

    receive do
      {:response, count} ->
        count |> inspect |> String.to_integer()
    after
      3000 ->
        IO.puts("No response after 3 seconds...")
    end
  end

  def get_counts do
    # Args - NONE
    # Returns count of each PATH corresponding PATH. Tuple??
    send(@server, {self(), :get_counts})

    receive do
      {:response, counts} ->
        counts
    after
      3000 ->
        IO.puts("No response after 3 seconds...")
    end
  end

  # Internal Server Processes

  def start() do
    # Start Server by inacting the listen loop
    IO.puts("Fireee UPPP!! [Server Starting]")
    pid = spawn(__MODULE__, :listen_loop, [%{}])
    Process.register(pid, @server)
  end

  def listen_loop(state) do
    receive do
      # Option 1- Bump Count
      {sender, :bump_count, path} ->
        state = Map.update(state, path, 1, &(&1 + 1))
        send(sender, {:response, :ok})
        listen_loop(state)

      # Option 2 - Get Count
      {sender, :get_count, path} ->
        send(sender, {:response, state[path]})
        listen_loop(state)

      # Option 3 - get Counts
      {sender, :get_counts} ->
        send(sender, {:response, state})
        listen_loop(state)

      # Catch All
      unexpected ->
        IO.puts("Unexpected message: #{unexpected}")
        listen_loop(state)
    end
  end
end

# alias Servy.FourOhFourCounter, as: Counter

# Counter.start()

# Counter.bump_count("/bigfoot")
# Counter.bump_count("/nessie")
# Counter.bump_count("/nessie")
# Counter.bump_count("/bigfoot")
# Counter.bump_count("/nessie")

# IO.inspect(Counter.get_count("/nessie"))
# IO.inspect(Counter.get_count("/bigfoot"))
# IO.inspect(Counter.get_counts)
