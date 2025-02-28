defmodule Accomplish.Repo.Migrations.AddCurrentStageToJobApplications do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    alter table(:job_applications) do
      add :current_stage_id,
          references(:job_application_stages, type: :uuid, on_delete: :nilify_all)
    end

    create index(:job_applications, [:current_stage_id], concurrently: true)
  end

  def down do
    drop_if_exists index(:job_applications, [:current_stage_id], concurrently: true)

    alter table(:job_applications) do
      remove :current_stage_id
    end
  end
end
