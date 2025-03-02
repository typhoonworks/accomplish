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

      add :entity_id, :uuid, null: false
      add :entity_type, :string, null: false

      add :context_id, :uuid, null: true
      add :context_type, :string, null: true

      add :occurred_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:activities, [:actor_id, :actor_type], concurrently: true)
    create index(:activities, [:entity_id, :entity_type], concurrently: true)
    create index(:activities, [:context_id, :context_type], concurrently: true)
    create index(:activities, [:inserted_at], concurrently: true)
  end

  def down do
    drop_if_exists index(:activities, [:actor_id, :actor_type], concurrently: true)
    drop_if_exists index(:activities, [:entity_id, :entity_type], concurrently: true)
    drop_if_exists index(:activities, [:context_id, :context_type], concurrently: true)
    drop_if_exists index(:activities, [:inserted_at], concurrently: true)
    drop table(:activities)
  end
end
