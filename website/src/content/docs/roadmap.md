---
title: Roadmap to 1.0.0
description: Planned milestones for the stable Texchanges review protocol.
---

This roadmap describes planned work. A milestone becomes part of the public API only when it is released and documented in the changelog.

## 0.3.0, Structured review data

**Planned.** Add JSONL manifests, policy checks, external decision files, protected files, source locations, and Git revision conversion. The existing Python resolver remains supported while gaining `scan`, `check`, `diff`, `decisions`, and `resolve` commands.

Migration: existing source commands and inline statuses continue to work. IDs remain optional unless a project policy requires them.

## 0.4.0, Collaboration and automation

**Planned.** Add review threads, replies, contributor metadata, a TexLua resolver, GitHub annotations, and shared fixtures that keep the Python and TexLua resolvers aligned.

Migration: author IDs and simple comments remain valid. Thread and contributor fields are additive metadata.

## 0.5.0, Accessible and robust authoring

**Planned.** Add accessible visual presets, tagged-PDF integration when the LaTeX environment supports it, stronger behavior in headings, captions, footnotes, and floats, plus dedicated math commands.

Migration: existing markup remains visually compatible. Tagging support will warn when unavailable rather than claim conformance.

## 0.6.0, Editor workflow

**Planned.** Add a standard-library language server and a thin VS Code client for diagnostics, hover details, document symbols, and review actions.

Migration: editors use the existing Texchanges source protocol. The LaTeX package remains usable without an editor extension.

## 0.7.0, Optional Overleaf assistance

**Planned.** Add a capability-detected browser extension for inserting and deciding Texchanges markup. It will use no telemetry and will fail closed for unsupported editor versions.

Migration: the Git workflow remains the stable collaborative option. The extension adds convenience without becoming a requirement.

## 0.8.0, Interoperability hardening

**Planned.** Stabilize exchange schemas, migration tooling, Python and TexLua parity tests, and real-project compatibility fixtures.

Migration: schema and CLI compatibility commitments will be documented before the 1.0.0 freeze.

## 0.9.0, Release candidate

**Planned.** Freeze new public APIs, complete accessibility and cross-engine verification, audit the documentation, and resolve feedback from pilot projects.

Migration: upgrade guidance will cover every supported pre-1.0 format and command.

## 1.0.0, Stable review protocol

**Planned.** Publish documented compatibility guarantees for LaTeX markup, decision files, CLI resolution, reports, and supported integrations. The release will include clean archive validation, real-project fixtures, and complete user migration guidance.

## How the roadmap stays current

Each release updates this page and the [GitHub README](https://github.com/phucnht/texchanges#roadmap-to-100). Completed work is recorded in the changelog. Feature ideas and use cases are welcome through [GitHub Issues](https://github.com/phucnht/texchanges/issues).

Feature proposals and use cases are welcome through [GitHub Issues](https://github.com/phucnht/texchanges/issues).
