# Texchanges Overleaf workflow

This bundle supports explicit Texchanges review markup and automatic `latexdiff` in one Overleaf project. It includes `texchanges.sty` as a fallback for projects whose selected TeX Live version does not yet contain Texchanges.

## Explicit review

1. Select `texchanges-explicit-review.tex` as the Overleaf Main document.
2. Compile with pdfLaTeX.
3. Change `\texchangesexamplemode` from `review` to `final` or `original` to inspect the three output modes.

## Automatic comparison

1. Select `texchanges-review.tex` as the Overleaf Main document.
2. Compile with pdfLaTeX.
3. The top-level `latexmkrc` creates `review-generated.tex` from `texchanges-original.tex` and `texchanges-revised.tex`, then compiles the visual diff.

The automatic example uses word-level matching. Short shared phrases remain unchanged, while nearby additions and removals are marked separately.

Keep `latexmkrc` and the two revision files at the top level. Edit both filenames in `latexmkrc` when adapting the workflow to a real project. Avoid shell metacharacters in those names.

The generated review file is temporary. Do not add it to version control.
