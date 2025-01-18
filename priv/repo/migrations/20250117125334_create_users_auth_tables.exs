defmodule Accomplish.Repo.Migrations.CreateUsersAuthTables do
  # excellent_migrations:safety-assured-for-this-file table_dropped

  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS citext;")

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :username, :string, null: false
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create table(:users_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create unique_index(:users, [:username], concurrently: true)
    create unique_index(:users, [:email], concurrently: true)
    create index(:users_tokens, [:user_id], concurrently: true)
    create unique_index(:users_tokens, [:context, :token], concurrently: true)
  end

  def down do
    drop_if_exists unique_index(:users_tokens, [:context, :token], concurrently: true)
    drop_if_exists index(:users_tokens, [:user_id], concurrently: true)
    drop_if_exists unique_index(:users, [:email], concurrently: true)
    drop_if_exists unique_index(:users, [:username], concurrently: true)

    drop table(:users_tokens)
    drop table(:users)

    execute("DROP EXTENSION IF EXISTS citext;")
  end
end
