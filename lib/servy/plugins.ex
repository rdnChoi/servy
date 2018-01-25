defmodule Servy.Plugins do

  require Logger
  alias Servy.Conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  defp rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}"}
  end

  defp rewrite_path_captures(%Conv{} = conv, nil), do: conv

  def log(conv) do
    if Mix.env == :dev do
      IO.inspect(%Conv{} = conv)
    end
    conv
  end

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
      Logger.info("404 on path #{path}")
      Logger.warn("Warning: #{path} is on the loose!")
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

end