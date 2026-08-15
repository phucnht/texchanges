# texchanges

`texchanges` is a LaTeX-native track-changes protocol for Overleaf, human reviewers, and AI agents. It keeps changes in plain text, renders Word-like review markup, and resolves the same source into accepted or original output.

## Installation

Texchanges is distributed through TeX Live. Install it with the distribution's package manager when needed, then load it normally:

```latex
\usepackage[review]{texchanges}
```

For Overleaf projects whose TeX Live version does not include Texchanges, upload `texchanges.sty` beside the main document. The unified `texchanges-overleaf.zip` bundle includes the package, an explicit review document, automatic comparison files, and `latexmkrc`. Overleaf updates TeX Live on its own release schedule, so a new CTAN package may take time to appear there.

## Overleaf fallback

If the TeX Live version selected for the project does not contain Texchanges,
upload `texchanges.sty` beside your main `.tex` file:

```latex
\usepackage[review]{texchanges}

\txreplace{old text}{new text}
\txadd{new text}
\txremove{old text}
```

Switch `review` to `final` to accept pending changes or to `original` to show the unchanged document.

## Structured review

```latex
\txdefineauthor[name={Phuc Nguyen},color=orange]{phuc}

\txreplace[
  author=phuc,
  id=R12,
  comment={Clarify this claim.},
  status=pending
]{human-like behavior}{O\&M-aligned behavior}
```

Change keys are:

- `author`, a registered author ID.
- `id`, an optional document-unique change ID.
- `comment`, an attached reviewer note.
- `status`, one of `pending`, `accepted`, or `rejected`.

The legacy form `\txreplace[Reviewer]{old}{new}` remains supported as a visual label. Short aliases `\add`, `\remove`, `\replace`, `\highlight`, and `\comment` are installed only when another package has not defined them.

## Modes and decisions

| Mode | Pending | Accepted | Rejected |
|---|---|---|---|
| `review` | visual old and new | proposed text | original text |
| `final` | proposed text with warning | proposed text | original text |
| `original` | original text | original text | original text |

## Reports

```latex
\txlistofchanges
\txlistofchanges[style=summary]
\txlistofchanges[
  style=list,
  title={Open reviewer changes},
  show={added,replaced,commented},
  status={pending},
  author={phuc}
]
```

Detailed reports need two LaTeX runs. With `hyperref`, entries link to changes that have an ID. Summary and compact-summary reports group counts by author and change type. Reports are displayed and recorded only in `review` mode.

## Visual customization

Presets are `texchanges`, `default`, `underlined`, `bfit`, and `nocolor`.

```latex
\usepackage[
  review,
  markup=texchanges,
  addedmarkup=uline,
  deletedmarkup=sout,
  highlightmarkup=background,
  commentmarkup=inline,
  authormarkup=superscript,
  authormarkupposition=right,
  authormarkuptext=id
]{texchanges}
```

- Added/deleted styles: `colored`, `sout`, `xout`, `uline`, `uuline`, `uwave`, `dashuline`, `dotuline`, `bf`, `it`, `sl`, and `em` where relevant.
- Highlight styles: `background`, `uuline`, and `uwave`.
- Comment styles: `inline`, `todo`, `margin`, `footnote`, and `uwave`.
- Author styles: `superscript`, `subscript`, `brackets`, `footnote`, and `none`.

