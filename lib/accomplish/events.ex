defmodule Accomplish.Events do
  @moduledoc false

  @pubsub Accomplish.PubSub

  def subscribe(identifier) when is_binary(identifier) do
    Phoenix.PubSub.subscribe(@pubsub, topic(identifier))
  end

  def unsubscribe(identifier) when is_binary(identifier) do
    Phoenix.PubSub.unsubscribe(@pubsub, topic(identifier))
  end

  def broadcast!(identifier, message) do
    Phoenix.PubSub.broadcast!(@pubsub, topic(identifier), message)
  end

  defp topic(identifier), do: "events" <> ":#{identifier}"

  defmacro __using__(_opts) do
    quote do
      def subscribe(identifier) when is_binary(identifier) do
        Accomplish.Events.subscribe(identifier)
      end

      def unsubscribe(identifier) when is_binary(identifier) do
        Accomplish.Events.unsubscribe(identifier)
      end

      def broadcast!(identifier, message) do
        Accomplish.Events.broadcast!(identifier, message)
      end
    end
  end
end
