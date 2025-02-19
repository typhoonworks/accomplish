<script>
  import { onMount, onDestroy } from "svelte";
  import { Editor } from "@tiptap/core";
  import Document from "@tiptap/extension-document";
  import Paragraph from "@tiptap/extension-paragraph";
  import Text from "@tiptap/extension-text";
  import Code from "@tiptap/extension-code";
  import Placeholder from "@tiptap/extension-placeholder";
  import { NoNewLine } from "./editor/extensions/no_new_line";

  export let content;
  export let placeholder = null;
  export let classList = "text-zinc-200";

  let editor;
  let element;

  onMount(() => {
    editor = new Editor({
      element: element,
      extensions: [
        Document,
        Paragraph,
        Text,
        NoNewLine,
        Code.configure({
          HTMLAttributes: {
            class: "inline",
          },
        }),
        Placeholder.configure({
          placeholder,
        }),
      ],
      content,
      editorProps: {
        attributes: {
          class: `focus:outline-none ${classList}`,
        },
      },
    });
  });

  onDestroy(() => {
    if (editor) editor.destroy();
  });
</script>

<!-- Simple, clean, and respects styling -->
<div bind:this={element} class="cursor-text"></div>
