defmodule Servy.ServicesSupervisor do
  use Supervisor

  def start_link() do
    IO.puts("Starting the services supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Define Children in init()
  def init(:ok) do
    children = [
      {Servy.SensorServer, 60}, # 2nd argument in tuple used as argument in servers init(args) function
      Servy.PledgeServer,
      Servy.FourOhFourCounter
    ]

    Supervisor.init(children, strategy: :one_for_one)

  end
end