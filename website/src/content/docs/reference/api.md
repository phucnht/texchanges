---
title: API reference
description: Native commands, options, reports, and runtime setters.
---

## Package options

- Modes: `review`, `draft`, `final`, `original`, or `mode=<mode>`.
- Presets: `markup=texchanges|default|underlined|bfit|nocolor`.
- Renderers: `addedmarkup`, `deletedmarkup`, `highlightmarkup`, `commentmarkup`, `authormarkup`, `authormarkupposition`, and `authormarkuptext`.
- Compatibility: `compat=changes` and `commandnameprefix=none|ifneeded|always`.
- Dependency pass-through: `xcolor={...}`, `ulem={...}`, `todonotes={...}`, and `truncate={...}`.

## Native commands

```latex
\txdefineauthor[name=<name>,color=<color>]{<author-id>}
\txsetanonymousname{<name>}

\txadd[<keys>]{<new>}
\txremove[<keys>]{<old>}
\txreplace[<keys>]{<old>}{<new>}
\txhighlight[<keys>]{<text>}
\txcomment[<keys>]{<comment>}
```

Keys are `author`, `id`, `comment`, and `status=pending|accepted|rejected`.

## Report command

```latex
\txlistofchanges[
  style=list|summary|compactsummary,
  title={<title>},
  show={added,removed,replaced,highlighted,commented},
  status={pending,accepted,rejected},
  author={<author IDs>}
]
```

Report setters are `\txsettruncatewidth`, `\txsetsummarywidth`, `\txsetsummarytowidth`, `\txsetlocextension`, and `\txsetsocextension`.

Runtime renderer hooks are `\txsetaddedmarkup`, `\txsetdeletedmarkup`, `\txsethighlightmarkup`, `\txsetcommentmarkup`, `\txsetauthormarkup`, `\txsetauthormarkupposition`, and `\txsetauthormarkuptext`.
