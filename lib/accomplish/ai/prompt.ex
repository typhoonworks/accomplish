defmodule Accomplish.AI.Prompt do
  @moduledoc """
  A struct representing a complete prompt configuration for an LLM.

  This struct encapsulates all the data needed to generate content with an LLM,
  including the messages, model settings, and other parameters.
  """

  @type t :: %__MODULE__{
          messages: list(map()),
          model: String.t(),
          system: String.t(),
          max_tokens: integer(),
          temperature: float(),
          additional_params: map()
        }

  defstruct [
    :messages,
    :model,
    :system,
    :max_tokens,
    :temperature,
    additional_params: %{}
  ]

  @doc """
  Creates a new Prompt struct with the provided parameters.

  ## Parameters
    - messages: List of message maps to send to the LLM
    - model: The model identifier to use
    - system: The system message/instructions
    - max_tokens: Maximum number of tokens to generate
    - temperature: Randomness parameter (0.0 to 1.0)
    - additional_params: Any additional parameters for specific providers

  ## Returns
    - A new Prompt struct
  """
  def new(
        messages,
        model,
        system,
        max_tokens \\ 1000,
        temperature \\ 0.7,
        additional_params \\ %{}
      ) do
    %__MODULE__{
      messages: messages,
      model: model,
      system: system,
      max_tokens: max_tokens,
      temperature: temperature,
      additional_params: additional_params
    }
  end
end
