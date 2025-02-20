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

      document.querySelectorAll(".context-menu").forEach((openMenu) => {
        openMenu.classList.add("hidden");
      });

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

      document.addEventListener("click", hideContextMenu, { once: true });
    };

    const hideContextMenu = (event: MouseEvent) => {
      if (menu.contains(event.target as Node)) {
        return;
      }

      event.preventDefault();
      event.stopPropagation();

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
