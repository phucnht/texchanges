# Changelog

All notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versions before 0.2.2 predate the public repository history, so their links point at the first public tag.

## [Unreleased]

## [0.3.0] - 2026-08-18

### Added

- Editor support files in `editors/`, shipped in the CTAN archive: VS Code snippets that wrap the selected text, and a TeXstudio completion list covering every command, package option, and change key.
- Log-level regression tests in `testfiles/`, run by `l3build check` against pdfTeX, XeTeX, and LuaTeX, covering the public command surface, the `changes` compatibility aliases, and the localization defaults.
- Contributor documentation: `CONTRIBUTING.md`, issue and pull request templates, and `CITATION.cff`.
- A printable cheatsheet, an editor shortcuts guide, and an accessible reviewing guide covering screen reader, terminal, and low-vision workflows alongside the current limitations.
- Vietnamese and French translations of the documentation home page and the Start here section.

### Fixed

- Babel translations now activate for the document's main language. They previously applied only after an explicit mid-document `\selectlanguage`.
- Multi-word translated captions keep their spaces. They were previously collapsed (for example "ListederAenderungen") because spaces are ignored under expl3 catcodes.
- The compact summary title and the pending, accepted, and rejected status names are localized; reports with `style=compactsummary` now use `\txcompactsummaryname`.
- `texchanges-merge` keeps legacy `\txreplace[Label]` changes unchanged during status updates instead of silently discarding the label, and explains why on stderr.
- `texchanges-merge` recognizes `\end {verbatim}` with interior whitespace when skipping verbatim environments.
- `authormarkuptext=name` works on TeX Live 2023, whose expl3 does not predefine the `\prop_item:NV` variant.
- The documentation homepage no longer runs a replaced word into the following word in final mode.

### Changed

- `scripts/ctan-release.sh` and the test suite read the package version from `texchanges.sty` instead of hardcoding their own copies.
- Publishing a GitHub release now builds and attaches the CTAN archive, the Overleaf bundle, the manual, and checksums automatically.
- The verification suite runs as named cases; `make check TEST=<name>` runs a subset and failures are summarized instead of aborting the run.
- Continuous integration verifies the package against TeX Live 2023, 2024, 2025, and the latest release.
- The documentation moved to <https://texchanges.dev>. The manual, the citation file, and the repository links point there; the previous address redirects.

## [0.2.4] - 2026-08-15

### Changed

- Replace the separate Overleaf archives with one bundle containing Texchanges, explicit review, automatic `latexdiff`, and a conditional `latexmkrc`.
- Expand the automatic comparison example with granular word, phrase, formatting, and list changes.
- Configure the automatic example for word-level matching so short shared phrases remain unchanged in the generated diff.

## [0.2.3] - 2026-08-15

### Added

- Install the resolver as the user-level `texchanges-merge` command in TeX Live while retaining a self-contained Python source script.
- Add `--version`, readable help in narrow terminals, complete argument descriptions, and a manual page.

### Changed

- Rename example documents with package-specific filenames and update all Overleaf, test, documentation, and release references.

## [0.2.2] - 2026-08-14

### Changed

- Use Phuc Nguyen consistently in public package metadata and documentation.
- Replace personal reviewer names in examples and fixtures with the maintainer's `phuc` author ID.

## [0.2.1] - 2026-08-13

### Added

- Add a CTAN manual, release validation, and public documentation site.

### Fixed

- Hide change lists and summaries outside review mode.
- Stop writing report labels and auxiliary data in final and original modes.

## [0.2.0] - 2026-08-13

### Added

- Add registered authors, author colors, author display controls, and anonymous author naming.
- Add unique change IDs, attached comments, and pending, accepted, or rejected statuses with review, final, and original semantics.
- Add visual presets, individual markup styles, runtime rendering hooks, and dependent-package option pass-through.
- Add detailed, summary, and compact reports with type, status, and author filtering plus localization in six languages.
- Add opt-in `changes` 4.2.1 compatibility commands and prefix strategies.
- Add a standard-library source finalization CLI with filtering, dry runs, backups, interactive decisions, and nested-brace parsing.
- Expand tests across three TeX engines and add API, parity, and migration docs.

## [0.1.0] - 2026-08-13

### Added

- Add explicit additions, removals, replacements, comments, and highlights.
- Add review, final, and original document modes.
- Add optional reviewer labels and collision-safe short aliases.
- Add Overleaf-ready explicit and automatic `latexdiff` examples.
- Add PDF-based mode tests and distribution tooling.

[Unreleased]: https://github.com/phucnht/texchanges/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/phucnht/texchanges/compare/v0.2.4...v0.3.0
[0.2.4]: https://github.com/phucnht/texchanges/compare/v0.2.3...v0.2.4
[0.2.3]: https://github.com/phucnht/texchanges/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/phucnht/texchanges/releases/tag/v0.2.2
[0.2.1]: https://github.com/phucnht/texchanges/releases/tag/v0.2.2
[0.2.0]: https://github.com/phucnht/texchanges/releases/tag/v0.2.2
[0.1.0]: https://github.com/phucnht/texchanges/releases/tag/v0.2.2
