defmodule BrowserFileManagerWeb.ManagerLive do
  use BrowserFileManagerWeb, :live_view

  alias BrowserFileManagerWeb.DataShape
  alias BrowserFileManager.Content
  alias BrowserFileManager.FileData

  alias Phoenix.LiveView.JS

  def mount(params, _session, socket) do
    IO.puts "マウント"

    path = ( if params["path"] != nil, do: params["path"], else: "" )
    xampp_http_ip = Application.fetch_env!(:browser_file_manager, :xampp_http_ip)
    parent_path = DataShape.get_parent_path(path)
    current_file_id = Content.get_current_id_entry(path) #currnet_file_id改善の余地あり、　pathで判断しているが、current_file_idで検索するなどしたい
    IO.puts "カレントファイルID:" <> inspect current_file_id

    # #カレントフォルダーのデータを作る
    current_folder_name = DataShape.get_last_folder_name(path, "d")
    current_folder_data = DataShape.get_file_data(path, current_folder_name, true)
    db_current_file = Content.get_db_file(current_file_id)
    zip_current_folder_data = DataShape.zip_ls_db([current_folder_data], db_current_file)
    current_folder_data = Enum.at(DataShape.grouping_tags(zip_current_folder_data), 0)

    socket = socket
    |> assign(:path, path)
    |> assign(:xampp_http_ip, xampp_http_ip)
    |> assign(:parent_path, parent_path)
    |> assign(:currnet_file_id, current_file_id)
    |> assign(:selected_is_current, true)
    |> assign(:selected, current_folder_data)
    |> assign(:hamburger, %{status: false, manager_menu: "", side_menu: ""})
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

    path = socket.assigns.path

    current_file_id = Content.get_current_id_entry(path)

    #カレントディレクトリの子のファイルデータを取得する
    tmp_file_list = DataShape.get_file_data_list(path)
    db_children_files = Content.get_db_children_files(path, current_file_id)
    file_list = DataShape.zip_ls_db(tmp_file_list, db_children_files)
    file_list = DataShape.grouping_tags(file_list)

    #選択中ファイルのデータを作る　更新する
    selected = socket.assigns.selected
    selected_file_name = DataShape.get_last_folder_name(selected.file_path, selected.file_category)
    selected_file_data = DataShape.get_file_data(path, selected_file_name, socket.assigns.selected_is_current)
    db_selected_file = Content.get_db_file(selected.file_db.id)
    zip_selected_file_data = DataShape.zip_ls_db([selected_file_data], db_selected_file)
    selected_file_data = Enum.at(DataShape.grouping_tags(zip_selected_file_data), 0)

    IO.puts inspect Enum.at(file_list, 4)

    socket
    |> assign(:file_list, file_list)
    |> assign(:currnet_file_id, current_file_id)
    |> assign(:selected, selected_file_data)
    |> assign(:page_title, "Index File")

    # if Map.has_key?(params, "search") do
    #   search_way(socket, params)
    # else
    #   common_way(socket, params)
    # end
  end

  # 一般的なルート（検索じゃないほう）
  def common_way(socket, params) do
    IO.puts "コモンウェイ"

    path = socket.assigns.path

    current_file_id = Content.get_current_id_entry(path)

    #カレントディレクトリの子のファイルデータを取得する
    tmp_file_list = DataShape.get_file_data_list(path)
    db_children_files = Content.get_db_children_files(path, current_file_id)
    file_list = DataShape.zip_ls_db(tmp_file_list, db_children_files)
    file_list = DataShape.grouping_tags(file_list)

    #選択中ファイルのデータを作る　更新する
    selected = socket.assigns.selected
    selected_file_name = DataShape.get_last_folder_name(selected.file_path, selected.file_category)
    selected_file_data = DataShape.get_file_data(path, selected_file_name, socket.assigns.selected_is_current)
    db_selected_file = Content.get_db_file(selected.file_db.id)
    zip_selected_file_data = DataShape.zip_ls_db([selected_file_data], db_selected_file)
    selected_file_data = Enum.at(DataShape.grouping_tags(zip_selected_file_data), 0)

    IO.puts inspect Enum.at(file_list, 4)

    socket
    |> assign(:file_list, file_list)
    |> assign(:currnet_file_id, current_file_id)
    |> assign(:selected, selected_file_data)
    |> assign(:page_title, "Index File")
  end

  # 検索のときのルート
  def search_way(socket, params) do
    IO.puts "サーチウェイ"

    socket
  end

  defp apply_action(socket, :edit, _params) do
    IO.puts "アプライアクション:edit"
    socket
    |> assign(:page_title, "Edit File")
  end

  defp apply_action(socket, :new, _params) do
    IO.puts "アプライアクション:new"
    socket
    |> assign(:page_title, "New File")
  end

  defp apply_action(socket, :search, _params) do
    IO.puts "アプライアクション:search"
    socket
    |> assign(:page_title, "Search")
  end

  # :newでsaveしたデータのidをselected.file_dbに入れて、表示を変更させるため
  defp apply_action(socket, :new_id, %{"id" => id}) do
    IO.puts "アプライアクション:new_id"
    [db_selected_file] = Content.get_db_file(id)
    selected_file_data = %FileData{socket.assigns.selected | file_db: db_selected_file}

    patch = "/live?path=" <> socket.assigns.path
    socket
    |> assign(:selected, selected_file_data)
    |> push_patch(to: patch)
  end

  def handle_event("change", %{"path" => path}, socket) do
    IO.puts "ハンドルイベント:change"

    parent_path = DataShape.get_parent_path(path)
    current_file_id = Content.get_current_id_entry(path)
    IO.puts "カレントファイルID" <> inspect current_file_id

    #カレントディレクトリの子のファイルデータを取得する
    tmp_file_list = DataShape.get_file_data_list(path)
    db_children_files = Content.get_db_children_files(path, current_file_id)
    file_list = DataShape.zip_ls_db(tmp_file_list, db_children_files)
    file_list = DataShape.grouping_tags(file_list)

    #カレントフォルダーのデータを作る
    current_folder_name = DataShape.get_last_folder_name(path, "d")
    current_folder_data = DataShape.get_file_data(path, current_folder_name, true)
    db_current_file = Content.get_db_file(current_file_id)
    zip_current_folder_data = DataShape.zip_ls_db([current_folder_data], db_current_file)
    current_folder_data = Enum.at(DataShape.grouping_tags(zip_current_folder_data), 0)

    socket = socket
    |> assign(:file_list, file_list)
    |> assign(:parent_path, parent_path)
    |> assign(:path, path)
    |> assign(:current_file_id, current_file_id)
    |> assign(:selected_is_currnet, true)
    |> assign(:selected, current_folder_data)
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
    IO.puts "ハンドルイベント selected_file"
    path = socket.assigns.path
    selected_file_path =  params["selected_file_path"]
    selected_file_id = params["selected_file_id"]
    selected_file_category = params["selected_file_category"]

    #選択したフォルダーのデータを作る
    selected_file_name = DataShape.get_last_folder_name(selected_file_path, selected_file_category)

    selected_folder_data = DataShape.get_file_data(path, selected_file_name, false)
    IO.puts inspect selected_folder_data.file_path
    db_selected_file = Content.get_db_file(selected_file_id)
    zip_selected_file_data = DataShape.zip_ls_db([selected_folder_data], db_selected_file)
    selected_folder_data = Enum.at(DataShape.grouping_tags(zip_selected_file_data), 0)

    socket = socket
    |> assign(:selected_is_current, false)
    |> assign(:selected, selected_folder_data)
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

  def handle_event("wowow", _params, socket) do
    IO.puts ("あああああああああああああああああああああああ")
    {:noreply, socket}
  end
end
