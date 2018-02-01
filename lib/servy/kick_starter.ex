defmodule Servy.KickStarter do
  use GenServer

  def start_link(_arg) do
    IO.puts("Starting the Kickstarter...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def get_server() do
    server_pid = Process.whereis(:http_server)
    server_pid
  end

  # Server (callbacks)

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HttpServer exited #{inspect reason}")
    server_pid = start_server()
    {:noreply, server_pid}
  end

  def start_server() do
    IO.puts("Starting the Http Server...")
    port = Application.get_env(:servy, :port)
    server_pid = spawn_link(Servy.HttpServer, :start, [port])
    Process.register(server_pid, :http_server)
    server_pid
  end
end