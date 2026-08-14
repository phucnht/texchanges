# CTAN submission notes

Use these values for the `texchanges` 0.2.2 upload form.

- **Package:** `texchanges`
- **Version:** `0.2.2`
- **License:** LPPL 1.3c or later
- **Archive:** `dist/texchanges-0.2.2.zip`
- **Summary:** LaTeX-native tracked changes with review decisions and reports
- **Repository:** <https://github.com/phucnht/texchanges>
- **Documentation:** <https://phucnht.github.io/texchanges/>
- **Bug tracker:** <https://github.com/phucnht/texchanges/issues>

## Description

Texchanges provides explicit tracked-change markup for LaTeX and Overleaf. It
supports additions, removals, replacements, highlights, comments, authors,
stable change IDs, decision statuses, filtered review reports, localization,
visual presets, and an opt-in compatibility layer for the `changes` package.
Native replacement commands use the readable old-to-new argument order.

The distribution also includes a standard-library Python merge tool for
accepting, rejecting, or permanently resolving marked changes.

## Announcement

Version 0.2.2 adds review-only change reports, a complete PDF manual, CTAN
packaging, and public web documentation. Reports are now silent in `final` and
`original` modes, which prevents stale auxiliary data from appearing in a
resolved document.

## Submission checklist

- Run `make release-check` from the product repository.
- Confirm that `dist/SHA256SUMS` matches the release files.
- Use a monitored email address in the CTAN uploader field.
- Review every generated form value before submitting.
- Wait for CTAN validation and maintainer correspondence.
