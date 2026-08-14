---
title: Quick start
description: Add review markup and select a document mode.
---

```latex
\documentclass{article}
\usepackage[review]{texchanges}

\begin{document}
This \txreplace{draft}{revised} sentence contains a replacement.
This paragraph has \txadd{new text} and \txremove{old text}.
\end{document}
```

Compile in `review` mode to show markup. Change the option to `final` to render proposed text or `original` to render the initial document.

The replacement command always uses `\txreplace{old}{new}` in the native API.
