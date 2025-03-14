defmodule Accomplish.Workers.ImportResumeDataWorker do
  @moduledoc """
  Worker that imports structured resume data into user profiles.

  This worker handles only the import part:
  1. Taking structured data from the extraction worker
  2. Importing it to the user's profile
  3. No LLM calls or expensive operations to retry
  """

  use Oban.Worker, queue: :default, max_attempts: 5

  require Logger

  alias Accomplish.Accounts
  alias Accomplish.Profiles.Importer

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "user_id" => user_id,
          "structured_data" => structured_data
        }
      }) do
    with {:ok, user} <- get_user(user_id),
         {:ok, result} <- Importer.import_profile_data(user, structured_data) do
      {:ok, %{user_id: user.id, result: result}}
    else
      {:error, :user_not_found} ->
        Logger.error("User not found: #{user_id}")
        {:error, :user_not_found}

      {:error, {:import_failed, step, changeset}} ->
        Logger.error("Failed to import profile data at step #{step}: #{inspect(changeset)}")
        {:error, :profile_import_failed}
    end
  end

  defp get_user(user_id) do
    case Accounts.get_user(user_id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end
end
