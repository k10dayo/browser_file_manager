defmodule BrowserFileManagerWeb.ManagerLive do
  use BrowserFileManagerWeb, :live_view

  alias BrowserFileManagerWeb.DataShape
  alias BrowserFileManager.Content

  alias Phoenix.LiveView.JS

  def mount(params, _session, socket) do
    IO.puts "マウント"

    path = ( if params["path"] != nil, do: params["path"], else: "" )
    xampp_http_ip = Application.fetch_env!(:browser_file_manager, :xampp_http_ip)
    tmp_file_list = DataShape.get_list(path)
    parent_path = DataShape.get_parent_path(path)
    #currnet_file_id改善の余地あり、　pathで判断しているが、current_file_idで検索するなどしたい
    current_file_id = Content.get_current_id_entry(path)
    db_children_files = Content.get_db_children_files(path, current_file_id)
    # IO.puts inspect file_list
    # IO.puts inspect db_children_files
    IO.puts "カレントファイルID:" <> inspect current_file_id
    file_list = DataShape.zip_ls_db(tmp_file_list, db_children_files)
    file_list = DataShape.grouping_tags(file_list)

    socket = socket
    |> assign(:path, path)
    |> assign(:xampp_http_ip, xampp_http_ip)
    |> assign(:live_action, :index)
    |> assign(:file_list, file_list)
    |> assign(:parent_path, parent_path)
    |> assign(:hamburger, %{status: false, manager_menu: "", side_menu: ""})
    |> assign(:currnet_file_id, current_file_id)
    |> assign(:selected, %{img: "/images/folder.png", name: "/"})
    |> assign(:detail, %{status: :row, detail_off: "", detail_on: "hidden", file_width: "w-[100px]"})

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
    socket
  end

  defp apply_action(socket, :new, _params) do
    IO.puts "アプライアクション:new"
    socket
  end

  def handle_event("change", %{"path" => path}, socket) do
    IO.puts "ハンドルイベント:change"

    tmp_file_list = DataShape.get_list(path)
    parent_path = DataShape.get_parent_path(path)

    current_file_id = Content.get_current_id_entry(path)
    IO.puts current_file_id
    db_children_files = Content.get_db_children_files(path, current_file_id)

    file_list = DataShape.zip_ls_db(tmp_file_list, db_children_files)
    file_list = DataShape.grouping_tags(file_list)

    socket = socket
    |> assign(:file_list, file_list)
    |> assign(:parent_path, parent_path)
    |> assign(:path, path)
    |> assign(:current_file_id, current_file_id)
    {:noreply, socket}
  end

  def handle_event("hamburger", _, socket) do
    hamburger = socket.assigns.hamburger
    hamburger = if hamburger.status do
      %{hamburger | status: false, manager_menu: "", side_menu: ""}
    else
      %{hamburger | status: true, manager_menu: "action_manager_menu", side_menu: "action_side_menu"}
    end
    socket = socket
    |> assign(:hamburger, hamburger)
    {:noreply, socket}
  end

  def handle_event("selected_file", params, socket) do
    IO.puts inspect params
    {:noreply, socket}
  end

  def handle_event("detail", _params, socket) do
    detail = socket.assigns.detail
    IO.puts inspect detail
    detail = if detail.status == :row do
      %{detail| status: :column, detail_off: "hidden", detail_on: "", file_width: "w-full"}
    else
      %{detail| status: :row, detail_off: "", detail_on: "hidden", file_width: "w-[100px]"}
    end
    socket = socket
    |> assign(:detail, detail)
    {:noreply, socket}
  end
end
