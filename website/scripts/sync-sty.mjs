/**
 * Copy the package into the site's static assets.
 *
 * The playground's Open in Overleaf button carries texchanges.sty with the
 * snippet, so the compiled result matches the version this site documents
 * rather than whichever version the compiler has installed. Copying at build
 * time rather than committing a second copy keeps the two from drifting.
 */

import { copyFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const source = join(here, '..', '..', 'texchanges.sty');
const target = join(here, '..', 'public', 'texchanges.sty');

mkdirSync(dirname(target), { recursive: true });
copyFileSync(source, target);
