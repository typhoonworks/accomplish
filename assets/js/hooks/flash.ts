import type { Hook } from "phoenix_live_view";

const Flash: Hook = {
  mounted() {
    const el = this.el as HTMLElement;
    let timer: NodeJS.Timeout | null = null;
    const timeout = parseInt(el.dataset.timeout || "0", 10);

    const clearTimer = () => {
      if (timer) {
        clearTimeout(timer);
        timer = null;
      }
    };

    const startTimer = (duration: number) => {
      clearTimer();
      timer = setTimeout(() => {
        const event = new MouseEvent("click", {
          bubbles: true,
          cancelable: true,
        });
        el.dispatchEvent(event);
      }, duration);
    };

    if (timeout > 0) {
      startTimer(timeout);
    }

    el.addEventListener("mouseenter", clearTimer);
    el.addEventListener("mouseleave", () => {
      if (timeout > 0) {
        startTimer(timeout);
      }
    });

    this.destroyed = () => {
      clearTimer();
      el.removeEventListener("mouseenter", clearTimer);
    };
  },
};

export default Flash;
