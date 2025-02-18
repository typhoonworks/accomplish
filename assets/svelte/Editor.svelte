<script>
  import { onMount, onDestroy } from "svelte";
  import { Editor } from "@tiptap/core";
  import { Markdown } from "tiptap-markdown";

  import Text from "@tiptap/extension-text";
  import Paragraph from "@tiptap/extension-paragraph";
  import Bold from "@tiptap/extension-bold";
  import Italic from "@tiptap/extension-italic";
  import Document from "@tiptap/extension-document";
  import History from "@tiptap/extension-history";
  import BulletList from "@tiptap/extension-bullet-list";
  import OrderedList from "@tiptap/extension-ordered-list";
  import { ListItem } from "./editor/extensions/list_item";
  import Placeholder from "@tiptap/extension-placeholder";
  import Link from "@tiptap/extension-link";
  import Dropcursor from "@tiptap/extension-dropcursor";
  import Gapcursor from "@tiptap/extension-gapcursor";
  import CodeBlock from "@tiptap/extension-code-block";
  import Blockquote from "@tiptap/extension-blockquote";
  import Code from "@tiptap/extension-code";
  import Strike from "@tiptap/extension-strike";

  export let content;
  export let placeholder = null;
  export let inputId;
  export let classList = "text-zinc-200";

  let element;
  let editor;
  let hiddenInput;

  const BASE_EXTENSIONS = [
    Text,
    Paragraph,
    Bold,
    Italic,
    Strike,
    Code,
    Document,
    CodeBlock,
    Blockquote,
    Dropcursor,
    Gapcursor,
    History,
    ListItem,
  ];

  function handleParentClick() {
    if (editor) {
      editor.commands.focus();
    }
  }

  function updateHiddenInput() {
    const markdownOutput = editor.storage.markdown.getMarkdown();
    console.log(markdownOutput);
    if (hiddenInput && editor) {
      hiddenInput.value = JSON.stringify(editor.getJSON());
    }
  }

  onMount(() => {
    editor = new Editor({
      element: element,
      extensions: [
        ...BASE_EXTENSIONS,
        Markdown,
        BulletList.configure({
          HTMLAttributes: {
            class: "list-disc",
          },
        }),
        OrderedList.configure({
          HTMLAttributes: {
            class: "list-decimal",
          },
        }),
        ListItem,
        Placeholder.configure({
          placeholder,
        }),
        Link.configure({
          openOnClick: false,
          autolink: true,
        }),
      ],
      content: content,
      editorProps: {
        attributes: {
          class: `focus:outline-none ${classList}`,
        },
      },
      onTransaction: () => {
        editor = editor;
        updateHiddenInput();
      },
    });

    hiddenInput = document.getElementById(inputId);
    updateHiddenInput();
    // hiddenInput.parentElement.addEventListener("click", handleParentClick);
  });

  onDestroy(() => {
    if (editor) {
      editor.destroy();
    }
  });
</script>

<div bind:this={element}></div>
