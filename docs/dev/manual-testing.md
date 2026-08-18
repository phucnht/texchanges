# Manual testing

Run this before tagging a release. The automated suite compares text extracted from PDFs, so it cannot see colour, position, or font, and it cannot reach Overleaf at all. Everything below covers what the suite cannot.

## 1. Automated pass first

```bash
make release-check
```

Expect 21 green cases and `Texchanges release artifacts verified.` on the last line. This covers three engines, the `l3build` log comparison, version agreement across the five copies, the CLI, the automatic `latexdiff` path, and both archives.

To dig into one area:

```bash
make check TEST=localization
```

## 2. Compiled output, by eye

```bash
make example
open build/explicit-review/texchanges-explicit-review.pdf
```

| Element | Expected |
|---|---|
| `\txreplace{World}{research community}` | "World" struck through in red, "research community" underlined in blue, a small gap between them |
| `\txadd` | Underlined in the author's colour, orange here |
| `\txremove` | Struck through in the author's colour |
| `\txhighlight` | Yellow background |
| `\txcomment` | Bracketed note in the comment colour |
| Author label | Small superscript reading `reviewer` |
| End of document | A summary table counting changes per author and type |

`\txreplace` deliberately uses the fixed removed and added colours rather than the author colour, so that old and new stay distinguishable inside one change. If a replacement renders in the author colour, that is a regression.

### The three modes

Edit `\providecommand{\texchangesexamplemode}{...}` in `examples/explicit-review/texchanges-explicit-review.tex` and recompile for each value.

| Mode | Must appear | Must not appear |
|---|---|---|
| `review` | Markup, comments, summary table | |
| `final` | "research community", the added text | "World", the removed text, comments, the summary |
| `original` | "World", the removed text | "research community", the added text |

In `final`, the `.log` must carry `Pending changes were accepted`. Restore `review` afterwards.

## 3. The merge CLI

```bash
cd examples/explicit-review
python3 ../../scripts/texchanges-merge.py texchanges-explicit-review.tex --accept --dry-run
```

Every command gains `status={accepted}` and no argument is lost. Then check the filters, which must touch only what they name:

```bash
python3 ../../scripts/texchanges-merge.py texchanges-explicit-review.tex --reject --id R2 --dry-run
python3 ../../scripts/texchanges-merge.py texchanges-explicit-review.tex --accept --author reviewer --dry-run
```

The author filter skips `\txadd` (no author) and the short alias `\replace`.

Removing the markup must leave a document that still compiles:

```bash
python3 ../../scripts/texchanges-merge.py texchanges-explicit-review.tex /tmp/final.tex --accept --merge
grep -c 'txreplace\|txadd\|txremove' /tmp/final.tex   # 0
pdflatex -output-directory=/tmp /tmp/final.tex
```

A legacy label must survive a status update. This regressed once and the tool used to discard it silently:

```bash
printf '\\documentclass{article}\\usepackage{texchanges}\\begin{document}\n\\txreplace[Reviewer]{a}{b}\n\\end{document}\n' > /tmp/legacy.tex
python3 scripts/texchanges-merge.py /tmp/legacy.tex --accept --dry-run
```

`Reviewer` stays in the output and a note explaining why appears on stderr.

## 4. Overleaf

This is where most users are, and nothing automated reaches it. Upload `dist/texchanges-overleaf.zip` as a new project; the bundle holds seven files.

1. Set `texchanges-explicit-review.tex` as the Main document and compile. The result matches section 2.
2. Switch the Main document to `texchanges-review.tex` and compile. `latexmkrc` runs `latexdiff` at word level, so the output shows removed words struck through and added words underlined.
3. Change the TeX Live year under **Menu, Settings** to the oldest supported release and compile again. Version-specific expl3 differences have broken the package here before.

## 5. Website

```bash
npm --prefix website run dev -- --host 127.0.0.1
```

| Check | Expected |
|---|---|
| Mode demo | The three buttons swap the sentence, and words keep their spaces in every mode |
| Language picker | Styled to the site palette rather than the operating system, with a visible check mark |
| `/vi/` and `/fr/` | Translated content and navigation |
| An untranslated path such as `/vi/reference/api/` | English content with the fallback notice |
| Dark mode | Readable throughout |
| A 375px wide window | No horizontal scroll, navigation collapses, grids fall to one column |

After deploying, confirm the production paths resolve, which catches a wrong `base`:

```bash
curl -s https://texchanges.dev/ | grep -o 'href="[^"]*\.css"'
```

Each path must start at the root and return 200.
