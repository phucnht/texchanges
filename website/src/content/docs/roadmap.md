---
title: Roadmap to 1.0.0
description: A living checklist for the stable Texchanges review protocol.
---

This is a living checklist. Features will be grouped into future minor releases only after implementation and testing. Completed work belongs in the changelog.

## Planned work

- [ ] Review data and project policies
  - [ ] JSONL manifests with stable source locations
  - [ ] External decision files and policy checks
  - [ ] Protected-file enforcement and Git revision conversion

- [ ] Resolution and compatibility
  - [ ] Expanded CLI commands for scanning, checking, deciding, and resolving
  - [ ] TexLua resolver and Python parity fixtures
  - [ ] Schema and migration tooling
  - [ ] Typst interoperability, with a documented review-markup bridge and format-aware conversion limits

- [ ] Collaboration
  - [ ] Categories, threads, replies, and contributor metadata
  - [ ] GitHub review annotations and CI summaries

- [ ] Robust and accessible authoring
  - [ ] Safe markup in headings, captions, footnotes, floats, and math
  - [ ] Accessible visual presets and tagged-PDF support where available
  - [ ] Clear diagnostics for unsupported citation and verbatim contexts

- [ ] Editor and optional browser tooling
  - [ ] Standard-library language server and thin VS Code client
  - [ ] Capability-detected Overleaf browser extension with no telemetry

- [ ] 1.0.0 readiness
  - [ ] Public compatibility commitments for markup, decisions, CLI, and reports
  - [ ] Cross-engine, accessibility, archive, and real-project verification
  - [ ] Complete migration guidance and pilot feedback resolution

## How the roadmap stays current

Each release updates this page and the [GitHub README](https://github.com/phucnht/texchanges#roadmap-to-100). Completed work is recorded in the changelog. Feature ideas and use cases are welcome through [GitHub Issues](https://github.com/phucnht/texchanges/issues).
