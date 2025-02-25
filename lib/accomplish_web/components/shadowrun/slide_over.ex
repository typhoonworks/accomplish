defmodule AccomplishWeb.Shadownrun.SlideOver do
  @moduledoc false

  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :prevent_scroll, :boolean, default: false
  slot :inner_block, required: true

  def slide_over(assigns) do
    ~H"""
    <aside
      id={"#{@id}-container"}
      class={"z-[90] h-full #{if @show, do: "w-full lg:w-[400px]", else: "w-0"} transition-all duration-500 ease-in-out overflow-visible absolute top-0 right-0 lg:relative"}
      aria-labelledby={@id}
      role="dialog"
      aria-modal="true"
      phx-mounted={@show && show_slide_over(@id)}
      data-toggle={toggle_slide_over(@id)}
      data-open={show_slide_over(@id)}
      data-close={hide_slide_over(@id)}
    >
      <div class="pointer-events-auto h-full w-full bg-zinc-900 shadow-xl flex flex-col border-l border-zinc-700">
        {render_slot(@inner_block, id: @id)}
      </div>
    </aside>
    """
  end

  def show_slide_over(js \\ %JS{}, id) do
    js
    |> JS.remove_class("w-0", to: "##{id}-container")
    |> JS.add_class("w-full lg:w-[400px]", to: "##{id}-container")
    |> JS.set_attribute({"aria-expanded", "true"}, to: "##{id}")
    |> JS.add_class("overflow-hidden", to: "body")
  end

  def hide_slide_over(js \\ %JS{}, id) do
    js
    |> JS.remove_class("w-full lg:w-[400px]", to: "##{id}-container")
    |> JS.add_class("w-0", to: "##{id}-container")
    |> JS.remove_attribute("aria-expanded", to: "##{id}")
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  def toggle_slide_over(js \\ %JS{}, id) do
    js
    |> JS.toggle_class("w-0", to: "##{id}-container")
    |> JS.toggle_class("w-full lg:w-[400px]", to: "##{id}-container")
    |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{id}")
  end
end
