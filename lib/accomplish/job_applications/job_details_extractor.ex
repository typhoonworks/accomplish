defmodule Accomplish.JobApplications.JobDetailsExtractor do
  @moduledoc false

  require Logger
  alias Accomplish.AI

  @default_provider :anthropic
  @max_tokens 2500
  @temperature 0.2

  @system_message """
  You are an AI specialized in parsing job posting data and returning structured fields for creating a “draft job application” record.
  The data you return will be used to populate a database entity for a job application.


   You must extract these job detail fields:
    1) role (job title)
    2) company (an embedded object containing):
       - name, e.g. “GitLab”
       - website, e.g. “gitlab.com”
    3) apply_url
       - The URL from any “Apply For This Job” link or button in the posting.
       - If not a valid URL then it should be nil
    4) source
       - The original URL used to access this job posting.
    5) employment_type (full_time, part_time, contractor, employer_of_record, internship)
    6) workplace_type (remote, on_site, hybrid)
    7) job_description (Rich Text → Markdown)
       - The main role/responsibilities text. All original formatting and links should remain intact where possible.
    8) compensation_details (Rich Text → Markdown)
       - Salary range, benefits, or other compensation info.

   Return valid JSON with the following structure:
   {
     "apply_url":,
     "company": {
       "name": string,
       "website" string:
     },
     "compensation_details": string,
     "employment_type": string,
     "job_description": string,
     "workplace_type": string,
     "role": string,
     "source": string
   }
  """

  @prefill_message """
    {
      "apply_url": "",
      "company": {
        "name": "",
        "website": ""
      },
      "compensation_details": "",
      "employment_type": "",
      "job_description": "",
      "workplace_type": "",
      "role": "",
      "source": ""
    }
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
  def extract(html_content, source_url, provider \\ @default_provider) do
    model = AI.get_model_for_provider(provider)

    messages = [
      %{role: "user", content: format_prompt_message(html_content, source_url)},
      %{role: "user", content: String.trim(@prefill_message)}
    ]

    prompt =
      AI.Prompt.new(
        messages,
        model,
        @system_message,
        @max_tokens,
        @temperature
      )

    with {:ok, response} <- AI.chat(provider, prompt),
         {:ok, result} <- extract_result(response) do
      {:ok, result}
    else
      error ->
        Logger.error("Failed to extract fields: #{inspect(error)}")
        {:error, error}
    end
  end

  def format_prompt_message(content, url) do
    """
    Below is the raw text or HTML content we scraped from a job posting, along with the source URL. Please parse it according to the rules set by the System Prompt and produce structured data for each of the required fields. Return the result in valid JSON.

    \"\"\"#{content}\"\"\"

    Source: #{url}
    """
  end

  defp extract_result(%AI.Response{} = response), do: parse_json_content(response.message.content)
  defp extract_result(_), do: :invalid_ai_response

  defp parse_json_content(text) do
    text
    |> clean_json()
    |> JSON.decode()
    |> case do
      {:ok, decoded} ->
        {:ok, decoded}

      error ->
        Logger.error("Failed to parse JSON: #{inspect(error)} from content: #{text}")
        error
    end
  end

  defp clean_json(text) do
    text
    |> String.trim()
    |> String.replace(~r/^```json\s*/m, "")
    |> String.replace(~r/\s*```$/m, "")
  end
end
