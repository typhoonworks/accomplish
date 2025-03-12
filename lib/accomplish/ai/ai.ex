defmodule Accomplish.AI do
  @moduledoc """
  Public interface for AI interactions in the application.

  This module provides a unified API for:
  1. Making synchronous LLM requests with different providers
  2. Managing streaming LLM sessions for real-time content generation
  3. Accessing information about available providers and models
  """

  alias Accomplish.Streaming.Manager
  alias Accomplish.AI.Providers
  alias Accomplish.AI.Service

  @doc """
  Makes a synchronous request to an AI provider.

  Sends the provided prompt to the specified provider and returns the complete response.

  ## Parameters
    - provider: The provider name (atom, e.g. :anthropic, :ollama, :fake)
    - prompt: A `%Accomplish.AI.Prompt{}` struct containing all parameters

  ## Returns
    - The complete response from the provider, usually a map with content and metadata
  """
  @spec chat(atom(), Accomplish.AI.Prompt.t()) :: map()
  def chat(provider, prompt) do
    Service.chat(provider, prompt)
  end

  @doc """
  Starts a streaming session for content generation.

  Creates a stream that allows real-time content generation with progress
  updates and periodic persistence.

  ## Parameters
    - stream_id: Unique identifier for this stream
    - persistence_fn: A function that persists the current buffer
    - provider: The provider name (atom, e.g. :anthropic, :ollama, :fake)
    - prompt: A `%Accomplish.AI.Prompt{}` struct containing prompt parameters
    - stream_opts: A keyword list of options:
      - save_interval: Milliseconds between buffer saves (default: 5000)
      - ttl: Time to live in milliseconds for the stream (default: 6000)

  ## Returns
    - `{:ok, stream_id}` on success
    - `{:error, reason}` on failure
  """
  def start_streaming(stream_id, persistence_fn, provider, prompt, stream_opts \\ []) do
    Service.start_stream_chat(stream_id, persistence_fn, provider, prompt, stream_opts)
  end

  @doc """
  Stops a streaming session given its stream_id.

  This will trigger any final persistence operations before shutting down the stream.

  ## Parameters
    - stream_id: The unique identifier of the stream to stop

  ## Returns
    - `:ok` whether the stream exists or not
  """
  def stop_streaming(stream_id) do
    Manager.stop_stream(stream_id)
  end

  @doc """
  Gets the status of a streaming session.

  ## Parameters
    - stream_id: The unique identifier of the stream

  ## Returns
    - `:streaming` - Stream is active and receiving content
    - `:completed` - Stream has finished successfully
    - `:stopped` - Stream was manually stopped
    - `:not_found` - No stream with the given ID exists
  """
  def get_status(stream_id) do
    case Manager.get_stream(stream_id) do
      {:ok, pid} -> Manager.get_status(pid)
      :not_found -> :not_found
    end
  end

  @doc """
  Gets the appropriate model name for a given provider.

  Returns the default model string to use with the specified provider.

  ## Parameters
    - provider: The provider name as an atom (e.g., :anthropic, :ollama)

  ## Returns
    - The model string to use with this provider (e.g., "claude-3-5-haiku-20241022")
  """
  @spec get_model_for_provider(atom()) :: String.t()
  def get_model_for_provider(provider) do
    Providers.get_model_for_provider(provider)
  end

  @doc """
  Returns a map of all providers and their default models.

  ## Returns
    - A map with provider atoms as keys and model strings as values
  """
  @spec all_provider_models() :: map()
  def all_provider_models do
    Providers.all_provider_models()
  end

  @doc """
  Returns a list of available provider atoms.

  ## Returns
    - A list of atoms representing available AI providers
  """
  @spec available_providers() :: list(atom())
  def available_providers do
    Providers.all_providers() |> Map.keys()
  end
end
