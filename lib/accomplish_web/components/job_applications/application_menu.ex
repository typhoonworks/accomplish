defmodule AccomplishWeb.Components.JobApplicationMenu do
  @moduledoc """
  Reusable application menu component that can be used in different contexts:
  - As a static dropdown in headers
  - As a right-click context menu in lists

  Provides a consistent interface for application-related actions.
  """
  use Phoenix.Component

  alias Accomplish.JobApplications.Stages

  import AccomplishWeb.CoreComponents
  import AccomplishWeb.ShadowrunComponents
  import AccomplishWeb.Shadowrun.Menu
  import AccomplishWeb.Shadowrun.ContextMenu
  import AccomplishWeb.JobApplicationHelpers

  attr :application, :map, required: true
  attr :position, :string, default: "right-click", values: ["right-click", "static", "dropdown"]
  attr :id, :string, default: nil

  def application_menu(assigns) do
    menu_id = assigns.id || "app-menu-#{assigns.application.id}"

    assigns = assign(assigns, :menu_id, menu_id)

    ~H"""
    <.context_menu id={@id} position={@position}>
      <!-- Status submenu -->
      <div class="relative group/submenu">
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
        
    <!-- Status submenu content -->
        <div class="absolute left-full top-0 hidden group-hover/submenu:block w-48 bg-zinc-800 shadow-md border border-zinc-700 rounded-md z-90">
          <.menu class="w-full">
            <.menu_group>
              <%= for option <- options_for_application_status() do %>
                <.menu_item
                  phx-click="update_application_status"
                  phx-value-id={@application.id}
                  phx-value-status={option.value}
                >
                  <div class="w-full flex items-center gap-2">
                    <.icon name={option.icon} class={Enum.join(["size-4", option.color], " ")} />
                    <span>{option.label}</span>
                    <.menu_shortcut>
                      <div class="w-full flex items-center gap-2 justify-between">
                        <%= if option.value == @application.status do %>
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

      <.menu_separator />
      
    <!-- Add stage submenu -->
      <div class="relative group/submenu">
        <.menu_item class="flex items-center justify-between">
          <div class="flex items-center gap-2">
            <.icon name="hero-arrow-down-on-square" class="size-4" />
            <span>Add stage</span>
          </div>
          <.menu_shortcut>
            <div class="flex gap-4">
              <div class="flex gap-1">
                <span>Ctrl</span>
                <span>S</span>
              </div>
              <span class="text-[8px]">▶</span>
            </div>
          </.menu_shortcut>
        </.menu_item>
        
    <!-- Add stage submenu content -->
        <div class="absolute left-full top-0 hidden group-hover/submenu:block w-48 bg-zinc-800 shadow-md border border-zinc-700 rounded-md z-90">
          <.menu class="w-full">
            <.menu_group>
              <%= for stage <- Stages.predefined_stages() do %>
                <.menu_item
                  phx-click="prepare_predefined_stage"
                  phx-value-application_id={@application.id}
                  phx-value-title={stage.title}
                  phx-value-type={Atom.to_string(stage.type)}
                >
                  <div class="w-full flex items-center gap-2">
                    <.icon name={stage_icon(stage.type)} class="size-4 text-zinc-300" />
                    <span>{stage.title}</span>
                  </div>
                </.menu_item>
              <% end %>
              <.menu_separator />
              <.menu_item phx-click="prepare_new_stage" phx-value-application_id={@application.id}>
                <div class="w-full flex items-center gap-2">
                  <.icon name="hero-pencil-square" class="size-4" />
                  <span>Custom stage</span>
                </div>
              </.menu_item>
            </.menu_group>
          </.menu>
        </div>
      </div>
      
    <!-- Current stage submenu -->
      <div class="relative group/submenu">
        <.menu_item disabled={Enum.empty?(@application.stages)}>
          <div class="w-full flex items-center gap-2">
            <.icon name="hero-square-3-stack-3d" class="size-4" />
            <span>Current stage</span>
          </div>
          <.menu_shortcut>
            <div class="flex gap-1">
              <span>C</span>
              <span class="text-[8px]">▶</span>
            </div>
          </.menu_shortcut>
        </.menu_item>
        
    <!-- Current stage submenu content -->
        <div class="absolute left-full top-0 hidden group-hover/submenu:block w-48 bg-zinc-800 shadow-md border border-zinc-700 rounded-md z-90">
          <.menu class="w-full">
            <.menu_group>
              <%= for stage <- @application.stages do %>
                <.menu_item
                  phx-click="set_current_stage"
                  phx-value-application_id={@application.id}
                  phx-value-stage_id={stage.id}
                >
                  <div class="w-full flex items-center gap-2">
                    <.icon name={stage_icon(stage.type)} class="size-4 text-zinc-300" />
                    <span>{stage.title}</span>
                    <.menu_shortcut>
                      <div class="w-full flex items-center gap-2 justify-between">
                        <%= if stage.id == @application.current_stage_id do %>
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

      <.menu_separator />
      
    <!-- Cover letter actions -->
      <.menu_item phx-click="new_cover_letter" phx-value-application_id={@application.id}>
        <div class="w-full flex items-center gap-2">
          <.lucide_icon name="square-pen" class="size-4 text-zinc-400" />
          <span>Write cover letter</span>
          <.menu_shortcut>⌘W</.menu_shortcut>
        </div>
      </.menu_item>

      <.menu_item phx-click="open_cover_letter_dialog" phx-value-application_id={@application.id}>
        <div class="w-full flex items-center gap-2">
          <.lucide_icon name="sparkles" class="size-4 text-zinc-400" />
          <span>Generate cover letter</span>
          <.menu_shortcut>⌘G</.menu_shortcut>
        </div>
      </.menu_item>

      <.menu_separator />
      
    <!-- Delete application -->
      <.menu_item phx-click="delete_application" phx-value-id={@application.id}>
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
    </.context_menu>
    """
  end
end
