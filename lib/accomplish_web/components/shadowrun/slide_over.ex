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
    <div
      id={"#{@id}-container"}
      class="hidden absolute inset-y-0 right-0 z-[99] w-[400px] h-full"
      aria-labelledby={@id}
      role="dialog"
      aria-modal="true"
    >
      <div class="pointer-events-none flex h-full w-full">
        <div
          id={@id}
          phx-mounted={@show && show_slide_over(@id)}
          data-toggle={toggle_slide_over(@id)}
          data-open={show_slide_over(@id)}
          data-close={hide_slide_over(@id)}
          class="pointer-events-auto h-full w-full max-w-md bg-zinc-900 shadow-xl transition-transform duration-500 ease-in-out translate-x-full flex flex-col border-l border-zinc-700"
        >
          <div class="flex h-full flex-col overflow-y-auto py-6">
            <div class="relative flex-1 px-4 sm:px-6">
              {render_slot(@inner_block, id: @id)}
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def show_slide_over(js \\ %JS{}, id) do
    js
    |> JS.show(
      to: "##{id}",
      transition:
        {"transform transition ease-in-out duration-500 sm:duration-700", "translate-x-full",
         "translate-x-0"}
    )
    |> JS.show(to: "##{id}-container")
    |> JS.set_attribute({"aria-expanded", "true"}, to: "##{id}")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_slide_over(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}",
      transition:
        {"transform transition ease-in-out duration-500 sm:duration-700", "translate-x-0",
         "translate-x-full"}
    )
    |> JS.hide(to: "##{id}-container", time: 700)
    |> JS.remove_attribute("aria-expanded", to: "##{id}")
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  def toggle_slide_over(js \\ %JS{}, id) do
    js
    |> JS.toggle_class("translate-x-0", to: "##{id}")
    |> JS.toggle_class("translate-x-full", to: "##{id}")
    |> JS.toggle_class("hidden", to: "##{id}-container", time: 500)
    |> JS.toggle_class("overflow-hidden", to: "body")
    |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{id}")
  end
end
