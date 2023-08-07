defmodule BrowserFileManager.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BrowserFileManager.Content` context.
  """

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        name: "some name",
        star: 42
      })
      |> BrowserFileManager.Content.create_file()

    file
  end
end
