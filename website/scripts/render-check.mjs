/**
 * Check the playground renderer against the fixtures the PDF tests compile.
 *
 * The renderer is a second implementation of behaviour `texchanges.sty`
 * defines, so it is held to the same expectations as the compiled output:
 * every token `scripts/test.sh` requires in a mode must appear, and every token
 * it forbids must not. Run through `make check TEST=playground`.
 */

import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

import { render } from '../src/scripts/txrender.js';

const root = join(dirname(fileURLToPath(import.meta.url)), '..', '..');
const failures = [];

/**
 * Each entry mirrors an assertion block in `scripts/test.sh`. The `review`
 * expectations for `review.tex` come from `case_modes`; the ones for
 * `features.tex` come from `case_features`, `case_status_final` and
 * `case_status_original`.
 */
const EXPECTATIONS = [
  {
    fixture: 'tests/review.tex',
    modes: {
      review: {
        present: ['OLDTOKEN', 'NEWTOKEN', 'ADDTOKEN', 'REMOVETOKEN', 'COMMENTTOKEN', 'HIGHLIGHTTOKEN'],
        absent: [],
      },
      final: {
        present: ['NEWTOKEN', 'ADDTOKEN', 'HIGHLIGHTTOKEN'],
        absent: ['OLDTOKEN', 'REMOVETOKEN', 'COMMENTTOKEN'],
      },
      original: {
        present: ['OLDTOKEN', 'REMOVETOKEN', 'HIGHLIGHTTOKEN'],
        absent: ['NEWTOKEN', 'ADDTOKEN', 'COMMENTTOKEN'],
      },
    },
  },
  {
    fixture: 'tests/features.tex',
    modes: {
      review: {
        present: ['OLDPENDING', 'NEWPENDING', 'NEWACCEPTED', 'OLDREJECTED', 'HIGHLIGHTED', 'COMMENTED'],
        absent: ['OLDACCEPTED', 'NEWREJECTED'],
      },
      final: {
        present: ['NEWPENDING', 'NEWACCEPTED', 'OLDREJECTED', 'ADDED', 'HIGHLIGHTED'],
        absent: ['OLDPENDING', 'OLDACCEPTED', 'NEWREJECTED', 'REMOVED', 'COMMENTED'],
      },
      original: {
        present: ['OLDPENDING', 'OLDACCEPTED', 'OLDREJECTED', 'REMOVED', 'HIGHLIGHTED'],
        absent: ['NEWPENDING', 'NEWACCEPTED', 'NEWREJECTED', 'ADDED', 'COMMENTED'],
      },
    },
  },
];

for (const { fixture, modes } of EXPECTATIONS) {
  const source = readFileSync(join(root, fixture), 'utf8');
  for (const [mode, { present, absent }] of Object.entries(modes)) {
    const { text } = render(source, mode);
    for (const token of present) {
      if (!text.includes(token)) failures.push(`${fixture} ${mode}: missing ${token}`);
    }
    for (const token of absent) {
      if (text.includes(token)) failures.push(`${fixture} ${mode}: unexpected ${token}`);
    }
  }
}

// The legacy reviewer label is an optional argument without `=`, which the
// merge CLI once discarded. The renderer must keep it visible in review mode.
const legacy = render('\\begin{document}\\txreplace[Reviewer]{a}{b}\\end{document}', 'review');
if (!legacy.text.includes('a') || !legacy.html.includes('Reviewer')) {
  failures.push('legacy label: [Reviewer] did not survive');
}

// An unknown command stays visible rather than being swallowed silently.
const unknown = render('\\begin{document}\\emph{KEEPME}\\end{document}', 'review');
if (!unknown.text.includes('KEEPME')) failures.push('unknown command: content was dropped');

if (failures.length > 0) {
  for (const failure of failures) console.error(failure);
  process.exit(1);
}
console.log('playground renderer matches the compiled fixtures');
