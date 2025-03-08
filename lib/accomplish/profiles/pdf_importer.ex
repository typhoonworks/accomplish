defmodule Accomplish.Profiles.PDFImporter do
  @moduledoc """
  Service for parsing resume/CV PDFs and extracting structured profile data.

  This service integrates with the PDFExtractor to process uploaded resumes,
  extract text content, and use LLMs to parse the resume into structured data
  for user profiles, experiences, and education.
  """

  require Logger
  import Accomplish.ConfigHelpers

  alias Accomplish.PDFExtractor

  @model "claude-3-5-haiku-20241022"

  @system_message """
  You are an AI specialized in parsing resume/CV data and returning structured fields for creating profile records.
  The data you return will be used to populate database entities for a user's profile, work experiences, and education.

  You must extract these profile fields:
  1) headline (professional title/headline)
  2) bio (short professional summary)
  3) location (city, state/country)
  4) skills (array of skills)

  For each work experience, extract:
  1) company (company name)
  2) role (job title)
  3) employment_type (full_time, part_time, contractor, internship)
  4) start_date (YYYY-MM format)
  5) end_date (YYYY-MM format, or "present")
  6) description (bullet points of responsibilities/achievements)

  For each education entry, extract:
  1) school (institution name)
  2) degree (degree type - BS, MS, PhD, etc)
  3) field_of_study (major or field)
  4) start_date (YYYY-MM format)
  5) end_date (YYYY-MM format)

  Return valid JSON with the following structure:
  {
    "profile": {
      "headline": string,
      "bio": string,
      "location": string,
      "skills": array of strings
    },
    "experiences": [
      {
        "company": string,
        "role": string,
        "employment_type": string,
        "start_date": string,
        "end_date": string,
        "description": string
      }
    ],
    "education": [
      {
        "school": string,
        "degree": string,
        "field_of_study": string,
        "start_date": string,
        "end_date": string
      }
    ]
  }

  Normalize dates to YYYY-MM format. Convert "present" or "current" to null for end_date.
  If any required field is missing, leave it null or empty array.
  Keep the text formatting (bullet points, paragraphs) in descriptions.
  """

  @prefill_message """
  {
    "profile": {
      "headline": "",
      "bio": "",
      "location": "",
      "skills": []
    },
    "experiences": [
      {
        "company": "",
        "role": "",
        "employment_type": "",
        "start_date": "",
        "end_date": "",
        "description": ""
      }
    ],
    "education": [
      {
        "school": "",
        "degree": "",
        "field_of_study": "",
        "start_date": "",
        "end_date": ""
      }
    ]
  }
  """

  @doc """
  Processes a resume PDF and extracts structured profile information.

  ## Parameters
    - pdf_binary: Raw binary content of the PDF file

  ## Returns
    - `{:ok, structured_data}` with extracted profile, experiences, and education
    - `{:error, reason}` on failure
  """
  def extract_profile_data(pdf_binary) when is_binary(pdf_binary) do
    with {:ok, %{"metadata" => _metadata, "text" => text_content}} <-
           PDFExtractor.extract_text(pdf_binary),
         {:ok, structured_data} <- parse_with_llm(text_content) do
      process_dates(structured_data)
    else
      {:error, reason} ->
        Logger.error("Resume extraction failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @doc """
  Processes a resume PDF file and extracts structured profile information.

  ## Parameters
    - file_path: Path to the PDF file

  ## Returns
    - Same returns as `extract_profile_data/1`
  """
  def extract_profile_data_from_file(file_path) do
    case File.read(file_path) do
      {:ok, pdf_binary} ->
        extract_profile_data(pdf_binary)

      {:error, reason} ->
        Logger.error("Failed to read resume file: #{inspect(reason)}")
        {:error, {:file_read_error, reason}}
    end
  end

  defp parse_with_llm(text_content) do
    api_key = get_env("ANTHROPIC_API_KEY")
    client = Anthropix.init(api_key)

    prompt_message = """
    Below is the raw text content extracted from a resume/CV. Please parse it according to the rules in the System Prompt and produce structured data for each of the required fields. Return the result in valid JSON.

    ```
    #{text_content}
    ```
    """

    messages = [
      %{role: "user", content: String.trim(prompt_message)},
      %{role: "user", content: String.trim(@prefill_message)}
    ]

    with {:ok, response} <-
           Anthropix.chat(client,
             model: @model,
             system: String.trim(@system_message),
             messages: messages
           ),
         {:ok, result} <- extract_result(response) do
      {:ok, result}
    else
      error ->
        Logger.error("Failed to extract profile data: #{inspect(error)}")
        {:error, error}
    end
  end

  defp extract_result(%{"content" => [%{"text" => text} | _]}) when is_binary(text) do
    case JSON.decode(clean_json(text)) do
      {:ok, decoded} -> {:ok, decoded}
      error -> error
    end
  end

  defp extract_result(other) do
    Logger.error("Unexpected response structure: #{inspect(other)}")
    {:error, :unexpected_response}
  end

  defp clean_json(text) do
    text
    |> String.trim()
    |> String.replace(~r/^```json\s*/m, "")
    |> String.replace(~r/\s*```$/m, "")
  end

  defp process_dates(data) do
    profile = Map.get(data, "profile", %{})

    experiences =
      Enum.map(Map.get(data, "experiences", []), fn exp ->
        exp
        |> normalize_date_field("start_date")
        |> normalize_date_field("end_date")
      end)

    education =
      Enum.map(Map.get(data, "education", []), fn edu ->
        edu
        |> normalize_date_field("start_date")
        |> normalize_date_field("end_date")
      end)

    {:ok,
     %{
       "profile" => profile,
       "experiences" => experiences,
       "education" => education
     }}
  end

  defp normalize_date_field(item, field) do
    value = Map.get(item, field)

    cond do
      is_nil(value) ->
        item

      field == "end_date" && Regex.match?(~r/present|current/i, value) ->
        Map.put(item, field, nil)

      Regex.match?(~r/^\d{4}-\d{2}$/, value) ->
        item

      Regex.match?(~r/^(\d{1,2})[\/\-](\d{4})$/, value) ->
        [_, month, year] = Regex.run(~r/^(\d{1,2})[\/\-](\d{4})$/, value)
        month_padded = String.pad_leading(month, 2, "0")
        Map.put(item, field, "#{year}-#{month_padded}")

      Regex.match?(~r/^\d{4}$/, value) ->
        Map.put(item, field, "#{value}-01")

      true ->
        Logger.warning("Could not normalize date format for '#{value}' in field '#{field}'")
        item
    end
  end
end
