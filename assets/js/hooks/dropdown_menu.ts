import type { Hook } from "phoenix_live_view";

const DropdownMenu: Hook = {
  mounted() {
    const el = this.el as HTMLElement;

    const hideDropdownOnOutsideClick = (event: MouseEvent) => {
      if (!el.contains(event.target as Node)) {
        el.setAttribute("data-state", "closed");
      }
    };

    document.addEventListener("contextmenu", hideDropdownOnOutsideClick);

    this.destroyed = () => {
      document.removeEventListener("contextmenu", hideDropdownOnOutsideClick);
    };
  },
};

export default DropdownMenu;
