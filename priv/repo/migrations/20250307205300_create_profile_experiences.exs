defmodule Accomplish.Repo.Migrations.CreateProfileExperiences do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:profile_experiences, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :profile_id, references(:profiles, type: :uuid, on_delete: :delete_all), null: false
      add :company, :string
      add :role, :string
      add :start_date, :date
      add :end_date, :date
      add :description, :text
      add :location, :string
      add :is_current, :boolean, default: false

      timestamps(type: :utc_datetime)
    end

    create index(:profile_experiences, [:profile_id], concurrently: true)
  end

  def down do
    drop_if_exists index(:profile_experiences, [:profile_id], concurrently: true)
    drop table(:profile_experiences)
  end
end
