# Tests

## Layout

- `*.tex`: LaTeX fixtures. Each is a small document compiled by `scripts/test.sh`; the resulting PDF text (via `pdftotext`) is checked for sentinel tokens such as `OLDTOKEN` or `NEWACCEPTED`.
- `duplicate-id.tex`, `undefined-author.tex`: negative fixtures, the suite asserts these **fail** to compile.
- `test_merge.py`: stdlib `unittest` tests for the `texchanges-merge` CLI.
- `../testfiles/*.lvt`: l3build log-level tests with `.tlg` baselines, comparing the typeset log across pdfTeX, XeTeX, and LuaTeX. See [docs/dev/testing.md](../docs/dev/testing.md).

## Running

Run everything (also what CI runs):

```bash
make check
```

Run only cases whose name contains a substring:

```bash
make check TEST=localization
```

Case names are listed at the bottom of `scripts/test.sh` (`modes`, `features`, `list`, `localization`, `style_matrix`, `python_unit`, `versions`, ...). Failures are collected and summarized at the end instead of aborting the run.

Run just the Python unit tests:

```bash
python3 -m unittest -v tests.test_merge
```

Keep compile output for inspection:

```bash
TEXCHANGES_TEST_DIR=/tmp/tx-out make check
```

## Prerequisites

`pdflatex`, `xelatex`, `lualatex`, `latexdiff`, `pdftotext`, `perl`, and `python3` (3.10+). A full TeX Live installation provides everything except `python3`.

## Adding a fixture

1. Create `tests/<name>.tex`. Keep it minimal and put unique sentinel tokens (for example `MYFEATURETOKEN`) in the text whose presence or absence proves the behavior.
2. Add a `case_<name>()` function in `scripts/test.sh` that calls `compile_named <name> [runs]` and asserts with `assert_contains` / `assert_not_contains`. Reports need two compile runs; hyperlinked lists need three.
3. Register it with `run_case <name>` at the bottom of the script.
4. If the behavior differs by mode, assert it in `review`, `final`, and `original` (see `tests/review.tex`, `final.tex`, `original.tex` for the pattern).
5. For behavior that must *fail*, follow the `case_error_fixtures` pattern.

CLI changes get a test method in `test_merge.py` instead; the CLI must stay standard-library-only (there is a test enforcing this).

Adding or removing a **public command** or a **localization string** also changes the l3build baselines. Update them with `make save-baselines` and review the diff before committing.
