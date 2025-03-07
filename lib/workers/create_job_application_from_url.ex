defmodule AccomplishWeb.Workers.CreateJobApplicationFromUrl do
  @moduledoc """
  Worker that creates job applications from a job posting URL.

  This worker validates the URL, scrapes job details using AI-based extraction,
  and creates a job application record for the user.
  """

  use Oban.Worker, queue: :default

  alias Accomplish.Accounts
  alias Accomplish.JobApplications
  alias Accomplish.JobApplications.HTMLImporter
  alias Accomplish.Validators

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "applicant_id" => applicant_id,
          "job_posting_url" => job_posting_url
        }
      }) do
    with :ok <- Validators.validate_url_string(job_posting_url, strict: true),
         {:ok, user} <- get_user(applicant_id),
         {:ok, html_content} <- fetch_html_content(job_posting_url),
         {:ok, job_details} <- HTMLImporter.extract_fields(html_content, job_posting_url),
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

  defp fetch_html_content(url) do
    try do
      html = Req.get!(url).body
      parsed_doc = Floki.parse_document!(html)
      raw_html = Floki.raw_html(parsed_doc)
      {:ok, raw_html}
    rescue
      e ->
        Logger.error("Failed to fetch HTML from #{url}: #{Exception.message(e)}")
        {:error, :html_extraction_failed}
    end
  end

  defp create_job_application(user, job_details, source_url) do
    application_params = %{
      role: job_details["role"],
      company_name: get_in(job_details, ["company", "name"]) || "Unknown Company",
      status: :draft,
      source: source_url,
      apply_url: job_details["apply_url"],
      notes: job_details["job_description"],
      employment_type: job_details["employment_type"],
      location: job_details["location"],
      compensation_details: job_details["compensation_details"]
    }

    JobApplications.create_application(user, application_params)
  end
end
