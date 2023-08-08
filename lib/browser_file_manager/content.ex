defmodule BrowserFileManager.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias BrowserFileManager.Repo

  alias BrowserFileManager.Content.File
  alias BrowserFileManager.Information.Tag

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  # def list_files do
  #   Repo.all(File)
  # end
  def list_files do
    Repo.all(File)
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

      iex> get_file!(456)
      ** (Ecto.NoResultsError)

  """
  # def get_file!(id), do: Repo.get!(File, id)
  def get_file!(id) do
    File
    |> Repo.get!(id)
    |> Repo.preload(:tags)
  end

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_file(attrs \\ %{}) do
  #   %File{}
  #   |> File.changeset(attrs)
  #   |> Repo.insert()
  # end
  def create_file(attrs \\ %{}) do
    path = String.split(attrs["name"], "/")
    [emp | path] = path
    root_select(path, attrs, %File{})
  end

  @doc """
  Updates a file.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file(%File{} = file, attrs) do
    file
    # |> File.changeset(attrs)
    |> change_file(attrs)
    |> Repo.update()
  end


  #root_selectが一番最初の入口になる
  #受け取ったパスが１つのとき（ルートのファイルを追加編集するとき）
  def root_select([last], attrs, file) do
    IO.puts "ルートセレクト（ラスト）"
    id = Repo.one(from u in File, select: u.id, where: is_nil(u.parent_id), where: u.name == ^last)
    #もしデータが存在していたらアップデートする
    if id != nil do
      file = get_file!(id)
      attrs = Map.put(attrs, "name", last)
      attrs = Map.put(attrs, "parent_id", nil)
      update_file(file, attrs)
    else
      #データがなかった場合は作成する
      root_insert([last], attrs, file)
    end
  end
  #受け取ったパスが２つ以上のとき（ルートより下のファイルを追加編集するとき）
  def root_select(path, attrs, file) when is_list(path) do
    IO.puts "ルートセレクト"
    [head | tail] = path
    id = Repo.one(from u in File, select: u.id, where: is_nil(u.parent_id), where: u.name == ^head)
    #もしデータがあれば、その下のパスを検索する
    if id != nil do
      rest_select(tail, id, attrs, file)
    else
      #データがなかったら作成する
      root_insert(path, attrs, file)
    end
  end
  #２つ目以降で最後のパスを探す関数
  def rest_select([last], parent_id, attrs, file) do
    IO.puts "レストセレクト（ラスト）"
    id = Repo.one(from u in File, select: u.id, where: u.parent_id == ^parent_id, where: u.name == ^last)
    #ファイルが存在する場合はアップデート
    if id != nil do
      file = get_file!(id)
      attrs = Map.put(attrs, "name", last)
      attrs = Map.put(attrs, "parent_id", parent_id)
      update_file(file, attrs)
    else
      #データがなかったら作成する
      rest_insert([last], parent_id, attrs, file)
    end
  end
  #２つ目以降のパスを探す関数
  def rest_select(path, parent_id, attrs, file) do
    IO.puts "レストセレクト"
    [head | tail] = path
    id = Repo.one(from u in File, select: u.id, where: u.parent_id == ^parent_id, where: u.name == ^head)
    #ファイルが存在する場合は、その下のパスを検索する
    if id != nil do
      rest_select(tail, id, attrs, file)
    else
      #データがなかったら作成する
      rest_insert(path, parent_id, attrs, file)
    end
  end
  #追加編集するファイルがルートのとき作成する関数
  def root_insert([last], attrs, file) do
    IO.puts "ルートインサート（ラスト）"
    attrs = Map.put(attrs, "name", last)
    %File{}
    |> change_file(attrs)
    |> Repo.insert()
  end
  #ルートのデータを作成する関数
  def root_insert([head | tail], attrs, file) do
    IO.puts "ルートインサート"
    %File{}
    |> change_file(%{"name" => head, "parent_id" => "", "star" => "", "tag_ids" => []})
    |> Repo.insert()
    id = Repo.one(from u in File, select: u.id, where: is_nil(u.parent_id), where: u.name == ^head)
    #作成したファイルの下のデータを作成する
    rest_insert(tail, id, attrs, file)
  end
  #２つ目以降の追加編集するファイルを作成する関数
  def rest_insert([last], parent_id, attrs, file) do
    IO.puts "レストインサート（ラスト）"
    attrs = Map.put(attrs, "name", last)
    attrs = Map.put(attrs, "parent_id", parent_id)
    file
    |> change_file(attrs)
    |> Repo.insert()
  end
  #２つ目以降のファイルを作成する関数
  def rest_insert([head | tail], parent_id, attrs, file) do
    IO.puts "レストインサート"
    %File{}
    |> change_file(%{"name" => head, "parent_id" => parent_id, "star" => "", "tag_ids" => []})
    |> Repo.insert()
    id = Repo.one(from u in File, select: u.id, where: u.parent_id == ^parent_id, where: u.name == ^head)
    #作成したファイルの下のデータを作成する
    rest_insert(tail, id, attrs, file)
  end

  @doc """
  Deletes a file.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Ecto.Changeset{data: %File{}}

  """
  # def change_file(%File{} = file, attrs \\ %{}) do
  #   File.changeset(file, attrs)
  # end

  def change_file(%File{} = file, attrs \\ %{}) do
    tags = list_tags_by_id(attrs["tag_ids"])
    file
    |> Repo.preload(:tags)
    |> File.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
  end

  # タグidを受け取って、その情報を返す　put_assocでくっつける
  def list_tags_by_id(nil), do: []
  def list_tags_by_id(tag_ids) do
    Repo.all(from c in Tag, where: c.id in ^tag_ids)
  end

  #絶対パスを取得してくる
  def get_absolute_path(id) do
    id = String.to_integer(id)
    sql ="
      WITH RECURSIVE connected_files AS (
      SELECT id, name, parent_id
      FROM files
      WHERE id = $1

      UNION ALL

      SELECT p.id, p.name, p.parent_id
      FROM files p
      JOIN connected_files c ON p.id = c.parent_id
    )
    SELECT *
    FROM connected_files;
  "
  {:ok, result} = Ecto.Adapters.SQL.query(BrowserFileManager.Repo, sql, [id])
  IO.puts inspect result.columns
  rows = Enum.reverse(result.rows)
  IO.puts inspect rows
  absolute_path = Enum.map(rows, fn s -> Enum.at(s, 1) end)
  |> List.insert_at(0, "")
  |> Enum.join("/")
  IO.puts inspect absolute_path
  absolute_path
  end

  def get_children() do
    Repo.all(from u in File, where: is_nil u.parent_id)
    |> Repo.preload(:tags)
    # Repo.all(File)
  end
end
