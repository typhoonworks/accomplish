defmodule Accomplish.Repo.Migrations.CreateCoverLetters do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:cover_letters, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string, null: false
      add :content, :text, null: false
      add :status, :string, default: "draft", null: false
      add :submitted_at, :utc_datetime

      add :application_id, references(:job_applications, type: :uuid, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:cover_letters, [:application_id], concurrently: true)
  end

  def down do
    drop_if_exists index(:cover_letters, [:application_id], concurrently: true)
    drop table(:cover_letters)
  end
end
