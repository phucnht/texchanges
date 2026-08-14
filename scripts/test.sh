#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TASK_TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/texchanges-test.XXXXXX")"
trap 'rm -rf "$TASK_TMP_DIR"' EXIT

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

compile_mode() {
  local mode="$1"
  TEXINPUTS="$PROJECT_ROOT:" pdflatex \
    -halt-on-error \
    -interaction=nonstopmode \
    -output-directory="$TASK_TMP_DIR" \
    "$PROJECT_ROOT/tests/$mode.tex" >/dev/null
  pdftotext "$TASK_TMP_DIR/$mode.pdf" "$TASK_TMP_DIR/$mode.txt"
}

for mode in review final original; do
  compile_mode "$mode"
done

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

compile_named report-extensions 2
assert_contains "$TASK_TMP_DIR/report-extensions.txt" "CUSTOM LIST"
assert_contains "$TASK_TMP_DIR/report-extensions.txt" "CUSTOM SUMMARY"
assert_contains "$TASK_TMP_DIR/report-extensions.txt" "CUSTOMEXTENSION"
assert_contains "$TASK_TMP_DIR/report-extensions.txcustomsummary" "anonymous/added/pending"
test -f "$TASK_TMP_DIR/report-extensions.txcustomlist"

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

printf '%s\n' 'STALE ORIGINAL REPORT' > "$TASK_TMP_DIR/status-original.txc"
printf '%s\n' '\txsummaryentry{anonymous/added/pending}{99}' > "$TASK_TMP_DIR/status-original.txs"
compile_named status-original
assert_contains "$TASK_TMP_DIR/status-original.txt" OLDACCEPTED
assert_contains "$TASK_TMP_DIR/status-original.txt" OLDREJECTED
assert_contains "$TASK_TMP_DIR/status-original.txt" ACCEPTEDREMOVE
assert_not_contains "$TASK_TMP_DIR/status-original.txt" ACCEPTEDADD
assert_not_contains "$TASK_TMP_DIR/status-original.txt" "HIDDEN ORIGINAL REPORT"
assert_not_contains "$TASK_TMP_DIR/status-original.txt" "STALE ORIGINAL REPORT"

compile_named compat
assert_contains "$TASK_TMP_DIR/compat.txt" COMPATNEW
assert_contains "$TASK_TMP_DIR/compat.txt" COMPATOLD
assert_contains "$TASK_TMP_DIR/compat.txt" COMPATCOMMENT

compile_named compat-ifneeded
assert_contains "$TASK_TMP_DIR/compat-ifneeded.txt" ORIGINALCOMMENT
assert_contains "$TASK_TMP_DIR/compat-ifneeded.txt" CHANGECOMMENT
assert_contains "$TASK_TMP_DIR/compat-ifneeded.txt" ADDED

compile_named options
assert_contains "$TASK_TMP_DIR/options.txt" OPTIONS

compile_named styles
assert_contains "$TASK_TMP_DIR/styles.txt" STYLEADD
assert_contains "$TASK_TMP_DIR/styles.txt" STYLEDELETE
assert_contains "$TASK_TMP_DIR/styles.txt" STYLEHIGHLIGHT

compile_named list 3
assert_contains "$TASK_TMP_DIR/list.txt" DETAILED
assert_contains "$TASK_TMP_DIR/list.txt" LISTADD
assert_contains "$TASK_TMP_DIR/list.txt" LISTCOMMENT
assert_not_contains "$TASK_TMP_DIR/list.txt" "Removed (L2)"

compile_named localization
assert_contains "$TASK_TMP_DIR/localization.txt" "DANH SACH"

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

for engine in xelatex lualatex; do
  TEXMFCACHE="$TASK_TMP_DIR/texmf-cache" TEXINPUTS="$PROJECT_ROOT:" "$engine" -halt-on-error -interaction=nonstopmode \
    -output-directory="$TASK_TMP_DIR" "$PROJECT_ROOT/tests/features.tex" >/dev/null
done

python3 -m unittest -v tests.test_merge

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

compile_style_case compat-none 'compat=changes,commandnameprefix=none' '\added{added}\replaced{new}{old}'
compile_style_case compat-ifneeded 'compat=changes,commandnameprefix=ifneeded' '\added{added}\replaced{new}{old}'
compile_style_case compat-always 'compat=changes,commandnameprefix=always' '\chadded{added}\chreplaced{new}{old}'

latexdiff --flatten --type=UNDERLINE \
  "$PROJECT_ROOT/examples/automatic-diff/original.tex" \
  "$PROJECT_ROOT/examples/automatic-diff/revised.tex" \
  > "$TASK_TMP_DIR/automatic.tex"
pdflatex \
  -halt-on-error \
  -interaction=nonstopmode \
  -output-directory="$TASK_TMP_DIR" \
  "$TASK_TMP_DIR/automatic.tex" >/dev/null
pdftotext "$TASK_TMP_DIR/automatic.pdf" "$TASK_TMP_DIR/automatic.txt"
assert_contains "$TASK_TMP_DIR/automatic.txt" realistic
assert_contains "$TASK_TMP_DIR/automatic.txt" approximates

perl -c "$PROJECT_ROOT/examples/automatic-diff/latexmkrc" >/dev/null

printf 'texchanges checks passed: modes, metadata, reports, compatibility, CLI, engines, automatic diff\n'
