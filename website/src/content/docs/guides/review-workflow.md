---
title: Review workflow
description: Use review, final, and original modes consistently.
---

| Mode | Pending | Accepted | Rejected |
|---|---|---|---|
| `review` | Visual markup | Proposed text | Original text |
| `final` | Proposed text with warning | Proposed text | Original text |
| `original` | Original text | Original text | Original text |

Change lists are review artifacts. `\txlistofchanges` is silent in `final` and `original`, and those modes do not write report auxiliary data.

Use final mode as a publication check. Its warning identifies unresolved pending changes that were rendered as proposed text.
