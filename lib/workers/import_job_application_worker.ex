defmodule Accomplish.Workers.ImportJobApplicationWorker do
  @moduledoc """
  Worker that imports structured job data into a job application.
  """

  use Oban.Worker, queue: :default, max_attempts: 5

  require Logger

  alias Accomplish.Accounts
  alias Accomplish.JobApplications.Importer

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "user_id" => user_id,
          "job_details" => job_details
        }
      }) do
    with {:ok, user} <- get_user(user_id),
         {:ok, application} <- Importer.import_job_details(user, job_details) do
      {:ok, application}
    else
      {:error, :user_not_found} ->
        Logger.error("User not found: #{user_id}")
        {:error, :user_not_found}

      {:error, {:import_failed, changeset}} ->
        Logger.error("Failed to import job application: #{inspect(changeset)}")
        {:error, :job_application_import_failed}
    end
  end

  defp get_user(user_id) do
    case Accounts.get_user(user_id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end
end
