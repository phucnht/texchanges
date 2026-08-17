# Architecture notes

## The package

`texchanges.sty` is a single expl3 file. The flow for every change command (`\txadd`, `\txremove`, `\txreplace`, `\txhighlight`, `\txcomment`) is:

1. `\tx_change_parse:n` reads the optional argument — either a key–value list (`author`, `id`, `comment`, `status`) or a bare legacy label — and validates it (`\tx_change_validate:` rejects duplicate IDs and undefined authors).
2. `\tx_record:nn` runs only in `review` mode: it bumps per-`author/type/status` counters and writes a `\txreportline` entry to the list auxiliary file (`\jobname.txc` by default).
3. `\tx_render:nn` picks the visible output from the mode (`review`/`final`/`original`) and the change status (`pending`/`accepted`/`rejected`).

`\txlistofchanges` replays the auxiliary data: `style=list` reads `\jobname.txc` through `\@starttoc`, while the summary styles read the counters written at end-of-document to `\jobname.txs` (`\txsummaryentry` lines). This is why detailed reports need two compile runs.

Localization goes through babel caption hooks: `\tx_install_localizations:` adds a `\tx_localize:n {key=value,...}` call to each known `\captions<language>`. It runs both at load time and at begin-document (guarded by a property list so it installs once), which covers babel loaded before or after texchanges. Translated strings use `~` for spaces because the package body is tokenized under expl3 catcodes.

## The merge CLI

`scripts/texchanges-merge.py` is an independent reimplementation of the markup grammar (it does not run TeX). `parse_changes` scans for the commands in the `COMMANDS` table while skipping comments and verbatim environments, and `transform` either rewrites `status=` keys in place or merges the markup away. It intentionally refuses to add a status to legacy `[Label]` options, because the package cannot parse a mixed `[Label,status=...]` argument.

The CLI must stay standard-library-only so TeX Live can ship it as a single script; `tests/test_merge.py` enforces the import list.

## Versioning

`texchanges.sty`'s `\ProvidesExplPackage` line is the single source of truth. `scripts/ctan-release.sh` parses it, and the `versions` test case asserts that `scripts/texchanges-merge.py`, `build.lua`, and `website/package.json` agree.
