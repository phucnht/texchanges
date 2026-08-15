# CTAN submission notes

Use these values for the `texchanges` 0.2.3 update form.

- **Package:** `texchanges`
- **Version:** `0.2.3`
- **License:** LPPL 1.3c or later
- **Archive:** `dist/texchanges-0.2.3.zip`
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

The distribution also includes the standard-library Python
`texchanges-merge` tool for accepting, rejecting, or permanently resolving
marked changes.

## Announcement

Version 0.2.3 adds the user-level `texchanges-merge` command, a manual page,
version output, and readable command help. Example documents now use
package-specific filenames following CTAN feedback.

## Submission checklist

- Run `make release-check` from the product repository.
- Confirm that `dist/SHA256SUMS` matches the release files.
- Use a monitored email address in the CTAN uploader field.
- Review every generated form value before submitting.
- Wait for CTAN validation and maintainer correspondence.
