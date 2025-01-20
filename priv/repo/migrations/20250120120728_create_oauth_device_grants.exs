defmodule Accomplish.Repo.Migrations.CreateOauthDeviceGrants do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:oauth_device_grants, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :device_code, :string, null: false
      add :user_code, :string, null: false
      add :expires_in, :integer, null: false
      add :revoked_at, :utc_datetime
      add :last_polling_at, :utc_datetime_usec

      add :application_id, references(:oauth_applications, type: :uuid, on_delete: :delete_all),
        null: false

      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:oauth_device_grants, [:device_code], concurrently: true)
    create unique_index(:oauth_device_grants, [:user_code], concurrently: true)
    create index(:oauth_device_grants, [:application_id], concurrently: true)
    create index(:oauth_device_grants, [:user_id], concurrently: true)
  end

  def down do
    drop_if_exists index(:oauth_device_grants, [:user_id], concurrently: true)
    drop_if_exists index(:oauth_device_grants, [:application_id], concurrently: true)
    drop_if_exists unique_index(:oauth_device_grants, [:user_code], concurrently: true)
    drop_if_exists unique_index(:oauth_device_grants, [:device_code], concurrently: true)

    drop table(:oauth_device_grants)
  end
end
