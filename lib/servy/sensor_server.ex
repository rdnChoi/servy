defmodule State do
  defstruct sensor_data: %{}, 
            refresh_interval: :timer.minutes(60)
end

defmodule Servy.SensorServer do
  use GenServer
  import State

  @ss :sensor_server

  # Client Interface

  def start_link(interval) do
    IO.puts("Starting Sensor Server with interval #{interval} min refresh...")
    initial_state = Map.put(%State{}, :refresh_interval, :timer.minutes(interval))
  # initial_state = %State{refresh_interval: :timer.minutes(interval)} - ** Works to Update map this way too **
    GenServer.start_link(__MODULE__, initial_state, name: @ss)
  end

  def get_sensor_data() do
    GenServer.call(@ss, :get_sensor_data)
  end

  def get_all_data() do
    GenServer.call(@ss, :get_all_data)
  end

  def set_refresh_interval(refresh_interval) do
    GenServer.cast(@ss, {:set_refresh_interval, refresh_interval})
  end

  # Server (callbacks)

  def init(state) do
    initial_sensor_data = get_sensor_data_from_source()
    Process.send_after(@ss, :refresh, state.refresh_interval)
    {:ok, %{state | sensor_data: initial_sensor_data}}
  end

  def handle_info(:refresh, state) do
    IO.puts("Refreshing the cache...")
    new_sensor_data = get_sensor_data_from_source()
    Process.send_after(@ss, :refresh, state.refresh_interval)
    {:noreply, %{state | sensor_data: new_sensor_data}}
  end

  def handle_cast({:set_refresh_interval, new_refresh_interval}, state) do
    new_state = %{state | refresh_interval: new_refresh_interval}
    Process.send_after(@ss, :refresh, new_state.refresh_interval)

    IO.puts("Refresh interval set to #{new_state.refresh_interval} ms")
    {:noreply, new_state}
  end

  def handle_call(:get_all_data, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state.sensor_data, state}
  end

  defp get_sensor_data_from_source() do
    IO.puts("Running tasks to get sensor data.")
    task = Task.async(Servy.Tracker, :get_location, ["bigfoot"])

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end