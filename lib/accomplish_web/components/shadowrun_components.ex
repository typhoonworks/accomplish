defmodule AccomplishWeb.ShadowrunComponents do
  @moduledoc false

  use Phoenix.Component
  use Gettext, backend: AccomplishWeb.Gettext

  # alias Phoenix.LiveView.JS

  import AccomplishWeb.CoreComponents

  attr :active, :boolean, default: false
  attr :icon, :string, default: nil
  attr :text, :string, required: true
  attr :href, :string, required: true

  def nav_button(assigns) do
    ~H"""
    <.link
      href={@href}
      class={[
        "group flex items-center gap-2 px-2 py-1.5 text-[13px] tracking-tight rounded-md transition-all",
        "hover:bg-zinc-800 hover:text-zinc-50",
        if(@active, do: "bg-zinc-700 text-zinc-50 shadow-sm", else: "bg-zinc-900 text-zinc-400")
      ]}
    >
      <%= if @icon do %>
        <.icon
          name={@icon}
          class="size-4 shrink-0 group-hover:scale-110 group-hover:text-zinc-50 text-current"
        />
      <% end %>
      <span>{@text}</span>
    </.link>
    """
  end
end
