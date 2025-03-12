<script>
  import { onMount, onDestroy } from "svelte";
  import { Editor } from "@tiptap/core";
  import { Markdown } from "tiptap-markdown";
  import PulseIndicator from "./PulseIndicator.svelte";

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
  import { StreamContent } from "./editor/extensions/stream_content";

  export let live;
  export let field;
  export let resourceId;
  export let blurEvent;

  export let content;
  export let placeholder = null;
  export let inputId;
  export let classList = "text-zinc-200";
  export let autosave = false;
  export let autosaveDelay = 1500;

  export let streaming = false;
  export let streamingComplete = false;

  let editor;
  let element;
  let hiddenInput;
  let autosaveTimer;
  let lastSavedContent;
  let activeStream = null;
  let pendingContent = "";
  let lastProcessedLength = 0;
  let showPulseIndicator = false;

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
    StreamContent,
  ];

  function handleParentClick() {
    if (editor && !streaming) {
      editor.commands.focus();
    }
  }

  function updateHiddenInput() {
    if (!editor || !hiddenInput) return;

    const markdownOutput = editor.storage.markdown.getMarkdown();
    hiddenInput.value = markdownOutput;
  }

  function pushUpdate() {
    if (streaming) return;

    if (!editor) return;

    const markdownOutput = editor.storage.markdown.getMarkdown();
    if (live && blurEvent) {
      live.pushEvent(blurEvent, { id: resourceId, field: field, value: markdownOutput });
    }
  }

  function handleContentChange() {
    editor = editor;
    updateHiddenInput();

    if (autosave && !streaming) {
      const newContent = editor.storage.markdown.getMarkdown();
      if (newContent !== lastSavedContent) {
        clearTimeout(autosaveTimer);
        autosaveTimer = setTimeout(() => {
          lastSavedContent = newContent;
          pushUpdate();
        }, autosaveDelay);
      }
    }
  }

  // Process content updates during streaming
  $: {
    if (streaming && content !== pendingContent) {
      pendingContent = content;
      if (editor && activeStream) {
        handleStreamUpdate(content);
      }
    }
  }

  // Start streaming when streaming becomes true
  $: {
    if (streaming && editor && !activeStream) {
      startStreaming();

      setTimeout(() => {
        showPulseIndicator = true;
      }, 200);
    }
  }

  // End streaming when streamingComplete becomes true
  $: {
    if (streamingComplete && activeStream) {
      finishStreaming();
      showPulseIndicator = false;
    }
  }

  function handleStreamUpdate(newContent) {
    if (!editor || !activeStream) return;

    // Only process new content
    if (newContent.length > lastProcessedLength) {
      const newChunk = newContent.slice(lastProcessedLength);
      lastProcessedLength = newContent.length;

      // Stream the new chunk
      activeStream(newChunk);
    }
  }

  function startStreaming() {
    if (!editor) return;

    lastProcessedLength = 0;
    const pos = editor.state.doc.content.size;

    editor.commands.streamContent(pos, ({ write }) => {
      return new Promise((resolve) => {
        activeStream = (chunk) => {
          write({
            partial: chunk,
            appendToChain: (chain) => chain.scrollIntoView(),
          });
        };

        const checkComplete = () => {
          if (!streaming) {
            resolve();
            activeStream = null;
          } else {
            setTimeout(checkComplete, 100);
          }
        };

        checkComplete();
      });
    });

    editor.setEditable(false);
  }

  function finishStreaming() {
    if (editor) {
      editor.setEditable(true);

      updateHiddenInput();

      activeStream = null;
      lastProcessedLength = 0;
    }
  }

  onMount(() => {
    lastSavedContent = content;
    pendingContent = content;

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
        Placeholder.configure({
          placeholder,
        }),
        Link.configure({
          openOnClick: true,
          autolink: true,
        }),
      ],
      content: content,
      editable: !streaming,
      editorProps: {
        attributes: {
          class: `focus:outline-none ${classList}`,
        },
      },
      onTransaction: handleContentChange,
      onBlur: pushUpdate,
    });

    hiddenInput = document.getElementById(inputId);
    updateHiddenInput();

    hiddenInput.parentElement.addEventListener("click", handleParentClick);

    // If we're already streaming when component mounts, start stream
    if (streaming && !activeStream) {
      startStreaming();
    }
  });

  onDestroy(() => {
    if (editor) {
      editor.destroy();
    }
    if (autosaveTimer) {
      clearTimeout(autosaveTimer);
    }
    if (hiddenInput && hiddenInput.parentElement) {
      hiddenInput.parentElement.removeEventListener("click", handleParentClick);
    }
  });
</script>

<div bind:this={element} class={streaming ? "streaming-editor" : "relative"}></div>

{#if showPulseIndicator}
  <PulseIndicator />
{/if}
