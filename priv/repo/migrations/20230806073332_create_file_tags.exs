defmodule BrowserFileManager.Repo.Migrations.CreateFileTags do
  use Ecto.Migration

  def change do
    create table(:file_tags, primary_key: false) do
      add :file_id, references(:files, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
    end

    create index(:file_tags, [:file_id])
    create unique_index(:file_tags, [:file_id, :tag_id])
  end
end
