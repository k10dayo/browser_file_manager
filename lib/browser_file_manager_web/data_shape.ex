defmodule BrowserFileManagerWeb.DataShape do
  alias BrowserFileManagerWeb.DataShape
  # 共通で使うデータを整える関数をここに記述していく

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
