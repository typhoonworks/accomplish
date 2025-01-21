defmodule Accomplish.Repo.Migrations.CreateOauthApplications do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:oauth_applications, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :uid, :string, null: false
      add :secret, :string, null: false
      add :redirect_uri, :text, null: false
      add :scopes, {:array, :string}, default: []
      add :confidential, :boolean, null: false, default: true
      add :token_ttl, :integer, null: false, default: 3600

      timestamps(type: :utc_datetime)
    end

    create unique_index(:oauth_applications, [:uid], concurrently: true)
    create unique_index(:oauth_applications, [:name], concurrently: true)
  end

  def down do
    drop_if_exists unique_index(:oauth_applications, [:name], concurrently: true)
    drop_if_exists unique_index(:oauth_applications, [:uid], concurrently: true)
    drop table(:oauth_applications)
  end
end
