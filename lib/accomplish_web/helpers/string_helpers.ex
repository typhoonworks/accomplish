defmodule AccomplishWeb.StringHelpers do
  @moduledoc false

  def truncate(text, opts \\ []) do
    max_length = opts[:length] || 50
    omission = opts[:omission] || "..."

    cond do
      not String.valid?(text) ->
        text

      String.length(text) < max_length ->
        text

      true ->
        length_with_omission = max_length - String.length(omission)

        "#{String.slice(text, 0, length_with_omission)}#{omission}"
    end
  end
end
