import TipTapListItem from "@tiptap/extension-list-item";

export const ListItem = TipTapListItem.extend({
  addKeyboardShortcuts() {
    return {
      "Shift-Enter": () => {
        this.editor.commands.splitListItem(this.name);
      },
      Tab: () => this.editor.commands.sinkListItem(this.name),
      "Shift-Tab": () => this.editor.commands.liftListItem(this.name),
    };
  },
});
