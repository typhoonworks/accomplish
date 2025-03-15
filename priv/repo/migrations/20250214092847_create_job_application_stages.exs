defmodule Accomplish.Repo.Migrations.CreateJobApplicationStages do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:job_application_stages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :slug, :string
      add :title, :string, null: false
      add :type, :string, null: false
      add :status, :string, null: false, default: "pending"
      add :is_final_stage, :boolean, default: false, null: false
      add :date, :utc_datetime
      add :location, :string
      add :instructions, :text
      add :notes, :text

      add :application_id, references(:job_applications, type: :uuid, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
      soft_delete_columns()
    end
  end

  def down do
    drop table(:job_application_stages)
  end
end
