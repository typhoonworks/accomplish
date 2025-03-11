defmodule AccomplishWeb.Components.JobApplications.DocumentList do
  @moduledoc false

  use Phoenix.Component

  @endpoint AccomplishWeb.Endpoint
  @router AccomplishWeb.Router

  import Phoenix.VerifiedRoutes
  import AccomplishWeb.CoreComponents
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu
  import AccomplishWeb.Shadowrun.StackedList

  import AccomplishWeb.TimeHelpers
  import AccomplishWeb.CoverLetterHelpers

  def document_group(assigns) do
    ~H"""
    <div
      id={"#{@type}-group"}
      class="hidden opacity-0 translate-y-2 transition-transform duration-300"
      phx-hook="StackedList"
    >
      <.list_header>
        <div class="flex items-center gap-2">
          <div class={"h-3 w-3 rounded-full #{status_color(@type)}"}></div>
          <h2 class="text-sm tracking-tight text-zinc-300">
            {list_name(@type)}
          </h2>
        </div>
      </.list_header>
      <.list_content>
        <div id={"#{@type}-container"} phx-update="stream">
          <div
            :for={{dom_id, document} <- @documents}
            id={dom_id}
            data-menu={"context-menu-#{document.id}"}
            phx-hook="ContextMenu"
          >
            <.list_item href={resource_link(@type, document, @application)}>
              <div class="flex items-center gap-2">
                <.document_status_select type={@type} document={document} />
                <p class="text-[13px] text-zinc-300 leading-tight">
                  {document.title}
                </p>
              </div>

              <p class="hidden lg:block text-[13px] text-zinc-400 leading-tight text-right truncate">
              </p>

              <p class="text-[13px] text-zinc-400 leading-tight text-right w-24">
                {document.inserted_at && formatted_relative_time(document.inserted_at)}
              </p>

              <.context_menu document={document} type={@type} />
            </.list_item>
          </div>
          <.list_empty_state>
            <div class="text-[13px] text-zinc-300 leading-tight">
              This application doesn't have any cover letters yet
            </div>
          </.list_empty_state>
        </div>
      </.list_content>
    </div>
    """
  end

  def document_status_select(assigns) do
    ~H"""
    <.dropdown_menu class="z-90">
      <.dropdown_menu_trigger id={"#{@document.id}-dropdown-trigger"} class="group">
        <div
          class={"h-3 w-3 rounded-full #{document_status_color(@document.status)} hover:scale-110 hover:shadow transition hover:cursor-default"}
          role="button"
          aria-haspopup="true"
          aria-expanded="false"
          tabindex="0"
        >
        </div>
      </.dropdown_menu_trigger>

      <.dropdown_menu_content side="right">
        <.menu class="w-56 text-zinc-300 bg-zinc-800">
          <.menu_group>
            <.menu_item class="pointer-events-none">
              <span class="text-zinc-400 font-extralight tracking-tighter">
                Change document status
              </span>
            </.menu_item>
          </.menu_group>

          <.menu_separator />

          <.menu_group>
            <%= for option <- options_for_document_status(@type) do %>
              <.menu_item
                phx-click="update_document_status"
                phx-value-id={@document.id}
                phx-value-status={option.value}
                phx-value-type={@type}
              >
                <div class="w-full flex items-center gap-2">
                  <%= if Map.has_key?(option, :icon) do %>
                    <.icon name={option.icon} class={Enum.join(["size-4", option.color], " ")} />
                  <% end %>
                  <span>{option.label}</span>
                  <.menu_shortcut>
                    <div class="w-full flex items-center gap-2 justify-between">
                      <%= if String.to_atom(option.value) == @document.status do %>
                        <.icon name="hero-check-solid" class="size-5 text-zinc-50" />
                      <% end %>
                      <span>{option.shortcut}</span>
                    </div>
                  </.menu_shortcut>
                </div>
              </.menu_item>
            <% end %>
          </.menu_group>
        </.menu>
      </.dropdown_menu_content>
    </.dropdown_menu>
    """
  end

  defp context_menu(assigns) do
    ~H"""
    <.menu id={"context-menu-#{@document.id}"} class="hidden w-56 text-zinc-300 bg-zinc-800">
      <.menu_group>
        {status_menu_item(%{document: @document, type: @type})}

        <.menu_separator />
        <.menu_item phx-click="delete_document" phx-value-id={@document.id} phx-value-type={@type}>
          <div class="w-full flex items-center gap-2">
            <.icon name="hero-trash" class="size-4" />
            <span>Delete</span>
            <.menu_shortcut>
              <div class="flex gap-1">
                <span>⌘</span>
                <span>⌫</span>
              </div>
            </.menu_shortcut>
          </div>
        </.menu_item>
      </.menu_group>
    </.menu>
    """
  end

  defp status_menu_item(assigns) do
    ~H"""
    <div class="relative group">
      <.menu_item class="flex items-center justify-between">
        <div class="flex items-center gap-2">
          <.icon name="hero-envelope-open" class="size-4" />
          <span>Status</span>
        </div>
        <.menu_shortcut>
          <div class="flex gap-4">
            <span>S</span>
            <span class="text-[8px]">▶</span>
          </div>
        </.menu_shortcut>
      </.menu_item>
      
    <!-- Submenu positioned absolutely -->
      <div class="absolute left-full top-0 hidden group-hover:block w-48 bg-zinc-800 shadow-md border border-zinc-700 rounded-md z-90">
        <.menu class="w-full">
          <.menu_group>
            <%= for option <- options_for_document_status(@type) do %>
              <.menu_item
                phx-click="update_application_status"
                phx-value-id={@document.id}
                phx-value-status={option.value}
              >
                <div class="w-full flex items-center gap-2">
                  <.icon name={option.icon} class={Enum.join(["size-4", option.color], " ")} />
                  <span>{option.label}</span>
                  <.menu_shortcut>
                    <div class="w-full flex items-center gap-2 justify-between">
                      <%= if String.to_atom(option.value) == @document.status do %>
                        <.icon name="hero-check-solid" class="size-5 text-zinc-50" />
                      <% end %>
                    </div>
                  </.menu_shortcut>
                </div>
              </.menu_item>
            <% end %>
          </.menu_group>
        </.menu>
      </div>
    </div>
    """
  end

  def resource_link("cover_letter", document, application) do
    ~p"/job_application/#{application.slug}/cover_letter/#{document.id}"
  end

  def resource_link(_, _, _), do: "#"

  def status_color(_), do: "border-zinc-200"

  def options_for_document_status("cover_letter"), do: options_for_cover_letter_status()
  def options_for_document_status(_), do: []

  def document_status_color(:draft), do: "bg-zinc-400"
  def document_status_color(:final), do: "bg-blue-400"
  def document_status_color(:submitted), do: "bg-green-400"

  def list_name("cover_letter"), do: "Cover letters"
end
