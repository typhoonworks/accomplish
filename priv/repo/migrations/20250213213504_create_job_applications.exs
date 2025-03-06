defmodule Accomplish.Repo.Migrations.CreateJobApplications do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:job_applications, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :slug, :string
      add :role, :string, null: false
      add :company, :map, default: %{}, null: false
      add :status, :string, null: false
      add :applied_at, :utc_datetime
      add :last_updated_at, :utc_datetime
      add :source, :string
      add :notes, :text

      add :stages_count, :integer, default: 0, null: false
      add :lock_version, :integer, default: 1, null: false

      add :applicant_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:job_applications, [:applicant_id], concurrently: true)
  end

  def down do
    drop_if_exists index(:job_applications, [:applicant_id], concurrently: true)
    drop table(:job_applications)
  end
end
