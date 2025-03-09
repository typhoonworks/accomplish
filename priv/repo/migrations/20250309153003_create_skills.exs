defmodule Accomplish.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:skills, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :normalized_name, :string, null: false
      add :usage_count, :integer, default: 0, null: false

      timestamps()
    end

    create unique_index(:skills, [:normalized_name], concurrently: true)
    create index(:skills, [:usage_count], concurrently: true)
  end

  def down do
    drop_if_exists unique_index(:skills, [:normalized_name], concurrently: true)
    drop_if_exists index(:skills, [:usage_count], concurrently: true)
    drop table(:skills)
  end
end
