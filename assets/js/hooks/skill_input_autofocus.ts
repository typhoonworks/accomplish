import type { Hook } from "phoenix_live_view";

const SkillInputAutofocus: Hook = {
  mounted() {
    const el = this.el as HTMLInputElement;

    setTimeout(() => {
      el.focus();
    }, 50);

    const handleClickOutside = (event: MouseEvent) => {
      if (el && !el.contains(event.target as Node)) {
        const suggestionsList = document.querySelector('[id$="-suggestions"]');
        if (!suggestionsList || !suggestionsList.contains(event.target as Node)) {
          this.pushEventTo(el, "skill-input-blur", { value: el.value });
        }
      }
    };

    document.addEventListener("click", handleClickOutside);

    this.destroyed = () => {
      document.removeEventListener("click", handleClickOutside);
    };
  },
};

export default SkillInputAutofocus;
