defmodule BrowserFileManagerWeb.PageController do
  use BrowserFileManagerWeb, :controller
  alias BrowserFileManagerWeb.DataShape

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def copyright(conn, _params) do
    render(conn, :copyright, layout: false)
  end
end
