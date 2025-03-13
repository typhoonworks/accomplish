defmodule Accomplish.AI.Service do
  @moduledoc """
  Core service that handles all AI provider interactions.

  This module:
  1. Provides a unified interface for both synchronous and streaming AI requests
  2. Delegates requests to the appropriate provider adapter
  3. Manages stream creation and error handling for streaming sessions
  4. Abstracts away provider-specific implementation details
  """

  require Logger

  alias Accomplish.Streaming.Manager
  alias Accomplish.AI.Providers
  alias Accomplish.AI.Prompt

  @doc """
  Makes a synchronous request to an AI provider.

  This function delegates to the appropriate provider adapter's chat function
  and returns the complete response.

  ## Parameters
    - provider_name: The provider name as an atom (e.g., :anthropic, :ollama, :fake)
    - prompt: An Accomplish.AI.Prompt struct containing all parameters for generation

  ## Returns
    - The complete response from the provider in the provider's native format
  """
  def chat(provider_name, prompt) do
    adapter_module = Providers.get_provider(provider_name)

    case adapter_module.chat(prompt, false) do
      {:ok, payload} ->
        adapter_module.build_response(payload)

      error ->
        Logger.debug("Adapter error: #{error}")
        {:error, :client_error}
    end
  end

  @doc """
  Starts a streaming content generation session.

  ## Parameters
    - stream_id: Unique identifier for this stream
    - persistence_fn: Function that takes a buffer string and persists it
    - provider_name: The provider name as an atom (e.g., :anthropic, :ollama, :fake)
    - prompt: An Accomplish.AI.Prompt struct containing all parameters for generation
    - stream_opts: Additional options for the stream manager
      - save_interval: How often to persist the buffer (in ms, default: 5000)
      - ttl: How long to keep the stream alive without updates (in ms, default: 6000)

  ## Returns
    - {:ok, stream_id} on successful stream initialization
  """
  def start_stream_chat(
        stream_id,
        persistence_fn,
        provider_name,
        %Prompt{} = prompt,
        stream_opts \\ []
      ) do
    Manager.create_stream(stream_id, persistence_fn, stream_opts)

    {:ok, stream_pid} = Manager.get_stream(stream_id)

    adapter_module = Providers.get_provider(provider_name)
    receiver_pid = adapter_module.create_streaming_wrapper(stream_pid)

    Task.start(fn ->
      try do
        adapter_module.chat(prompt, receiver_pid)
      rescue
        e ->
          Logger.error("Exception in content generation: #{inspect(e)}")
          send(receiver_pid, {:stream_error, "Failed to generate content: #{inspect(e)}"})
      end
    end)

    {:ok, stream_id}
  end
end
