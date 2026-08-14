# Automatic latexdiff on Overleaf

Upload all files in this directory to the top level of a new Overleaf project.
Set `review.tex` as the Main document and use pdfLaTeX. Each recompile runs
`latexdiff` over `original.tex` and `revised.tex`, then displays the generated
visual diff.

Edit the two filenames in `latexmkrc` to match a real project. Keep filenames
free of shell metacharacters because they are part of a compile command.

To compile either revision without diffing, temporarily comment out the
`$pdflatex` line in `latexmkrc`, then select that revision as the Main document.

This workflow follows Overleaf's documented method:

https://www.overleaf.com/learn/latex/Articles/How_to_use_latexdiff_on_Overleaf
