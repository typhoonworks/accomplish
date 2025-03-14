defmodule Accomplish.Profiles.PDFParser do
  @moduledoc """
  Service for parsing resume/CV PDFs and extracting structured profile data.

  This service integrates with the PDFExtractor to process uploaded resumes,
  extract text content, and use LLMs to parse the resume into structured data
  for user profiles, experiences, and education.
  """

  require Logger

  alias Accomplish.PDFExtractor
  alias Accomplish.AI

  @default_provider :anthropic
  @max_tokens 2500
  @temperature 0.2

  @system_message """
  You are an AI specialized in parsing resume/CV data and returning structured fields for creating profile records.
  The data you return will be used to populate database entities for a user's profile, work experiences, and education.

  You must extract these profile fields:
  1) Full name
  2) headline (professional title/headline)
  3) bio (short professional summary)
  4) location (city, state/country)
  5) skills (array of skills)
  6) github_handle (GitHub username, extract from URLs like https://github.com/username)
  7) linkedin_handle (LinkedIn username, extract from URLs like https://linkedin.com/in/username)
  8) website_url (Personal website URL, ensure it includes http:// or https://)
  9) interests (Professional or personal interests and hobbies, with formatting preserved)

  For each work experience, extract:
  1) company (company name)
  2) role (job title)
  3) employment_type (full_time, part_time, contractor, employer_of_record, internship)
  4) workplace_type (remote, on_site, hybrid)
  5) start_date (YYYY-MM format)
  6) end_date (YYYY-MM format, or "present")
  7) description (bullet points of responsibilities/achievements)
  8) location (city, state/country where job was performed)

  For each education entry, extract:
  1) school (institution name)
  2) degree (degree type - BS, MS, PhD, etc)
  3) field_of_study (major or field)
  4) start_date (YYYY-MM format)
  5) end_date (YYYY-MM format)
  6) description (any additional information about the education)

  Return valid JSON with the following structure:
  {
    "profile": {
      "full_name": string,
      "headline": string,
      "bio": string,
      "location": string,
      "skills": array of strings,
      "github_handle": string,
      "linkedin_handle": string,
      "website_url": string,
      "interests": string
    },
    "experiences": [
      {
        "company": string,
        "role": string,
        "employment_type": string,
        "workplace_type": string,
        "start_date": string,
        "end_date": string,
        "description": string,
        "location": string
      }
    ],
    "education": [
      {
        "school": string,
        "degree": string,
        "field_of_study": string,
        "start_date": string,
        "end_date": string,
        "description": string
      }
    ]
  }

  For extracting handles and URLs:
  - Extract the github_handle from GitHub URLs (e.g., https://github.com/username → "username")
  - Extract the linkedin_handle from LinkedIn URLs (e.g., https://linkedin.com/in/username → "username")
  - For website_url, include the full URL with protocol (http:// or https://)
  - If handles or URLs aren't explicitly found, look for patterns like "github.com/username" in text

  For workplace_type:
  - Identify as "remote", "on_site", or "hybrid" based on context clues
  - Look for terms like "Remote", "Work from home", "On-site", "In-office", "Hybrid"

  Normalize dates to YYYY-MM format. Convert "present" or "current" to null for end_date.
  If any required field is missing, leave it null or empty array.
  Keep the text formatting (bullet points, paragraphs) in descriptions and interests.
  """

  @prefill_message """
  {
    "profile": {
      "full_name": "",
      "headline": "",
      "bio": "",
      "location": "",
      "skills": [],
      "github_handle": "",
      "linkedin_handle": "",
      "website_url": "",
      "interests": ""
    },
    "experiences": [
      {
        "company": "",
        "role": "",
        "employment_type": "",
        "workplace_type": "",
        "start_date": "",
        "end_date": "",
        "description": "",
        "location": ""
      }
    ],
    "education": [
      {
        "school": "",
        "degree": "",
        "field_of_study": "",
        "start_date": "",
        "end_date": "",
        "description": ""
      }
    ]
  }
  """

  # ---------------------------------------------------------------------------
  # Public APIs
  # ---------------------------------------------------------------------------

  @doc """
  Processes a resume PDF file path and extracts structured profile information.

  ## Parameters
    - file_path: Path to the PDF file

  ## Returns
    - `{:ok, structured_data}` with extracted profile, experiences, and education
    - `{:error, reason}` on failure
  """
  def extract_from_file(file_path, provider \\ @default_provider) do
    case File.read(file_path) do
      {:ok, pdf_binary} ->
        extract_from_binary(pdf_binary, provider)

      {:error, reason} ->
        Logger.error("Failed to read resume file: #{inspect(reason)}")
        {:error, {:file_read_error, reason}}
    end
  end

  @doc """
  Processes a resume PDF binary and extracts structured profile information.

  ## Parameters
    - pdf_binary: Raw binary content of the PDF file

  ## Returns
    - `{:ok, structured_data}` with extracted profile, experiences, and education
    - `{:error, reason}` on failure
  """
  def extract_from_binary(pdf_binary, provider \\ @default_provider)

  def extract_from_binary(pdf_binary, provider) when is_binary(pdf_binary) do
    with {:ok, %{"text" => text_content}} <- PDFExtractor.extract_text(pdf_binary),
         {:ok, structured_data} <- extract_from_text(text_content, provider) do
      {:ok, structured_data}
    else
      {:error, reason} ->
        Logger.error("Resume extraction failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def extract_from_binary(_pdf_binary, _provider), do: {:error, :invalid_binary}

  @doc """
  Processes plain text content from a resume and extracts structured profile information.

  ## Parameters
    - text_content: Text content of the resume

  ## Returns
    - `{:ok, structured_data}` with extracted profile, experiences, and education
    - `{:error, reason}` on failure
  """
  def extract_from_text(text_content, provider \\ @default_provider)
      when is_binary(text_content) and is_atom(provider) do
    with {:ok, raw_data} <- parse_with_llm(text_content, provider),
         {:ok, processed_data} <- process_data(raw_data) do
      {:ok, processed_data}
    else
      {:error, reason} ->
        Logger.error("Failed to extract profile data from text: #{inspect(reason)}")
        {:error, reason}
    end
  end

  # ---------------------------------------------------------------------------
  # Internal / Private
  # ---------------------------------------------------------------------------

  defp parse_with_llm(text_content, provider) do
    model = AI.get_model_for_provider(provider)

    messages = [
      %{role: "user", content: format_prompt_message(text_content)},
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
        Logger.error("Failed to extract profile data: #{inspect(error)}")
        {:error, error}
    end
  end

  defp format_prompt_message(text_content) do
    """
    Below is the raw text content extracted from a resume/CV. Please parse it according to the rules in the System Prompt and produce structured data for each of the required fields. Return the result in valid JSON.

    ```
    #{text_content}
    ```
    """
    |> String.trim()
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

  defp process_data(%{} = data) do
    Logger.debug("Processing data: #{inspect(data)}")

    profile =
      Map.get(data, "profile", %{})
      |> process_text_field("interests")

    experiences =
      Map.get(data, "experiences", [])
      |> Enum.map(fn exp ->
        exp
        |> normalize_date_field("start_date")
        |> normalize_date_field("end_date")
        |> process_text_field("description")
      end)

    education =
      Map.get(data, "education", [])
      |> Enum.map(fn edu ->
        edu
        |> normalize_date_field("start_date")
        |> normalize_date_field("end_date")
        |> process_text_field("description")
      end)

    {:ok,
     %{
       "profile" => profile,
       "experiences" => experiences,
       "education" => education
     }}
  end

  defp process_data(not_a_map),
    do: {:ok, not_a_map}

  defp normalize_date_field(item, field) do
    value = Map.get(item, field)

    cond do
      value == nil ->
        item

      Regex.match?(~r/present|current/i, value) and field == "end_date" ->
        Map.put(item, field, nil)

      # Already in YYYY-MM
      Regex.match?(~r/^\d{4}-\d{2}$/, value) ->
        item

      # e.g. 12/2020 or 12-2020
      Regex.match?(~r/^(\d{1,2})[\/\-](\d{4})$/, value) ->
        [_, month, year] = Regex.run(~r/^(\d{1,2})[\/\-](\d{4})$/, value)
        month_padded = String.pad_leading(month, 2, "0")
        Map.put(item, field, "#{year}-#{month_padded}")

      # Just a year like 2020
      Regex.match?(~r/^\d{4}$/, value) ->
        Map.put(item, field, "#{value}-01")

      true ->
        item
    end
  end

  defp process_text_field(item, field) do
    value = Map.get(item, field)

    cond do
      value == nil ->
        item

      is_list(item) ->
        Map.put(item, field, Enum.join(item, "\n- "))

      true ->
        item
    end
  end
end
