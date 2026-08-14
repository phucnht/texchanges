---
title: Troubleshooting
description: Resolve common installation, compilation, and reporting issues.
---

## Package not found

Upload `texchanges.sty` beside the main document or install it through the active TeX distribution. On Overleaf, confirm the project's TeX Live version.

## Report is empty

Reports require `review` mode and normally need two LaTeX runs. Final and original modes intentionally suppress reports.

## Undefined author

Register structured author IDs with `\txdefineauthor` before using `author=<id>`.

## Duplicate change ID

Every non-empty native `id` or compatibility `changeid` must be unique within the document.

## Command collision

Use namespaced `\tx...` commands. In compatibility mode, select `commandnameprefix=ifneeded` or `always` when another package owns a compatibility command name.
