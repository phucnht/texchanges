---
title: Authors and decisions
description: Register reviewers and attach stable metadata to changes.
---

```latex
\txdefineauthor[name={Phuc Nguyen},color=orange]{phuc}

\txreplace[
  author=phuc,
  id=R12,
  comment={Clarify this claim.},
  status=pending
]{old text}{new text}
```

- `author` refers to a registered author ID.
- `id` is an optional document-wide unique change ID.
- `comment` attaches a note to the change.
- `status` accepts `pending`, `accepted`, or `rejected`.

Duplicate non-empty IDs and undefined structured authors produce package errors. The legacy form `\txadd[Reviewer]{text}` remains available as a visual label.
