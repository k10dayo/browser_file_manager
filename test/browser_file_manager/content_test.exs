defmodule BrowserFileManager.ContentTest do
  use BrowserFileManager.DataCase

  alias BrowserFileManager.Content

  describe "files" do
    alias BrowserFileManager.Content.File

    import BrowserFileManager.ContentFixtures

    @invalid_attrs %{name: nil, star: nil}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Content.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Content.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      valid_attrs = %{name: "some name", star: 42}

      assert {:ok, %File{} = file} = Content.create_file(valid_attrs)
      assert file.name == "some name"
      assert file.star == 42
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      update_attrs = %{name: "some updated name", star: 43}

      assert {:ok, %File{} = file} = Content.update_file(file, update_attrs)
      assert file.name == "some updated name"
      assert file.star == 43
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_file(file, @invalid_attrs)
      assert file == Content.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Content.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Content.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Content.change_file(file)
    end
  end
end
