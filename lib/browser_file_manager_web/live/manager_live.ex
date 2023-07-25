defmodule BrowserFileManagerWeb.ManagerLive do
  use BrowserFileManagerWeb, :live_view

  alias BrowserFileManagerWeb.PageHTML
  alias BrowserFileManagerWeb.DataShape

  def mount(params, _session, socket) do
    path = ( if params["path"] != nil, do: params["path"], else: "" )
    file_list = PageHTML.get_list(path)
    parent_path = DataShape.get_parent_path(path)
    xampp_http_ip = Application.fetch_env!(:browser_file_manager, :xampp_http_ip)
    socket = assign(socket, :path, path)
    socket = assign(socket, :file_list, file_list)
    socket = assign(socket, :parent_path, parent_path)
    socket = assign(socket, :xampp_http_ip, xampp_http_ip)
    socket = assign(socket, :manager_menu_status, "")
    {:ok, socket, layout: false}
  end

  def handle_params(params, _url, socket) do
    IO.puts "ハンドルパラムス"
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    path = ( if params["path"] != nil, do: params["path"], else: "" )
    file_list = PageHTML.get_list(path)
    parent_path = DataShape.get_parent_path(path)
    socket
    |> assign(:path, path)
    |> assign(:file_list, file_list)
    |> assign(:parent_path, parent_path)
  end

  def handle_event("change", %{"path" => path}, socket) do
    IO.puts "はんどるいべんと"
    IO.puts "ハンドルイベントで受け取った" <> inspect socket.assigns.file_list
    file_list = PageHTML.get_list(path)
    parent_path = DataShape.get_parent_path(path)
    IO.puts "これだあああああああ" <> inspect file_list
    socket = socket
    |> assign(:file_list, file_list)
    |> assign(:parent_path, parent_path)
    |> assign(:path, path)
    {:noreply, socket}
  end

  def handle_event("hamburger", _, socket) do
    status = if socket.assigns.manager_menu_status != "" do
      ""
    else
      "action_manager_menu"
    end
    socket = socket
    |> assign(:manager_menu_status, status)
    {:noreply, socket}
  end
end
