defmodule Accomplish.AI.Adapters.Anthropic do
  @moduledoc """
  Adapter for interfacing with Anthropic's Claude API.

  This module provides functionality to:
  1. Generate content using Claude models, with optional streaming
  2. Handle streaming responses from Anthropic's API
  3. Process and transform Claude's responses into a consistent format

  The adapter can be used in both streaming and non-streaming modes:
  - For streaming responses, it creates a wrapper process to handle incoming chunks
  - For non-streaming, it makes a direct synchronous request to the API
  """

  require Logger
  import Accomplish.ConfigHelpers

  alias Accomplish.Streaming.Manager
  alias Accomplish.AI.Prompt

  @doc """
  Creates a streaming wrapper that handles Anthropic's streaming format.

  Returns a PID that can be passed to Anthropic's API for streaming.

  ## Parameters
    - stream_pid: The PID of the stream manager process

  ## Returns
    - A PID that can be used as a stream target for Anthropic
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
      {_pid, {:data, %{"type" => type} = message}} ->
        case type do
          "message_start" ->
            receive_loop(stream_pid)

          "content_block_delta" ->
            if is_map_key(message, "delta") and is_map_key(message["delta"], "text") do
              Manager.append(stream_pid, message["delta"]["text"])
            end

            receive_loop(stream_pid)

          "content_block_stop" ->
            Manager.complete_stream(stream_pid)

          "message_stop" ->
            Manager.complete_stream(stream_pid)

          _ ->
            receive_loop(stream_pid)
        end

      {:stream_error, error} ->
        Logger.error("Streaming error: #{inspect(error)}")
        Manager.complete_stream(stream_pid)

      other ->
        Logger.debug("Unhandled message in StreamAdapter: #{inspect(other)}")
        receive_loop(stream_pid)
    end
  end

  @doc """
  Communicates with Anthropic's Claude API to generate content.

  This function supports both streaming and non-streaming modes:
  - When `receiver_pid` is provided, responses stream to that process
  - When `receiver_pid` is false or nil, returns the complete response

  ## Parameters
    - prompt: An Accomplish.AI.Prompt struct containing all parameters for generation
    - receiver_pid: The PID to stream responses to, or false for non-streaming mode

  ## Returns
    - In streaming mode: sends chunks to the receiver process and returns API response
    - In non-streaming mode: returns the complete API response directly
  """
  def chat(%Prompt{} = prompt, receiver_pid \\ false) do
    api_key = get_env("ANTHROPIC_API_KEY")
    client = Anthropix.init(api_key)
    Logger.debug("Initializing Anthropix client for content generation")

    Anthropix.chat(client,
      model: prompt.model,
      system: prompt.system,
      messages: prompt.messages,
      stream: receiver_pid,
      max_tokens: prompt.max_tokens,
      temperature: prompt.temperature
    )
  end
end
