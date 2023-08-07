defmodule BrowserFileManager.InformationTest do
  use BrowserFileManager.DataCase

  alias BrowserFileManager.Information

  describe "properties" do
    alias BrowserFileManager.Information.Property

    import BrowserFileManager.InformationFixtures

    @invalid_attrs %{name: nil}

    test "list_properties/0 returns all properties" do
      property = property_fixture()
      assert Information.list_properties() == [property]
    end

    test "get_property!/1 returns the property with given id" do
      property = property_fixture()
      assert Information.get_property!(property.id) == property
    end

    test "create_property/1 with valid data creates a property" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Property{} = property} = Information.create_property(valid_attrs)
      assert property.name == "some name"
    end

    test "create_property/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Information.create_property(@invalid_attrs)
    end

    test "update_property/2 with valid data updates the property" do
      property = property_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Property{} = property} = Information.update_property(property, update_attrs)
      assert property.name == "some updated name"
    end

    test "update_property/2 with invalid data returns error changeset" do
      property = property_fixture()
      assert {:error, %Ecto.Changeset{}} = Information.update_property(property, @invalid_attrs)
      assert property == Information.get_property!(property.id)
    end

    test "delete_property/1 deletes the property" do
      property = property_fixture()
      assert {:ok, %Property{}} = Information.delete_property(property)
      assert_raise Ecto.NoResultsError, fn -> Information.get_property!(property.id) end
    end

    test "change_property/1 returns a property changeset" do
      property = property_fixture()
      assert %Ecto.Changeset{} = Information.change_property(property)
    end
  end

  describe "tags" do
    alias BrowserFileManager.Information.Tag

    import BrowserFileManager.InformationFixtures

    @invalid_attrs %{name: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Information.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Information.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tag{} = tag} = Information.create_tag(valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Information.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tag{} = tag} = Information.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Information.update_tag(tag, @invalid_attrs)
      assert tag == Information.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Information.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Information.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Information.change_tag(tag)
    end
  end
end
