defmodule Servy.Fetcher do

  # Moduel Replaced by Task core module. This shows how task works.
  def async(fun) do
    parent = self()
    spawn(fn -> send(parent, {self(), :result, fun.()}) end)
  end

  def get_result(pid) do
    receive do {^pid, :result, value} -> value end
  end
end