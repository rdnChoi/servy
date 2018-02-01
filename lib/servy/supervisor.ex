defmodule Servy.Supervisor do
  use Supervisor

  def start_link() do
    IO.puts("Starting THE Supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Define Children in init()
  def init(:ok) do
    children = [
      Servy.ServicesSupervisor,
      Servy.KickStarter
    ]

    Supervisor.init(children, strategy: :one_for_one)

  end

end