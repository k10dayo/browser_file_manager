defmodule BrowserFileManagerWeb.PageHTML do
  use BrowserFileManagerWeb, :html
  embed_templates "page_html/*"

  alias BrowserFileManagerWeb.DataShape
  alias BrowserFileManager.FileData

  def get_list(path) do
    IO.puts "受け取ったパス: " <> path

    #ルートパスの取得
    root_path = Application.fetch_env!(:browser_file_manager, :root)
    join_path = root_path <> path
    IO.puts "フルパス: " <> join_path

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

    # IO.puts inspect ls_data
    ls_data
  end
end
