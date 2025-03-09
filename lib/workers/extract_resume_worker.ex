defmodule Accomplish.Workers.ExtractResumeData do
  @moduledoc """
  Worker that extracts structured data from resume PDFs.

  This worker handles only the extraction part:
  1. Processing resumes from a file path
  2. Processing extracted text from a resume
  3. Returns structured data for later import
  """

  use Oban.Worker, queue: :default, max_attempts: 3

  require Logger

  alias Accomplish.Profiles.PDFParser
  alias Accomplish.Workers.ImportResumeData

  @rate_limit_backoff [1, 5, 15, 30, 60]

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "user_id" => user_id,
          "resume_path" => resume_path
        },
        attempt: attempt
      }) do
    with {:ok, structured_data} <-
           extract_with_backoff(fn -> PDFParser.extract_from_file(resume_path) end, attempt) do
      %{user_id: user_id, structured_data: structured_data}
      |> ImportResumeData.new()
      |> Oban.insert()

      {:ok, %{user_id: user_id, message: "Resume data extracted successfully"}}
    else
      {:error, :file_read_error, reason} ->
        Logger.error("Failed to read resume file: #{inspect(reason)}")
        {:error, :file_read_error}

      {:snooze, backoff} ->
        {:snooze, backoff}

      {:error, reason} ->
        Logger.error("Error extracting resume data: #{inspect(reason)}")
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
    with {:ok, structured_data} <-
           extract_with_backoff(fn -> PDFParser.extract_from_text(text_content) end, attempt) do
      %{user_id: user_id, structured_data: structured_data}
      |> ImportResumeData.new()
      |> Oban.insert()

      {:ok, %{user_id: user_id, message: "Resume data extracted successfully"}}
    else
      {:snooze, backoff} ->
        {:snooze, backoff}

      {:error, reason} ->
        Logger.error("Error extracting resume data: #{inspect(reason)}")
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
end
