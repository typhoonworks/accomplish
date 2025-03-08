defmodule Accomplish.Workers.ProcessResume do
  @moduledoc """
  Worker that processes resume PDFs and imports the extracted data to user profiles.

  This worker extracts text from a resume PDF, uses an LLM to parse the content into
  structured data, and then populates the user's profile, experiences, and education.
  """

  use Oban.Worker, queue: :default, max_attempts: 2

  require Logger

  alias Accomplish.Accounts
  alias Accomplish.Profiles.PDFParser
  alias Accomplish.Profiles.Importer

  @rate_limit_backoff [1, 5, 15, 30, 60]

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "user_id" => user_id,
          "resume_path" => resume_path
        },
        attempt: attempt
      }) do
    with {:ok, user} <- get_user(user_id),
         {:ok, profile_data} <- PDFParser.extract_profile_data_from_file(resume_path),
         {:ok, _result} <- Importer.import_profile_data(user, profile_data) do
      {:ok, %{user_id: user.id}}
    else
      {:error, :user_not_found} ->
        Logger.error("User not found: #{user_id}")
        {:error, :user_not_found}

      {:error, :file_read_error, reason} ->
        Logger.error("Failed to read resume file: #{inspect(reason)}")
        {:error, :file_read_error}

      {:error, %Anthropix.APIError{status: 429, type: "rate_limit_error"}} ->
        backoff = Enum.at(@rate_limit_backoff, attempt - 1, 120)
        Logger.warning("Rate limit hit for LLM service, retrying in #{backoff} seconds")
        {:snooze, backoff}

      {:error, %Anthropix.APIError{status: 529, type: "overloaded_error"}} ->
        backoff = Enum.at(@rate_limit_backoff, attempt - 1, 120)
        Logger.warning("LLM service temporarily unavailable, retrying in #{backoff} seconds")
        {:snooze, backoff}

      {:error, :parsing_failed} ->
        Logger.error("Failed to parse resume data from file: #{resume_path}")
        {:error, :parsing_failed}

      {:error, {:import_failed, step, changeset}} ->
        Logger.error("Failed to import profile data at step #{step}: #{inspect(changeset)}")
        {:error, :profile_import_failed}

      {:error, reason} ->
        Logger.error("Error processing resume: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def perform(%Oban.Job{args: %{"user_id" => _}}) do
    {:error, :missing_resume_path}
  end

  def perform(%Oban.Job{args: %{"resume_path" => _}}) do
    {:error, :missing_user_id}
  end

  defp get_user(user_id) do
    case Accounts.get_user(user_id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end
end
