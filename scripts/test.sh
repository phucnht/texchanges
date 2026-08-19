#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# Set TEXCHANGES_TEST_DIR to keep compile output for inspection (CI uploads it
# when a run fails); the default is a temporary directory removed on exit.
if [ -n "${TEXCHANGES_TEST_DIR:-}" ]; then
  TASK_TMP_DIR="$TEXCHANGES_TEST_DIR"
  mkdir -p "$TASK_TMP_DIR"
else
  TASK_TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/texchanges-test.XXXXXX")"
  trap 'rm -rf "$TASK_TMP_DIR"' EXIT
fi

for tool in pdflatex xelatex lualatex latexdiff pdftotext perl python3; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'Missing required test tool: %s\n' "$tool" >&2
    exit 1
  fi
done

assert_contains() {
  local file="$1"
  local token="$2"
  if ! grep -Fq "$token" "$file"; then
    printf 'Expected %s in %s\n' "$token" "$file" >&2
    exit 1
  fi
}

assert_not_contains() {
  local file="$1"
  local token="$2"
  if grep -Fq "$token" "$file"; then
    printf 'Did not expect %s in %s\n' "$token" "$file" >&2
    exit 1
  fi
}

compile_named() {
  local name="$1"
  local runs="${2:-1}"
  local run
  for ((run = 1; run <= runs; run++)); do
    TEXINPUTS="$PROJECT_ROOT:" pdflatex \
      -halt-on-error \
      -interaction=nonstopmode \
      -output-directory="$TASK_TMP_DIR" \
      "$PROJECT_ROOT/tests/$name.tex" >/dev/null
  done
  pdftotext "$TASK_TMP_DIR/$name.pdf" "$TASK_TMP_DIR/$name.txt"
}

compile_style_case() {
  local name="$1"
  local options="$2"
  local command="$3"
  local source="$TASK_TMP_DIR/style-$name.tex"
  printf '%s\n' \
    '\documentclass{article}' \
    "\\usepackage[review,$options]{texchanges}" \
    '\begin{document}' \
    "$command" \
    '\end{document}' > "$source"
  TEXINPUTS="$PROJECT_ROOT:" pdflatex -halt-on-error -interaction=nonstopmode \
    -output-directory="$TASK_TMP_DIR" "$source" >/dev/null
}

# --------------------------------------------------------------------------
# Test cases. Each runs in its own subshell; a failure aborts only that case.
# --------------------------------------------------------------------------

case_modes() {
  local mode
  for mode in review final original; do
    compile_named "$mode"
  done

  assert_contains "$TASK_TMP_DIR/review.txt" OLDTOKEN
  assert_contains "$TASK_TMP_DIR/review.txt" NEWTOKEN
  assert_contains "$TASK_TMP_DIR/review.txt" ADDTOKEN
  assert_contains "$TASK_TMP_DIR/review.txt" REMOVETOKEN
  assert_contains "$TASK_TMP_DIR/review.txt" COMMENTTOKEN
  assert_contains "$TASK_TMP_DIR/review.txt" HIGHLIGHTTOKEN

  assert_contains "$TASK_TMP_DIR/final.txt" NEWTOKEN
  assert_contains "$TASK_TMP_DIR/final.txt" ADDTOKEN
  assert_contains "$TASK_TMP_DIR/final.txt" HIGHLIGHTTOKEN
  assert_not_contains "$TASK_TMP_DIR/final.txt" OLDTOKEN
  assert_not_contains "$TASK_TMP_DIR/final.txt" REMOVETOKEN
  assert_not_contains "$TASK_TMP_DIR/final.txt" COMMENTTOKEN

  assert_contains "$TASK_TMP_DIR/original.txt" OLDTOKEN
  assert_contains "$TASK_TMP_DIR/original.txt" REMOVETOKEN
  assert_contains "$TASK_TMP_DIR/original.txt" HIGHLIGHTTOKEN
  assert_not_contains "$TASK_TMP_DIR/original.txt" NEWTOKEN
  assert_not_contains "$TASK_TMP_DIR/original.txt" ADDTOKEN
  assert_not_contains "$TASK_TMP_DIR/original.txt" COMMENTTOKEN
}

