defmodule BrowserFileManagerWeb.PropertyController do
  use BrowserFileManagerWeb, :controller

  alias BrowserFileManager.Information
  alias BrowserFileManager.Information.Property

  def index(conn, _params) do
    properties = Information.list_properties()
    render(conn, :index, properties: properties)
  end

  def new(conn, _params) do
    changeset = Information.change_property(%Property{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"property" => property_params}) do
    case Information.create_property(property_params) do
      {:ok, property} ->
        conn
        |> put_flash(:info, "Property created successfully.")
        |> redirect(to: ~p"/properties/#{property}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    property = Information.get_property!(id)
    render(conn, :show, property: property)
  end

  def edit(conn, %{"id" => id}) do
    property = Information.get_property!(id)
    changeset = Information.change_property(property)
    render(conn, :edit, property: property, changeset: changeset)
  end

  def update(conn, %{"id" => id, "property" => property_params}) do
    property = Information.get_property!(id)

    case Information.update_property(property, property_params) do
      {:ok, property} ->
        conn
        |> put_flash(:info, "Property updated successfully.")
        |> redirect(to: ~p"/properties/#{property}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, property: property, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    property = Information.get_property!(id)
    {:ok, _property} = Information.delete_property(property)

    conn
    |> put_flash(:info, "Property deleted successfully.")
    |> redirect(to: ~p"/properties")
  end
end
