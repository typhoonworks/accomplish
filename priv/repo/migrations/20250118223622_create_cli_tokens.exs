defmodule Accomplish.Repo.Migrations.CreateCliTokens do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:cli_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :token, :string, null: false
      add :expires_at, :utc_datetime, null: false
      add :state, :string, null: false, default: "pending"
      add :context, :map, null: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true

      timestamps(type: :utc_datetime)
    end

    create index(:cli_tokens, [:user_id], concurrently: true)
    create index(:cli_tokens, [:token], concurrently: true)
  end

  def down do
    drop_if_exists index(:cli_tokens, [:user_id], concurrently: true)
    drop_if_exists index(:cli_tokens, [:token], concurrently: true)

    drop table(:cli_tokens)
  end
end
