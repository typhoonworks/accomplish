defmodule Accomplish.Streaming.Providers do
  @moduledoc """
  Maps provider names to their corresponding adapter modules.
  """

  @providers %{
    anthropic: Accomplish.Streaming.Adapters.Anthropic,
    fake: Accomplish.Streaming.Adapters.Fake
  }

  @spec get_provider(atom()) :: module()
  def get_provider(provider_name) do
    Map.get(@providers, provider_name, Accomplish.Streaming.Adapters.Fake)
  end

  @spec all_providers() :: map()
  def all_providers, do: @providers
end
