defmodule Accomplish.AI.Adapters.Fake do
  @moduledoc """
  A fake adapter for testing AI functionality without making actual API calls.

  This adapter:
  1. Simulates both streaming and non-streaming LLM responses
  2. Adheres to the same interface as real adapters (e.g., Anthropic, Ollama)
  3. Provides configurable delays, text content, and response formats for testing
  4. Can be used in both streaming and non-streaming modes for test coverage
  """

  require Logger

  alias Accomplish.Streaming.Manager
  alias Accomplish.AI.Prompt

  @default_paragraphs [
    "Dear Hiring Manager,\n\n",
    "I am writing to express my enthusiastic interest in the Software Engineer position at Acme Inc. As a passionate developer with five years of experience building scalable web applications, I was immediately drawn to your company's innovative approach to solving complex problems and your commitment to user-centric design.\n\n",
    "Throughout my career at XYZ Corp, I have demonstrated expertise in full-stack development using Elixir and Phoenix, which directly aligns with the technical requirements outlined in your job description. I successfully led the redesign of our core product's architecture, resulting in a 40% improvement in response times and a significant reduction in server costs. My experience working in agile environments has honed my ability to collaborate effectively with cross-functional teams while maintaining a focus on delivering high-quality code.\n\n",
    "I'm particularly excited about Acme's mission to revolutionize how businesses handle data processing. Your recent launch of the StreamProc platform showcases precisely the kind of challenging technical problems I love solving. The opportunity to contribute to products that make a real difference for users is exactly what I'm looking for in my next role.\n\n",
    "I would welcome the opportunity to discuss how my skills and experience could benefit your team. Thank you for considering my application, and I look forward to the possibility of working together.\n\nSincerely,\nAlex Developer"
  ]

  @default_delay 150
  @default_chunk_size 10

  @doc """
  Creates a streaming wrapper that simulates streaming text.

  Returns a PID that acts as a receiver for simulated streaming.

  ## Parameters
    - stream_pid: The PID of the stream manager process

  ## Returns
    - A PID that can be used as a stream target
  """
  def create_streaming_wrapper(stream_pid) do
    stream_pid
  end

  @doc """
  Simulates LLM responses with configurable content.

  This function supports both streaming and non-streaming modes:
  - When `receiver_pid` is provided, responses stream to that process
  - When `receiver_pid` is false or nil, returns the complete response synchronously

  ## Parameters
    - prompt: An Accomplish.AI.Prompt struct containing the configuration
    - receiver_pid: The PID to stream responses to, or false for non-streaming mode

  ## Options in prompt.additional_params:
    - paragraphs: List of text paragraphs to use in the response
    - delay_ms: Milliseconds to wait between chunks (streaming mode only)
    - chunk_size: Number of characters to send in each chunk (streaming mode only)
    - simulate_error: When true, simulates an error response

  ## Returns
    - In streaming mode: Task that handles the streaming, response chunks sent to receiver_pid
    - In non-streaming mode: Complete text response as a formatted map similar to real LLMs
  """
  def chat(%Prompt{} = prompt, receiver_pid \\ false) do
    config = prompt.additional_params || %{}
    paragraphs = Map.get(config, :paragraphs, @default_paragraphs)

    # If we're in non-streaming mode, return the full response synchronously
    if receiver_pid == false do
      text = Enum.join(paragraphs, "")

      # Return a response format similar to real LLM APIs
      %{
        "content" => [%{"text" => text}],
        "model" => prompt.model || "fake-model",
        "id" => "fake-#{System.unique_integer()}",
        "type" => "message"
      }
    else
      # In streaming mode, process asynchronously
      delay_ms = Map.get(config, :delay_ms, @default_delay)
      chunk_size = Map.get(config, :chunk_size, @default_chunk_size)

      Logger.info("Starting fake content generation with #{length(paragraphs)} paragraphs")

      Task.start(fn ->
        stream_paragraphs(receiver_pid, paragraphs, delay_ms, chunk_size)
      end)
    end
  end

  defp stream_paragraphs(stream_pid, paragraphs, delay_ms, chunk_size) do
    text = Enum.join(paragraphs, "")
    total_length = String.length(text)
    chunks = chunks_from_text(text, chunk_size)

    Enum.each(chunks, fn chunk ->
      Manager.append(stream_pid, chunk)
      Process.sleep(delay_ms)
    end)

    Logger.info("Fake content generation complete (sent #{total_length} characters)")
    Manager.complete_stream(stream_pid)
  end

  defp chunks_from_text(text, chunk_size) do
    text_length = String.length(text)

    chunk_count =
      div(text_length, chunk_size) + if rem(text_length, chunk_size) > 0, do: 1, else: 0

    0..(chunk_count - 1)
    |> Enum.map(fn i ->
      start_pos = i * chunk_size
      end_pos = min((i + 1) * chunk_size, text_length)
      String.slice(text, start_pos, end_pos - start_pos)
    end)
  end

  def standard_cover_letter do
    Enum.join(@default_paragraphs, "")
  end

  @doc """
  Creates a prompt with fake adapter specific configuration.

  ## Parameters
    - base_prompt: An existing prompt to modify, or nil to create a new one
    - paragraphs: Optional custom paragraphs to use instead of defaults
    - delay_ms: Optional custom delay between chunks (in milliseconds)
    - chunk_size: Optional custom chunk size (in characters)

  ## Returns
    - A new Prompt struct configured for the fake adapter
  """
  def configure_prompt(base_prompt \\ nil, paragraphs \\ nil, delay_ms \\ nil, chunk_size \\ nil) do
    prompt =
      base_prompt ||
        %Prompt{
          messages: [%{role: "user", content: "Generate a cover letter"}],
          model: "fake-model",
          system: "You are a fake model for testing",
          max_tokens: 1000,
          temperature: 0.7,
          additional_params: %{}
        }

    fake_params = %{}

    fake_params =
      if paragraphs, do: Map.put(fake_params, :paragraphs, paragraphs), else: fake_params

    fake_params = if delay_ms, do: Map.put(fake_params, :delay_ms, delay_ms), else: fake_params

    fake_params =
      if chunk_size, do: Map.put(fake_params, :chunk_size, chunk_size), else: fake_params

    %{prompt | additional_params: Map.merge(prompt.additional_params, fake_params)}
  end
end
