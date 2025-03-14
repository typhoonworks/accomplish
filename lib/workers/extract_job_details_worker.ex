defmodule Accomplish.Workers.ExtractJobDetailsWorker do
  @moduledoc """
  Worker that extracts job details from URLs.

  This worker handles only the extraction part:
  1. Scrapping URLs
  2. Returns structured data for later import
  """

  use Oban.Worker, queue: :default, max_attempts: 3

  require Logger

  alias Accomplish.JobApplications.HTMLExtractor
  alias Accomplish.JobApplications.JobDetailsExtractor
  alias Accomplish.URLValidators
  alias Accomplish.Workers.ImportJobApplicationWorker

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "user_id" => user_id,
          "job_posting_url" => job_posting_url
        },
        attempt: attempt
      }) do
    with :ok <- URLValidators.validate_url_string(job_posting_url, strict: true),
         extraction_result <- HTMLExtractor.extract(job_posting_url),
         {:ok, content} <- handle_extraction_result(extraction_result),
         {:ok, job_details} <- extract_job_details(content, job_posting_url, attempt) do
      %{user_id: user_id, job_details: job_details}
      |> ImportJobApplicationWorker.new()
      |> Oban.insert()
    else
      {:error, reason} ->
        {:error, reason}

      _ ->
        {:error, :extraction_failed}
    end
  end

  defp handle_extraction_result({:ok, content, :protection_detected}) do
    Logger.info("Protection detected but content was extracted successfully")
    {:ok, content}
  end

  defp handle_extraction_result({:ok, content}) do
    {:ok, content}
  end

  defp handle_extraction_result({:error, reason}) do
    {:error, reason}
  end

  defp extract_job_details(content, job_posting_url, _attempt) do
    case JobDetailsExtractor.extract(content, job_posting_url) do
      {:ok, job_details} ->
        {:ok, job_details}

      {:error, reason} ->
        Logger.error("Failed to extract job details: #{inspect(reason)}")
        {:error, :parsing_failed}
    end
  end
end