case_features() {
  compile_named features 2
  assert_contains "$TASK_TMP_DIR/features.txt" OLDPENDING
  assert_contains "$TASK_TMP_DIR/features.txt" NEWPENDING
  assert_contains "$TASK_TMP_DIR/features.txt" NEWACCEPTED
  assert_not_contains "$TASK_TMP_DIR/features.txt" OLDACCEPTED
  assert_contains "$TASK_TMP_DIR/features.txt" OLDREJECTED
  assert_not_contains "$TASK_TMP_DIR/features.txt" NEWREJECTED
  assert_contains "$TASK_TMP_DIR/features.txt" SUMMARY
  assert_contains "$TASK_TMP_DIR/features.txt" "Phuc Nguyen"
  assert_contains "$TASK_TMP_DIR/features.txt" Alice
  assert_contains "$TASK_TMP_DIR/features.txs" "phuc/replaced/pending"
}

case_report_extensions() {
  compile_named report-extensions 2
  assert_contains "$TASK_TMP_DIR/report-extensions.txt" "CUSTOM LIST"
  assert_contains "$TASK_TMP_DIR/report-extensions.txt" "CUSTOM SUMMARY"
  assert_contains "$TASK_TMP_DIR/report-extensions.txt" "CUSTOMEXTENSION"
  assert_contains "$TASK_TMP_DIR/report-extensions.txcustomsummary" "anonymous/added/pending"
  test -f "$TASK_TMP_DIR/report-extensions.txcustomlist"
}

case_status_final() {
  printf '%s\n' 'STALE FINAL REPORT' > "$TASK_TMP_DIR/status-final.txc"
  printf '%s\n' '\txsummaryentry{anonymous/added/pending}{99}' > "$TASK_TMP_DIR/status-final.txs"
  compile_named status-final
  assert_contains "$TASK_TMP_DIR/status-final.txt" NEWPENDING
  assert_contains "$TASK_TMP_DIR/status-final.txt" NEWACCEPTED
  assert_contains "$TASK_TMP_DIR/status-final.txt" OLDREJECTED
  assert_contains "$TASK_TMP_DIR/status-final.txt" REJECTEDREMOVE
  assert_not_contains "$TASK_TMP_DIR/status-final.txt" REJECTEDADD
  assert_not_contains "$TASK_TMP_DIR/status-final.txt" "HIDDEN FINAL REPORT"
  assert_not_contains "$TASK_TMP_DIR/status-final.txt" "STALE FINAL REPORT"
  assert_contains "$TASK_TMP_DIR/status-final.log" "Pending changes were accepted"
}

case_status_original() {
  printf '%s\n' 'STALE ORIGINAL REPORT' > "$TASK_TMP_DIR/status-original.txc"
  printf '%s\n' '\txsummaryentry{anonymous/added/pending}{99}' > "$TASK_TMP_DIR/status-original.txs"
  compile_named status-original
  assert_contains "$TASK_TMP_DIR/status-original.txt" OLDACCEPTED
  assert_contains "$TASK_TMP_DIR/status-original.txt" OLDREJECTED
  assert_contains "$TASK_TMP_DIR/status-original.txt" ACCEPTEDREMOVE
  assert_not_contains "$TASK_TMP_DIR/status-original.txt" ACCEPTEDADD
  assert_not_contains "$TASK_TMP_DIR/status-original.txt" "HIDDEN ORIGINAL REPORT"
  assert_not_contains "$TASK_TMP_DIR/status-original.txt" "STALE ORIGINAL REPORT"
}

case_compat() {
  compile_named compat
  assert_contains "$TASK_TMP_DIR/compat.txt" COMPATNEW
  assert_contains "$TASK_TMP_DIR/compat.txt" COMPATOLD
  assert_contains "$TASK_TMP_DIR/compat.txt" COMPATCOMMENT

  compile_named compat-ifneeded
  assert_contains "$TASK_TMP_DIR/compat-ifneeded.txt" ORIGINALCOMMENT
  assert_contains "$TASK_TMP_DIR/compat-ifneeded.txt" CHANGECOMMENT
  assert_contains "$TASK_TMP_DIR/compat-ifneeded.txt" ADDED
}

case_options() {
  compile_named options
  assert_contains "$TASK_TMP_DIR/options.txt" OPTIONS
}

case_styles() {
  compile_named styles
  assert_contains "$TASK_TMP_DIR/styles.txt" STYLEADD
  assert_contains "$TASK_TMP_DIR/styles.txt" STYLEDELETE
  assert_contains "$TASK_TMP_DIR/styles.txt" STYLEHIGHLIGHT
}

