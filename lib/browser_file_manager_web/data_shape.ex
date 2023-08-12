defmodule BrowserFileManagerWeb.DataShape do
  alias BrowserFileManagerWeb.DataShape
  alias BrowserFileManager.Content
  alias BrowserFileManager.Content.File
  # 共通で使うデータを整える関数をここに記述していく

  alias BrowserFileManager.FileData

  # pathを受け取ると、そのpathのフォルダ内のファイルを%FileData{}のリストにして返す
  def get_file_data_list(path) do

    #フルパスの取得
    root_path = Application.fetch_env!(:browser_file_manager, :root)
    join_path = root_path <> path
    # IO.puts "フルパス: " <> join_path

    #　linuxコマンドを打って、結果を整える
    ls_data = System.shell("cd #{join_path} && ls -p --group-directories-first")
    |> DataShape.format_ls()

    IO.puts inspect ls_data

    # ファイル名から%FileData{}にする作業
    ls_data = Enum.map(ls_data, fn s ->
      tmp_file_data = file_name_to_file_data(path, s)
      file_path = path <> "/" <> tmp_file_data.file_name
      %FileData{tmp_file_data | file_path: file_path}
    end)
  end

  def get_file_data(path, file_name, selected_is_currnet) do
    if path == "" and file_name == "" do
      %FileData{file_category: "d", file_name: "", file_img: "/images/folder.png"}
    else
      tmp_file_data = file_name_to_file_data(path, file_name)
      if selected_is_currnet do
        #カレントディレクトリのデータを作っていたときの処理
        IO.puts "あああああああああああああああああああああ"
        %FileData{tmp_file_data | file_path: path}
      else
        #選択したファイルのデータを作っていたときの処理
        IO.puts "いいいいいいいいいいいいいいいいいいいいいい"
        file_path = path <> "/" <> tmp_file_data.file_name
        %FileData{tmp_file_data | file_path: file_path}
      end
    end
  end

  # lsコマンドの結果を受け取り、フォルダ名とファイル名のリストにして返す
  def format_ls(ls_result) do
    formating = ls_result
    |> elem(0)
    |> String.split("\n")
    |> Enum.filter(fn s -> s != "" end)
  end

  def file_name_to_file_data(path, row_file_name) do
      xampp_http_ip = Application.fetch_env!(:browser_file_manager, :xampp_http_ip)
      #　文字列の最後の文字を取得する
      codepoints = String.codepoints(row_file_name)
      last_string = Enum.at(codepoints, Enum.count(codepoints)-1)
      #　もし最後の文字が "/" だったら "d" を一緒に返す
      file_category = (
        if last_string == "/" do
          "d"
        else
          #　文字列を "." でスプリットして、jpg等だったら "i" を一緒に返す　それ以外は "-" を返す
          dot_split = String.split(row_file_name, ".")
          case Enum.at(dot_split, Enum.count(dot_split)-1) do
            n when n in ["jpg", "jpeg", "png", "webp"] -> "i"
            n when n in ["mp4"] -> "v"
            _ -> "-"
          end
        end
      )
      file_name = (
        if last_string == "/" do
          DataShape.RemoveLastString.remove_last_string(row_file_name)
        else
          row_file_name
        end
      )
      file_img = (
        case file_category do
          "d" -> "/images/folder.png"
          "i" -> xampp_http_ip <> path <> "/" <> file_name
          "v" -> "/images/video_icon.png"
          "-" -> "/images/question_file.png"
        end
      )
      %FileData{file_category: file_category, file_name: file_name, file_img: file_img}
  end

  #フォルダ名とファイル名のリストを受け取ると、画像だけのリストにして返す
  def filter_images(file_list) when is_list(file_list) do
    file_list
    |> Enum.filter(
      fn s ->
        Enum.member?(
          ["png", "jpg", "jpeg", "webp"],
          Enum.at(
            String.split(s, "."), Enum.count(String.split(s, "."))-1
          )
        )
      end
    )
  end

  #パスを渡すとそのパスの親のパスを返す
  def get_parent_path(path) do
    parent_path = (
    if "" != path do
      String.split(path, "/")
      |> DataShape.RemoveLastString.remove_last_element()
      |> Enum.join("/")
    else
      ""
    end
    )
  end


  # list -p コマンドではディレクトリは最後に/がつくので取り除く
  # 文字列の最後の文字だけを取り除く関数　例　"hello/" -> "hello"
  defmodule RemoveLastString do
    def remove_last_string(str) when is_binary(str) do
      str_list = String.codepoints(str)
      str_list = remove_last_element(str_list)
      Enum.join(str_list, "")
    end
    def remove_last_element([]), do: []
    def remove_last_element([_]), do: []
    def remove_last_element([head | tail]) do
      [head | remove_last_element(tail)]
    end
  end

  def get_last_folder_name(path, category) do
    if path == "" do
      path
    else
      split_path_list = String.split(path, "/")
      last_element = List.last(split_path_list)
      if category == "d" do
        last_element <> "/"
      else
        last_element
      end
    end
  end

  #無駄な比較？が多かったのでボツ
  #lsしたlistと、DBから取ってきたlistを名前が一致するもので、まとめる
  # def zip_ls_db(file_list, db_children_files) do
  #   Enum.map(file_list, fn file ->
  #     db_file = Enum.find(db_children_files, fn db_file -> db_file.name == file.file_name end)
  #     file = %FileData{file | file_db: db_file}
  #   end)
  # end

  #lsしたlistと、DBから取ってきたlistを名前が一致するもので、まとめる
  def zip_ls_db(file_list, []) do
    file_list
  end
  def zip_ls_db(file_list, [db_file_last]) do
    index = Enum.find_index(file_list, fn file -> file.file_name == db_file_last.name end)
    file_list = if index != nil do
      List.update_at(file_list, index, &(%FileData{&1 | file_db: db_file_last}))
    else
      file_list
    end
  end
  def zip_ls_db(file_list, [db_file_head | db_file_tail]) do
    index = Enum.find_index(file_list, fn file -> file.file_name == db_file_head.name end)
    file_list = if index != nil do
      List.update_at(file_list, index, &(%FileData{&1 | file_db: db_file_head}))
    else
      file_list
    end
    zip_ls_db(file_list, db_file_tail)
  end

  #ファイルが持っているタグをプロパティでまとめて、そのファイルのgroup_tagsにぶちこむ
  def grouping_tags(file_list) do
    IO.puts "グルーピング"
    Enum.map(file_list, fn file ->
      group_tags = if file.file_db.id != nil do
        groups = Enum.map(file.file_db.tags, fn tag -> if tag.property != nil, do: %{p_id: tag.property_id, p_name: tag.property.name, tags: nil}, else: %{p_id: nil, p_name: nil, tags: nil} end)
        groups = Enum.uniq(groups)
        tags = file.file_db.tags

        Enum.map(groups, fn  group ->
          tmp = Enum.filter(tags, fn tag -> tag.property_id == group.p_id end)
          tmp = Enum.map(tmp, fn s -> %{id: s.id, name: s.name, p_id: s.property_id} end)
          %{group | tags: tmp}
        end)
      else
        nil
      end
      %FileData{file | group_tags: group_tags}
    end)
  end


end
