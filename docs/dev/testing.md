# Testing notes

`tests/README.md` covers day-to-day usage; this file records testing decisions.

## Why PDF-text assertions

The suite compiles fixtures and greps `pdftotext` output for sentinel tokens. This tests what a reader actually sees across modes and statuses, works identically on every engine, and needs no reference files. Its blind spots: it cannot see color, position, or font changes (the style matrix only asserts that each style *compiles*).

## l3build log-level tests

`l3build check` runs as the `l3build` case inside `make check`, and independently via `l3build check`. Sources live in `testfiles/`:

- `tx-api.lvt` asserts the full public command surface exists, that every localization string expands to its expected English default, and that `\texchangesmode` reflects the package mode.
- `tx-compat.lvt` asserts the `changes` compatibility surface exists and pins the opposite argument orders of `\txreplace` (old, new) and `\replaced` (new, old).

These complement the PDF-text assertions: they compare the **typeset log**, so they catch a renamed command, a dropped alias, or a changed caption string even when the rendered PDF still looks plausible. `checkengines` covers pdfTeX, XeTeX, and LuaTeX, so an engine-specific divergence shows up as a diff.

Baselines are the `.tlg` files beside each `.lvt`. After an intentional change, regenerate and review the diff before committing:

```bash
make save-baselines            # all tests
make save-baselines TEST=tx-api
```

Failures write `build/test/<name>.<engine>.diff`; read that file to see exactly which log line moved.

Tests are written against `regression-test.tex`'s macros (`\TEST`, `\TYPE`, `\ASSERT`, `\OMIT`/`\TIMO`). Two constraints learned the hard way:

- `\SHOWCS` does not exist in this harness; use `\ifcsname` with `\TYPE`, which also produces a far more stable baseline than dumping macro bodies.
- Do not trigger `\PackageError` inside an `.lvt`: the run blocks waiting for input. Error paths are covered instead by the negative fixtures `tests/duplicate-id.tex` and `tests/undefined-author.tex`, which assert that compilation fails.

The suite skips this case with a warning when `l3build` is not on `PATH`, so a checkout without a full TeX Live still runs everything else.
