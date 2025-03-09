defmodule Accomplish.Repo.Migrations.AddFeatureFlagsTable do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:fun_with_flags_toggles, primary_key: false) do
      add :id, :bigserial, primary_key: true
      add :flag_name, :string, null: false
      add :gate_type, :string, null: false
      add :target, :string, null: false
      add :enabled, :boolean, null: false
    end

    create index(
             :fun_with_flags_toggles,
             [:flag_name, :gate_type, :target],
             unique: true,
             name: "fwf_flag_name_gate_target_idx",
             concurrently: true
           )
  end

  def down do
    drop_if_exists index(
                     :fun_with_flags_toggles,
                     [:flag_name, :gate_type, :target],
                     unique: true,
                     name: "fwf_flag_name_gate_target_idx",
                     concurrently: true
                   )

    drop table(:fun_with_flags_toggles)
  end
end
