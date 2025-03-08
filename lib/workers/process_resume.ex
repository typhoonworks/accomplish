defmodule Accomplish.Workers.ProcessResume do
  @moduledoc """
  Worker that processes resume PDFs and imports the extracted data to user profiles.

  This worker handles resume processing in the background, including:
  1. Processing resumes from a file path
  2. Processing extracted text from a resume
  3. Importing the structured data to user profiles
  """

  use Oban.Worker, queue: :default, max_attempts: 3

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
         {:ok, structured_data} <-
           extract_with_backoff(fn -> PDFParser.extract_from_file(resume_path) end, attempt),
         {:ok, result} <- Importer.import_profile_data(user, structured_data) do
      {:ok, %{user_id: user.id, result: result}}
    else
      {:error, :user_not_found} ->
        Logger.error("User not found: #{user_id}")
        {:error, :user_not_found}

      {:error, :file_read_error, reason} ->
        Logger.error("Failed to read resume file: #{inspect(reason)}")
        {:error, :file_read_error}

      {:snooze, backoff} ->
        {:snooze, backoff}

      {:error, {:import_failed, step, changeset}} ->
        Logger.error("Failed to import profile data at step #{step}: #{inspect(changeset)}")
        {:error, :profile_import_failed}

      {:error, reason} ->
        Logger.error("Error processing resume: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "user_id" => user_id,
          "resume_text" => text_content
        },
        attempt: attempt
      }) do
    with {:ok, user} <- get_user(user_id),
         {:ok, structured_data} <-
           extract_with_backoff(fn -> PDFParser.extract_from_text(text_content) end, attempt),
         {:ok, result} <- Importer.import_profile_data(user, structured_data) do
      {:ok, %{user_id: user.id, result: result}}
    else
      {:error, :user_not_found} ->
        Logger.error("User not found: #{user_id}")
        {:error, :user_not_found}

      {:snooze, backoff} ->
        {:snooze, backoff}

      {:error, {:import_failed, step, changeset}} ->
        Logger.error("Failed to import profile data at step #{step}: #{inspect(changeset)}")
        {:error, :profile_import_failed}

      {:error, reason} ->
        Logger.error("Error processing resume: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def perform(%Oban.Job{args: %{"user_id" => _}}) do
    {:error, :missing_data_source}
  end

  def perform(%Oban.Job{args: %{"resume_path" => _}}) do
    {:error, :missing_user_id}
  end

  def perform(%Oban.Job{args: %{"resume_text" => _}}) do
    {:error, :missing_user_id}
  end

  defp extract_with_backoff(extract_fn, attempt) do
    case extract_fn.() do
      {:ok, data} ->
        {:ok, data}

      {:error, %Anthropix.APIError{status: status}} = _error when status in [429, 529] ->
        backoff = Enum.at(@rate_limit_backoff, attempt - 1, 120)
        status_type = if status == 429, do: "rate limit", else: "service overloaded"
        Logger.warning("LLM #{status_type} hit, retrying in #{backoff} seconds")
        {:snooze, backoff}

      error ->
        error
    end
  end

  defp get_user(user_id) do
    case Accounts.get_user(user_id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end
end
