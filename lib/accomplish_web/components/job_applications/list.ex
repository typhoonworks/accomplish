defmodule AccomplishWeb.Components.JobApplications.List do
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
  import AccomplishWeb.Components.JobApplicationMenu

  def application_group(assigns) do
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
            <.list_item href={~p"/job_application/#{application.slug}/overview"}>
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
                {application.applied_at && formatted_relative_time(application.applied_at)}
              </p>

              <.application_menu
                application={application}
                position="right-click"
                id={"context-menu-#{application.id}"}
              />
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
end