Runtime hooks such as `\txsetaddedmarkup`, `\txsetcommentmarkup`, `\txsetauthormarkup`, and the width/auxiliary-file setters are documented in the [online API reference](https://phucnht.github.io/texchanges/reference/api/).

## `changes` compatibility

Compatibility is opt-in because replacement arguments use the opposite order:

```latex
\usepackage[review,compat=changes]{texchanges}

\definechangesauthor[name={Phuc Nguyen},color=orange]{phuc}
\replaced[id=phuc,changeid=R12]{new text}{old text}
```

Use `commandnameprefix=none|ifneeded|always` for compatibility commands. Native `\txreplace` always remains `old` then `new`.

## Resolve source markup

The `texchanges-merge` CLI can update statuses or permanently merge markup
from any working directory after it is installed by TeX Live:

```bash
texchanges-merge paper.tex reviewed.tex --accept
texchanges-merge paper.tex final.tex --accept --merge
texchanges-merge paper.tex --reject --id R12 --in-place
texchanges-merge paper.tex --accept --author phuc --dry-run
```

From a source checkout, use `python3 scripts/texchanges-merge.py` in place of `texchanges-merge`. The tool requires Python 3.10 or later and uses only the standard library.

In-place updates create a `.bak` file. Interactive mode, nested braces, Unicode, comments, and common verbatim-like environments are supported. Malformed input fails before any file is written.

## Automatic `latexdiff`

`examples/automatic-diff/` compares `texchanges-original.tex` and `texchanges-revised.tex` through Overleaf's `latexmkrc` mechanism, with `texchanges-review.tex` as the Main document. It uses word-level matching, so short shared phrases remain unchanged. The same `latexmkrc` compiles `texchanges-explicit-review.tex` normally when that document is selected as Main.

## Examples

The repository includes two complete, visual walkthroughs:

| Workflow | Use it when | Start here |
|---|---|---|
| Explicit review | You need author IDs, decisions, comments, review reports, and one source that compiles in three modes. | [Explicit review example](examples/explicit-review/README.md) |
| Automatic `latexdiff` | You need a visual comparison between two complete document revisions. | [Automatic diff example](examples/automatic-diff/README.md) |

Run `make dist` to build the single `dist/texchanges-overleaf.zip` upload bundle. Its [workflow guide](examples/overleaf-workflow/README.md) explains both Main-document choices.

### Explicit review at a glance

![Explicit review mode with marked changes and a review report.](website/public/examples/explicit-review-review.png)

### Automatic diff at a glance

![Automatic latexdiff output with the original and revised wording marked visually.](website/public/examples/automatic-diff-review.png)

## Roadmap to 1.0.0

| Version | Focus | Planned outcome |
|---|---|---|
| 0.3.0 | Structured review data | Manifests, policies, external decisions, protected files, source locations, and Git conversion. |
| 0.4.0 | Collaboration and automation | Review threads, contributor metadata, TexLua resolution, and GitHub annotations. |
| 0.5.0 | Accessible and robust authoring | Accessible presets, tagged-PDF support where available, stronger document contexts, and math commands. |
| 0.6.0 | Editor workflow | Language-server diagnostics and a thin VS Code client. |
| 0.7.0 | Optional Overleaf assistance | A capability-detected browser extension with no telemetry. |
| 0.8.0 | Interoperability hardening | Stable schemas, migration tooling, resolver parity, and real-project fixtures. |
| 0.9.0 | Release candidate | API freeze, cross-engine verification, documentation audit, and pilot feedback. |
| 1.0.0 | Stable review protocol | Compatibility guarantees for markup, decisions, CLI resolution, reports, and supported integrations. |

See the [detailed roadmap](https://phucnht.github.io/texchanges/roadmap/) for capabilities, migration notes, and milestone status. Roadmap entries are planned work. Completed work appears in the changelog.

## Development

```bash
make check
make example
make doc
make dist
make ctan
make website
make release-check
```

The suite covers all modes, metadata, reports, styles, compatibility syntax, the CLI, pdfLaTeX, XeLaTeX, LuaLaTeX, and automatic `latexdiff`.

## Limitations

- Complex display math, floats, headings, verbatim content, and some commands should be changed at a larger text boundary or reviewed with `latexdiff`.
- The merge CLI intentionally skips comments and common verbatim-like environments. Custom verbatim environments require manual review.

Maintained by Phuc Nguyen. Report issues at <https://github.com/phucnht/texchanges/issues>.

Released under LPPL 1.3c or later. See `LICENSE`.
