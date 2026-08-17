---
title: Editor shortcuts
description: Snippets and completion files that make Texchanges markup faster to type.
---

Marking up a review means typing the same handful of commands hundreds of times. These shortcuts remove most of that typing. None of them are required; the package works with a plain text editor.

The files live in [`editors/`](https://github.com/phucnht/texchanges/tree/main/editors) in the repository.

## Overleaf

Nothing to install. Overleaf autocompletes commands from every package the document loads, so once `\usepackage{texchanges}` is in the preamble, typing `\txr` offers `\txreplace`.

Overleaf has no plugin API, so there is no way to add Texchanges entries to its context menu or toolbar. A browser extension could inject them, and one is [on the roadmap](/texchanges/roadmap/), but it would have to detect and degrade gracefully whenever Overleaf changes its interface, which is why it is a separate piece of work rather than a quick addition.

## VS Code

Copy `editors/vscode/texchanges.code-snippets` into your project's `.vscode/` directory, or install it for every project through **Command Palette → Configure Snippets → New Global Snippets file**.

| Prefix | Inserts |
|---|---|
| `txreplace` | `\txreplace{old}{new}` |
| `txreplacemeta` | `\txreplace` with author, ID, comment, and status |
| `txadd`, `txremove`, `txhighlight`, `txcomment` | the matching command |
| `txmeta` | just the `[author=…,id=…,comment=…,status=…]` block |
| `txauthor` | `\txdefineauthor` |
| `txlist`, `txlistfilter` | `\txlistofchanges`, plain or filtered |
| `txusepackage` | the package load line with a mode picker |

### Wrapping the selected text

Reviewing usually means "select this wording, mark it as replaced". Typing a prefix cannot do that, because the prefix replaces what you selected. Bind **Insert Snippet** instead. Open **Command Palette → Open Keyboard Shortcuts (JSON)** and add:

```json
{
  "key": "ctrl+alt+r",
  "command": "editor.action.insertSnippet",
  "when": "editorHasSelection && editorLangId == latex",
  "args": { "name": "Texchanges: replace old with new" }
}
```

Now select the old wording, press the key, and type the replacement. The snippets use `TM_SELECTED_TEXT`, so the selection becomes the first argument. Change `name` to bind any other snippet.

## TeXstudio and TeXmaker

Add `editors/texstudio/texchanges.cwl` under **Options → Configure TeXstudio → Completion**, then tick `texchanges.cwl`.

This gives you command completion with argument placeholders, plus value lists: package options complete after `\usepackage[`, and `author`, `id`, `comment`, and `status` complete inside a change command's optional argument.

## Other editors

The `.cwl` file is a plain list of command signatures and is a good starting point for writing completion data elsewhere. Contributions are welcome; see [CONTRIBUTING.md](https://github.com/phucnht/texchanges/blob/main/CONTRIBUTING.md).

## See also

- [Cheatsheet](/texchanges/reference/cheatsheet/) — every command, key, and option on one page.
- [Accessible reviewing](/texchanges/guides/accessible-reviewing/) — keyboard and screen reader workflows.
