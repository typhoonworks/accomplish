defmodule Accomplish.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:notifications, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string, null: false
      add :event_name, :string, null: false
      add :status, :string, null: false, default: "unread"
      add :navigate_url, :string
      add :metadata, :map, default: %{}

      add :source_id, :uuid
      add :source_type, :string
      add :actor_id, :uuid, null: false
      add :actor_type, :string, null: false, default: "User"

      add :recipient_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:notifications, [:type, :status], concurrently: true)
    create index(:notifications, [:recipient_id], concurrently: true)
    create index(:notifications, [:actor_id, :actor_type], concurrently: true)
  end

  def down do
    drop_if_exists index(:notifications, [:actor_id, :actor_type], concurrently: true)
    drop_if_exists index(:notifications, [:recipient_id], concurrently: true)
    drop_if_exists index(:notifications, [:type, :status], concurrently: true)
    drop table(:notifications)
  end
end
