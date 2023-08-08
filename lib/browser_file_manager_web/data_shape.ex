defmodule BrowserFileManagerWeb.DataShape do
  alias BrowserFileManagerWeb.DataShape
  alias BrowserFileManager.Content
  # 共通で使うデータを整える関数をここに記述していく

  alias BrowserFileManager.FileData

  # pathを受け取ると、そのpathのフォルダ内のファイルを%FileData{}のリストにして返す
  def get_list(path) do
    IO.puts "ゲットリスト()"
    IO.puts "受け取ったパス: " <> path
    IO.puts inspect Content.get_children()

    #フルパスの取得
    root_path = Application.fetch_env!(:browser_file_manager, :root)
    join_path = root_path <> path
    # IO.puts "フルパス: " <> join_path

    #　linuxコマンドを打って、結果を整える
    ls_data = System.shell("cd #{join_path} && ls -p --group-directories-first")
    |> DataShape.format_ls()

    IO.puts inspect ls_data

    ls_data = Enum.map(ls_data, fn s ->
      #　文字列の最後の文字を取得する
      codepoints = String.codepoints(s)
      last_string = Enum.at(codepoints, Enum.count(codepoints)-1)
      #　もし最後の文字が "/" だったら "d" を一緒に返す
      file_category = (
        if last_string == "/" do
          "d"
        else
          #　文字列を "." でスプリットして、jpg等だったら "i" を一緒に返す　それ以外は "-" を返す
          dot_split = String.split(s, ".")
          case Enum.at(dot_split, Enum.count(dot_split)-1) do
            n when n in ["jpg", "jpeg", "png", "webp"] -> "i"
            n when n in ["mp4"] -> "v"
            _ -> "-"
          end
        end
      )
      file_name = (
        if last_string == "/" do
          DataShape.RemoveLastString.remove_last_string(s)
        else
          s
        end
      )
      file_path = path <> "/" <> file_name
      %FileData{file_category: file_category, file_name: file_name, file_path: file_path}
    end)

    ls_data
  end

  def get_children(path) do
    IO.puts "hello"
  end

  # lsコマンドの結果を受け取り、フォルダ名とファイル名のリストにして返す
  def format_ls(ls_result) do
    formating = ls_result
    |> elem(0)
    |> String.split("\n")
    |> Enum.filter(fn s -> s != "" end)
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

end