case_list() {
  compile_named list 3
  assert_contains "$TASK_TMP_DIR/list.txt" DETAILED
  assert_contains "$TASK_TMP_DIR/list.txt" LISTADD
  assert_contains "$TASK_TMP_DIR/list.txt" LISTCOMMENT
  assert_not_contains "$TASK_TMP_DIR/list.txt" "Removed (L2)"
}

case_localization() {
  compile_named localization 2
  assert_contains "$TASK_TMP_DIR/localization.txt" "Danh sách thay đổi"
  assert_contains "$TASK_TMP_DIR/localization.txt" "Thêm (L1): VNTOKEN"
  assert_contains "$TASK_TMP_DIR/localization.txt" "Các thay đổi (rút gọn)"
  assert_contains "$TASK_TMP_DIR/localization.txt" "đang chờ"
  assert_contains "$TASK_TMP_DIR/localization.txt" "DANH SACH"
}

case_error_fixtures() {
  if TEXINPUTS="$PROJECT_ROOT:" pdflatex -halt-on-error -interaction=nonstopmode \
    -output-directory="$TASK_TMP_DIR" "$PROJECT_ROOT/tests/duplicate-id.tex" >/dev/null 2>&1; then
    printf 'Expected duplicate change ID compilation to fail\n' >&2
    exit 1
  fi
  if TEXINPUTS="$PROJECT_ROOT:" pdflatex -halt-on-error -interaction=nonstopmode \
    -output-directory="$TASK_TMP_DIR" "$PROJECT_ROOT/tests/undefined-author.tex" >/dev/null 2>&1; then
    printf 'Expected undefined author compilation to fail\n' >&2
    exit 1
  fi
}

case_engines() {
  local engine
  for engine in xelatex lualatex; do
    TEXMFCACHE="$TASK_TMP_DIR/texmf-cache" TEXINPUTS="$PROJECT_ROOT:" "$engine" -halt-on-error -interaction=nonstopmode \
      -output-directory="$TASK_TMP_DIR" "$PROJECT_ROOT/tests/features.tex" >/dev/null
  done
}

case_python_unit() {
  python3 -m unittest -v tests.test_merge
}

case_versions() {
  # texchanges.sty is the single source of truth for both the version and the
  # release date; every other copy must agree with it.
  #
  # This case is deliberately in two halves. The positive checks below name the
  # files that must state the version, and the negative sweep at the end catches
  # any file that states one without being named here. An earlier version of
  # this case had only the positive half over four files, and three other files
  # carrying the version drifted to a stale release without the suite noticing.
  # CTAN caught it instead.
  local sty_version sty_slash sty_iso sty_long
  sty_version="$(sed -n 's/.*\\ProvidesExplPackage{texchanges}{[^}]*}{\([^}]*\)}.*/\1/p' "$PROJECT_ROOT/texchanges.sty")"
  sty_slash="$(sed -n 's/.*\\ProvidesExplPackage{texchanges}{\([^}]*\)}.*/\1/p' "$PROJECT_ROOT/texchanges.sty")"
  test -n "$sty_version"
  test -n "$sty_slash"
  sty_iso="${sty_slash//\//-}"
  sty_long="$(python3 -c 'import datetime,sys; d=datetime.datetime.strptime(sys.argv[1], "%Y/%m/%d"); print(f"{d.day} {d:%B} {d.year}")' "$sty_slash")"

  # Version, everywhere it is stated.
  assert_contains "$PROJECT_ROOT/scripts/texchanges-merge.py" "VERSION = \"$sty_version\""
  assert_contains "$PROJECT_ROOT/build.lua" "version = \"$sty_version\""
  assert_contains "$PROJECT_ROOT/website/package.json" "\"version\": \"$sty_version\""
  # The lockfile carries its own copy of the package version and npm only
  # refreshes it on install, so it drifts silently without this check.
  assert_contains "$PROJECT_ROOT/website/package-lock.json" "\"version\": \"$sty_version\""
  assert_contains "$PROJECT_ROOT/CITATION.cff" "version: $sty_version"
  assert_contains "$PROJECT_ROOT/texchanges-merge.1" "\"texchanges $sty_version\""
  assert_contains "$PROJECT_ROOT/texchanges-doc.tex" "pdftitle={Texchanges $sty_version Manual}"
  assert_contains "$PROJECT_ROOT/texchanges-doc.tex" "\\date{Version $sty_version,"

  # Release date, which is a second axis nothing used to check. It appears in
  # three spellings, so compare each against the one in texchanges.sty.
  assert_contains "$PROJECT_ROOT/CITATION.cff" "date-released: '$sty_iso'"
  assert_contains "$PROJECT_ROOT/texchanges-merge.1" "\"$sty_iso\""
  assert_contains "$PROJECT_ROOT/texchanges-doc.tex" "\\date{Version $sty_version, $sty_long}"

  test -x "$PROJECT_ROOT/scripts/texchanges-merge.py"
  test "$("$PROJECT_ROOT/scripts/texchanges-merge.py" --version)" = "texchanges-merge $sty_version"

  # Negative sweep. Nothing tracked may name a version of this package other
  # than the current one. The pattern is anchored on the package name or the
  # word "Version" so that dependency versions such as "@astrojs/yaml2ts 0.2.4"
  # in the lockfile do not match. CHANGELOG.md is excluded because recording
  # older releases is its purpose.
  #
  # A new file that states the version is covered the moment it is committed,
  # with nobody having to remember to extend the list above.
  local stale
  stale="$(
    cd "$PROJECT_ROOT" || exit 1
    git ls-files \
      | grep -vx 'CHANGELOG.md' \
      | xargs grep -inE '(texchanges[ -]|Version )[0-9]+\.[0-9]+\.[0-9]+' 2>/dev/null \
      | grep -v "$sty_version" || true
  )"
  if [ -n "$stale" ]; then
    printf 'Files naming a version other than %s:\n%s\n' "$sty_version" "$stale" >&2
    exit 1
  fi
}

