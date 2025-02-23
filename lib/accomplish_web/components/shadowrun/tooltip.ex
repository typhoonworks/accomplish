defmodule AccomplishWeb.Shadowrun.Tooltip do
  @moduledoc false

  use Phoenix.LiveComponent

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tooltip(assigns) do
    ~H"""
    <div
      class={[
        "relative group/tooltip inline-block",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  slot :inner_block, required: true

  def tooltip_trigger(assigns) do
    ~H"""
    {render_slot(@inner_block)}
    """
  end

  attr :class, :string, default: nil
  attr :side, :string, default: "top", values: ~w(bottom left right top)
  attr :rest, :global
  slot :inner_block, required: true

  def tooltip_content(assigns) do
    assigns =
      assign(assigns, :variant_class, side_variant(assigns.side))

    ~H"""
    <div
      data-side={@side}
      class={[
        "tooltip-content absolute whitespace-nowrap hidden group-hover/tooltip:block",
        "z-40 w-auto overflow-hidden rounded-md border bg-zinc-800 px-3 py-1.5 text-xs font-light text-zinc-200",
        "border-zinc-600/50",
        "animate-in fade-in-0 zoom-in-95",
        "data-[side=bottom]:slide-in-from-top-2",
        "data-[side=left]:slide-in-from-right-2",
        "data-[side=right]:slide-in-from-left-2",
        "data-[side=top]:slide-in-from-bottom-2",
        @variant_class,
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp side_variant("top"), do: "bottom-full mb-2"
  defp side_variant("bottom"), do: "top-full mt-2"
  defp side_variant("left"), do: "right-full mr-2"
  defp side_variant("right"), do: "left-full ml-2"
end
