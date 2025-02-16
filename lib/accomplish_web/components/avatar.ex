defmodule AccomplishWeb.Components.Avatar do
  @moduledoc false

  use AccomplishWeb, :live_component

  attr :name, :string
  attr :src, :string, default: nil
  attr :size, :atom, values: [:xs, :sm, :md, :lg], required: true

  attr :initial, :string
  attr :alt, :string
  attr :bg_color, :string
  attr :class, :string, default: nil
  attr :rest, :global

  def avatar(%{name: name} = assigns) when not is_nil(name) do
    assigns
    |> assign_new(:initial, fn -> name |> String.at(0) |> String.upcase() end)
    |> assign_new(:bg_color, fn -> background_color(name) end)
    |> assign(name: nil, alt: name)
    |> avatar()
  end

  def avatar(%{src: src} = assigns) when not is_nil(src) do
    ~H"""
    <img
      class={[
        "flex-shrink-0 object-cover ",
        common_classes(@size, @class),
        size_class(@size),
        @class
      ]}
      src={@src}
      alt={@alt}
      @rest
    />
    """
  end

  def avatar(assigns) do
    ~H"""
    <span
      class={[
        "inline-flex items-center justify-center text-zinc-200 uppercase select-none bg-opacity-90",
        common_classes(@size, @class),
        @bg_color,
        size_class(@size),
        @class
      ]}
      @rest
    >
      {@initial}
    </span>
    """
  end

  defp common_classes(size, extra_classes) do
    [
      "rounded-full ring-1 ring-zinc-800/50 hover:ring-zinc-600/80 hover:scale-105 backdrop-blur-sm transition-all duration-200",
      size_class(size),
      extra_classes
    ]
  end

  defp size_class(:xs), do: "h-6 w-6 text-[10px] font-medium"
  defp size_class(:sm), do: "h-10 w-10 text-[12px] font-semibold"
  defp size_class(:md), do: "h-24 w-24 text-[20px] font-semibold"
  defp size_class(:lg), do: "h-32 w-32 text-[28px] font-semibold"

  defp background_color(name) do
    case rem(String.to_charlist(name) |> hd(), 3) do
      0 -> "bg-yellow-500/70"
      1 -> "bg-purple-600/70"
      2 -> "bg-sky-600/70"
    end
  end
end
