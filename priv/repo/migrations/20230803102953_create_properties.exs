defmodule BrowserFileManager.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :name, :string

      timestamps()
    end
  end
end
