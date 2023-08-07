defmodule BrowserFileManagerWeb.TagHTML do
  use BrowserFileManagerWeb, :html

  import Phoenix.HTML.Form

  embed_templates "tag_html/*"

  @doc """
  Renders a tag form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def tag_form(assigns)
end