case_cli_help() {
  COLUMNS=10 "$PROJECT_ROOT/scripts/texchanges-merge.py" --help \
    | grep -F 'Resolve or merge Texchanges markup without third-party dependencies.' >/dev/null
}

case_manpage() {
  local section
  if command -v mandoc >/dev/null 2>&1; then
    mandoc -T lint "$PROJECT_ROOT/texchanges-merge.1"
  elif command -v groff >/dev/null 2>&1; then
    groff -man -Tascii "$PROJECT_ROOT/texchanges-merge.1" >/dev/null
  else
    for section in NAME SYNOPSIS DESCRIPTION OPTIONS 'EXIT STATUS' EXAMPLES FILES AUTHOR 'REPORTING BUGS'; do
      grep -Fq ".SH $section" "$PROJECT_ROOT/texchanges-merge.1"
    done
  fi
}

case_style_matrix() {
  local preset style
  for preset in texchanges default underlined bfit nocolor; do
    compile_style_case "preset-$preset" "markup=$preset" '\txreplace{old}{new}'
  done
  for style in colored uline uuline uwave dashuline dotuline bf it sl em; do
    compile_style_case "added-$style" "addedmarkup=$style" '\txadd{added}'
  done
  for style in colored sout xout uline uuline uwave dashuline dotuline bf it sl em; do
    compile_style_case "deleted-$style" "deletedmarkup=$style" '\txremove{deleted}'
  done
  for style in background uuline uwave; do
    compile_style_case "highlight-$style" "highlightmarkup=$style" '\txhighlight{highlighted}'
  done
  for style in inline margin footnote uwave todo; do
    compile_style_case "comment-$style" "commentmarkup=$style" '\txcomment{commented}'
  done
  for style in superscript subscript brackets footnote none; do
    compile_style_case "author-$style" "authormarkup=$style" '\txadd[Reviewer]{added}'
  done
}

case_compat_prefixes() {
  compile_style_case compat-none 'compat=changes,commandnameprefix=none' '\added{added}\replaced{new}{old}'
  compile_style_case compat-ifneeded 'compat=changes,commandnameprefix=ifneeded' '\added{added}\replaced{new}{old}'
  compile_style_case compat-always 'compat=changes,commandnameprefix=always' '\chadded{added}\chreplaced{new}{old}'
}

