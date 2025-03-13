defmodule Accomplish.AI.Adapters.Mistral do
  @moduledoc """
  Adapter for interfacing with Mistral's API.

  This module provides functionality to:

  1. Generate content using Mistral models, with optional streaming.
  2. Handle streaming responses from Mistral's API.
  3. Process and transform Mistral's responses into a consistent format.

  The adapter supports both streaming and non-streaming modes:

  - In streaming mode, it creates a wrapper process to handle incoming chunks.
  - In non-streaming mode, it makes a direct synchronous request to the API.
  """

  require Logger
  import Accomplish.ConfigHelpers

  alias Accomplish.Streaming.Manager
  alias Accomplish.AI.Prompt
  alias Accomplish.AI.Response

  @doc """
  Creates a streaming wrapper that handles Mistral's streaming format.

  Returns a PID that can be passed to Mistral's API for streaming.

  ## Parameters
    - stream_pid: The PID of the stream manager process

  ## Returns
    - A PID that can be used as a stream target for Mistral
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
      {_, {:data, %{"choices" => choices} = _message}} ->
        Enum.each(choices, fn choice ->
          if is_map_key(choice, "delta") and is_map_key(choice["delta"], "content") do
            Manager.append(stream_pid, choice["delta"]["content"])
          end
        end)

        if Enum.any?(choices, fn choice ->
             Map.get(choice, "finish_reason") == "stop"
           end) do
          Manager.complete_stream(stream_pid)
        else
          receive_loop(stream_pid)
        end

      other ->
        Logger.debug("Unhandled message in Mistral Adapter: #{inspect(other)}")
        receive_loop(stream_pid)
    end
  end

  @doc """
  Communicates with Mistral's API to generate content.

  Supports both streaming and non-streaming modes:

  - When `receiver_pid` is provided, responses stream to that process.
  - When `receiver_pid` is false or nil, returns the complete API response directly.

  ## Parameters
    - prompt: An `Accomplish.AI.Prompt` struct containing parameters for generation.
    - receiver_pid: The PID to stream responses to, or false/nil for non-streaming mode.

  ## Returns
    - In streaming mode: sends chunks to the receiver process and returns the API response.
    - In non-streaming mode: returns the complete API response directly.
  """
  def chat(%Prompt{} = prompt, receiver_pid \\ false) do
    api_key = get_env("MISTRAL_API_KEY")
    client = Mistral.init(api_key)
    Logger.debug("Initializing Mistral client with model: #{prompt.model}")

    params = [
      model: prompt.model,
      messages: prompt.messages,
      max_tokens: prompt.max_tokens,
      temperature: prompt.temperature
    ]

    params =
      if receiver_pid do
        Keyword.put(params, :stream, receiver_pid)
      else
        params
      end

    Mistral.chat(client, params)
  end

  @doc """
  Builds a consistent response struct from a Mistral API payload.
  """
  def build_response(payload) when is_map(payload) do
    with {:ok, model} <- Map.fetch(payload, "model"),
         {:ok, choices} <- Map.fetch(payload, "choices"),
         [first_choice | _] when is_map(first_choice) <- choices,
         {:ok, message} <- Map.fetch(first_choice, "message"),
         {:ok, content} <- Map.fetch(message, "content") do
      role = Map.get(message, "role", "assistant")
      {:ok, Response.new(content, model, role)}
    else
      _ -> {:error, :missing_required_fields}
    end
  end

  def build_response(_), do: {:error, :invalid_response}
end
