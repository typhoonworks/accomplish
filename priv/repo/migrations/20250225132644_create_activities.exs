defmodule Accomplish.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:activities, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :actor_id, :uuid, null: false
      add :actor_type, :string, null: false, default: "User"
      add :action, :string, null: false
      add :metadata, :map, default: %{}

      add :target_id, :uuid, null: false
      add :target_type, :string, null: false

      add :occurred_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:activities, [:actor_id, :actor_type], concurrently: true)
    create index(:activities, [:target_id, :target_type], concurrently: true)
    create index(:activities, [:inserted_at], concurrently: true)
  end

  def down do
    drop_if_exists index(:activities, [:actor_id, :actor_type], concurrently: true)
    drop_if_exists index(:activities, [:target_id, :target_type], concurrently: true)
    drop_if_exists index(:activities, [:inserted_at], concurrently: true)
    drop table(:activities)
  end
end
