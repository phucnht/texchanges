---
title: Feature parity
description: Compare Texchanges 0.2.4 with changes 4.2.1.
---

| Capability | Texchanges 0.2.4 |
|---|---|
| Add, delete, replace, highlight, comment | Native, with old-to-new replacement order |
| Review/draft and final output | Supported, plus `original` mode |
| Registered authors and colors | Supported |
| Per-change author and comment | Supported |
| Visual presets and individual styles | Supported |
| Detailed lists and author summaries | Supported in review mode |
| Babel/Polyglossia captions | Six language sets |
| Command collision strategies | Opt-in compatibility |
| Source markup removal | Supplemental merge CLI |
| Unique change IDs | Texchanges extension |
| Pending/accepted/rejected status | Texchanges extension |
| Selective author/ID resolution | Texchanges CLI extension |

Compatibility mode retains `\replaced{new}{old}`. The native API uses `\txreplace{old}{new}`.
