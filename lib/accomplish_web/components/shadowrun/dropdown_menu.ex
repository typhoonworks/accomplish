defmodule AccomplishWeb.Shadownrun.DropdownMenu do
  @moduledoc false

  use AccomplishWeb, :live_component

  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def dropdown_menu(assigns) do
    ~H"""
    <div class={["relative group inline-block", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  attr :rest, :global

  def dropdown_menu_trigger(assigns) do
    ~H"""
    <div
      class={["dropdown-menu-trigger peer", @class]}
      data-state="closed"
      {@rest}
      phx-click={toggle()}
      phx-click-away={hide()}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :side, :string, values: ["top", "right", "bottom", "left"], default: "bottom"
  attr :align, :string, values: ["start", "center", "end"], default: "start"
  slot :inner_block, required: true
  attr :rest, :global

  def dropdown_menu_content(assigns) do
    assigns =
      assign(assigns, :variant_class, side_variant(assigns.side, assigns.align))

    ~H"""
    <div
      class={[
        "z-50 animate-in peer-data-[state=closed]:fade-out-0 peer-data-[state=open]:fade-in-0 peer-data-[state=closed]:zoom-out-95 peer-data-[state=open]:zoom-in-95 peer-data-[side=bottom]:slide-in-from-top-2 peer-data-[side=left]:slide-in-from-right-2 peer-data-[side=right]:slide-in-from-left-2 peer-data-[side=top]:slide-in-from-bottom-2",
        "absolute peer-data-[state=closed]:hidden",
        @variant_class,
        @class
      ]}
      {@rest}
    >
      <div class="">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dropdown_menu_shortcut(assigns) do
    ~H"""
    <span
      class={[
        "ml-auto text-xs tracking-widest opacity-60",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @variants %{
    side: %{
      "top" => "bottom-full mb-2",
      "bottom" => "top-full mt-2",
      "left" => "right-full mr-2",
      "right" => "left-full ml-2"
    },
    align: %{
      "start-horizontal" => "left-0",
      "center-horizontal" => "left-1/2 -translate-x-1/2 slide-in-from-left-1/2",
      "end-horizontal" => "right-0",
      "start-vertical" => "top-0",
      "center-vertical" => "top-1/2 -translate-y-1/2 slide-in-from-top-1/2",
      "end-vertical" => "bottom-0"
    }
  }

  def side_variant(side, align \\ "center") do
    Enum.map_join(%{side: side, align: align(align, side)}, " ", fn {key, value} ->
      @variants[key][value]
    end)
  end

  defp align(align, side) do
    cond do
      side in ["top", "bottom"] ->
        "#{align}-horizontal"

      side in ["left", "right"] ->
        "#{align}-vertical"
    end
  end

  defp toggle(js \\ %JS{}) do
    JS.toggle_attribute(js, {"data-state", "open", "closed"})
  end

  defp hide(js \\ %JS{}) do
    JS.set_attribute(js, {"data-state", "closed"})
  end
end
