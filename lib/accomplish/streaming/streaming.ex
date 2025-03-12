defmodule Accomplish.Streaming do
  @moduledoc """
  Public interface for streaming content generation.
  """

  alias Accomplish.Streaming.Manager
  alias Accomplish.Streaming.Providers
  alias Accomplish.Streaming.Service

  @doc """
  Starts a streaming session for content generation.

  ## Parameters
    - stream_id: Unique identifier for this stream.
    - persistence_fn: A function that persists the current buffer.
    - provider: The provider name (an atom, e.g. :anthropic, :fake) to select the adapter.
    - prompt: A `%Accomplish.AI.Prompt{}` struct containing prompt parameters.
    - stream_opts: A keyword list of options (e.g., `save_interval`, `ttl`).

  ## Returns
    - `{:ok, stream_id}` on success.
    - `{:error, reason}` on failure.
  """
  def start_streaming(stream_id, persistence_fn, provider, prompt, stream_opts \\ []) do
    Service.start_streaming(stream_id, persistence_fn, provider, prompt, stream_opts)
  end

  @doc """
  Stops a streaming session given its stream_id.
  """
  def stop_streaming(stream_id) do
    Manager.stop_stream(stream_id)
  end

  @doc """
  Gets the status of a streaming session.
  """
  def get_status(stream_id) do
    case Manager.get_stream(stream_id) do
      {:ok, pid} -> Manager.get_status(pid)
      :not_found -> :not_found
    end
  end

  @doc """
  Gets the appropriate model name for a given provider.
  """
  @spec get_model_for_provider(atom()) :: String.t()
  def get_model_for_provider(provider) do
    Providers.get_model_for_provider(provider)
  end

  @doc """
  Returns a map of all providers and their default models.
  """
  @spec all_provider_models() :: map()
  def all_provider_models do
    Providers.all_provider_models()
  end

  @doc """
  Returns a list of available provider atoms.
  """
  @spec available_providers() :: list(atom())
  def available_providers do
    Providers.all_providers() |> Map.keys()
  end
end
