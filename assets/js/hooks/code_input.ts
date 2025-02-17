import type { Hook } from "phoenix_live_view";

const CodeInput: Hook = {
  mounted() {
    const el = this.el as HTMLElement;
    const inputs = Array.from(el.querySelectorAll('input[type="text"]')) as HTMLInputElement[];
    const hiddenInput = el.querySelector("#hidden_user_code") as HTMLInputElement | null;
    const form = el.querySelector("#device_verification_form") as HTMLFormElement | null;

    if (!hiddenInput || !form) {
      throw new Error("Missing required elements: hidden input or form not found.");
    }

    inputs.forEach((input, index) => {
      const handleInput = (event: Event) => {
        const target = event.target as HTMLInputElement;
        target.value = target.value.toUpperCase(); // Always uppercase input

        if (target.value.length === 1 && index < inputs.length - 1) {
          inputs[index + 1].focus();
        }

        const userCode = inputs.map((input) => input.value).join("");
        hiddenInput.value = userCode;

        if (userCode.length === inputs.length) {
          form.submit(); // Trigger form submission when complete
        }
      };

      const handleKeyDown = (event: KeyboardEvent) => {
        if (event.key === "Backspace" && index > 0 && input.value === "") {
          inputs[index - 1].focus();
        }
      };

      input.addEventListener("input", handleInput);
      input.addEventListener("keydown", handleKeyDown);

      this.destroyed = () => {
        input.removeEventListener("input", handleInput);
        input.removeEventListener("keydown", handleKeyDown);
      };
    });
  },
};

export default CodeInput;
