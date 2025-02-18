defmodule AccomplishWeb.Shadownrun.Sidebar do
  @moduledoc false

  use AccomplishWeb, :live_component

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :open, :boolean, default: true
  attr :name, :string, required: true
  slot :inner_block, required: true

  def sidebar_group(assigns) do
    ~H"""
    <li id={@id} class={@class}>
      <button
        id={"#{@id}-button"}
        class="text-xs/6 font-semibold text-zinc-400 flex flex-1 items-center transition-all cursor-pointer"
        phx-click={toggle_sidebar_group(@id)}
      >
        {@name}
        <.icon
          class="h-4 w-4 ml-2 shrink-0 transition-transform duration-300 ease-in-out icon"
          name="hero-chevron-down-solid"
        />
      </button>
      <ul
        id={"#{@id}-content"}
        role="list"
        class="-mx-2 mt-2 space-y-1 max-h-96 opacity-100 overflow-visible transition-all duration-300 ease-in-out"
      >
        {render_slot(@inner_block)}
      </ul>
    </li>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def sidebar_item(assigns) do
    ~H"""
    <li class={@class}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :text, :string, required: true
  attr :active, :boolean, default: false

  def sidebar_link(assigns) do
    ~H"""
    <.link
      href={@href}
      class={"group flex gap-x-3 rounded-md p-2 text-[13px] font-medium tracking-tight text-zinc-300 #{if @active, do: "bg-zinc-800", else: " hover:bg-zinc-800"}"}
    >
      <.icon
        name={@icon}
        class="size-4 shrink-0 self-center transition-all group-hover:scale-110 group-hover:text-zinc-50"
      />
      {@text}
    </.link>
    """
  end

  def toggle_sidebar_group(js \\ %JS{}, id) do
    js
    |> JS.toggle(
      to: "##{id}-content",
      in: {
        "transition-all duration-200 ease-in-out origin-top",
        "scale-y-0 opacity-0",
        "scale-y-100 opacity-100"
      },
      out: {
        "transition-all duration-200 ease-in-out origin-top",
        "scale-y-100 opacity-100",
        "scale-y-0 opacity-0"
      }
    )
    |> JS.toggle_class("-rotate-90", to: "##{id}-button .icon")
  end
end
