defmodule AccomplishWeb.Shadowrun.Forms do
  @moduledoc """
  Provides structured input components with labels, borders, and hints,
  while maintaining the Shadowrun minimalistic aesthetic.
  """

  use Phoenix.Component
  use Gettext, backend: AccomplishWeb.Gettext

  import AccomplishWeb.CoreComponents, only: [translate_error: 1]

  attr :id, :string, default: nil
  attr :name, :string, required: true
  attr :label, :string, default: nil
  attr :hint, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
             range search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
            multiple pattern placeholder readonly required rows size step)

  def shadow_structured_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> shadow_structured_input()
  end

  def shadow_structured_input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="flex justify-between items-center gap-4">
      <.shadow_label :if={@label} for={@id} required={@rest[:required]}>{@label}</.shadow_label>
      <div class="flex-1">
        <textarea
          id={@id}
          name={@name}
          class={[
            "w-full px-3 py-2 border border-zinc-600 rounded-md bg-transparent text-zinc-200 text-sm placeholder-zinc-500",
            "focus:outline-none focus:ring-2 focus:ring-zinc-500",
            @errors != [] && "border-red-600 focus:ring-red-600",
            "min-h-[6rem] resize-none"
          ]}
          {@rest}
        ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
        <.shadow_error :for={msg <- @errors}>{msg}</.shadow_error>
        <p :if={@hint} class="mt-1 text-xs text-zinc-400">{@hint}</p>
      </div>
    </div>
    """
  end

  def shadow_structured_input(assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="w-full flex justify-between items-center gap-4">
      <.shadow_label :if={@label} for={@id} required={@rest[:required]} class="text-left w-auto">
        {@label}
      </.shadow_label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "w-1/3 px-3 py-2 border border-zinc-600 rounded-md bg-transparent text-zinc-200 text-sm placeholder-zinc-500",
          "focus:outline-none focus:ring-2 focus:ring-zinc-500",
          @errors != [] && "border-red-600 focus:ring-red-600"
        ]}
        {@rest}
      />
      <.shadow_error :for={msg <- @errors}>{msg}</.shadow_error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  attr :required, :boolean, default: false
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def shadow_label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-medium text-zinc-300">
      <%= render_slot(@inner_block) %>
      <span :if={@required} class="text-red-600">*</span>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def shadow_error(assigns) do
    ~H"""
    <p class="mt-1 text-xs text-red-600 phx-no-feedback:hidden">
      <%= render_slot(@inner_block) %>
    </p>
    """
  end
end
