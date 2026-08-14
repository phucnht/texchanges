---
title: Merge CLI
description: Update decisions or permanently resolve review markup.
---

```bash
python3 scripts/texchanges_merge.py paper.tex reviewed.tex --accept
python3 scripts/texchanges_merge.py paper.tex final.tex --accept --merge
python3 scripts/texchanges_merge.py paper.tex --reject --id R12 --in-place
python3 scripts/texchanges_merge.py paper.tex --accept --author phuc --dry-run
```

The standard-library Python CLI can filter by author or change ID, update statuses, permanently merge markup, unwrap highlights, and remove standalone comments.

Output must differ from the input unless `--in-place` is selected. In-place changes create a backup. Malformed markup fails before the destination is written.
