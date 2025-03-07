import type { Hook } from "phoenix_live_view";

interface AccordionContentElement extends HTMLElement {
  updateMaxHeight?: () => void;
  detailsEl?: HTMLElement;
}

const AccordionContent: Hook = {
  mounted() {
    const el = this.el as AccordionContentElement;
    const detailsId = el.dataset.detailsId;
    const details = detailsId ? document.getElementById(detailsId) : null;
    if (!details) return;

    const updateMaxHeight = () => {
      if ((details as HTMLDetailsElement).open) {
        el.style.maxHeight = `${el.scrollHeight}px`;
      } else {
        el.style.maxHeight = "0";
      }
    };

    details.addEventListener("toggle", updateMaxHeight);
    el.updateMaxHeight = updateMaxHeight;
    el.detailsEl = details;

    requestAnimationFrame(() => {
      updateMaxHeight();
    });
  },
  updated() {
    const el = this.el as HTMLElement;
    const detailsId = el.dataset.detailsId;
    const details = detailsId ? document.getElementById(detailsId) : null;
    if (details && (details as HTMLDetailsElement).open) {
      el.style.maxHeight = `${el.scrollHeight}px`;
    }
  },
  destroyed() {
    const el = this.el as AccordionContentElement;
    if (el.detailsEl && el.updateMaxHeight) {
      el.detailsEl.removeEventListener("toggle", el.updateMaxHeight);
    }
  },
};

export default AccordionContent;
