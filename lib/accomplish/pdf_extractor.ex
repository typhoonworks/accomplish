defmodule Accomplish.PDFExtractor do
  @moduledoc """
  Extracts text content from PDF files for resume/CV processing using a Rust NIF.

  This module provides high-performance utilities for converting PDF files to structured text
  that can be fed to LLMs for extracting profile information. The implementation uses
  Rustler to interface with a Rust NIF that handles the actual PDF parsing.
  """

  require Logger
  use Rustler, otp_app: :accomplish, crate: "pdf_extractor"

  @doc """
  Extracts text content from a PDF binary.

  ## Parameters
    - pdf_binary: Raw binary content of the PDF file
    - opts: A keyword list of options
      - :include_metadata - Boolean to include PDF metadata in output. Defaults to `true`.
      - :timeout - Timeout in milliseconds for extraction operations. Defaults to `5000`.

  ## Returns
    - `{:ok, %{text: content, metadata: metadata}}` on success
    - `{:error, reason}` on failure

  ## Examples
      iex> pdf_binary = File.read!("resume.pdf")
      iex> PDFExtractor.extract_text(pdf_binary)
      {:ok, %{text: "Resume content...", metadata: %{title: "John's Resume"}}}
  """
  def extract_text(pdf_binary, opts \\ []) when is_binary(pdf_binary) do
    include_metadata = Keyword.get(opts, :include_metadata, true)
    timeout = Keyword.get(opts, :timeout, 5000)

    try do
      Task.await(
        Task.async(fn ->
          extract_text_nif(pdf_binary, include_metadata)
        end),
        timeout
      )
    catch
      :exit, {:timeout, _} ->
        Logger.error("PDF extraction timed out after #{timeout}ms")
        {:error, :extraction_timeout}
    end
  end

  @doc """
  Extracts text from a PDF file on disk.

  ## Parameters
    - file_path: Path to the PDF file
    - opts: Same options as `extract_text/2`

  ## Returns
    - Same returns as `extract_text/2`
  """
  def extract_text_from_file(file_path, opts \\ []) do
    case File.read(file_path) do
      {:ok, pdf_binary} ->
        extract_text(pdf_binary, opts)

      {:error, reason} ->
        Logger.error("Failed to read PDF file: #{inspect(reason)}")
        {:error, {:file_read_error, reason}}
    end
  end

  # Native implemented functions

  @doc false
  # This function is implemented in Rust
  def extract_text_nif(_pdf_binary, _include_metadata), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  # This function is implemented in Rust
  def extract_metadata_nif(_pdf_binary), do: :erlang.nif_error(:nif_not_loaded)
end
