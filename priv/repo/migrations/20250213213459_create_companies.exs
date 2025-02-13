defmodule Accomplish.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:companies, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :website, :string
      add :notes, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:companies, [:name], concurrently: true)
  end

  def down do
    drop_if_exists unique_index(:companies, [:name], concurrently: true)
    drop table(:companies)
  end
end
