---
title: Installation
description: Install Texchanges locally or use it on Overleaf.
---

## TeX distributions

After Texchanges is available in your distribution, install it with the distribution's package manager. Then load it normally:

```latex
\usepackage[review]{texchanges}
```

CTAN publication and TeX distribution updates are separate processes. A new CTAN package can take additional time to reach TeX Live, MiKTeX, and Overleaf.

## Overleaf fallback

Download `texchanges.sty` from the latest GitHub release and upload it beside your main `.tex` file. Keep the package line unchanged.

## Manual installation

Place `texchanges.sty` in the document directory or in a local `texmf` tree, then refresh the filename database if your distribution requires it.