case_editor_files() {
  python3 -m json.tool "$PROJECT_ROOT/editors/vscode/texchanges.code-snippets" >/dev/null
  local command
  for command in txadd txremove txreplace txhighlight txcomment txdefineauthor txlistofchanges; do
    assert_contains "$PROJECT_ROOT/editors/texstudio/texchanges.cwl" "\\$command"
  done
  # The compatibility layer reverses the replacement arguments; the completion
  # data must not teach the wrong order.
  assert_contains "$PROJECT_ROOT/editors/texstudio/texchanges.cwl" '\txreplace{old}{new}'
  assert_contains "$PROJECT_ROOT/editors/texstudio/texchanges.cwl" '\replaced{new}{old}'
}

case_playground() {
  # The website playground reimplements the package's mode semantics in
  # JavaScript so a visitor sees them without a TeX installation. Hold that
  # second implementation to the same fixtures the compiled cases use, so it
  # cannot quietly drift from texchanges.sty.
  if ! command -v node >/dev/null 2>&1; then
    printf 'node not installed; skipping the playground renderer check\n' >&2
    return 0
  fi
  node "$PROJECT_ROOT/website/scripts/render-check.mjs" >/dev/null
}

case_l3build() {
  if ! command -v l3build >/dev/null 2>&1; then
    printf 'l3build not installed; skipping log-level regression tests\n' >&2
    return 0
  fi
  (cd "$PROJECT_ROOT" && l3build check < /dev/null)
}

case_latexdiff() {
  latexdiff --flatten --type=UNDERLINE --config MINWORDSBLOCK=1 \
    "$PROJECT_ROOT/examples/automatic-diff/texchanges-original.tex" \
    "$PROJECT_ROOT/examples/automatic-diff/texchanges-revised.tex" \
    > "$TASK_TMP_DIR/automatic.tex"
  pdflatex \
    -halt-on-error \
    -interaction=nonstopmode \
    -output-directory="$TASK_TMP_DIR" \
    "$TASK_TMP_DIR/automatic.tex" >/dev/null
  pdftotext "$TASK_TMP_DIR/automatic.pdf" "$TASK_TMP_DIR/automatic.txt"
  assert_contains "$TASK_TMP_DIR/automatic.tex" '\DIFdel{new }'
  assert_contains "$TASK_TMP_DIR/automatic.tex" '\DIFdel{a realistic representation }'
  assert_contains "$TASK_TMP_DIR/automatic.tex" '\DIFadd{selected characteristics }'
  assert_contains "$TASK_TMP_DIR/automatic.tex" '\emph{\DIFdelbegin'
  assert_contains "$TASK_TMP_DIR/automatic.tex" '\begin{itemize}'
  assert_contains "$TASK_TMP_DIR/automatic.txt" selected
  assert_contains "$TASK_TMP_DIR/automatic.txt" adaptive
  assert_contains "$TASK_TMP_DIR/automatic.txt" completion

  perl -c "$PROJECT_ROOT/examples/automatic-diff/latexmkrc" >/dev/null
}

# --------------------------------------------------------------------------
# Runner. TEST=<substring> runs only matching cases; failures are collected
# and reported together instead of aborting on the first one.
# --------------------------------------------------------------------------

FAILURES=0
RAN=0
RUN_FILTER="${TEST:-}"

run_case() {
  local name="$1"
  if [ -n "$RUN_FILTER" ] && [[ "$name" != *"$RUN_FILTER"* ]]; then
    return 0
  fi
  RAN=$((RAN + 1))
  if ( set -e; "case_$name" ); then
    printf 'ok: %s\n' "$name"
  else
    printf 'FAIL: %s\n' "$name" >&2
    FAILURES=$((FAILURES + 1))
  fi
}

run_case modes
run_case features
run_case report_extensions
run_case status_final
run_case status_original
run_case compat
run_case options
run_case styles
run_case list
run_case localization
run_case error_fixtures
run_case engines
run_case python_unit
run_case versions
run_case cli_help
run_case manpage
run_case style_matrix
run_case compat_prefixes
run_case editor_files
run_case playground
run_case l3build
run_case latexdiff

if [ "$RAN" -eq 0 ]; then
  printf 'No test case matches TEST=%s\n' "$RUN_FILTER" >&2
  exit 1
fi
if [ "$FAILURES" -gt 0 ]; then
  printf '%d of %d test case(s) failed\n' "$FAILURES" "$RAN" >&2
  exit 1
fi
printf 'texchanges checks passed: %d case(s) covering modes, metadata, reports, compatibility, CLI, engines, automatic diff\n' "$RAN"
