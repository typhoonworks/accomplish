defmodule AccomplishWeb.Shadowrun.Accordion do
  @moduledoc false

  use Phoenix.LiveComponent

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def accordion(assigns) do
    ~H"""
    <div class={["space-y-2", @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def accordion_item(assigns) do
    ~H"""
    <div class={@class}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :group, :string, required: true
  attr :class, :string, default: nil
  attr :open, :boolean, default: false
  slot :inner_block, required: true

  def accordion_trigger(assigns) do
    ~H"""
    <details id={"accordion-" <> @group} class="group/accordion peer/accordion" open={@open}>
      <summary class={[
        "flex w-full items-center justify-between cursor-pointer",
        @class
      ]}>
        {render_slot(@inner_block)}

        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="h-4 w-4 transition-transform duration-200 group-open/accordion:rotate-180"
        >
          <path d="m6 9 6 6 6-6"></path>
        </svg>
      </summary>
    </details>
    """
  end

  attr :id, :string, required: true
  attr :group, :string, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def accordion_content(assigns) do
    ~H"""
    <div
      id={@id}
      data-details-id={"accordion-" <> @group}
      phx-hook="AccordionContent"
      class="overflow-hidden transition-all duration-300"
    >
      <div class={@class}>
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end
end
