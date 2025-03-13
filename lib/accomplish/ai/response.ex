defmodule Accomplish.AI.Response do
  @moduledoc false

  @type message :: %{
          required(:content) => String.t(),
          optional(:role) => String.t()
        }

  @type t :: %__MODULE__{
          message: message(),
          model: String.t()
        }

  defstruct [
    :model,
    message: %{}
  ]

  @spec new(String.t(), String.t(), String.t()) :: t()
  def new(content, model, role \\ "assistant") do
    %__MODULE__{
      model: model,
      message: %{content: content, role: role}
    }
  end
end
