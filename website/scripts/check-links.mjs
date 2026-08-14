import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const dist = fileURLToPath(new URL('../dist/', import.meta.url));
const siteBase = '/texchanges/';
const pages = [];

function collect(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const path = join(directory, entry.name);
    if (entry.isDirectory()) collect(path);
    else if (entry.name.endsWith('.html')) pages.push(path);
  }
}

function targetFor(href) {
  const clean = href.split(/[?#]/, 1)[0];
  if (!clean.startsWith(siteBase)) return null;
  const local = clean.slice(siteBase.length);
  return join(dist, local.endsWith('/') || local === '' ? local : '',
    local.endsWith('/') || local === '' ? 'index.html' : local);
}

collect(dist);
const broken = [];

for (const page of pages) {
  const html = readFileSync(page, 'utf8');
  for (const match of html.matchAll(/href="([^"]+)"/g)) {
    const target = targetFor(match[1]);
    if (target && !existsSync(target)) {
      broken.push(`${relative(dist, page)} -> ${match[1]}`);
    }
  }
}

if (broken.length) {
  console.error(`Broken internal links:\n${broken.join('\n')}`);
  process.exit(1);
}

console.log(`Checked internal links in ${pages.length} generated pages.`);
