// assets/svelte/editor/extensions/stream_content.js
import { Extension } from "@tiptap/core";

export const StreamContent = Extension.create({
  name: "streamContent",

  addCommands() {
    return {
      streamContent:
        (position, callback, _options = {}) =>
        ({ editor, dispatch }) => {
          if (!dispatch) return true;

          let insertRange =
            typeof position === "number" ? { from: position, to: position } : position;

          if (!insertRange) {
            const { from, to } = editor.state.selection;
            insertRange = { from, to };
          }

          let buffer = "";

          const write = (ctx) => {
            const { partial, appendToChain } = ctx;

            buffer += partial;

            try {
              editor.commands.setContent(buffer, false);

              if (appendToChain) {
                appendToChain(editor.chain()).run();
              }
            } catch (error) {
              console.error("Error streaming partial Markdown:", error);
            }

            return {
              buffer,
              from: 0,
              to: editor.state.doc.content.size,
            };
          };

          const getWritableStream = () => {
            return new WritableStream({
              write(chunk) {
                const decoder = new TextDecoder();
                const text = decoder.decode(chunk, { stream: true });
                write({ partial: text });
              },
            });
          };

          try {
            callback({ write, getWritableStream });
          } catch (error) {
            console.error("Error in streamContent callback:", error);
          }

          return true;
        },
    };
  },
});
