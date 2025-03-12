defmodule Accomplish.Streaming.Providers do
  @moduledoc """
  Maps provider names to their corresponding adapter modules and models.
  """

  require Logger
  import Accomplish.ConfigHelpers

  @providers %{
    anthropic: Accomplish.Streaming.Adapters.Anthropic,
    ollama: Accomplish.Streaming.Adapters.Ollama,
    fake: Accomplish.Streaming.Adapters.Fake
  }

  @provider_models %{
    anthropic: "claude-3-5-haiku-20241022",
    ollama: "llama3.2",
    fake: "fake-model"
  }

  @doc """
  Returns the adapter module for a given provider name.
  Defaults to Fake adapter if provider is not found.

  ## Parameters
    - provider_name: The provider name as an atom (:anthropic, :ollama, etc.)

  ## Returns
    - A module that implements the adapter interface
  """
  @spec get_provider(atom()) :: module()
  def get_provider(provider_name) do
    Map.get(@providers, provider_name, Accomplish.Streaming.Adapters.Fake)
  end

  @doc """
  Returns a map of all registered providers and their modules.

  ## Returns
    - A map with provider names as keys and modules as values
  """
  @spec all_providers() :: map()
  def all_providers, do: @providers

  @doc """
  Returns the appropriate model name for a given provider.
  """
  @spec get_model_for_provider(atom()) :: String.t()
  def get_model_for_provider(provider) do
    env_var_name = "#{String.upcase(Atom.to_string(provider))}_MODEL"

    case get_env(env_var_name, nil) do
      nil ->
        case Map.fetch(@provider_models, provider) do
          {:ok, model} ->
            model

          :error ->
            Logger.warning("Unknown provider #{provider}, using fake model")
            @provider_models.fake
        end

      override ->
        override
    end
  end

  @doc """
  Returns a map of all registered providers and their default models.

  ## Returns
    - A map with provider names as keys and model names as values
  """
  @spec all_provider_models() :: map()
  def all_provider_models, do: @provider_models
end
