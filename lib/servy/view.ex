defmodule Servy.View do
  # Absolute path of template folder
  @templates_path Path.expand("../../templates", __DIR__)

  def render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end
end
