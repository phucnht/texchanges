/**
 * Copy the package into the site's static assets.
 *
 * The playground's Open in Overleaf button carries texchanges.sty with the
 * snippet, because Overleaf rebuilds its TeX Live once a year and a package
 * that reached CTAN after the freeze is not installed there yet. Copying at
 * build time rather than committing a second copy keeps the two from drifting.
 */

import { copyFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const source = join(here, '..', '..', 'texchanges.sty');
const target = join(here, '..', 'public', 'texchanges.sty');

mkdirSync(dirname(target), { recursive: true });
copyFileSync(source, target);
