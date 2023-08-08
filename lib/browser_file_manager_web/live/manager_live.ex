defmodule BrowserFileManagerWeb.ManagerLive do
  use BrowserFileManagerWeb, :live_view

  alias BrowserFileManagerWeb.DataShape

  alias Phoenix.LiveView.JS

  def mount(params, _session, socket) do
    IO.puts "マウント"
    xampp_http_ip = Application.fetch_env!(:browser_file_manager, :xampp_http_ip)
    socket = socket
    |> assign(:xampp_http_ip, xampp_http_ip)
    |> assign(:live_action, :index)
    |> assign(:manager_menu_status, "")
    |> assign(:side_menu_status, "")
    |> assign(:selected, %{img: "/images/folder.png", name: "/"})
    {:ok, socket, layout: false}
  end

  def handle_params(params, _url, socket) do
    IO.puts "ハンドルパラムス"
    # html要素をelixir側で取得できないかためしたけどわからないやつ↓
    # IO.puts inspect JS.show(to: "#side_menu")
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    IO.puts "アプライアクション:index"
    path = ( if params["path"] != nil, do: params["path"], else: "" )
    file_list = DataShape.get_list(path)
    parent_path = DataShape.get_parent_path(path)
    socket
    |> assign(:path, path)
    |> assign(:file_list, file_list)
    |> assign(:parent_path, parent_path)
    |> assign(:live_action, :index)
  end

  defp apply_action(socket, :new, _params) do
    socket
  end

  def handle_event("change", %{"path" => path}, socket) do
    IO.puts "ハンドルイベント:change"
    file_list = DataShape.get_list(path)
    parent_path = DataShape.get_parent_path(path)
    socket = socket
    |> assign(:file_list, file_list)
    |> assign(:parent_path, parent_path)
    |> assign(:path, path)
    {:noreply, socket}
  end

  def handle_event("hamburger", _, socket) do
    manager_menu_status = if socket.assigns.manager_menu_status != "" do
      ""
    else
      "action_manager_menu"
    end
    side_menu_status = if socket.assigns.side_menu_status != "" do
      ""
    else
      "action_side_menu"
    end
    socket = socket
    |> assign(:manager_menu_status, manager_menu_status)
    |> assign(:side_menu_status, side_menu_status)
    {:noreply, socket}
  end

  def handle_event("selected_file", params, socket) do
    IO.puts inspect params
    {:noreply, socket}
  end
end
