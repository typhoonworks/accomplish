import type { Hook } from "phoenix_live_view";

const ContextMenu: Hook = {
  mounted() {
    const el = this.el as HTMLElement;
    const menuId = el.getAttribute("data-menu");

    if (!menuId) {
      return;
    }

    const menu = document.getElementById(menuId) as HTMLElement | null;
    if (!menu) {
      return;
    }

    const showContextMenu = (event: MouseEvent) => {
      event.preventDefault();

      // Hide all open context menus first
      document.querySelectorAll(".context-menu").forEach((openMenu) => {
        openMenu.classList.add("hidden");
      });

      // Show the current menu
      menu.classList.remove("hidden");

      const menuWidth = menu.offsetWidth;
      const menuHeight = menu.offsetHeight;
      const viewportWidth = window.innerWidth;
      const viewportHeight = window.innerHeight;

      let left = event.clientX;
      let top = event.clientY;

      if (left + menuWidth > viewportWidth) {
        left = viewportWidth - menuWidth - 10;
      }

      if (top + menuHeight > viewportHeight) {
        top = viewportHeight - menuHeight - 10;
      }

      menu.style.left = `${left}px`;
      menu.style.top = `${top}px`;
      menu.style.position = "fixed";
      menu.classList.add("context-menu");
      menu.style.zIndex = "9999";

      // Ensure the menu closes when clicking elsewhere
      document.addEventListener("click", hideContextMenu);
    };

    const hideContextMenu = (event: MouseEvent) => {
      // If clicking a menu item inside the context menu, close it
      if (menu.contains(event.target as Node)) {
        setTimeout(() => {
          menu.classList.add("hidden");
          menu.classList.remove("context-menu");
        }, 100); // Allow LiveView to process `phx-click` before hiding
        return;
      }

      // If clicking outside, close immediately
      menu.classList.add("hidden");
      menu.classList.remove("context-menu");
    };

    el.addEventListener("contextmenu", showContextMenu);

    this.destroyed = () => {
      el.removeEventListener("contextmenu", showContextMenu);
      document.removeEventListener("click", hideContextMenu);
    };
  },
};

export default ContextMenu;
