defmodule Accomplish.Repo.Migrations.CreateProfileEducations do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:profile_educations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :profile_id, references(:profiles, type: :uuid, on_delete: :delete_all), null: false
      add :school, :string
      add :degree, :string
      add :field_of_study, :string
      add :start_date, :date
      add :end_date, :date
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create index(:profile_educations, [:profile_id], concurrently: true)
  end

  def down do
    drop_if_exists index(:profile_educations, [:profile_id], concurrently: true)
    drop table(:profile_educations)
  end
end
