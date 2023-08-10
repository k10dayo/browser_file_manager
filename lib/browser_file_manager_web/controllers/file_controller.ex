defmodule BrowserFileManagerWeb.FileController do
  use BrowserFileManagerWeb, :controller

  alias BrowserFileManager.Content
  alias BrowserFileManager.Content.File

  def index(conn, _params) do
    files = Content.list_files()
    render(conn, :index, files: files)
  end

  def new(conn, _params) do
    changeset = Content.change_file(%File{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, params) do
    file_params = params["file"]
    tag_ids = if Map.has_key?(params, "hello"), do: params["hello"], else: []
    file_params = Map.put(file_params, "tag_ids", tag_ids)
    IO.puts inspect file_params

    case Content.create_file(file_params) do
      {:ok, file} ->
        conn
        |> put_flash(:info, "File created successfully.")
        |> redirect(to: ~p"/files/#{file}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    absolute_path = Content.get_absolute_path(id)
    file = Content.get_file!(id)
    render(conn, :show, file: file, absolute_path: absolute_path)
  end

  def edit(conn, %{"id" => id}) do
    file = Content.get_file!(id)
    changeset = Content.change_file(file)
    render(conn, :edit, file: file, changeset: changeset)
  end

  def update(conn, params) do
    IO.puts inspect params
    id = params["id"]
    file_params = params["file"]
    tag_ids = if Map.has_key?(params, "hello"), do: params["hello"], else: []
    file_params = Map.put(file_params, "tag_ids", tag_ids)
    IO.puts inspect file_params

    file = Content.get_file!(id)

    case Content.update_file(file, file_params) do
      {:ok, file} ->
        conn
        |> put_flash(:info, "File updated successfully.")
        |> redirect(to: ~p"/files/#{file}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, file: file, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Content.get_file!(id)
    {:ok, _file} = Content.delete_file(file)

    conn
    |> put_flash(:info, "File deleted successfully.")
    |> redirect(to: ~p"/files")
  end
end
