---
title: Visual styles
description: Select presets and customize individual renderers.
---

Presets are `texchanges`, `default`, `underlined`, `bfit`, and `nocolor`.

```latex
\usepackage[
  review,
  markup=texchanges,
  addedmarkup=uline,
  deletedmarkup=sout,
  highlightmarkup=background,
  commentmarkup=inline,
  authormarkup=superscript
]{texchanges}
```

Added and deleted text supports color, strikeout, crossout, underline variants, bold, italic, slanted, and emphasized styles. Highlights support background, double underline, and wavy underline. Comments support inline, todo, margin, footnote, and wavy forms.
