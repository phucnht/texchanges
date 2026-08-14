---
title: Migrate from changes
description: Adopt Texchanges compatibility or move to the native API.
---

## Compatibility path

```latex
\usepackage[review,compat=changes]{texchanges}
```

Existing `\added`, `\deleted`, `\replaced{new}{old}`, `\highlight`, `\comment`, author definitions, reports, and setters remain available.

## Native path

- `\added[id=phuc]{new}` becomes `\txadd[author=phuc]{new}`.
- `\deleted[id=phuc]{old}` becomes `\txremove[author=phuc]{old}`.
- `\replaced[id=phuc]{new}{old}` becomes `\txreplace[author=phuc]{old}{new}`.
- Native `id=R12` stores a unique change ID.
- Compatibility mode uses `changeid=R12` because `id` retains its author meaning.

Add `status=pending|accepted|rejected` when decisions should remain visible in source. Use the merge CLI when resolved markup should be removed permanently.
