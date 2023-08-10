defmodule BrowserFileManagerWeb.FileHTML do
  use BrowserFileManagerWeb, :html

  import Phoenix.HTML.Form

  embed_templates "file_html/*"

  @doc """
  Renders a file form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def file_form(assigns)

  def tag_select(f, changeset) do
    existing_ids =
      changeset
      |> Ecto.Changeset.get_change(:tags, [])
      |> Enum.map(& &1.data.id)
    IO.puts inspect changeset
    IO.puts inspect existing_ids

    tag_opts =
      # for cat <- BrowserFileManager.Information.list_tags(),
      for cat <- BrowserFileManager.Information.list_tags(),
          do: [key: cat.name, value: cat.id, selected: cat.id in existing_ids]

    multiple_select(f, :tag_ids, tag_opts)
  end

  def tag_select_origin(f, changeset) do
    existing_ids =
      changeset
      |> Ecto.Changeset.get_change(:tags, [])
      |> Enum.map(& &1.data.id)
    IO.puts inspect changeset
    IO.puts inspect existing_ids

    tag_opts =
      # for cat <- BrowserFileManager.Information.list_tags(),
      for cat <- BrowserFileManager.Information.list_tags() do
        %{key: cat.name,
        value: cat.id,
        selected: cat.id in existing_ids,
        property_id: (if cat.property ==nil, do: nil, else: cat.property.id),
        property: (if cat.property ==nil, do: "無プロパティ", else: cat.property.name)
        }
      end

    # property_uniq_id = Enum.map(tag_opts, fn s -> s.property_id end) |> Enum.uniq |> Enum.sort(fn x, y -> x === nil || (y !== nil && x <= y) end)
    property_uniq_id = Enum.map(tag_opts, fn s -> %{id: s.property_id, name: s.property} end) |> Enum.uniq_by(fn %{id: id} -> id end)

    sort_tags =
      for property_id <- property_uniq_id do
        for tag when tag.property_id == property_id.id <- tag_opts, do: tag
      end

    tag_zip = Enum.zip(property_uniq_id, sort_tags)
    tag_zip
  end
end
