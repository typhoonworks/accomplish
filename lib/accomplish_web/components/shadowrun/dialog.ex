defmodule AccomplishWeb.Shadownrun.Dialog do
  @moduledoc false

  use AccomplishWeb, :live_component

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :class, :string, default: nil
  slot :inner_block, required: true

  attr :position, :atom, default: :center

  def dialog(assigns) do
    position_classes =
      case assigns[:position] do
        :upper_third -> "top-[23%] translate-y-[-23%]"
        _ -> "top-[50%] translate-y-[-50%]"
      end

    assigns = assign(assigns, :position_classes, position_classes)

    ~H"""
    <div
      id={@id}
      phx-mounted={@show && JS.exec("phx-show-modal", to: "##{@id}")}
      phx-remove={JS.exec("phx-hide-modal", to: "##{@id}")}
      phx-show-modal={show_dialog(@id)}
      phx-hide-modal={hide_dialog(@id)}
      class="relative z-50 hidden group/dialog peer-data-[state=closed]:hidden"
    >
      <div
        id={"#{@id}-bg"}
        class="fixed inset-0 bg-zinc-900/50 peer-data-[state=open]:animate-in peer-data-[state=closed]:animate-out peer-data-[state=closed]:fade-out-0 peer-data-[state=open]:fade-in-0"
        aria-hidden="true"
      />
      <div
        class="fixed inset-0 flex items-center justify-center overflow-y-auto"
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <.focus_wrap
          id={"#{@id}-wrap"}
          phx-window-keydown={JS.exec("phx-hide-modal", to: "##{@id}")}
          phx-key="escape"
          phx-click-away={JS.exec("phx-hide-modal", to: "##{@id}")}
          class="w-full sm:max-w-[425px]"
        >
          <div
            role="dialog"
            aria-modal="true"
            tabindex="0"
            class={[
              "fixed left-[50%] z-50 grid w-full max-w-lg translate-x-[-50%]",
              @position_classes,
              "gap-4 border border-zinc-700 bg-zinc-800 text-zinc-300 shadow-lg duration-200",
              "peer-data-[state=open]:animate-in peer-data-[state=closed]:animate-out",
              "peer-data-[state=closed]:fade-out-0 peer-data-[state=open]:fade-in-0",
              "peer-data-[state=closed]:zoom-out-95 peer-data-[state=open]:zoom-in-95",
              "peer-data-[state=closed]:slide-out-to-left-1/2 peer-data-[state=closed]:slide-out-to-top-[48%]",
              "peer-data-[state=open]:slide-in-from-left-1/2 peer-data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg",
              @class
            ]}
          >
            {render_slot(@inner_block)}

            <button
              type="button"
              class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none peer-data-[state=open]:bg-accent peer-data-[state=open]:text-muted-foreground"
              phx-click={JS.exec("phx-hide-modal", to: "##{@id}")}
            >
              <.icon name="hero-x-mark-solid" class="size-4" />
              <span class="sr-only">Close</span>
            </button>
          </div>
        </.focus_wrap>
      </div>
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def dialog_header(assigns) do
    ~H"""
    <div class={["flex flex-col space-y-1.5 px-6 pt-6  text-center sm:text-left text-zinc-50", @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def dialog_title(assigns) do
    ~H"""
    <h3 class={["text-lg font-semibold leading-none tracking-tight", @class]}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def dialog_description(assigns) do
    ~H"""
    <p class={["text-sm text-zinc-400", @class]}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :id, :string, default: nil
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def dialog_content(assigns) do
    ~H"""
    <div
      id={@id}
      class={["flex flex-col space-y-1.5 px-6 text-center sm:text-left text-zinc-200", @class]}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def dialog_footer(assigns) do
    ~H"""
    <div class={[
      "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2 px-6 py-2 ring-1 ring-zinc-700",
      @class
    ]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  def show_dialog(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}")
    |> JS.show(to: "##{id}", transition: {"_", "_", "_"}, time: 130)
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_dialog(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}")
    |> JS.hide(to: "##{id}", transition: {"_", "_", "_"}, time: 130)
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end
end
