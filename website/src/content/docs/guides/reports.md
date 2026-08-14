---
title: Change reports
description: Create detailed and summarized review reports.
---

```latex
\txlistofchanges
\txlistofchanges[style=summary]
\txlistofchanges[
  style=list,
  title={Pending reviewer changes},
  show={added,replaced,commented},
  status={pending},
  author={phuc}
]
```

Available layouts are `list`, `summary`, and `compactsummary`. Filters accept change types, statuses, and author IDs.

Detailed reports show excerpts, IDs, page numbers, and links when `hyperref` is loaded. Run LaTeX twice to refresh report content and counts. Reports are produced only in `review` mode.
