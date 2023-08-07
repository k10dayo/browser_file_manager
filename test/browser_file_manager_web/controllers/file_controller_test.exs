defmodule BrowserFileManagerWeb.FileControllerTest do
  use BrowserFileManagerWeb.ConnCase

  import BrowserFileManager.ContentFixtures

  @create_attrs %{name: "some name", star: 42}
  @update_attrs %{name: "some updated name", star: 43}
  @invalid_attrs %{name: nil, star: nil}

  describe "index" do
    test "lists all files", %{conn: conn} do
      conn = get(conn, ~p"/files")
      assert html_response(conn, 200) =~ "Listing Files"
    end
  end

  describe "new file" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/files/new")
      assert html_response(conn, 200) =~ "New File"
    end
  end

  describe "create file" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/files", file: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/files/#{id}"

      conn = get(conn, ~p"/files/#{id}")
      assert html_response(conn, 200) =~ "File #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/files", file: @invalid_attrs)
      assert html_response(conn, 200) =~ "New File"
    end
  end

  describe "edit file" do
    setup [:create_file]

    test "renders form for editing chosen file", %{conn: conn, file: file} do
      conn = get(conn, ~p"/files/#{file}/edit")
      assert html_response(conn, 200) =~ "Edit File"
    end
  end

  describe "update file" do
    setup [:create_file]

    test "redirects when data is valid", %{conn: conn, file: file} do
      conn = put(conn, ~p"/files/#{file}", file: @update_attrs)
      assert redirected_to(conn) == ~p"/files/#{file}"

      conn = get(conn, ~p"/files/#{file}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, file: file} do
      conn = put(conn, ~p"/files/#{file}", file: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit File"
    end
  end

  describe "delete file" do
    setup [:create_file]

    test "deletes chosen file", %{conn: conn, file: file} do
      conn = delete(conn, ~p"/files/#{file}")
      assert redirected_to(conn) == ~p"/files"

      assert_error_sent 404, fn ->
        get(conn, ~p"/files/#{file}")
      end
    end
  end

  defp create_file(_) do
    file = file_fixture()
    %{file: file}
  end
end
