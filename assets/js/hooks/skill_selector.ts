import type { Hook } from "phoenix_live_view";

const SkillSelector: Hook = {
  mounted() {
    const el = this.el as HTMLElement;
    const input = el.querySelector("#skill-input") as HTMLInputElement | null;
    const suggestionsList = el.querySelector("[id$='-suggestions']") as HTMLElement | null;

    if (input) {
      input.addEventListener("keydown", (event) => {
        if (!suggestionsList || suggestionsList.children.length === 0) return;

        const suggestions = Array.from(suggestionsList.children) as HTMLElement[];
        let currentIndex = suggestions.findIndex((s) => s.classList.contains("bg-zinc-700"));

        switch (event.key) {
          case "ArrowDown":
            event.preventDefault();
            if (currentIndex >= 0) {
              suggestions[currentIndex].classList.remove("bg-zinc-700");
              currentIndex = (currentIndex + 1) % suggestions.length;
            } else {
              currentIndex = 0;
            }
            suggestions[currentIndex].classList.add("bg-zinc-700");
            suggestions[currentIndex].scrollIntoView({ block: "nearest" });
            break;

          case "ArrowUp":
            event.preventDefault();
            if (currentIndex >= 0) {
              suggestions[currentIndex].classList.remove("bg-zinc-700");
              currentIndex = (currentIndex - 1 + suggestions.length) % suggestions.length;
            } else {
              currentIndex = suggestions.length - 1;
            }
            suggestions[currentIndex].classList.add("bg-zinc-700");
            suggestions[currentIndex].scrollIntoView({ block: "nearest" });
            break;

          case "Enter":
            if (currentIndex >= 0) {
              event.preventDefault();
              suggestions[currentIndex].click();
            }
            break;

          case "Escape":
            this.pushEventTo(el, "cancel-skill-input", {});
            break;
        }
      });

      input.addEventListener("blur", (_event) => {
        setTimeout(() => {
          if (!el.contains(document.activeElement)) {
            this.pushEventTo(el, "cancel-skill-input", {});
          }
        }, 150);
      });
    }

    document.addEventListener("click", (event) => {
      if (
        !el.contains(event.target as Node) &&
        this.el.querySelector("#skill-input-container")?.classList.contains("hidden") === false
      ) {
        this.pushEventTo(el, "cancel-skill-input", {});
      }
    });
  },
};

export default SkillSelector;
