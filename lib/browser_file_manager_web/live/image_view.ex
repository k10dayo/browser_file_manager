defmodule BrowserFileManagerWeb.ImageView do
  use BrowserFileManagerWeb, :live_view
  alias BrowserFileManagerWeb.DataShape

  @xampp_http_ip Application.fetch_env!(:browser_file_manager, :xampp_http_ip)
  @root_path Application.fetch_env!(:browser_file_manager, :root)

  def mount(params, _session, socket) do
      # 現在の相対パスを取得
      relative_path =
      if( Map.get(params, "path") != nil) do
          params["path"]
      else
          ""
      end
      # 表示する画像のパス取得
      content_path = @xampp_http_ip <> relative_path
      current_image_name = Enum.at(String.split(relative_path, "/"), Enum.count(String.split(relative_path, "/"))-1)
      image_list = get_image_list(relative_path)

      current_image_index = Enum.find_index(image_list, fn s -> s == current_image_name end)

      parent_path = relative_path
      |> String.split("/")
      |> DataShape.RemoveLastString.remove_last_element()
      |> Enum.join("/")

      IO.puts inspect parent_path
      IO.puts inspect relative_path
      IO.puts inspect content_path
      IO.puts inspect current_image_name
      IO.puts inspect image_list
      IO.puts inspect current_image_index

      socket = assign(socket,
      parent_path: parent_path,
      image_path: relative_path,
      content_path: content_path,
      current_image_name: current_image_name,
      image_list: image_list,
      current_image_index: current_image_index
      )

      {:ok, socket, layout: false}
  end

  def handle_event("left", _, socket) do
      image_list = socket.assigns[:image_list]
      current_image_index = socket.assigns[:current_image_index]
      parent_path = socket.assigns[:parent_path]
      current_image_index = (
      if current_image_index > 0 do
          current_image_index = current_image_index - 1
      else
          current_image_index
      end
      )
      current_image_name = Enum.at(image_list, current_image_index)
      content_path = @xampp_http_ip <> parent_path <> "/" <> current_image_name

      socket = assign(socket,
      current_image_index: current_image_index,
      content_path: content_path
      )
      {:noreply, socket}
  end

  def handle_event("right", _, socket) do
      image_list = socket.assigns[:image_list]
      current_image_index = socket.assigns[:current_image_index]
      parent_path = socket.assigns[:parent_path]
      current_image_index = (
      if current_image_index < Enum.count(image_list)-1 do
          current_image_index = current_image_index + 1
      else
          current_image_index
      end
      )
      current_image_name = Enum.at(image_list, current_image_index)
      content_path = @xampp_http_ip <> parent_path <> "/" <> current_image_name

      socket = assign(socket,
      current_image_index: current_image_index,
      content_path: content_path
      )
      {:noreply, socket}
  end


  # 以下関数
  def get_image_list(relative_path) do

      parent_path = (
      if "" != relative_path do
      String.split(relative_path, "/")
      |> DataShape.RemoveLastString.remove_last_element()
      |> Enum.join("/")
      else
      ""
      end)

      parent_path = @root_path <> parent_path
      image_list = System.shell("cd #{parent_path} && ls")
      |> DataShape.format_ls()
      |> DataShape.filter_images()
  end
end
