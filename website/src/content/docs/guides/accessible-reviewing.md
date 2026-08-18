---
title: Accessible reviewing
description: How Texchanges works with screen readers and low vision, and where it currently falls short.
---

Reviewers are not all sighted, and review tooling often assumes they are. This page describes what works today, what does not, and which workflow to choose.

## Why the source is the accessible surface

Texchanges keeps every change in the document source as ordinary text:

```latex
\txreplace[author=phuc,id=R12,comment={Clarify this claim.},status=pending]{human-like behavior}{O\&M-aligned behavior}
```

A screen reader reads that line completely: who proposed the change, which change it is, why, whether it is still open, the old wording, and the new wording. Nothing is hidden behind a colored underline, a hover target, or a sidebar widget.

This is a real advantage over word processor track changes, where the same information lives in interface chrome that must be navigated separately from the text. Here, reviewing the source **is** reviewing the changes.

The practical consequence: if you use a screen reader, work in the `.tex` file with your usual editor, not in a rendered PDF.

## A terminal-only review workflow

`texchanges-merge` covers the whole decision cycle without a graphical interface. Every step prints plain text.

Read what is proposed, without changing anything:

```bash
texchanges-merge paper.tex --accept --dry-run
```

That prints a unified diff. Decide one change at a time by its ID:

```bash
texchanges-merge paper.tex --accept --id R12 --in-place
texchanges-merge paper.tex --reject --id R13 --in-place
```

Decide everything from one reviewer at once:

```bash
texchanges-merge paper.tex --accept --author phuc --in-place
```

Or step through interactively, answering `a`, `r`, or `s` per change:

```bash
texchanges-merge paper.tex --interactive --in-place
```

`--in-place` writes a `.bak` copy first, and malformed input fails before anything is written, so a mistake is recoverable.

The change report is also available as text: compile with `\txlistofchanges` and read the generated `.txc` file directly rather than the PDF.

## Low vision and color blindness

Do not rely on the default palette. Author identity is conveyed by color alone, which fails for color-blind readers.

```latex
\usepackage[review,markup=nocolor,authormarkuptext=name]{texchanges}
```

- `markup=nocolor` turns off color entirely and distinguishes changes by underline and strikethrough instead.
- `authormarkuptext=name` prints the author's full name rather than a short ID.
- `authormarkup=brackets` or `authormarkup=footnote` moves attribution into the text flow instead of a small superscript.
- `commentmarkup=footnote` moves notes out of the margin, where they are usually set in a smaller size.

For magnification, `\txsettruncatewidth` controls how much excerpt text a report line shows before it is cut, which matters when lines wrap heavily at large zoom.

## Current limitations

These are real, and we would rather state them than let you discover them mid-review.

- **The PDF is not tagged.** Texchanges does not yet emit PDF/UA structure, so assistive technology reading the rendered PDF gets no semantic marking for a change.
- **Deleted text is announced as ordinary text.** A screen reader reading the PDF sees struck-out words as normal words. Someone listening to a `review`-mode PDF may hear the old and new wording run together with no indication which is which. This is the single strongest reason to review the source rather than the PDF.
- **Author color is not announced.** In the default preset, author identity exists only as color in the PDF. Use `authormarkuptext=name` so the name is in the text.
- **`soul` and `ulem` markup is visual only.** The underline and strikethrough carry no semantics that a PDF reader can expose.

Tagged-PDF support, and accessible visual presets verified against real assistive technology, are tracked under "Robust and accessible authoring" on the [roadmap](/roadmap/) and are part of what 1.0.0 must deliver.

## Reporting problems

If a workflow here fails with your assistive technology, please [open an issue](https://github.com/phucnht/texchanges/issues) and say which tool and version you use. Accessibility reports are treated as bugs, not feature requests.
