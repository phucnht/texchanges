.PHONY: help check test example doc dist overleaf-check ctan release-check website clean

PACKAGE := texchanges
BUILD_DIR := build
DIST_DIR := dist

help:
	@printf '%s\n' \
	  'make check    Run mode and automatic-diff verification' \
	  'make test     Alias for make check' \
	  'make example  Compile the explicit review example' \
	  'make doc      Compile the package manual' \
	  'make dist     Build the unified Overleaf-ready zip archive' \
	  'make overleaf-check  Validate the unified Overleaf bundle' \
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
	mkdir -p $(DIST_DIR) $(BUILD_DIR)/overleaf-workflow
	cp texchanges.sty examples/explicit-review/texchanges-explicit-review.tex \
	  examples/automatic-diff/texchanges-original.tex \
	  examples/automatic-diff/texchanges-revised.tex \
	  examples/automatic-diff/texchanges-review.tex \
	  examples/automatic-diff/latexmkrc \
	  $(BUILD_DIR)/overleaf-workflow/
	cp examples/overleaf-workflow/README.md $(BUILD_DIR)/overleaf-workflow/README.md
	(cd $(BUILD_DIR)/overleaf-workflow && zip -q ../../$(DIST_DIR)/$(PACKAGE)-overleaf.zip \
	  texchanges.sty texchanges-explicit-review.tex texchanges-original.tex \
	  texchanges-revised.tex texchanges-review.tex latexmkrc README.md)

overleaf-check: dist
	@task_tmp=$$(mktemp -d "$${TMPDIR:-/tmp}/texchanges-overleaf.XXXXXX"); \
	trap 'rm -rf "$$task_tmp"' EXIT; \
	unzip -t $(DIST_DIR)/$(PACKAGE)-overleaf.zip >/dev/null; \
	unzip -q $(DIST_DIR)/$(PACKAGE)-overleaf.zip -d "$$task_tmp"; \
	(cd "$$task_tmp" && \
	  latexmk -pdf -halt-on-error -interaction=nonstopmode texchanges-explicit-review.tex >/dev/null && \
	  latexmk -pdf -halt-on-error -interaction=nonstopmode texchanges-review.tex >/dev/null && \
	  pdftotext texchanges-explicit-review.pdf - | grep -Fq 'Texchanges Explicit Review' && \
	  pdftotext texchanges-review.pdf - | grep -Fq 'selected' && \
	  pdftotext texchanges-review.pdf - | grep -Fq 'adaptive' && \
	  test -f review-generated.tex)

ctan: doc
	./scripts/ctan-release.sh

website:
	npm --prefix website run build

release-check: check overleaf-check ctan website
	@for archive in $(DIST_DIR)/*.zip; do unzip -t "$$archive" >/dev/null; done
	@task_tmp=$$(mktemp -d "$${TMPDIR:-/tmp}/texchanges-checksums.XXXXXX"); \
	trap 'rm -rf "$$task_tmp"' EXIT; \
	cp $(DIST_DIR)/*.zip $(BUILD_DIR)/texchanges-doc.pdf "$$task_tmp"/; \
	cd "$$task_tmp" && \
	if command -v sha256sum >/dev/null 2>&1; then \
	  sha256sum *.zip texchanges-doc.pdf; \
	else \
	  shasum -a 256 *.zip texchanges-doc.pdf; \
	fi > "$(CURDIR)/$(DIST_DIR)/SHA256SUMS"
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
