defmodule Accomplish.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:profiles, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false
      add :bio, :text
      add :headline, :string
      add :location, :string
      add :website_url, :string
      add :github_handle, :string
      add :linkedin_handle, :string
      add :skills, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end

    create unique_index(:profiles, [:user_id], concurrently: true)
  end

  def down do
    drop_if_exists index(:profiles, [:user_id], concurrently: true)
    drop table(:profiles)
  end
end
