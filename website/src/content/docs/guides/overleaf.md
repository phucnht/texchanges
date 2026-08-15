---
title: Overleaf
description: Use explicit review markup and automatic diffs on Overleaf.
---

Download `texchanges-overleaf.zip` from a release and upload it as an Overleaf project. The archive includes `texchanges.sty` for TeX Live versions that do not yet contain Texchanges.

Overleaf compiles projects with TeX Live. New CTAN packages become available through a later TeX Live and Overleaf update, so CTAN acceptance does not make the package immediately available on every Overleaf project.

Select `texchanges-explicit-review.tex` as the Main document for explicit review. Select `texchanges-review.tex` for automatic comparison. Its conditional `latexmkrc` runs `latexdiff` against the two revisions only for the automatic Main document, while the explicit document compiles normally.

The automatic example uses word-level matching, so short shared phrases remain unchanged. It demonstrates a removed word, phrase replacement, sentence-end insertion, formatted text, and a revised list. Use explicit Texchanges commands when reviewers or editing tools need stable authors, IDs, comments, and decision statuses. Use explicit markup or manual review for changed display math, complex floats, and custom verbatim-like environments.
