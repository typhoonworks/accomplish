defmodule Accomplish.JobApplications.HTMLImporter do
  require Logger
  import Accomplish.ConfigHelpers

  @model "claude-3-5-haiku-20241022"

  @system_message """
  You are an AI specialized in parsing job posting data and returning structured fields for creating a “draft job application” record. The data you return will be used to populate a database entity (Accomplish.JobApplications.Application).

  You must extract or infer these fields from the user-provided job posting content:

  1) role
     - Example: "Intermediate Fullstack Engineer, Plan: Product Planning (Vue and Ruby)"

  2) company (an embedded object containing):
     - name, e.g. “GitLab”
     - website, e.g. “gitlab.com”

  3) apply_url
     - The URL from any “Apply For This Job” link or button in the posting.

  4) source
     - The original URL used to access this job posting.

  5) employment_type
     - For example, "Full Time" mapped to "full_time".
     - Possible values: "full_time", "part_time", "contractor", "employer_of_record", "internship".

  6) location
     - Prefer "remote", "hybrid", or "on_site".
     - If the job is obviously remote, use “remote.”

  7) job_description (Rich Text → Markdown)
     - The main role/responsibilities text. All original formatting and links should remain intact where possible.

  8) compensation_details (Rich Text → Markdown)
     - Salary range, benefits, or other compensation info.

  ### Additional Requirements:
  - Return all text fields as Markdown if they contain formatting, links, or bullet points.
  - If any required field is missing, leave it blank or null.
  - Do not add extra fields besides the ones above.
  - Follow instructions closely:
    - The user will provide raw HTML or text from the job posting.
    - You must parse out relevant data or infer from context.
    - If the role’s location or type is unclear, do your best guess or return empty.

  You are not generating extra commentary; only structured data.
  """

  @doc """
  Parses raw HTML content and returns structured job posting data.

  ## Parameters

    - html_content: Raw HTML as a string (e.g. obtained via Floki.raw_html/1).
    - source_url: URL of the original job posting. Defaults to a sample URL.

  ## Returns

    - {:ok, parsed_data} on success, where `parsed_data` is a map with the required keys.
    - {:error, reason} on failure.
  """
  def extract_fields(html_content, source_url) do
    api_key = get_env("ANTHROPIC_API_KEY")
    client = Anthropix.init(api_key)

    prompt_message = """
    Below is the raw text or HTML content we scraped from a job posting, along with the source URL. Please parse it according to the rules set by the System Prompt and produce structured data for each of the required fields. Return the result in valid JSON.

    \"\"\"#{html_content}\"\"\"

    Source: #{source_url}
    """

    messages = [%{role: "user", content: prompt_message}]

    with {:ok, response} <-
           Anthropix.chat(client, model: @model, system: @system_message, messages: messages),
         {:ok, result} <- extract_result(response) do
      {:ok, result}
    else
      error ->
        Logger.error("Failed to extract fields: #{inspect(error)}")
        {:error, error}
    end
  end

  defp extract_result(%{"content" => [%{"text" => text} | _]}) when is_binary(text) do
    case JSON.decode(text) do
      {:ok, decoded} -> {:ok, decoded}
      error -> error
    end
  end

  defp extract_result(other) do
    Logger.error("Unexpected response structure: #{inspect(other)}")
    {:error, :unexpected_response}
  end
end
