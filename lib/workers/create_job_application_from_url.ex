defmodule AccomplishWeb.Workers.CreateJobApplicationFromUrl do
  @moduledoc """
  Worker that creates job applications from a job posting URL.

  This worker validates the URL, scrapes job details using AI-based extraction,
  and creates a job application record for the user.

  Features:
  - URL validation
  - HTML content extraction via HTMLExtractor
  - AI-based job details extraction
  - Intelligent rate limit handling with exponential backoff
  - Comprehensive error reporting
  """

  use Oban.Worker, queue: :default, max_attempts: 2

  alias Accomplish.Accounts
  alias Accomplish.JobApplications
  alias Accomplish.JobApplications.HTMLExtractor
  alias Accomplish.JobApplications.HTMLImporter
  alias Accomplish.Validators

  require Logger

  @rate_limit_backoff [1, 5, 15, 30, 60]

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "applicant_id" => applicant_id,
          "job_posting_url" => job_posting_url
        },
        attempt: attempt
      }) do
    with :ok <- Validators.validate_url_string(job_posting_url, strict: true),
         {:ok, user} <- get_user(applicant_id),
         extraction_result <- HTMLExtractor.extract(job_posting_url),
         {:ok, content} <- handle_extraction_result(extraction_result),
         {:ok, job_details} <- extract_job_details(content, job_posting_url, attempt),
         {:ok, application} <- create_job_application(user, job_details, job_posting_url) do
      {:ok, %{application_id: application.id}}
    else
      {:error, :invalid_url} ->
        Logger.error("Invalid URL provided: #{job_posting_url}")
        {:error, :invalid_url}

      {:error, :user_not_found} ->
        Logger.error("User not found: #{applicant_id}")
        {:error, :user_not_found}

      {:error, :html_extraction_failed} ->
        Logger.error("Failed to extract HTML from URL: #{job_posting_url}")
        {:error, :html_extraction_failed}

      {:error, :access_blocked} ->
        backoff = Enum.at(@rate_limit_backoff, attempt - 1, 120)
        Logger.warning("Access blocked by website, retrying in #{backoff} seconds")
        {:snooze, backoff}

      {:error, :rate_limit_error} ->
        backoff = Enum.at(@rate_limit_backoff, attempt - 1, 120)
        Logger.warning("Rate limit hit, retrying in #{backoff} seconds")
        {:snooze, backoff}

      {:error, :overloaded_error} ->
        backoff = Enum.at(@rate_limit_backoff, attempt - 1, 120)
        Logger.warning("Service temporarily unavailable, retrying in #{backoff} seconds")
        {:snooze, backoff}

      {:error, :parsing_failed} ->
        Logger.error("Failed to parse job details from URL: #{job_posting_url}")
        {:error, :parsing_failed}

      {:error, changeset} ->
        Logger.error("Failed to create job application: #{inspect(changeset.errors)}")
        {:error, :application_creation_failed}
    end
  end

  def perform(%Oban.Job{args: %{"applicant_id" => _}}) do
    {:error, :missing_job_url}
  end

  def perform(%Oban.Job{args: %{"job_posting_url" => _}}) do
    {:error, :missing_applicant_id}
  end

  defp get_user(applicant_id) do
    case Accounts.get_user(applicant_id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
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
    case HTMLImporter.extract_fields(content, job_posting_url) do
      {:ok, job_details} ->
        {:ok, job_details}

      {:error, %Anthropix.APIError{status: 429, type: "rate_limit_error"}} ->
        Logger.warning("Rate limit error from AI service")
        {:error, :rate_limit_error}

      {:error, %Anthropix.APIError{status: 529, type: "overloaded_error"}} ->
        Logger.warning("AI service is temporarily overloaded")
        {:error, :overloaded_error}

      {:error, reason} ->
        Logger.error("Failed to extract job details: #{inspect(reason)}")
        {:error, :parsing_failed}
    end
  end

  defp create_job_application(user, job_details, source_url) do
    company_name = get_in(job_details, ["company", "name"]) || "Unknown Company"
    company_website_url = get_in(job_details, ["company", "website_url"])

    application_params = %{
      role: job_details["role"] || "Unknown Role",
      company: %{name: company_name, website_url: company_website_url},
      status: :draft,
      source: source_url,
      apply_url: job_details["apply_url"],
      job_description: job_details["job_description"],
      employment_type: job_details["employment_type"],
      location: job_details["location"],
      compensation_details: job_details["compensation_details"]
    }

    JobApplications.create_application(user, application_params)
  end
end
