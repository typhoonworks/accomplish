defmodule Accomplish.Repo.Migrations.CreateOauthIdentities do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:oauth_identities, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :access_token, :text
      add :refresh_token, :text
      add :expires_at, :utc_datetime
      add :scopes, {:array, :string}, default: [], null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:oauth_identities, [:user_id])
    create unique_index(:oauth_identities, [:provider, :uid], concurrently: true)
  end

  def down do
    drop_if_exists unique_index(:oauth_identities, [:provider, :uid], concurrently: true)
    drop_if_exists index(:oauth_identities, [:user_id])

    drop table(:oauth_identities)
  end
end
