#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# texchanges.sty is the single source of truth for the package version.
VERSION="$(sed -n 's/.*\\ProvidesExplPackage{texchanges}{[^}]*}{\([^}]*\)}.*/\1/p' "$PROJECT_ROOT/texchanges.sty")"
if [ -z "$VERSION" ]; then
  printf 'Unable to read the package version from texchanges.sty.\n' >&2
  exit 1
fi
ARCHIVE="$PROJECT_ROOT/dist/texchanges-$VERSION.zip"
TASK_TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/texchanges-ctan.XXXXXX")"
trap 'rm -rf "$TASK_TMP_DIR"' EXIT

PACKAGE_DIR="$TASK_TMP_DIR/texchanges"
mkdir -p "$PACKAGE_DIR/examples/explicit-review"
mkdir -p "$PACKAGE_DIR/examples/automatic-diff"
mkdir -p "$PACKAGE_DIR/examples/overleaf-workflow"
mkdir -p "$PACKAGE_DIR/scripts"

cp "$PROJECT_ROOT/README.md" "$PROJECT_ROOT/LICENSE" \
  "$PROJECT_ROOT/CHANGELOG.md" "$PROJECT_ROOT/Makefile" \
  "$PROJECT_ROOT/build.lua" "$PROJECT_ROOT/texchanges.sty" \
  "$PROJECT_ROOT/texchanges-doc.tex" "$PROJECT_ROOT/build/texchanges-doc.pdf" \
  "$PROJECT_ROOT/texchanges-merge.1" \
  "$PACKAGE_DIR/"
cp "$PROJECT_ROOT/examples/explicit-review/README.md" \
  "$PROJECT_ROOT/examples/explicit-review/texchanges-explicit-review.tex" \
  "$PACKAGE_DIR/examples/explicit-review/"
cp "$PROJECT_ROOT/examples/automatic-diff/README.md" \
  "$PROJECT_ROOT/examples/automatic-diff/latexmkrc" \
  "$PROJECT_ROOT/examples/automatic-diff/texchanges-original.tex" \
  "$PROJECT_ROOT/examples/automatic-diff/texchanges-review.tex" \
  "$PROJECT_ROOT/examples/automatic-diff/texchanges-revised.tex" \
  "$PACKAGE_DIR/examples/automatic-diff/"
cp "$PROJECT_ROOT/examples/overleaf-workflow/README.md" \
  "$PACKAGE_DIR/examples/overleaf-workflow/"
cp "$PROJECT_ROOT/scripts/texchanges-merge.py" "$PACKAGE_DIR/scripts/"
mkdir -p "$PACKAGE_DIR/testfiles"
cp "$PROJECT_ROOT"/testfiles/*.lvt "$PROJECT_ROOT"/testfiles/*.tlg "$PACKAGE_DIR/testfiles/"
mkdir -p "$PACKAGE_DIR/editors/vscode" "$PACKAGE_DIR/editors/texstudio"
cp "$PROJECT_ROOT/editors/README.md" "$PACKAGE_DIR/editors/"
cp "$PROJECT_ROOT/editors/vscode/texchanges.code-snippets" "$PACKAGE_DIR/editors/vscode/"
cp "$PROJECT_ROOT/editors/texstudio/texchanges.cwl" "$PACKAGE_DIR/editors/texstudio/"

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
test -x "$VERIFY_DIR/texchanges/scripts/texchanges-merge.py"
test -f "$VERIFY_DIR/texchanges/texchanges-merge.1"
if find "$VERIFY_DIR/texchanges" -name 'texchanges_merge.py' | grep -q .; then
  printf 'Obsolete underscore CLI filename found in CTAN archive.\n' >&2
  exit 1
fi
TEXINPUTS="$VERIFY_DIR/texchanges:" pdflatex -halt-on-error \
  -interaction=nonstopmode -output-directory="$VERIFY_DIR" \
  "$VERIFY_DIR/texchanges/examples/explicit-review/texchanges-explicit-review.tex" >/dev/null
(cd "$VERIFY_DIR/texchanges/examples/automatic-diff" && \
  latexmk -pdf -halt-on-error -interaction=nonstopmode texchanges-review.tex >/dev/null)
ln -s "$VERIFY_DIR/texchanges/scripts/texchanges-merge.py" "$TASK_TMP_DIR/texchanges-merge"
(cd "$TASK_TMP_DIR" && ./texchanges-merge --version) \
  | grep -Fx "texchanges-merge $VERSION" >/dev/null
(cd "$TASK_TMP_DIR" && COLUMNS=10 ./texchanges-merge --help) \
  | grep -F 'Resolve or merge Texchanges markup without third-party dependencies.' >/dev/null

# The manual's title page is what a CTAN reviewer reads first, and it comes
# from a compiled artefact rather than from source, so assert on the artefact
# that is actually going into the archive. The 0.3.0 upload was held because
# this page still said 0.2.4 while every checked source file said 0.3.0.
# Compared with whitespace removed: poppler infers spaces from glyph
# positions, and different builds disagree about where they fall.
MANUAL_TEXT="$(pdftotext "$VERIFY_DIR/texchanges/texchanges-doc.pdf" -)"
if ! printf '%s' "$MANUAL_TEXT" | tr -d '[:space:]' | grep -Fq "Version$VERSION"; then
  printf 'The manual in the archive does not state version %s.\n' "$VERSION" >&2
  printf 'Its title page reads: %s\n' "$(printf '%s' "$MANUAL_TEXT" | head -6 | tr '\n' ' ')" >&2
  printf 'Rebuild it with make doc after updating texchanges-doc.tex.\n' >&2
  exit 1
fi
# The man page ships beside the CLI whose --version is already checked above.
grep -Fq "\"texchanges $VERSION\"" "$VERIFY_DIR/texchanges/texchanges-merge.1"

if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$ARCHIVE" > "$ARCHIVE.sha256"
else
  shasum -a 256 "$ARCHIVE" > "$ARCHIVE.sha256"
fi
printf 'Created %s\n' "$ARCHIVE"
