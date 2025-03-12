defmodule Accomplish.Streaming.Service do
  @moduledoc """
  Streaming service that coordinates between content generators and streaming adapters.

  This module:
  1. Creates stream wrappers for persistence
  2. Delegates content generation to the specified adapter
  3. Manages error handling and coordination
  """

  require Logger

  alias Accomplish.Streaming.Manager
  alias Accomplish.Streaming.Providers
  alias Accomplish.AI.Prompt

  @doc """
  Starts a streaming content generation session.

  ## Parameters
    - stream_id: Unique identifier for this stream
    - persistence_fn: Function that takes a buffer string and persists it
    - provider_name: The provider name for the adapter module to use for content generation
    - prompt: An Accomplish.AI.Prompt struct containing all parameters for generation
    - stream_opts: Additional options for the stream manager
      - save_interval: How often to persist the buffer (in ms)
      - ttl: How long to keep the stream alive without updates (in ms)

  ## Returns
    - {:ok, stream_id}
  """
  def start_streaming(
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
        adapter_module.generate_content(receiver_pid, prompt)
      rescue
        e ->
          Logger.error("Exception in content generation: #{inspect(e)}")
          send(receiver_pid, {:stream_error, "Failed to generate content: #{inspect(e)}"})
      end
    end)

    {:ok, stream_id}
  end
end
