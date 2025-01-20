defmodule Accomplish.Repo.Migrations.CreateOauthAccessTokens do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    create table(:oauth_access_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :token, :string, null: false
      add :refresh_token, :string
      add :expires_in, :integer
      add :scopes, {:array, :string}, default: []
      add :revoked_at, :utc_datetime
      add :previous_refresh_token, :string, default: ""

      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true

      add :application_id, references(:oauth_applications, type: :uuid, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:oauth_access_tokens, [:token], concurrently: true)

    create unique_index(:oauth_access_tokens, [:refresh_token],
             where: "refresh_token IS NOT NULL",
             concurrently: true
           )
  end

  def down do
    drop_if_exists unique_index(:oauth_access_tokens, [:refresh_token],
                     where: "refresh_token IS NOT NULL",
                     concurrently: true
                   )

    drop_if_exists unique_index(:oauth_access_tokens, [:token], concurrently: true)

    drop table(:oauth_access_tokens)
  end
end
