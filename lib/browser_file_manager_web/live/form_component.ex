defmodule BrowserFileManagerWeb.FormComponent do
  use BrowserFileManagerWeb, :live_component


  # def mount(params, session, socket) do
  #   IO.puts "まうんとおおおおおおおおおおおおおお"
  #   IO.puts inspect session
  #   IO.puts inspect socket
  #   {:ok, socket, layout: false}
  # end

  @impl true
  def render(assigns) do
    IO.puts "れんだーーーーーーーーーーー"
    ~H"""
    <div>
      レンダー
    </div>
    """
  end
end
