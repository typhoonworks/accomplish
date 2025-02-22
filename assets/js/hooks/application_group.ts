import type { Hook } from "phoenix_live_view";

const ApplicationGroup: Hook = {
  mounted() {
    const el = this.el as HTMLElement;
    const container = el.querySelector(`[id$="-container"]`) as HTMLElement | null;

    if (!container) {
      return;
    }

    const checkEmptyState = () => {
      if (container.children.length === 0) {
        // Animate out
        el.classList.add("opacity-0", "translate-y-2");
        setTimeout(() => {
          el.classList.add("hidden");
        }, 300); // Delay to match the Tailwind transition
      } else {
        // Show smoothly
        el.classList.remove("hidden");
        setTimeout(() => {
          el.classList.remove("opacity-0", "translate-y-2");
        }, 10); // Short delay to ensure class transition applies
      }
    };

    // Initial check
    checkEmptyState();

    // Observe DOM changes
    const observer = new MutationObserver(checkEmptyState);
    observer.observe(container, { childList: true });

    this.destroyed = () => {
      observer.disconnect();
    };
  },
};

export default ApplicationGroup;
