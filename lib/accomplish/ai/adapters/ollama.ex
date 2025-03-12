defmodule Accomplish.AI.Adapters.Ollama do
  @moduledoc """
  Adapter for interfacing with locally running Ollama LLM services.

  This module provides functionality to:
  1. Generate content using Ollama models, with optional streaming
  2. Handle streaming responses from Ollama's API
  3. Process and transform Ollama's responses into a consistent format
  4. Support both chat-based (message array) and completion-based (single prompt) workflows

  The adapter can be used in both streaming and non-streaming modes:
  - For streaming responses, it creates a wrapper process to handle incoming chunks
  - For non-streaming, it makes a direct synchronous request to the API
  """

  require Logger
  import Accomplish.ConfigHelpers

  alias Accomplish.Streaming.Manager
  alias Accomplish.AI.Prompt

  @doc """
  Creates a streaming wrapper that handles Ollama's streaming format.

  Returns a PID that can be passed to Ollama's API for streaming.

  ## Parameters
    - stream_pid: The PID of the stream manager process

  ## Returns
    - A PID that can be used as a stream target for Ollama
  """
  def create_streaming_wrapper(stream_pid) do
    {:ok, receiver_pid} =
      Task.start(fn ->
        receive_loop(stream_pid)
      end)

    receiver_pid
  end

  defp receive_loop(stream_pid) do
    receive do
      {_pid, {:data, data}} ->
        cond do
          Map.has_key?(data, "response") ->
            chunk = data["response"]
            Manager.append(stream_pid, chunk)

          data["message"] && Map.has_key?(data["message"], "content") ->
            chunk = data["message"]["content"]
            Manager.append(stream_pid, chunk)

          true ->
            nil
        end

        if Map.get(data, "done", false) do
          Manager.complete_stream(stream_pid)
        else
          receive_loop(stream_pid)
        end

      {:stream_error, error} ->
        Logger.error("Streaming error: #{inspect(error)}")
        Manager.complete_stream(stream_pid)

      other ->
        Logger.debug("Unhandled message in OllamaAdapter: #{inspect(other)}")
        receive_loop(stream_pid)
    end
  end

  @doc """
  Communicates with Ollama API to generate content.

  This function supports both streaming and non-streaming modes:
  - When `receiver_pid` is provided, responses stream to that process
  - When `receiver_pid` is false or nil, returns the complete response

  The function automatically determines whether to use chat or completion API:
  - Chat API is used when messages are in the [%{role:, content:}] format
  - Completion API is used otherwise (with system prompt if provided)

  ## Parameters
    - prompt: An Accomplish.AI.Prompt struct containing all parameters for generation
    - receiver_pid: The PID to stream responses to, or false for non-streaming mode

  ## Returns
    - In streaming mode: sends chunks to the receiver process and returns API response
    - In non-streaming mode: returns the complete API response directly
  """
  def chat(%Prompt{} = prompt, receiver_pid \\ false) do
    base_url = get_env("OLLAMA_BASE_URL", "http://localhost:11434/api")

    client = Ollama.init(base_url)
    Logger.debug("Initializing Ollama client for content generation with model: #{prompt.model}")

    case prompt.messages do
      [%{role: _role, content: _content} | _] = messages ->
        Ollama.chat(client,
          model: prompt.model,
          messages: convert_messages(messages),
          stream: receiver_pid,
          options: %{
            temperature: prompt.temperature,
            num_predict: prompt.max_tokens
          }
        )

      _ ->
        prompt_text = extract_prompt_text(prompt.messages)

        Ollama.completion(client,
          model: prompt.model,
          prompt: prompt_text,
          system: prompt.system,
          stream: receiver_pid,
          options: %{
            temperature: prompt.temperature,
            num_predict: prompt.max_tokens
          }
        )
    end
  end

  defp convert_messages(messages) do
    Enum.map(messages, fn message ->
      %{
        role: message.role,
        content: message.content
      }
    end)
  end

  defp extract_prompt_text(messages) when is_list(messages) do
    case messages do
      [%{content: content} | _] -> content
      [content | _] when is_binary(content) -> content
      _ -> ""
    end
  end

  defp extract_prompt_text(text) when is_binary(text), do: text
  defp extract_prompt_text(_), do: ""
end
