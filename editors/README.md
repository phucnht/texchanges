# Editor support

Shortcuts and completion data for writing Texchanges markup. Nothing here is required to use the package; they only reduce typing.

See the [cheatsheet](https://texchanges.dev/reference/cheatsheet/) for the commands themselves, and the [editor shortcuts guide](https://texchanges.dev/guides/editor-shortcuts/) for a walkthrough.

## Overleaf

No installation needed. Overleaf autocompletes commands from any package the document loads, so typing `\txr` already suggests `\txreplace` once `\usepackage{texchanges}` is present.

## VS Code

Copy `vscode/texchanges.code-snippets` into your project's `.vscode/` directory, or install it globally with **Command Palette → Configure Snippets → New Global Snippets file** and paste the contents.

Prefixes: `txadd`, `txremove`, `txreplace`, `txreplacemeta`, `txhighlight`, `txcomment`, `txmeta`, `txauthor`, `txlist`, `txlistfilter`, `txusepackage`.

Snippets that wrap text use the current selection when there is one. Typing a prefix cannot wrap a selection, so bind **Insert Snippet** to a key if you review by selecting text. Add this to `keybindings.json` (**Command Palette → Open Keyboard Shortcuts (JSON)**):

```json
{
  "key": "ctrl+alt+r",
  "command": "editor.action.insertSnippet",
  "when": "editorHasSelection && editorLangId == latex",
  "args": { "name": "Texchanges: replace old with new" }
}
```

Select the old wording, press the key, and type the replacement. Swap `name` for any snippet above to bind others.

## TeXstudio and TeXmaker

Add `texstudio/texchanges.cwl` under **Options → Configure TeXstudio → Completion**, then tick `texchanges.cwl` in the list of completion files.

This gives command completion, argument placeholders, and value lists for package options and for the `author`, `id`, `comment`, and `status` keys.

## Other editors

The `.cwl` file is a plain list of command signatures, so it is a useful reference when writing completion data for another editor. Contributions adding support for one are welcome; see [CONTRIBUTING.md](../CONTRIBUTING.md).
