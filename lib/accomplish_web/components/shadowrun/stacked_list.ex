defmodule AccomplishWeb.Shadownrun.StackedList do
  @moduledoc false

  use AccomplishWeb, :live_component

  attr :id, :string, default: nil
  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def stacked_list(assigns) do
    ~H"""
    <div id={@id} class={["overflow-hidden shadow ring-1 ring-zinc-700", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def list_header(assigns) do
    ~H"""
    <div class={["flex items-center justify-between bg-zinc-800 px-4 py-2 sm:px-6", @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def list_content(assigns) do
    ~H"""
    <div class={["bg-zinc-900", @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :clickable, :boolean, default: false
  attr :href, :string, default: "#"
  slot :inner_block, required: true

  def list_item(assigns) do
    ~H"""
    <%= if @clickable do %>
      <.link href={@href}>
        <div class={[
          "grid grid-cols-[2fr_2fr_1fr] items-center px-4 py-3 sm:px-6 hover:bg-zinc-800/50",
          @class
        ]}>
          {render_slot(@inner_block)}
        </div>
      </.link>
    <% else %>
      <div class={[
        "grid grid-cols-[2fr_2fr_1fr] items-center px-4 py-3 sm:px-6 hover:bg-zinc-800/50",
        @class
      ]}>
        {render_slot(@inner_block)}
      </div>
    <% end %>
    """
  end
end
