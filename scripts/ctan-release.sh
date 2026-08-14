#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION="0.2.2"
ARCHIVE="$PROJECT_ROOT/dist/texchanges-$VERSION.zip"
TASK_TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/texchanges-ctan.XXXXXX")"
trap 'rm -rf "$TASK_TMP_DIR"' EXIT

PACKAGE_DIR="$TASK_TMP_DIR/texchanges"
mkdir -p "$PACKAGE_DIR/examples/explicit-review"
mkdir -p "$PACKAGE_DIR/examples/automatic-diff"
mkdir -p "$PACKAGE_DIR/scripts"

cp "$PROJECT_ROOT/README.md" "$PROJECT_ROOT/LICENSE" \
  "$PROJECT_ROOT/CHANGELOG.md" "$PROJECT_ROOT/Makefile" \
  "$PROJECT_ROOT/build.lua" "$PROJECT_ROOT/texchanges.sty" \
  "$PROJECT_ROOT/texchanges-doc.tex" "$PROJECT_ROOT/build/texchanges-doc.pdf" \
  "$PACKAGE_DIR/"
cp "$PROJECT_ROOT/examples/explicit-review/README.md" \
  "$PROJECT_ROOT/examples/explicit-review/main.tex" \
  "$PACKAGE_DIR/examples/explicit-review/"
cp "$PROJECT_ROOT/examples/automatic-diff/README.md" \
  "$PROJECT_ROOT/examples/automatic-diff/latexmkrc" \
  "$PROJECT_ROOT/examples/automatic-diff/original.tex" \
  "$PROJECT_ROOT/examples/automatic-diff/review.tex" \
  "$PROJECT_ROOT/examples/automatic-diff/revised.tex" \
  "$PACKAGE_DIR/examples/automatic-diff/"
cp "$PROJECT_ROOT/scripts/texchanges_merge.py" "$PACKAGE_DIR/scripts/"

if find "$PACKAGE_DIR" -type f \( -name '*.aux' -o -name '*.log' -o -name '*.out' \
  -o -name '*.fls' -o -name '*.fdb_latexmk' -o -name '*.txc' -o -name '*.txs' \) \
  | grep -q .; then
  printf 'Generated compiler files found in CTAN staging directory.\n' >&2
  exit 1
fi

mkdir -p "$PROJECT_ROOT/dist"
(cd "$TASK_TMP_DIR" && zip -qr "$ARCHIVE" texchanges)
unzip -t "$ARCHIVE" >/dev/null

VERIFY_DIR="$TASK_TMP_DIR/verify"
mkdir -p "$VERIFY_DIR"
unzip -q "$ARCHIVE" -d "$VERIFY_DIR"
TEXINPUTS="$VERIFY_DIR/texchanges:" pdflatex -halt-on-error \
  -interaction=nonstopmode -output-directory="$VERIFY_DIR" \
  "$VERIFY_DIR/texchanges/examples/explicit-review/main.tex" >/dev/null

if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$ARCHIVE" > "$ARCHIVE.sha256"
else
  shasum -a 256 "$ARCHIVE" > "$ARCHIVE.sha256"
fi
printf 'Created %s\n' "$ARCHIVE"
