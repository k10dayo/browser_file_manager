defmodule BrowserFileManagerWeb.PageController do
  use BrowserFileManagerWeb, :controller
  alias BrowserFileManagerWeb.PageHTML
  alias BrowserFileManagerWeb.DataShape

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def manager(conn, prams) do
    path = ( if prams["path"] != nil, do: prams["path"], else: "" )
    file_list = PageHTML.get_list(path)
    parent_path = DataShape.get_parent_path(path)
    xampp_http_ip = Application.fetch_env!(:browser_file_manager, :xampp_http_ip)
    render(conn, :manager, layout: false,
      path: path,
      file_list: file_list,
      parent_path: parent_path,
      xampp_http_ip: xampp_http_ip)
  end
end
