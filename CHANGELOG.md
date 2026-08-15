# Changelog

## 0.2.3, 2026-08-15

- Install the resolver as the user-level `texchanges-merge` command in TeX
  Live while retaining a self-contained Python source script.
- Add `--version`, readable help in narrow terminals, complete argument
  descriptions, and a manual page.
- Rename example documents with package-specific filenames and update all
  Overleaf, test, documentation, and release references.

## 0.2.2, 2026-08-14

- Use Phuc Nguyen consistently in public package metadata and documentation.
- Replace personal reviewer names in examples and fixtures with the maintainer's
  `phuc` author ID.

## 0.2.1, 2026-08-13

- Hide change lists and summaries outside review mode.
- Stop writing report labels and auxiliary data in final and original modes.
- Add a CTAN manual, release validation, and public documentation site.

## 0.2.0, 2026-08-13

- Add registered authors, author colors, author display controls, and anonymous
  author naming.
- Add unique change IDs, attached comments, and pending, accepted, or rejected
  statuses with review, final, and original semantics.
- Add visual presets, individual markup styles, runtime rendering hooks, and
  dependent-package option pass-through.
- Add detailed, summary, and compact reports with type, status, and author
  filtering plus localization in six languages.
- Add opt-in `changes` 4.2.1 compatibility commands and prefix strategies.
- Add a standard-library source finalization CLI with filtering, dry runs,
  backups, interactive decisions, and nested-brace parsing.
- Expand tests across three TeX engines and add API, parity, and migration docs.

## 0.1.0, 2026-08-13

- Add explicit additions, removals, replacements, comments, and highlights.
- Add review, final, and original document modes.
- Add optional reviewer labels and collision-safe short aliases.
- Add Overleaf-ready explicit and automatic `latexdiff` examples.
- Add PDF-based mode tests and distribution tooling.
