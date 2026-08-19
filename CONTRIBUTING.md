# Contributing to Texchanges

Thanks for considering contributing to Texchanges: feedback, fixes and ideas are all useful. Texchanges is maintained by one person, so help of any kind is genuinely welcome. Below are a few pointers to help things along.

## Bugs and feature requests

Please log both through the [issues](https://github.com/phucnht/texchanges/issues) page. For a bug, a short document that shows the problem is worth more than anything else you can send, along with your TeX Live year, your engine, and any other packages loaded, since interactions with other packages are a common cause.

Feature requests are welcome too. The [roadmap](https://texchanges.dev/roadmap/) shows where the package is heading, and something that fits it will move faster.

## Good places to start

- New fixtures in `tests/` covering behaviour the suite misses.
- Localization: adding a babel language to the caption table in `texchanges.sty`, or correcting a translation that reads badly. Corrections from native speakers are especially welcome.
- Documentation: `README.md`, the manual `texchanges-doc.tex`, or the website under `website/src/content/docs/`.
- Gaps in the `changes` compatibility layer (`compat=changes`).

For anything larger, such as a new command or package option, open an issue first to talk the design through, so you do not spend an evening on something that conflicts with a plan you could not have known about.

## Making a change

1. Fork the repository and branch from `develop`.
2. Make the change and run `make check`. The suite needs `pdflatex`, `xelatex`, `lualatex`, `latexdiff`, `pdftotext`, `perl` and `python3` on your `PATH`; a full TeX Live installation provides all but the last.
3. Add a fixture for new behaviour, exercised in `review`, `final` and `original` where the behaviour differs by mode. CLI changes want a case in `tests/test_merge.py`.
4. Add a line to `CHANGELOG.md` saying what a user will notice.
5. Open a pull request against `develop`, one fix or one feature at a time.

CI runs the same `make check` across TeX Live 2023 onwards, plus a website build. Expect a first reply within a week or so; if it goes quiet, a ping is welcome.

`main` holds released code and is what the documentation site deploys from; it takes release merges from `develop` and documentation fixes. [docs/dev/releasing.md](docs/dev/releasing.md) has the branch layout and the release checklist.

## A few things to bear in mind

- The public commands `\txadd`, `\txremove`, `\txreplace`, `\txcomment` and `\txhighlight` are in released documents, so they stay backward compatible.
- `\txreplace{old}{new}` argument order is fixed. Only the `changes` compatibility layer uses the reversed order, because that is what `changes` itself does.
- The short aliases `\add`, `\remove`, `\replace`, `\highlight` and `\comment` must never overwrite a command another package has already defined.
- Compiled output does not belong in the repository: no PDFs, aux files, generated diffs or zips.

## Code style

`texchanges.sty` is expl3. Follow what is already in the file: `\g_tx_...` and `\l_tx_...` naming, `\cs_new_protected:Npn` for procedures, and `~` for spaces in text produced inside `\ExplSyntaxOn`.

`scripts/texchanges-merge.py` uses only the standard library, and `tests/test_merge.py` enforces that. Markdown prose is written one paragraph per physical line, without hard wrapping.

## Using AI tools

Use whatever tools help you, including AI assistants. What matters is that you understand the change, can say why it is right, and have run the suite against it. If someone asks why a patch does what it does, "the model wrote it" is not an answer, so read anything a tool hands you before sending it on.

Please write the pull request description in your own words. It is what tells a reviewer what you were trying to do.
