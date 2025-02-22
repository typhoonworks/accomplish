defmodule Accomplish.Repo.Migrations.CreateJobApplications do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:job_applications, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :role, :string, null: false
      add :status, :string, null: false
      add :applied_at, :utc_datetime, null: false
      add :last_updated_at, :utc_datetime
      add :source, :string
      add :notes, :text

      add :stages_count, :integer, default: 0, null: false

      add :company_id, references(:companies, type: :uuid, on_delete: :delete_all), null: false

      add :applicant_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:job_applications, [:company_id], concurrently: true)
    create index(:job_applications, [:applicant_id], concurrently: true)
  end

  def down do
    drop_if_exists index(:job_applications, [:company_id], concurrently: true)
    drop_if_exists index(:job_applications, [:applicant_id], concurrently: true)
    drop table(:job_applications)
  end
end
