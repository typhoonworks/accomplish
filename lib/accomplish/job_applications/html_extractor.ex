defmodule Accomplish.JobApplications.HTMLExtractor do
  @moduledoc """
  Extracts and processes job posting content from HTML pages.

  This module is responsible for:
  - Fetching HTML content from job posting URLs
  - Detecting anti-scraping measures while still attempting extraction
  - Filtering out irrelevant content to reduce token usage
  - Extracting key elements like job title and description
  - Optimizing the output for AI processing
  """

  require Logger

  @content_selectors [
    "main",
    "aside",
    "button",
    ".job-description",
    ".job-details",
    "#job-details",
    ".description"
  ]

  @noise_elements [
    "script",
    "style",
    "noscript",
    "iframe",
    "header",
    "footer",
    "nav"
  ]

  @blocked_status_codes [403, 429, 503]

  @anti_bot_indicators [
    ~r/captcha\s+required/i,
    ~r/access\s+denied/i,
    ~r/please complete security check/i,
    ~r/are you a robot/i,
    ~r/ddos protection by cloudflare/i,
    ~r/automated access to this site has been blocked/i,
    ~r/challenge validation/i
  ]

  @min_content_length 200

  @browser_user_agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"

  @browser_headers [
    {"user-agent", @browser_user_agent},
    {"accept",
     "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8"},
    {"accept-language", "en-US,en;q=0.9"},
    {"accept-encoding", "gzip, deflate, br"},
    {"sec-fetch-dest", "document"},
    {"sec-fetch-mode", "navigate"},
    {"sec-fetch-site", "none"}
  ]

  @max_retries 2

  @retry_delay 1500

  @doc """
  Fetches and filters content from a job posting URL.

  Returns `{:ok, content}` with optimized text content,
  `{:ok, content, :protection_detected}` when content was extracted despite protection signs,
  or `{:error, reason}` for failures.

  ## Examples

      iex> HTMLExtractor.extract("https://example.com/jobs/software-engineer")
      {:ok, "Software Engineer at Example - Full-time\\n\\nWe are looking for..."}

      iex> HTMLExtractor.extract("https://protected-site.com/jobs/123")
      {:ok, "Software Engineer - Some partial content...", :protection_detected}

      iex> HTMLExtractor.extract("invalid-url")
      {:error, :html_extraction_failed}
  """
  def extract(url, opts \\ []) do
    retry_count = Keyword.get(opts, :retry_count, 0)
    use_browser_headers = Keyword.get(opts, :use_browser_headers, retry_count > 0)

    try do
      req_options = if use_browser_headers, do: [headers: @browser_headers], else: []
      response = Req.get!(url, req_options)

      if response.status in @blocked_status_codes do
        handle_blocked_response(url, response, retry_count)
      else
        html = response.body

        protection_signs =
          Enum.any?(@anti_bot_indicators, fn pattern ->
            String.match?(html, pattern)
          end)

        parsed_doc = Floki.parse_document!(html)
        processed_content = process_html_content(parsed_doc)

        content_length = String.length(processed_content)

        cond do
          protection_signs && content_length < @min_content_length ->
            handle_blocked_response(url, response, retry_count)

          protection_signs ->
            Logger.info(
              "Protection detected at #{url}, but content was extracted (#{content_length} chars)"
            )

            {:ok, processed_content, :protection_detected}

          content_length < @min_content_length ->
            if retry_count < @max_retries do
              Logger.info(
                "Content appears short (#{content_length} chars), retrying with browser headers..."
              )

              Process.sleep(@retry_delay)
              extract(url, retry_count: retry_count + 1, use_browser_headers: true)
            else
              Logger.warning(
                "Short content (#{content_length} chars) after #{retry_count} retries"
              )

              {:ok, processed_content}
            end

          true ->
            {:ok, processed_content}
        end
      end
    rescue
      e ->
        Logger.error("Failed to fetch HTML from #{url}: #{Exception.message(e)}")
        {:error, :html_extraction_failed}
    end
  end

  defp handle_blocked_response(url, response, retry_count) do
    if retry_count < @max_retries do
      Logger.warning(
        "Possible blocking at #{url} (Status: #{response.status}), retrying with browser headers..."
      )

      Process.sleep(@retry_delay * (retry_count + 1))
      extract(url, retry_count: retry_count + 1, use_browser_headers: true)
    else
      Logger.error(
        "Scraping blocked at #{url} after #{retry_count} retries (Status: #{response.status})"
      )

      {:error, :access_blocked}
    end
  end

  defp process_html_content(parsed_doc) do
    job_content = extract_job_content(parsed_doc)

    filtered_content =
      if job_content != [] and Floki.text(job_content) |> String.trim() |> String.length() > 200 do
        job_content
      else
        clean_document(parsed_doc)
      end

    title = extract_title(parsed_doc)
    company = extract_company(parsed_doc)

    text_content = Floki.text(filtered_content)

    header =
      [title, company]
      |> Enum.filter(&(String.trim(&1) != ""))
      |> Enum.join(" - ")

    final_content = "#{header}\n\n#{text_content}"

    clean_text(final_content)
  end

  defp clean_document(parsed_doc) do
    body = Floki.find(parsed_doc, "body")

    Enum.reduce(@noise_elements, body, fn element, doc ->
      Floki.filter_out(doc, element)
    end)
  end

  defp extract_job_content(parsed_doc) do
    Enum.find_value(@content_selectors, [], fn selector ->
      content = Floki.find(parsed_doc, selector)

      if content != [] do
        Enum.reduce(@noise_elements, content, fn element, doc ->
          Floki.filter_out(doc, element)
        end)
      else
        nil
      end
    end)
  end

  defp extract_title(parsed_doc) do
    page_title =
      parsed_doc
      |> Floki.find("title")
      |> Floki.text()
      |> String.trim()

    heading_title =
      parsed_doc
      |> Floki.find("h1")
      |> Floki.text()
      |> String.trim()

    if heading_title != "" do
      heading_title
    else
      page_title
    end
  end

  defp extract_company(parsed_doc) do
    company_from_meta =
      parsed_doc
      |> Floki.find("meta[property='og:site_name']")
      |> Floki.attribute("content")
      |> List.first() || ""

    company_from_class =
      parsed_doc
      |> Floki.find(".company-name, .employer")
      |> Floki.text()
      |> String.trim()

    if company_from_class != "" do
      company_from_class
    else
      company_from_meta
    end
  end

  defp clean_text(text) do
    text
    |> String.replace(~r/\s+/, " ")
    |> String.replace(~r/\n\s*\n+/, "\n\n")
    |> String.trim()
  end
end
