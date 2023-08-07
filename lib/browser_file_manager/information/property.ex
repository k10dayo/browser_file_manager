defmodule BrowserFileManager.Information.Property do
  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
