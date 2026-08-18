---
title: Cheatsheet
description: One-page reference for Texchanges commands, keys, modes, and reports.
---

Everything on one page, meant to be printed or kept open beside the document you are reviewing.

## Load the package

```latex
\usepackage[review]{texchanges}
```

Replace `review` with `final` to accept pending changes, or `original` to read the unchanged document. One source, three outputs.

## Commands

| Command | Meaning |
|---|---|
| `\txreplace{old}{new}` | Replace text. **Old first, then new.** |
| `\txadd{text}` | Insert text. |
| `\txremove{text}` | Delete text. |
| `\txhighlight{text}` | Draw attention without changing anything. |
| `\txcomment{note}` | Attach a reviewer note. |

Short aliases `\add`, `\remove`, `\replace`, `\highlight`, and `\comment` exist only when no other package has claimed them.

## Change keys

Every command takes the same optional argument.

| Key | Value |
|---|---|
| `author` | A registered author ID. |
| `id` | A document-unique change ID. |
| `comment` | A note attached to this change. |
| `status` | `pending`, `accepted`, or `rejected`. |

```latex
\txreplace[author=phuc,id=R12,comment={Clarify this claim.},status=pending]{old}{new}
```

The legacy form `\txreplace[Reviewer]{old}{new}` still works as a plain visual label.

## What each mode shows

| Mode | Pending | Accepted | Rejected |
|---|---|---|---|
| `review` | old and new, marked up | new text | old text |
| `final` | new text, with a warning | new text | old text |
| `original` | old text | old text | old text |

## Authors

```latex
\txdefineauthor[name={Phuc Nguyen},color=orange]{phuc}
\txsetanonymousname{Reviewer}
```

Additions, removals, and highlights take the author's color. Replacements use the fixed removed and added colors so old and new stay distinguishable; the author label still carries the author color.

## Reports

```latex
\txlistofchanges
\txlistofchanges[style=summary]
\txlistofchanges[style=list,title={Open changes},show={added,replaced},status={pending},author={phuc}]
```

| Key | Values |
|---|---|
| `style` | `list`, `summary`, `compactsummary` |
| `title` | Any heading text |
| `show` | `added`, `removed`, `replaced`, `highlighted`, `commented` |
| `status` | `pending`, `accepted`, `rejected` |
| `author` | Registered author IDs |

Detailed reports need two LaTeX runs. Reports appear only in `review` mode. Titles, change types, and statuses are localized for English, German, French, Italian, and Vietnamese through babel.

## Appearance

```latex
\usepackage[review,markup=texchanges,addedmarkup=uline,deletedmarkup=sout]{texchanges}
```

| Option | Values |
|---|---|
| `markup` | `texchanges`, `default`, `underlined`, `bfit`, `nocolor` |
| `addedmarkup` | `colored`, `uline`, `uuline`, `uwave`, `dashuline`, `dotuline`, `bf`, `it`, `sl`, `em` |
| `deletedmarkup` | the same, plus `sout` and `xout` |
| `highlightmarkup` | `background`, `uuline`, `uwave` |
| `commentmarkup` | `inline`, `todo`, `margin`, `footnote`, `uwave` |
| `authormarkup` | `superscript`, `subscript`, `brackets`, `footnote`, `none` |
| `authormarkuptext` | `id`, `name` |

Use `markup=nocolor` when the output must not rely on color.

## Resolving markup

```bash
texchanges-merge paper.tex reviewed.tex --accept
texchanges-merge paper.tex final.tex --accept --merge
texchanges-merge paper.tex --reject --id R12 --in-place
texchanges-merge paper.tex --accept --author phuc --dry-run
```

`--merge` removes the markup permanently; without it, only `status` is updated. `--in-place` writes a `.bak` first. `--dry-run` prints a diff and writes nothing.

## Migrating from `changes`

```latex
\usepackage[review,compat=changes]{texchanges}
```

:::caution
`\replaced{new}{old}` takes its arguments in the opposite order from `\txreplace{old}{new}`. Native commands never change order.
:::

Use `commandnameprefix=none|ifneeded|always` to control how compatibility commands are named.

## Related

- [Editor shortcuts](/guides/editor-shortcuts/) for snippets and completion files.
- [Accessible reviewing](/guides/accessible-reviewing/) for screen reader and low-vision workflows.
- [API reference](/reference/api/) for runtime hooks and every setter.
