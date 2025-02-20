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

      menu.style.left = `${event.pageX}px`;
      menu.style.top = `${event.pageY}px`;
      menu.style.position = "absolute";
      menu.classList.remove("hidden");
      menu.classList.add("context-menu");

      document.addEventListener("click", hideContextMenu, { once: true });
    };

    const hideContextMenu = () => {
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
