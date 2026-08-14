---
title: Overleaf
description: Use explicit review markup and automatic diffs on Overleaf.
---

For immediate use, upload `texchanges.sty` beside the project's main document and load it with `\usepackage[review]{texchanges}`.

Overleaf compiles projects with TeX Live. New CTAN packages become available through a later TeX Live and Overleaf update, so CTAN acceptance does not make the package immediately available on every Overleaf project.

The repository also includes an automatic comparison example. Its `latexmkrc` runs `latexdiff` against complete old and new revisions. Use explicit Texchanges commands when reviewers or editing tools need stable authors, IDs, comments, and decision statuses.
