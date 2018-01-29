defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears() do
    # GET Aboslute path of file
    # Absolute path of pages folder
    Path.expand("../../db", __DIR__)
    |> Path.join("bears.json")
    |> read_file
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def read_file(source) do
    case File.read(source) do
      {:ok, content} ->
        content

      {:error, reason} ->
        IO.inspect("Error reading #{source}. Reason: #{reason}.")
        []
    end
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn b -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_bear
  end
end
