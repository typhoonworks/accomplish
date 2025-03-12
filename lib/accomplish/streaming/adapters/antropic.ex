defmodule Accomplish.Streaming.Adapters.Anthropic do
  @moduledoc """
  Adapter for handling streaming API responses from Anthropic.

  This module:
  1. Creates a wrapper for handling Anthropic's streaming format
  2. Translates messages to a consistent internal format for the Streaming.Manager
  3. Makes API calls to Anthropic's LLM services
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
  Generates content using Anthropic's Claude API.

  Makes the actual API call to Anthropic with the provided Prompt struct.

  ## Parameters
    - receiver_pid: The PID of the process that will receive streaming updates
    - prompt: An Accomplish.AI.Prompt struct containing all the parameters
  """
  def generate_content(receiver_pid, %Prompt{} = prompt) do
    api_key = get_env("ANTHROPIC_API_KEY")

    client = Anthropix.init(api_key)
    Logger.debug("Initializing Anthropix client for content generation")

    # Convert Prompt struct to Anthropix parameters
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
