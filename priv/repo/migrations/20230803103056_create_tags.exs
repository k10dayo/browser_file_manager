defmodule BrowserFileManager.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :property_id, references(:properties, on_delete: :nothing)

      timestamps()
    end

    create index(:tags, [:property_id])
  end
end
