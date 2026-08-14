---
title: changes compatibility
description: Use documented changes-style commands through an opt-in layer.
---

```latex
\usepackage[review,compat=changes]{texchanges}
\definechangesauthor[name={Phuc Nguyen},color=orange]{phuc}
\replaced[id=phuc,changeid=R12]{new text}{old text}
```

Compatibility mode provides `\added`, `\deleted`, `\replaced{new}{old}`, `\highlight`, `\comment`, author definitions, reports, and documented setter aliases.

The compatibility `id` key identifies an author. Use `changeid` for a unique Texchanges change ID. `commandnameprefix=none|ifneeded|always` controls compatibility commands only.
