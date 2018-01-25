defmodule Servy.PagesController do
alias Servy.FileHandler

@pages_path Path.expand("../../pages", __DIR__) # Absolute path of pages folder

  def show(conv, "faq") do
    @pages_path
    |> Path.join("faq.md")
    |> File.read
    |> FileHandler.handle_file(conv)
    |> markdown_to_html
  end

  def show(conv, file) do
  @pages_path
    |> Path.join("#{file}.html")
    |> File.read
    |> FileHandler.handle_file(conv)
  end

  def markdown_to_html(%{resp_status: 200} = conv) do
    %{ conv | resp_body: Earmark.as_html!(conv.resp_body)}
  end

  def markdown_to_html(conv), do: conv
  
end