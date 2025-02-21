import type { Hook } from "phoenix_live_view";
import { Howl } from "howler";

interface AudioMp3Extra {
  el: HTMLElement;
  sounds: { [key: string]: Howl };
  playSound(name: string): void;
  stopSound(name: string): void;
  setupSounds(obj: { [key: string]: string }): { [key: string]: Howl };
}

type AudioMp3Hook = Hook & AudioMp3Extra;

const AudioMp3 = {
  mounted() {
    const hook = this as AudioMp3Hook;
    const el = hook.el as HTMLElement;
    const soundsData = el.dataset.sounds;
    if (!soundsData) {
      console.error("No sounds data found on element");
      return;
    }

    hook.sounds = hook.setupSounds(JSON.parse(soundsData));

    const playSoundHandler = (e: Event) => {
      const customEvent = e as CustomEvent<{ name: string }>;
      hook.playSound(customEvent.detail.name);
    };

    const stopSoundHandler = (e: Event) => {
      const customEvent = e as CustomEvent<{ name: string }>;
      hook.stopSound(customEvent.detail.name);
    };

    window.addEventListener("phx:play-sound", playSoundHandler);
    window.addEventListener("js:play-sound", playSoundHandler);
    window.addEventListener("phx:stop-sound", stopSoundHandler);
    window.addEventListener("js:stop-sound", stopSoundHandler);
  },

  destroyed() {
    const hook = this as AudioMp3Hook;
    Object.entries(hook.sounds).forEach(([key, howl]) => {
      howl.unload();
    });
  },

  playSound(name: string) {
    const hook = this as AudioMp3Hook;
    if (hook.sounds[name]) {
      hook.sounds[name].play();
    } else {
      console.warn(`PLAY: No sound "${name}" found`);
    }
  },

  stopSound(name: string) {
    const hook = this as AudioMp3Hook;
    if (hook.sounds[name]) {
      hook.sounds[name].stop();
    } else {
      console.warn(`STOP: No sound "${name}" found`);
    }
  },

  setupSounds(obj: { [key: string]: string }): { [key: string]: Howl } {
    const sounds: { [key: string]: Howl } = {};
    Object.entries(obj).forEach(([key, value]) => {
      sounds[key] = new Howl({
        src: [value],
        preload: true,
        onplayerror: () => {
          console.error("FAILED to play " + key);
        },
      });
    });
    return sounds;
  },
} as unknown as AudioMp3Hook;

export default AudioMp3;
