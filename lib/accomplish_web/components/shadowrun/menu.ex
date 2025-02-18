defmodule AccomplishWeb.Shadownrun.Menu do
  @moduledoc false

  use AccomplishWeb, :live_component

  attr :class, :string, default: "top-0 left-full"
  slot :inner_block, required: true
  attr :rest, :global

  def menu(assigns) do
    ~H"""
    <div
      class={[
        "min-w-[8rem] overflow-hidden rounded-md ring-1 ring-zinc-700 bg-popover p-1 text-popover-foreground shadow-md",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :disabled, :boolean, default: false
  slot :inner_block, required: true
  attr :rest, :global

  def menu_item(assigns) do
    ~H"""
    <div
      class={[
        "hover:bg-accent",
        "relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
        @class
      ]}
      {%{"data-disabled" => @disabled}}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :inset, :boolean, default: false
  slot :inner_block, required: true
  attr :rest, :global

  def menu_label(assigns) do
    ~H"""
    <div class={["px-2 py-1.5 text-sm font-semibold", @inset && "pl-8", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block

  def menu_separator(assigns) do
    ~H"""
    <div
      role="separator"
      class={[
        "relative -mx-1 my-1 h-px bg-zinc-700",
        @class
      ]}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def menu_shortcut(assigns) do
    ~H"""
    <span class={["ml-auto text-xs tracking-widest opacity-60", @class]} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def menu_group(assigns) do
    ~H"""
    <div class={@class} role="group" {@rest}>{render_slot(@inner_block)}</div>
    """
  end
end
