defmodule BrowserFileManager.Content.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :name, :string
    field :star, :integer
    # field :parent_id, :id
    belongs_to :parent, BrowserFileManager.Content.File

    many_to_many :tags, BrowserFileManager.Information.Tag, join_through: "file_tags", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name, :star, :parent_id])
    |> validate_required([:name])
  end
end
