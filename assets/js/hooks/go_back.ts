import type { Hook } from "phoenix_live_view";

const GoBack: Hook = {
  mounted() {
    const el = this.el as HTMLButtonElement;

    const handleClick = () => {
      window.history.back();
    };

    el.addEventListener("click", handleClick);

    this.destroyed = () => {
      el.removeEventListener("click", handleClick);
    };
  },
};

export default GoBack;
