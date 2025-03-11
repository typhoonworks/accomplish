defmodule Accomplish.PDFExtractorTest do
  use Accomplish.DataCase, async: true
  alias Accomplish.PDFExtractor

  @moduletag :pdf_extraction

  @fixtures_path "test/fixtures/pdfs"
  @sample_pdf_path Path.join(@fixtures_path, "sample.pdf")
  @empty_pdf_path Path.join(@fixtures_path, "empty.pdf")

  describe "extract_text/2" do
    test "successfully extracts text from a valid PDF binary" do
      pdf_binary = File.read!(@sample_pdf_path)

      assert {:ok, result} = PDFExtractor.extract_text(pdf_binary)

      assert is_map(result)
      assert Map.has_key?(result, "text")
      assert is_binary(result["text"])

      assert String.length(result["text"]) > 0
    end

    test "includes metadata when include_metadata option is true" do
      pdf_binary = File.read!(@sample_pdf_path)

      assert {:ok, result} = PDFExtractor.extract_text(pdf_binary)

      assert Map.has_key?(result, "metadata")
      assert is_map(result["metadata"])

      assert Map.has_key?(result["metadata"], "page_count")
    end

    test "handles empty but valid PDF" do
      pdf_binary = File.read!(@empty_pdf_path)

      assert {:ok, result} = PDFExtractor.extract_text(pdf_binary)
      assert Map.has_key?(result, "text")
      assert Map.has_key?(result, "metadata")
    end

    test "excludes metadata when include_metadata option is false" do
      pdf_binary = File.read!(@sample_pdf_path)

      assert {:ok, result} = PDFExtractor.extract_text(pdf_binary, include_metadata: false)

      assert Map.has_key?(result, "metadata")
      assert is_map(result["metadata"])
      assert Enum.empty?(result["metadata"])
    end

    test "returns error for invalid PDF binary" do
      invalid_pdf = "This is not a valid PDF binary at all"

      assert {:error, :extraction_error, error_message} = PDFExtractor.extract_text(invalid_pdf)

      assert is_binary(error_message)
      assert String.contains?(error_message, "PDF")
    end

    @tag :slow
    test "handles timeout gracefully" do
      # Use the sample PDF but with an extremely short timeout
      pdf_binary = File.read!(@sample_pdf_path)

      # Set a timeout of 1ms which is too short for any PDF processing
      assert {:error, :extraction_timeout} = PDFExtractor.extract_text(pdf_binary, timeout: 1)
    end
  end

  describe "extract_text_from_file/2" do
    test "successfully extracts text from a PDF file" do
      assert {:ok, result} = PDFExtractor.extract_text_from_file(@sample_pdf_path)

      assert is_map(result)
      assert Map.has_key?(result, "text")
      assert is_binary(result["text"])
      assert String.length(result["text"]) > 0
    end

    test "returns error for non-existent file" do
      non_existent_file = Path.join(@fixtures_path, "does_not_exist.pdf")

      assert {:error, {:file_read_error, :enoent}} =
               PDFExtractor.extract_text_from_file(non_existent_file)
    end

    test "respects options parameter" do
      assert {:ok, result} =
               PDFExtractor.extract_text_from_file(@sample_pdf_path, include_metadata: false)

      assert Map.has_key?(result, "metadata")
      assert is_map(result["metadata"])
      assert Enum.empty?(result["metadata"])
    end
  end
end
