defmodule AccomplishWeb.Layout do
  @moduledoc false

  use AccomplishWeb, :live_view

  import AccomplishWeb.Shadowrun.Avatar
  import AccomplishWeb.Shadowrun.DropdownMenu
  import AccomplishWeb.Shadowrun.Menu
  import AccomplishWeb.Shadowrun.Sidebar
  import AccomplishWeb.Shadownrun.SlideOver

  attr :current_user, :map, default: nil
  attr :current_path, :string, default: "/"
  slot :page_header
  slot :page_drawer
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.mobile_sidebar current_path={@current_path} current_user={@current_user} />
    <.sidebar current_path={@current_path} current_user={@current_user} />

    <div class="lg:pl-72 h-screen lg:p-2 flex flex-col overflow-hidden ">
      <!-- Bordered box (centered) -->
      <div class="relative bg-neutral-900 lg:z-50 flex-1 flex flex-col min-h-0 lg:border lg:border-zinc-700 lg:rounded-lg overflow-hidden">
        {render_slot(@page_header, has_drawer?: true)}
        <!-- Content area: split between main canvas and drawer -->
        <div class="flex flex-1 overflow-hidden relative">
          <!-- Main canvas: scrollable content area -->
          <main class="flex-1 overflow-y-auto px-4 sm:px-6 lg:px-8 pb-20">
            {render_slot(@inner_block)}
          </main>
          {render_slot(@page_drawer)}
        </div>
      </div>
    </div>
    """
  end

  attr :page_title, :string, default: nil
  attr :page_drawer?, :boolean, default: false
  attr :drawer_open, :boolean, default: true
  slot :title
  slot :actions

  def page_header(assigns) do
    ~H"""
    <header class="sticky top-0 z-40 bg-neutral-900 border-b border-zinc-700">
      <div class="flex flex-col">
        <!-- Top row: always visible -->
        <div class="flex items-center justify-between h-10 px-4 sm:px-6 lg:px-8">
          <div class="flex items-center gap-x-2">
            <button
              type="button"
              id="show-mobile-sidebar"
              class="p-2.5 text-zinc-700 lg:hidden"
              phx-click={show_mobile_sidebar()}
            >
              <span class="sr-only">Open sidebar</span>
              <.icon class="size-6" name="hero-bars-3-solid" />
            </button>
            <div class="h-6 w-px bg-zinc-950/10 lg:hidden" aria-hidden="true"></div>
            <h2 class="text-[13px] text-zinc-50">
              {@page_title || render_slot(@title)}
            </h2>
            <!-- Desktop actions: inline with title -->
            <div class="hidden lg:flex lg:ml-4">
              {render_slot(@actions)}
            </div>
          </div>
          <!-- Right side controls: always in the top row -->
          <div class="flex items-center gap-x-4">
            <button
              type="button"
              class="-m-2.5 p-2.5 text-zinc-400 hover:text-zinc-500 hidden lg:block"
            >
              <span class="sr-only">View notifications</span>
              <.icon class="size-5" name="hero-bell" />
            </button>
            <%= if @page_drawer? do %>
              <.separator variant="vertical" size={60} />
              <button
                id="page-drawer-toggle"
                type="button"
                class="text-zinc-400 hover:text-zinc-500 group"
                phx-click={
                  JS.exec("data-toggle", to: "#page-drawer-container")
                  |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "#page-drawer-toggle")
                }
                data-state={if @drawer_open, do: "open", else: "closed"}
              >
                <span class="sr-only">Open/close drawer</span>
                <.icon
                  class="size-5 hidden group-[&[data-state=open]]:block"
                  name="hero-view-columns-solid"
                />
                <.icon
                  class="size-5 hidden group-[&[data-state=closed]]:block"
                  name="hero-view-columns"
                />
              </button>
            <% end %>
          </div>
        </div>
        <!-- Mobile actions: show below top row -->
        <div class="lg:hidden mt-2 flex flex-row border-t border-zinc-700 py-1 px-4 sm:px-6 lg:px-8">
          {render_slot(@actions)}
        </div>
      </div>
    </header>
    """
  end

  attr :drawer_open, :boolean, default: true
  slot :drawer_content

  def page_drawer(assigns) do
    ~H"""
    <.slide_over id="page-drawer" show={@drawer_open}>
      {render_slot(@drawer_content)}
    </.slide_over>
    """
  end

  def sidebar(assigns) do
    ~H"""
    <div class="hidden lg:fixed lg:inset-y-0 lg:z-50 lg:flex lg:w-72 lg:flex-col">
      <div class="flex grow flex-col gap-y-2 overflow-y-auto bg-zinc-950 px-6 pb-4">
        <div class="flex h-14 shrink-0 items-center">
          <.dropdown_menu>
            <.dropdown_menu_trigger id="sidebar-user-dropdown-trigger" class="group">
              <button
                type="button"
                class="-m-2 flex items-center p-2 rounded-md bg-zinc-950 hover:bg-zinc-800 group-[&[data-state=open]]:bg-zinc-800 transition-colors"
                id="user-menu-button"
                aria-expanded="false"
                aria-haspopup="true"
              >
                <span class="sr-only">Open user menu</span>
                <.avatar name={@current_user.username} size={:xs} />
                <span class="flex items-center">
                  <span class="ml-4 text-[14px] text-zinc-50" aria-hidden="true">
                    {@current_user.username}
                  </span>
                  <.icon class="ml-2 size-4 text-zinc-400" name="hero-chevron-down" />
                </span>
              </button>
            </.dropdown_menu_trigger>
            <.dropdown_menu_content>
              <.menu class="w-56 text-zinc-300 bg-zinc-900">
                <.menu_group>
                  <.menu_item class="text-[13px]">
                    <span>Profile</span>
                    <.menu_shortcut>⌘P</.menu_shortcut>
                  </.menu_item>
                  <.link href={~p"/settings"}>
                    <.menu_item class="text-[13px]">
                      <span>Settings</span>
                      <.menu_shortcut>⌘S</.menu_shortcut>
                    </.menu_item>
                  </.link>
                </.menu_group>
                <.menu_separator />
                <.menu_group>
                  <.link href={~p"/logout"} method="delete">
                    <.menu_item class="text-[13px]">
                      <span>Log out</span>
                      <.menu_shortcut>⌥⇧Q</.menu_shortcut>
                    </.menu_item>
                  </.link>
                </.menu_group>
              </.menu>
            </.dropdown_menu_content>
          </.dropdown_menu>
        </div>
        <nav class="flex flex-1 flex-col">
          <ul role="list" class="flex flex-1 flex-col gap-y-4">
            <li>
              <ul role="list" class="-mx-2 space-y-1">
                <li>
                  <.sidebar_link
                    href={~p"/mission_control"}
                    icon="hero-rocket-launch-solid"
                    text="Mission Control"
                    active={@current_path == "/mission_control"}
                  />
                </li>
              </ul>
            </li>
            <.sidebar_group id="workbench-menu" name="Workbench">
              <.sidebar_item>
                <.sidebar_link
                  href="#"
                  icon="hero-wrench-screwdriver-solid"
                  text="Projects"
                  active={@current_path == "/projects"}
                />
              </.sidebar_item>
              <.sidebar_item>
                <.sidebar_link
                  href="#"
                  icon="hero-chart-bar-solid"
                  text="Work Logs"
                  active={@current_path == "/work_logs"}
                />
              </.sidebar_item>
              <.sidebar_item>
                <.sidebar_link
                  href="#"
                  icon="hero-calendar-solid"
                  text="Calendar"
                  active={@current_path == "/calendar"}
                />
              </.sidebar_item>
            </.sidebar_group>
            <.sidebar_group id="vault-menu" name="Vault">
              <.sidebar_item>
                <.sidebar_link
                  href="#"
                  icon="hero-code-bracket-solid"
                  text="Snippets"
                  active={@current_path == "/snippets"}
                />
              </.sidebar_item>
              <.sidebar_item>
                <.sidebar_link
                  href="#"
                  icon="hero-beaker-solid"
                  text="Recipes"
                  active={@current_path == "/recipes"}
                />
              </.sidebar_item>
              <.sidebar_item>
                <.sidebar_link
                  href="#"
                  icon="hero-document-text-solid"
                  text="Notes"
                  active={@current_path == "/notes"}
                />
              </.sidebar_item>
            </.sidebar_group>
            <.sidebar_group id="career-menu" name="Career">
              <.sidebar_item>
                <.sidebar_link
                  href={~p"/job_applications"}
                  icon="hero-envelope-solid"
                  text="Job Applications"
                  active={@current_path == "/job_applications"}
                />
              </.sidebar_item>
              <.sidebar_item>
                <.sidebar_link
                  href="#"
                  icon="hero-folder-open-solid"
                  text="Documents"
                  active={@current_path == "/documents"}
                />
              </.sidebar_item>
            </.sidebar_group>

            <li class="mt-auto">
              <%!-- Placeholder --%>
            </li>
          </ul>
        </nav>
      </div>
    </div>
    """
  end

  def mobile_sidebar(assigns) do
    ~H"""
    <div
      id="mobile-sidebar-container"
      class="relative z-[99] lg:hidden"
      role="dialog"
      aria-modal="true"
      style="display: none;"
    >
      <div id="mobile-sidebar-backdrop" class="fixed inset-0 bg-zinc-900/80" aria-hidden="false">
      </div>

      <div class="fixed inset-0 flex">
        <div id="mobile-sidebar" class="relative mr-16 flex w-full flex-1">
          <div
            id="hide-mobile-sidebar"
            class="absolute left-full top-0 flex w-16 justify-center pt-5 text-zinc-50"
          >
            <button type="button" class="p-2.5" phx-click={hide_mobile_sidebar()}>
              <span class="sr-only">Close sidebar</span>
              <.icon class="size-6" name="hero-x-mark-solid" />
            </button>
          </div>

          <div class="flex grow flex-col gap-y-5 overflow-y-auto bg-zinc-950 px-6 pb-4 ring-1 ring-white/10">
            <div class="flex h-16 shrink-0 items-center">
              <.dropdown_menu>
                <.dropdown_menu_trigger id="mobile-sidebar-user-dropdown-trigger" class="group">
                  <button
                    type="button"
                    class="-m-2 flex items-center p-2 rounded-md bg-zinc-950 hover:bg-zinc-800 group-[&[data-state=open]]:bg-zinc-800 transition-colors"
                    id="user-mobile-menu-button"
                    aria-expanded="false"
                    aria-haspopup="true"
                  >
                    <span class="sr-only">Open user menu</span>
                    <.avatar name={@current_user.username} size={:xs} />
                    <span class="flex items-center">
                      <span class="ml-4 text-[14px] text-zinc-50" aria-hidden="true">
                        {@current_user.username}
                      </span>
                      <.icon class="ml-2 size-4 text-zinc-400" name="hero-chevron-down" />
                    </span>
                  </button>
                </.dropdown_menu_trigger>
                <.dropdown_menu_content>
                  <.menu class="w-56 text-zinc-300 bg-zinc-800">
                    <.menu_group>
                      <.menu_item class="text-[13px]">
                        <span>Profile</span>
                        <.menu_shortcut>⌘P</.menu_shortcut>
                      </.menu_item>
                      <.link href={~p"/settings"}>
                        <.menu_item class="text-[13px]">
                          <span>Settings</span>
                          <.menu_shortcut>⌘S</.menu_shortcut>
                        </.menu_item>
                      </.link>
                    </.menu_group>
                    <.menu_separator />
                    <.menu_group>
                      <.link href={~p"/logout"} method="delete">
                        <.menu_item class="text-[13px]">
                          <span>Log out</span>
                          <.menu_shortcut>⌥⇧Q</.menu_shortcut>
                        </.menu_item>
                      </.link>
                    </.menu_group>
                  </.menu>
                </.dropdown_menu_content>
              </.dropdown_menu>
            </div>
            <nav class="flex flex-1 flex-col">
              <ul role="list" class="flex flex-1 flex-col gap-y-4">
                <li>
                  <ul role="list" class="-mx-2 space-y-1">
                    <li>
                      <.sidebar_link
                        href={~p"/mission_control"}
                        icon="hero-rocket-launch-solid"
                        text="Mission Control"
                        active={@current_path == "/mission_control"}
                      />
                    </li>
                  </ul>
                </li>
                <.sidebar_group id="workbench-mobile-menu" name="Workbench">
                  <.sidebar_item>
                    <.sidebar_link
                      href="#"
                      icon="hero-wrench-screwdriver-solid"
                      text="Projects"
                      active={@current_path == "/projects"}
                    />
                  </.sidebar_item>
                  <.sidebar_item>
                    <.sidebar_link
                      href="#"
                      icon="hero-chart-bar-solid"
                      text="Work Logs"
                      active={@current_path == "/work_logs"}
                    />
                  </.sidebar_item>
                  <.sidebar_item>
                    <.sidebar_link
                      href="#"
                      icon="hero-calendar-solid"
                      text="Calendar"
                      active={@current_path == "/calendar"}
                    />
                  </.sidebar_item>
                </.sidebar_group>
                <.sidebar_group id="vault-mobile-menu" name="Vault">
                  <.sidebar_item>
                    <.sidebar_link
                      href="#"
                      icon="hero-code-bracket-solid"
                      text="Snippets"
                      active={@current_path == "/snippets"}
                    />
                  </.sidebar_item>
                  <.sidebar_item>
                    <.sidebar_link
                      href="#"
                      icon="hero-beaker-solid"
                      text="Recipes"
                      active={@current_path == "/recipes"}
                    />
                  </.sidebar_item>
                  <.sidebar_item>
                    <.sidebar_link
                      href="#"
                      icon="hero-document-text-solid"
                      text="Notes"
                      active={@current_path == "/notes"}
                    />
                  </.sidebar_item>
                </.sidebar_group>
                <.sidebar_group id="career-mobile-menu" name="Career">
                  <.sidebar_item>
                    <.sidebar_link
                      href={~p"/job_applications"}
                      icon="hero-briefcase-solid"
                      text="Job Applications"
                      active={@current_path == "/job_applications"}
                    />
                  </.sidebar_item>
                  <.sidebar_item>
                    <.sidebar_link
                      href="#"
                      icon="hero-folder-open-solid"
                      text="Documents"
                      active={@current_path == "/documents"}
                    />
                  </.sidebar_item>
                </.sidebar_group>
                <li class="mt-auto">
                  <%!-- Placeholder --%>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
