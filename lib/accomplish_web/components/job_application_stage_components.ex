defmodule AccomplishWeb.Components.JobApplicationStageComponents do
  @moduledoc false

  use Phoenix.Component

  @endpoint AccomplishWeb.Endpoint
  @router AccomplishWeb.Router

  import Phoenix.VerifiedRoutes
  import AccomplishWeb.CoreComponents
  import AccomplishWeb.ShadowrunComponents
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu
  import AccomplishWeb.Shadowrun.StackedList
  import AccomplishWeb.TimeHelpers
  import AccomplishWeb.JobApplicationStageHelpers

  def stage_group(assigns) do
    ~H"""
    <div
      id={"#{@status}-group"}
      class="hidden opacity-0 translate-y-2 transition-transform duration-300"
      phx-hook="StackedList"
    >
      <.list_header>
        <div class="flex items-center gap-2">
          <div class={"h-3 w-3 rounded-full #{status_color(@status)}"}></div>
          <h2 class="text-sm tracking-tight text-zinc-300">
            {format_status(@status)}
          </h2>
        </div>
      </.list_header>
      <.list_content>
        <div id={"#{@status}-container"} phx-update="stream">
          <div
            :for={{dom_id, stage} <- @stages}
            id={dom_id}
            data-menu={"context-menu-#{stage.id}"}
            phx-hook="ContextMenu"
          >
            <.list_item href={~p"/job_application/#{@application.slug}/stage/#{stage.slug}"}>
              <div class="flex items-center gap-2">
                <.stage_status_select application={@application} stage={stage} />
                <p class="text-[13px] text-zinc-300 leading-tight">
                  {stage.title}
                </p>
              </div>

              <p class="hidden lg:block text-[13px] text-zinc-400 leading-tight text-right truncate">
                <.shadow_pill :if={@application.current_stage_id == stage.id}>
                  Current stage
                </.shadow_pill>
              </p>

              <p class="text-[13px] text-zinc-400 leading-tight text-right w-24">
                {formatted_human_date(stage.date)}
              </p>

              <.menu id={"context-menu-#{stage.id}"} class="hidden w-56 text-zinc-300 bg-zinc-800">
                <.menu_group>
                  {status_menu_item(%{stage: stage, application: @application})}
                  {current_stage_menu_item(%{stage: stage, application: @application})}
                  <.menu_separator />
                  <.menu_item
                    phx-click="delete_stage"
                    phx-value-id={stage.id}
                    phx-value-status={stage.status}
                  >
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
            </.list_item>
          </div>
        </div>
      </.list_content>
    </div>
    """
  end

  def stage_status_select(assigns) do
    ~H"""
    <.dropdown_menu class="z-90">
      <.dropdown_menu_trigger id={"#{@stage.id}-dropdown-trigger"} class="group">
        <div
          class={"h-3 w-3 rounded-full #{status_color(@stage.status)} hover:scale-110 hover:shadow transition hover:cursor-default"}
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
                Change stage status
              </span>
            </.menu_item>
          </.menu_group>

          <.menu_separator />

          <.menu_group>
            <%= for option <- options_for_stage_status() do %>
              <.menu_item
                phx-click="update_stage_status"
                phx-value-id={@stage.id}
                phx-value-application_id={@application.id}
                phx-value-status={option.value}
              >
                <div class="w-full flex items-center gap-2">
                  <%= if Map.has_key?(option, :icon) do %>
                    <.icon name={option.icon} class={Enum.join(["size-4", option.color], " ")} />
                  <% end %>
                  <span>{option.label}</span>
                  <.menu_shortcut>
                    <div class="w-full flex items-center gap-2 justify-between">
                      <%= if option.value == @stage.status do %>
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
            <%= for option <- options_for_stage_status() do %>
              <.menu_item
                phx-click="update_stage_status"
                phx-value-id={@stage.id}
                phx-value-application_id={@application.id}
                phx-value-status={option.value}
              >
                <div class="w-full flex items-center gap-2">
                  <.icon name={option.icon} class={Enum.join(["size-4", option.color], " ")} />
                  <span>{option.label}</span>
                  <.menu_shortcut>
                    <div class="w-full flex items-center gap-2 justify-between">
                      <%= if option.value  == @stage.status do %>
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

  def current_stage_menu_item(assigns) do
    ~H"""
    <div class="relative group">
      <.menu_item
        phx-click="set_current_stage"
        phx-value-application-id={@application.id}
        phx-value-stage-id={@stage.id}
      >
        <div class="w-full flex items-center gap-2">
          <.icon name="hero-square-3-stack-3d" class="size-4" />
          <span>Set current stage</span>
          <.menu_shortcut>
            <div class="flex gap-1">
              <span>C</span>
            </div>
          </.menu_shortcut>
        </div>
      </.menu_item>
    </div>
    """
  end
end
