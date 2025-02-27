defmodule AccomplishWeb.Shadowrun.Table do
  @moduledoc false

  use Phoenix.LiveComponent

  attr :id, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, default: %{}

  slot :head, required: true
  slot :body, required: true

  def shadow_table(assigns) do
    ~H"""
    <table id={@id} class={["min-w-full divide-y divide-zinc-700", @class]} {@rest}>
      <thead>
        {render_slot(@head)}
      </thead>
      <tbody>
        {render_slot(@body)}
      </tbody>
    </table>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, default: %{}

  slot :inner_block, required: true

  def shadow_table_header(assigns) do
    ~H"""
    <th
      scope="col"
      class={["px-3 py-3.5 text-left text-[13px] font-light text-zinc-400", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </th>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, default: %{}

  slot :inner_block, required: true

  def shadow_table_row(assigns) do
    ~H"""
    <tr class={["relative group hover:bg-zinc-800 transition", @class]} {@rest}>
      {render_slot(@inner_block)}
    </tr>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, default: %{}

  slot :inner_block, required: true

  def shadow_table_cell(assigns) do
    ~H"""
    <td class={["whitespace-nowrap py-4 pl-4 pr-3 text-[13px] text-zinc-50", @class]} {@rest}>
      {render_slot(@inner_block)}
    </td>
    """
  end
end
