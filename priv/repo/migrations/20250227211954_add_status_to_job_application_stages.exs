defmodule Accomplish.Repo.Migrations.AddStatusToJobApplicationStages do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  @status_values ["pending", "in_progress", "completed", "skipped"]

  def up do
    alter table(:job_application_stages) do
      add :status, :string, null: false, default: "pending"
    end

    execute("""
    ALTER TABLE job_application_stages
    ADD CONSTRAINT job_application_stages_status_check
    CHECK (status IN (#{Enum.map(@status_values, &"'#{&1}'") |> Enum.join(", ")}))
    """)
  end

  def down do
    alter table(:job_application_stages) do
      remove :status
    end
  end
end
