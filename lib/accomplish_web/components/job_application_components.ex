defmodule AccomplishWeb.Components.JobApplicationComponents do
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
  import AccomplishWeb.JobApplicationHelpers

  alias Accomplish.JobApplications.Stages

  def application_group(assigns) do
    ~H"""
    <div
      id={"#{@status}-group"}
      class="hidden opacity-0 translate-y-2 transition-transform duration-300"
      phx-hook="ApplicationGroup"
    >
      <.list_header>
        <div class="flex items-center gap-2">
          <div class={"h-3 w-3 rounded-full #{status_color(@status)}"}></div>
          <h2 class="text-sm tracking-tight text-zinc-300">
            {format_status(@status)}
          </h2>
        </div>
        <button
          class="text-zinc-400 hover:text-zinc-200"
          phx-click="prepare_new_application"
          phx-value-status={@status}
          phx-value-modal_id="new-job-application"
        >
          <.icon class="text-current size-4" name="hero-plus" />
        </button>
      </.list_header>
      <.list_content>
        <div id={"#{@status}-container"} phx-update="stream">
          <div
            :for={{dom_id, application} <- @applications}
            id={dom_id}
            data-menu={"context-menu-#{application.id}"}
            phx-hook="ContextMenu"
          >
            <.list_item clickable={true} href={~p"/job_application/#{application.slug}/overview"}>
              <div class="flex items-center gap-2">
                <.application_status_select application={application} />
                <p class="text-[13px] text-zinc-300 leading-tight">
                  {application.company.name}
                  <span class="text-zinc-400">• {application.role}</span>
                </p>
              </div>

              <p class="hidden lg:block text-[13px] text-zinc-400 leading-tight text-right truncate">
                <.shadow_pill :if={application.current_stage}>
                  {application.current_stage.title}
                </.shadow_pill>
              </p>

              <p class="text-[13px] text-zinc-400 leading-tight text-right w-24">
                {formatted_relative_time(application.applied_at)}
              </p>

              <.menu
                id={"context-menu-#{application.id}"}
                class="hidden w-56 text-zinc-300 bg-zinc-800"
              >
                <.menu_group>
                  {status_menu_item(%{application: application})}

                  <.menu_separator />
                  {add_stage_menu_item(%{application: application})}
                  {current_stage_menu_item(%{application: application})}

                  <.menu_separator />
                  <.menu_item phx-click="delete_application" phx-value-id={application.id}>
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

  def application_status_select(assigns) do
    ~H"""
    <.dropdown_menu class="z-90">
      <.dropdown_menu_trigger id={"#{@application.id}-dropdown-trigger"} class="group">
        <div
          class={"h-3 w-3 rounded-full #{status_color(@application.status)} hover:scale-110 hover:shadow transition hover:cursor-default"}
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
                Change application status
              </span>
            </.menu_item>
          </.menu_group>

          <.menu_separator />

          <.menu_group>
            <%= for option <- options_for_application_status() do %>
              <.menu_item
                phx-click="update_application_status"
                phx-value-id={@application.id}
                phx-value-status={option.value}
              >
                <div class="w-full flex items-center gap-2">
                  <%= if Map.has_key?(option, :icon) do %>
                    <.icon name={option.icon} class={Enum.join(["size-4", option.color], " ")} />
                  <% end %>
                  <span>{option.label}</span>
                  <.menu_shortcut>
                    <div class="w-full flex items-center gap-2 justify-between">
                      <%= if option.value == @application.status do %>
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
                      <%= if option.value  == @application.status do %>
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

  defp add_stage_menu_item(assigns) do
    ~H"""
    <div class="relative group">
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
      
    <!-- Submenu positioned absolutely -->
      <div class="absolute left-full top-0 hidden group-hover:block w-56 bg-zinc-800 shadow-md border border-zinc-700 rounded-md z-90">
        <.menu class="w-full">
          <.menu_group>
            <%= for stage <- Stages.predefined_stages() do %>
              <.menu_item
                phx-click="prepare_predefined_stage"
                phx-value-application-id={@application.id}
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
            <.menu_item phx-click="prepare_new_stage" phx-value-application-id={@application.id}>
              <div class="w-full flex items-center gap-2">
                <.icon name="hero-pencil-square" class="size-4" />
                <span>Custom stage</span>
              </div>
            </.menu_item>
          </.menu_group>
        </.menu>
      </div>
    </div>
    """
  end

  def current_stage_menu_item(assigns) do
    ~H"""
    <div class="relative group">
      <.menu_item disabled={Enum.empty?(@application.stages)}>
        <div class="w-full flex items-center gap-2">
          <.icon name="hero-square-3-stack-3d" class="size-4" />
          <span>Current stage</span>
          <.menu_shortcut>
            <div class="flex gap-1">
              <span>C</span>
              <span class="text-[8px]">▶</span>
            </div>
          </.menu_shortcut>
        </div>
      </.menu_item>
      
    <!-- Submenu positioned absolutely -->
      <div class="absolute left-full top-0 hidden group-hover:block w-56 bg-zinc-800 shadow-md border border-zinc-700 rounded-md z-90">
        <.menu class="w-full">
          <.menu_group>
            <%= for stage <- @application.stages do %>
              <.menu_item
                phx-click="set_current_stage"
                phx-value-application-id={@application.id}
                phx-value-stage-id={stage.id}
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
    """
  end
end
