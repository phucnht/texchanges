.PHONY: help check test example doc dist ctan release-check website clean

PACKAGE := texchanges
BUILD_DIR := build
DIST_DIR := dist

help:
	@printf '%s\n' \
	  'make check    Run mode and automatic-diff verification' \
	  'make test     Alias for make check' \
	  'make example  Compile the explicit review example' \
	  'make doc      Compile the package manual' \
	  'make dist     Build Overleaf-ready zip archives' \
	  'make ctan     Build the CTAN submission archive' \
	  'make release-check  Verify package, manual, archives, and website' \
	  'make website  Build the public documentation site' \
	  'make clean    Remove generated output'

check:
	./scripts/test.sh

test: check

example:
	mkdir -p $(BUILD_DIR)/explicit-review
	TEXINPUTS="$(CURDIR):" latexmk -pdf -halt-on-error \
	  -interaction=nonstopmode \
	  -outdir=$(BUILD_DIR)/explicit-review \
	  examples/explicit-review/texchanges-explicit-review.tex

doc:
	mkdir -p $(BUILD_DIR)
	latexmk -pdf -halt-on-error -interaction=nonstopmode \
	  -outdir=$(BUILD_DIR) texchanges-doc.tex

dist: clean
	$(MAKE) doc
	mkdir -p $(DIST_DIR)
	zip -j $(DIST_DIR)/$(PACKAGE)-overleaf.zip \
	  texchanges.sty examples/explicit-review/texchanges-explicit-review.tex README.md LICENSE \
	  texchanges-doc.tex build/texchanges-doc.pdf \
	  scripts/texchanges-merge.py
	zip -j $(DIST_DIR)/$(PACKAGE)-automatic-diff-overleaf.zip \
	  examples/automatic-diff/texchanges-original.tex \
	  examples/automatic-diff/texchanges-revised.tex \
	  examples/automatic-diff/texchanges-review.tex \
	  examples/automatic-diff/latexmkrc \
	  examples/automatic-diff/README.md

ctan: doc
	./scripts/ctan-release.sh

website:
	npm --prefix website run build

release-check: check dist ctan website
	@for archive in $(DIST_DIR)/*.zip; do unzip -t "$$archive" >/dev/null; done
	@if command -v sha256sum >/dev/null 2>&1; then \
	  sha256sum $(DIST_DIR)/*.zip $(BUILD_DIR)/texchanges-doc.pdf; \
	else \
	  shasum -a 256 $(DIST_DIR)/*.zip $(BUILD_DIR)/texchanges-doc.pdf; \
	fi > $(DIST_DIR)/SHA256SUMS
	@printf 'Texchanges release artifacts verified.\n'

clean:
	latexmk -C examples/explicit-review/texchanges-explicit-review.tex >/dev/null 2>&1 || true
	$(RM) \
	  examples/automatic-diff/review-generated.tex \
	  examples/automatic-diff/texchanges-review.aux \
	  examples/automatic-diff/texchanges-review.fdb_latexmk \
	  examples/automatic-diff/texchanges-review.fls \
	  examples/automatic-diff/texchanges-review.log \
	  examples/automatic-diff/texchanges-review.pdf
	rm -rf $(BUILD_DIR) $(DIST_DIR)
	find . -type d -name __pycache__ -prune -exec rm -rf {} +
