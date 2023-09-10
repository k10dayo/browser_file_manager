defmodule BrowserFileManager.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :name, :string
      add :star, :integer, default: 0, null: false
      add :parent_id, references(:files, on_delete: :nothing)
      add :category, :char

      timestamps()
    end

    create index(:files, [:parent_id])
  end
end
