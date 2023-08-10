defmodule BrowserFileManager.InformationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BrowserFileManager.Information` context.
  """

  @doc """
  Generate a property.
  """
  def property_fixture(attrs \\ %{}) do
    {:ok, property} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> BrowserFileManager.Information.create_property()

    property
  end

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> BrowserFileManager.Information.create_tag()

    tag
  end
end
