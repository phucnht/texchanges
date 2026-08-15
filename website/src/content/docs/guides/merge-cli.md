---
title: Merge CLI
description: Update decisions or permanently resolve review markup.
---

```bash
texchanges-merge paper.tex reviewed.tex --accept
texchanges-merge paper.tex final.tex --accept --merge
texchanges-merge paper.tex --reject --id R12 --in-place
texchanges-merge paper.tex --accept --author phuc --dry-run
```

The command can run from any working directory after TeX Live installs it. From a source checkout, use `python3 scripts/texchanges-merge.py` in place of `texchanges-merge`.

The tool requires Python 3.10 or later and uses only the standard library. It can filter by author or change ID, update statuses, permanently merge markup, unwrap highlights, and remove standalone comments.

Output must differ from the input unless `--in-place` is selected. In-place changes create a backup. Malformed markup fails before the destination is written.
