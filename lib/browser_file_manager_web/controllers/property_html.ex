defmodule BrowserFileManagerWeb.PropertyHTML do
  use BrowserFileManagerWeb, :html

  embed_templates "property_html/*"

  @doc """
  Renders a property form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def property_form(assigns)
end
