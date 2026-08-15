---
title: Installation
description: Install Texchanges locally or use it on Overleaf.
---

## TeX distributions

Texchanges is distributed through TeX Live. Install it with the distribution's package manager when needed, then load it normally:

```latex
\usepackage[review]{texchanges}
```

CTAN publication and the TeX Live version selected for a project are separate concerns. Upload `texchanges.sty` when the active TeX Live version does not contain the package.

## Overleaf fallback

Download `texchanges-overleaf.zip` from the latest GitHub release and upload it as a project. The bundle includes `texchanges.sty` as a fallback, `texchanges-explicit-review.tex`, two automatic-diff revisions, `texchanges-review.tex`, and `latexmkrc`. Keep the package line unchanged.

## Manual installation

Place `texchanges.sty` in the document directory or in a local `texmf` tree, then refresh the filename database if your distribution requires it.
