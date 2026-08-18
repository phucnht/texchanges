# Releasing

## Branches

- `develop` is the integration branch. All feature and fix work lands here first, through a feature branch and a pull request.
- `main` is production: it holds released code and is what the documentation site deploys from. It moves at releases, and for documentation hotfixes (see below).
- Feature branches are named `feat/<topic>`, `fix/<topic>`, or `docs/<topic>` and branch from `develop`.

`main` requires a pull request with green checks. Nobody pushes to it directly, including the maintainer.

### Documentation hotfixes

Website and documentation corrections may go to `main` between releases, because production serves the site from `main` and a visible error should not wait for the next package release. Open a website-only pull request against `main`, then merge `main` back into `develop`. Anything touching `texchanges.sty`, the CLI, tests, or packaging is not a documentation hotfix and follows the release path below.

## Release checklist

Nothing is tagged before the suite passes **and** the package has been exercised by hand. Automation catches regressions in what it already knows about; the manual pass is what catches the rest.

### 1. Prepare on `develop`

- All intended work merged; CI green on `develop`.
- Bump the version in `texchanges.sty` (`\ProvidesExplPackage`, including the date). The `versions` test case fails until `scripts/texchanges-merge.py`, `build.lua`, and `website/package.json` agree, so update those too.
- Update `CITATION.cff` (`version`, `date-released`).
- Move the `CHANGELOG.md` `[Unreleased]` entries into a dated section and add the compare link.

### 2. Automated verification

```bash
make release-check
```

This runs the full suite (all modes, metadata, reports, styles, compatibility, CLI, three engines, `l3build` log-level tests, automatic `latexdiff`), builds and validates the Overleaf bundle and the CTAN archive, builds the website, and writes `dist/SHA256SUMS`.

### 3. Manual verification

Follow [manual-testing.md](manual-testing.md). It covers what the suite cannot see: colour and
position in the compiled PDF, the three document modes, the CLI filters and the legacy-label case,
the Overleaf bundle with both Main-document choices and an older TeX Live year, and the website in
all three languages.

### 4. Merge and tag

- Open a pull request from `develop` to `main`; wait for green checks; merge.
- Tag the release commit on `main` and push the tag:

```bash
git tag -a vX.Y.Z -m "Texchanges X.Y.Z"
git push origin refs/tags/vX.Y.Z
```

- Publish the release. `release.yml` verifies the tag matches the version in `texchanges.sty`, rebuilds everything, and attaches the CTAN archive, its checksum, the Overleaf bundle, `SHA256SUMS`, and the manual.

```bash
gh release create vX.Y.Z --title "Texchanges X.Y.Z" --notes "..."
```

- Download the attached assets and verify them before announcing:

```bash
shasum -a 256 -c SHA256SUMS
```

### 5. After the release

- Upload the CTAN archive at <https://ctan.org/upload>. The announcement wording is prepared separately by the maintainer.
- Merge `main` back into `develop` so the release commit and any hotfixes are shared.

## Rollback

Released tags and `main` are protected against deletion and force pushes, so a bad release is corrected by releasing again, not by rewriting history. Revert the offending commit on `main` through a pull request, then cut a patch release.
