// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";

// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "topbar";
import sendTimezoneToServer from "./utils/timezone";

// Import LiveSvelte integration
import { getHooks } from "live_svelte";
import * as Components from "../svelte/**/*.svelte";

// Import custom hooks
import AccordionContent from "./hooks/accordion_content";
import AudioMp3 from "./hooks/audio_mp3";
import Clipboard from "./hooks/clipboard";
import CodeInput from "./hooks/code_input";
import ContextMenu from "./hooks/context_menu";
import DropdownMenu from "./hooks/dropdown_menu";
import Flash from "./hooks/flash";
import GoBack from "./hooks/go_back";
import SkillSelector from "./hooks/skill_selector";
import StackedList from "./hooks/stacked_list";
import UrlInputAutoFocus from "./hooks/url_input_autofocus";

sendTimezoneToServer();

const hooks = {
  AccordionContent,
  AudioMp3,
  Clipboard,
  CodeInput,
  ContextMenu,
  DropdownMenu,
  Flash,
  GoBack,
  SkillSelector,
  StackedList,
  UrlInputAutoFocus,
  ...getHooks(Components),
};

let csrfToken = document.querySelector("meta[name='csrf-token']")?.getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {
    _csrf_token: csrfToken,
    timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
  },
  hooks,
});

window.addEventListener("phx:js-exec", (event: any) => {
  const { detail } = event;
  document.querySelectorAll(detail.to).forEach((el) => {
    liveSocket.execJS(el, el.getAttribute(detail.attr));
  });
});

topbar.config({
  barColors: {
    0: "#4b0082",
    0.5: "#9400d3",
    1.0: "#00ffc8",
  },
  shadowColor: "rgba(0, 0, 0, 0.3)",
});

window.addEventListener("phx:page-loading-start", () => topbar.show(300));
window.addEventListener("phx:page-loading-stop", () => topbar.hide());

liveSocket.connect();

// Expose `liveSocket` for debugging
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
