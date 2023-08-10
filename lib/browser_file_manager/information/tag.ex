defmodule BrowserFileManager.Information.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    belongs_to :property, BrowserFileManager.Information.Property

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :property_id])
    |> validate_required([:name])
  end
end
