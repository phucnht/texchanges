---
title: Démarrage rapide
description: Ajouter du balisage de relecture et choisir un mode de document.
---

```latex
\documentclass{article}
\usepackage[review]{texchanges}

\begin{document}
This \txreplace{draft}{revised} sentence contains a replacement.
This paragraph has \txadd{new text} and \txremove{old text}.
\end{document}
```

Compilez en mode `review` pour afficher le balisage. Passez l’option à `final` pour composer le texte proposé, ou à `original` pour composer le document initial.

Dans l’API native, la commande de remplacement suit toujours l’ordre `\txreplace{ancien}{nouveau}`.
