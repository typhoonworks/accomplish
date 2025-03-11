defmodule AccomplishWeb.Shadowrun.ContextMenu do
  @moduledoc """
  A flexible context menu component that can be used in various scenarios:

  1. As a right-click context menu
  2. As an always-visible dropdown menu
  3. With configurable submenu behavior

  This component maintains the existing submenu structure while providing
  positioning and visibility control.
  """
  use Phoenix.Component

  import AccomplishWeb.Shadowrun.Menu

  # Primary menu component that serves as a wrapper for context menus
  attr :id, :string, required: true
  attr :position, :string, default: "right-click", values: ["right-click", "static", "dropdown"]
  slot :inner_block, required: true

  def context_menu(assigns) do
    visibility_classes = if assigns.position == "right-click", do: "hidden", else: ""
    assigns = assign(assigns, :visibility_classes, visibility_classes)

    ~H"""
    <.menu id={@id} class={TwMerge.merge([@visibility_classes, "w-56 text-zinc-300 bg-zinc-800"])}>
      <.menu_group>
        {render_slot(@inner_block)}
      </.menu_group>
    </.menu>
    """
  end
end
