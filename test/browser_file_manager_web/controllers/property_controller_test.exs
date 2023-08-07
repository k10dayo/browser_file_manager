defmodule BrowserFileManagerWeb.PropertyControllerTest do
  use BrowserFileManagerWeb.ConnCase

  import BrowserFileManager.InformationFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all properties", %{conn: conn} do
      conn = get(conn, ~p"/properties")
      assert html_response(conn, 200) =~ "Listing Properties"
    end
  end

  describe "new property" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/properties/new")
      assert html_response(conn, 200) =~ "New Property"
    end
  end

  describe "create property" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/properties", property: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/properties/#{id}"

      conn = get(conn, ~p"/properties/#{id}")
      assert html_response(conn, 200) =~ "Property #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/properties", property: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Property"
    end
  end

  describe "edit property" do
    setup [:create_property]

    test "renders form for editing chosen property", %{conn: conn, property: property} do
      conn = get(conn, ~p"/properties/#{property}/edit")
      assert html_response(conn, 200) =~ "Edit Property"
    end
  end

  describe "update property" do
    setup [:create_property]

    test "redirects when data is valid", %{conn: conn, property: property} do
      conn = put(conn, ~p"/properties/#{property}", property: @update_attrs)
      assert redirected_to(conn) == ~p"/properties/#{property}"

      conn = get(conn, ~p"/properties/#{property}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, property: property} do
      conn = put(conn, ~p"/properties/#{property}", property: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Property"
    end
  end

  describe "delete property" do
    setup [:create_property]

    test "deletes chosen property", %{conn: conn, property: property} do
      conn = delete(conn, ~p"/properties/#{property}")
      assert redirected_to(conn) == ~p"/properties"

      assert_error_sent 404, fn ->
        get(conn, ~p"/properties/#{property}")
      end
    end
  end

  defp create_property(_) do
    property = property_fixture()
    %{property: property}
  end
end
