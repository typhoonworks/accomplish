defmodule AccomplishWeb.Components.Sidebar do
  @moduledoc false

  use AccomplishWeb, :live_component

  @doc """
  A reusable sidebar link component.
  """
  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :text, :string, required: true
  attr :active, :boolean, default: false

  def sidebar_link(assigns) do
    ~H"""
    <.link
      href={@href}
      class={"group flex gap-x-3 rounded-md p-2 text-[14px] font-medium tracking-tight text-zinc-300 #{if @active, do: "bg-zinc-800", else: " hover:bg-zinc-800"}"}
    >
      <.icon
        name={@icon}
        class="size-5 shrink-0 self-center transition-all group-hover:scale-110 group-hover:text-zinc-50"
      />
      {@text}
    </.link>
    """
  end
end
