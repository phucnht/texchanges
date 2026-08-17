---
title: Installation
description: Installer Texchanges localement ou l’utiliser sur Overleaf.
---

## Distributions TeX

Texchanges est distribué par TeX Live. Installez-le avec le gestionnaire de paquets de la distribution si nécessaire, puis chargez-le normalement :

```latex
\usepackage[review]{texchanges}
```

La publication sur CTAN et la version de TeX Live choisie pour un projet sont deux choses distinctes. Téléversez `texchanges.sty` lorsque la version active de TeX Live ne contient pas le paquet.

## Solution de repli pour Overleaf

Téléchargez `texchanges-overleaf.zip` depuis la dernière version publiée sur GitHub et téléversez-la comme projet. L’archive contient `texchanges.sty` comme repli, `texchanges-explicit-review.tex`, deux révisions pour la comparaison automatique, `texchanges-review.tex`, et `latexmkrc`. Laissez la ligne de chargement du paquet inchangée.

## Installation manuelle

Placez `texchanges.sty` dans le répertoire du document ou dans une arborescence `texmf` locale, puis actualisez la base de données des noms de fichiers si votre distribution l’exige.
