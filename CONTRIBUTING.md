# Contributing to Texchanges

Thank you for your interest in improving Texchanges. This guide explains what to work on, how to land a change, and what reviewers look for.

## What to contribute?

Good first contributions are small and self-contained:

- New test fixtures in `tests/` that cover behavior the suite misses.
- Localization: adding a babel language to the caption table in `texchanges.sty`, or correcting an existing translation.
- Documentation fixes in `README.md`, the manual `texchanges-doc.tex`, or the website under `website/src/content/docs/`.
- Gaps in the `changes` compatibility layer (`compat=changes`).

For anything larger (new commands, new package options, CLI behavior changes) please open an issue first and describe the design. The [roadmap](https://phucnht.github.io/texchanges/roadmap/) lists where the project is headed; work that fits it is much more likely to land.

## How to land a contribution

1. Fork the repository and branch from `develop`.
2. Make the change. Run the full suite locally with `make check`. The suite needs `pdflatex`, `xelatex`, `lualatex`, `latexdiff`, `pdftotext`, `perl`, and `python3` on your `PATH`; a full TeX Live installation provides everything except `python3`.
3. Add or update tests (see below). A behavior change without a test will be asked to add one.
4. Update `CHANGELOG.md` under the unreleased heading.
5. Open a pull request **against `develop`** with a short description of what changed and why. Keep each pull request to one fix or one feature.

CI runs the same `make check` plus a website build; both must pass.

`main` holds released code and is what the documentation site deploys from; it receives release merges from `develop` and documentation hotfixes only. See [docs/dev/releasing.md](docs/dev/releasing.md) for the branch layout and the release checklist.

## Signs of a good pull request

- It is self-contained: one fix or one feature, reviewable in one sitting.
- Every new behavior has a fixture in `tests/*.tex` asserted through `scripts/test.sh`, and it is exercised in all three modes (`review`, `final`, `original`) where the behavior differs by mode.
- CLI changes come with a unit test in `tests/test_merge.py` (stdlib `unittest`; the CLI must stay dependency-free and Python 3.10+).
- The changelog entry says what a user will notice, not what the code does.

## Compatibility rules

These are hard constraints; changes that break them will not be accepted:

- The documented public commands `\txadd`, `\txremove`, `\txreplace`, `\txcomment`, and `\txhighlight` stay backward compatible.
- `\txreplace{old}{new}` argument order is frozen. Only the `changes` compatibility layer uses the reversed order.
- Short aliases (`\add`, `\remove`, `\replace`, `\highlight`, `\comment`) must never overwrite a command another package has already defined.
- Do not commit compiled output: no PDFs, aux files, generated diffs, or zips.

## Code style

- `texchanges.sty` is written in expl3. Follow the conventions already in the file: `\g_tx_...`/`\l_tx_...` variable naming, `\cs_new_protected:Npn` for procedures, and `~` for spaces in text produced inside the `\ExplSyntaxOn` region.
- `scripts/texchanges-merge.py` uses only the standard library; `tests/test_merge.py` enforces this.
- Markdown prose is written one paragraph per physical line, without hard wrapping.

## AI policy

Do not submit contributions that were implemented by an AI model, and write your pull request description yourself. Reviewing a change relies on the human thought process behind it, and maintainer time is the project's scarcest resource. (This policy is about contributions to Texchanges itself; the package is, and remains, designed to make AI-assisted *review of documents* work well.)

## Review cycle

Expect a first response within a week. If review stalls, a friendly ping on the pull request is welcome. Small, well-tested changes merge fastest.
