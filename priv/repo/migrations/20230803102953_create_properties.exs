defmodule BrowserFileManager.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :name, :string

      timestamps()
    end

    create unique_index(:properties, [:name])
  end
end
