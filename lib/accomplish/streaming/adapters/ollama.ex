defmodule Accomplish.Streaming.Adapters.Ollama do
  @moduledoc """
  Adapter for handling streaming API responses from Ollama.

  This module:
  1. Creates a wrapper for handling Ollama's streaming format
  2. Translates messages to a consistent internal format for the Streaming.Manager
  3. Makes API calls to locally running Ollama LLM services
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
  Generates content using Ollama API.

  Makes the actual API call to Ollama with the provided Prompt struct.

  ## Parameters
    - receiver_pid: The PID of the process that will receive streaming updates
    - prompt: An Accomplish.AI.Prompt struct containing all the parameters
  """
  def generate_content(receiver_pid, %Prompt{} = prompt) do
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
