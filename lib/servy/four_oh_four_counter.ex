defmodule Servy.GenericFourServer do
# Internal Server Processes - Generic

  def start(callback_module, initial_state, name) do
    # Start Server by inacting the listen loop
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
  end

  # Helper Functions - Generic

  def call(pid, message) do
    send(pid, {:call, self(), message})
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  # Server

  def listen_loop(state, callback_module) do
    receive do
      # Generic
      {:call, sender, message} when is_pid(sender)->
        {response, new_state} = callback_module.handle_call(state, message)
        send(sender, {:response, response})
        listen_loop(new_state, callback_module)
      {:cast, message} ->
        new_state = callback_module.handle_cast(state, message)
        listen_loop(new_state, callback_module)
      # Catch All
      unexpected ->
        IO.puts("Unexpected message: #{unexpected}")
        listen_loop(state, callback_module)
    end
  end
end


defmodule Servy.FourOhFourCounter do
  @server :FourOhFourCounter_Server
  alias Servy.GenericFourServer

  # Internal Client Processes - App Specific

  def start() do
    IO.puts("Server Starting...")
    GenericFourServer.start(__MOD  ULE__, %{}, @server)
  end

  def bump_count(path) do
    # Takes in a status = 404 PATH and adds a +1 to the counter for that PATH 
    GenericFourServer.call(@server, {:bump_count, path})
  end

  def get_count(path) do
    # Args - PATH
    # Returns total count for PATH
    GenericFourServer.call(@server, {:get_count, path})
    # response |> inspect |> String.to_integer() - DOESN"T LIKE
  end

  def get_counts() do
    # Args - NONE
    # Returns count of each PATH corresponding PATH. Tuple??
    GenericFourServer.call(@server, :get_counts)
  end

  def clear() do
    GenericFourServer.cast(@server, :clear)
  end

  # App Specific

  def handle_call(state, {:bump_count, path}) do
    response = Map.update(state, path, 1, &(&1 + 1))
    IO.puts("#{path} bumped by 1!")
    {response, response}
  end

  def handle_call(state, {:get_count, path}) do
    {state[path], state}
  end

  def handle_call(state, :get_counts) do
    {state, state}
  end

  def handle_cast(_state, :clear) do
    %{}
  end
end

# alias Servy.FourOhFourCounter, as: Counter

# pid = Counter.start()

# Counter.bump_count("/bigfoot")
# Counter.bump_count("/nessie")
# Counter.bump_count("/nessie")
# Counter.bump_count("/bigfoot")
# Counter.bump_count("/nessie")

# IO.inspect(Counter.get_count("/nessie"))
# IO.inspect(Counter.get_count("/bigfoot"))
# IO.inspect(Counter.get_counts)

# Counter.clear()

# Counter.bump_count("/nessie")
# Counter.bump_count("/bigfoot")
# Counter.bump_count("/nessie")

# IO.inspect(Counter.get_count("/nessie"))
# IO.inspect(Counter.get_count("/bigfoot"))
# IO.inspect(Counter.get_counts)
