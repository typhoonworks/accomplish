import type { Hook } from "phoenix_live_view";

const UrlInputAutoFocus: Hook = {
  mounted() {
    const el = this.el as HTMLElement;
    const input = el.querySelector("input") as HTMLInputElement | null;
    if (input && input.dataset.autofocus === "true") {
      setTimeout(() => {
        input.focus();
        input.setSelectionRange(0, 0);
      }, 50);
    }

    el.addEventListener("url-input:focus", () => {
      const input = el.querySelector("input") as HTMLInputElement | null;
      if (input) {
        setTimeout(() => {
          input.focus();
          input.setSelectionRange(0, 0);
        }, 50);
      }
    });
  },
};

export default UrlInputAutoFocus;
