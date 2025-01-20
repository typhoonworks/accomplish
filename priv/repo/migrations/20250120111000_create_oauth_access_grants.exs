defmodule Accomplish.Repo.Migrations.CreateOauthAccessGrants do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:oauth_access_grants, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :token, :string, null: false
      add :expires_in, :integer, null: false
      add :redirect_uri, :text, null: false
      add :scopes, {:array, :string}, null: false, default: []
      add :revoked_at, :utc_datetime
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      add :application_id, references(:oauth_applications, type: :uuid, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:oauth_access_grants, [:token], concurrently: true)
    create index(:oauth_access_grants, [:user_id], concurrently: true)
    create index(:oauth_access_grants, [:application_id], concurrently: true)
  end

  def down do
    drop_if_exists unique_index(:oauth_access_grants, [:token], concurrently: true)
    drop_if_exists index(:oauth_access_grants, [:user_id], concurrently: true)
    drop_if_exists index(:oauth_access_grants, [:application_id], concurrently: true)

    drop table(:oauth_access_grants)
  end
end
