defmodule Accomplish.Repo.Migrations.CreateApiKeys do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:api_keys, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :key_hash, :string, null: false
      add :key_prefix, :string, null: false
      add :scopes, {:array, :string}, null: false
      add :revoked_at, :utc_datetime
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:api_keys, [:key_hash], concurrently: true)
    create index(:api_keys, [:user_id], concurrently: true)
  end

  def down do
    drop_if_exists unique_index(:api_keys, [:key_hash], concurrently: true)
    drop_if_exists index(:api_keys, [:user_id], concurrently: true)

    drop table(:api_keys)
  end
end
