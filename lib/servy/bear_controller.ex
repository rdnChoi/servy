defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  def index(conv) do
    bears =  
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    View.render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    View.render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end

  def delete(conv) do
    %{ conv | status: 403, resp_body: "Deleting #{conv.path} is forbidden!"}
  end

end

defmodule View do
@templates_path Path.expand("../../templates", __DIR__) # Absolute path of template folder

  def render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{ conv | status: 200, resp_body: content}
  end
end