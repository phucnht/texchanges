# Testing notes

`tests/README.md` covers day-to-day usage; this file records testing decisions.

## Why PDF-text assertions

The suite compiles fixtures and greps `pdftotext` output for sentinel tokens. This tests what a reader actually sees across modes and statuses, works identically on every engine, and needs no reference files. Its blind spots: it cannot see color, position, or font changes (the style matrix only asserts that each style *compiles*).

## Open question: l3build

`build.lua` declares `checkengines` and `checkruns`, but `l3build check` is not wired into `make check` — the bash suite above is what runs. Only the `uploadconfig` block of `build.lua` is currently used (CTAN upload metadata), and the version consistency test reads its `version` field.

Two options, not yet decided:

1. Wire `l3build check` in and add `.tlg` reference files. This is the standard CTAN-world regression setup and catches typeset-log-level changes the PDF-text greps cannot; the cost is creating and maintaining baseline `.tlg` files per engine.
2. Strip `build.lua` to the `uploadconfig` block so the file stops advertising checks that never run.

Until decided, leave `build.lua` as is.
