import type { Hook } from "phoenix_live_view";

interface CopyToClipboardEvent {
  text: string;
}

const Clipboard: Hook = {
  mounted() {
    this.handleEvent("copy-to-clipboard", ({ text }: CopyToClipboardEvent) => {
      navigator.clipboard
        .writeText(text)
        .then(() => {
          const el = document.createElement("div");
          el.innerText = "Copied to clipboard!";
          el.className =
            "flash flash-success fixed top-4 right-4 z-50 px-4 py-2 bg-green-700 text-white text-sm rounded-md shadow-lg";
          document.body.appendChild(el);

          setTimeout(() => {
            el.remove();
          }, 2000);
        })
        .catch((_err) => {
          const el = document.createElement("div");
          el.innerText = "Failed to copy to clipboard";
          el.className =
            "flash flash-error fixed top-4 right-4 z-50 px-4 py-2 bg-red-700 text-white text-sm rounded-md shadow-lg";
          document.body.appendChild(el);

          setTimeout(() => {
            el.remove();
          }, 2000);
        });
    });
  },
};

export default Clipboard;
