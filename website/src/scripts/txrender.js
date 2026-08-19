/**
 * A JavaScript approximation of how texchanges renders a document in each mode.
 *
 * This exists so the website can show what the package does without shipping a
 * TeX engine to the browser. It is a second implementation of behaviour that
 * `texchanges.sty` defines, which is a real risk, so `scripts/test.sh` runs the
 * `playground` case over the same fixtures the PDF tests use and asserts the
 * same tokens. If the package changes and this does not, the suite fails.
 *
 * The selection table below is transcribed from `\tx_render:nn` and the
 * argument order from the `\NewDocumentCommand` definitions of the five public
 * commands. It is not a guess at what the package probably does.
 */

/** Commands and how many mandatory arguments each takes. */
const COMMANDS = {
  txadd: { type: 'added', args: 1 },
  txremove: { type: 'removed', args: 1 },
  txreplace: { type: 'replaced', args: 2 },
  txhighlight: { type: 'highlighted', args: 1 },
  txcomment: { type: 'commented', args: 1 },
  // The package defines these short forms as aliases when the names are free.
  add: { type: 'added', args: 1 },
  remove: { type: 'removed', args: 1 },
  replace: { type: 'replaced', args: 2 },
  highlight: { type: 'highlighted', args: 1 },
  comment: { type: 'commented', args: 1 },
};

/** Commands consumed for their side effect, mapped to their mandatory argument
    count. They produce no visible output here; the change reports they drive
    are a compiled-document feature. */
const SILENT = {
  txdefineauthor: 1,
  txlistofchanges: 0,
  txsetanonymousname: 1,
  pagestyle: 1,
};

/** LaTeX colour names the examples use, mapped to something a browser knows. */
const COLORS = {
  orange: '#a54800',
  green: '#1b6b32',
  blue: '#0057b8',
  red: '#b3261e',
  violet: '#6b3fa0',
  purple: '#6b3fa0',
  teal: '#0f6b6b',
  brown: '#7a4a1e',
  magenta: '#a3197a',
  cyan: '#0f6b6b',
  black: '#1a1a1a',
};

const FALLBACK_COLORS = ['#a54800', '#0057b8', '#1b6b32', '#6b3fa0', '#a3197a'];

/**
 * Which text a change contributes, given the mode and its status.
 *
 * Transcribed from `\tx_render:nn`, where argument 1 is the old text and
 * argument 2 the new one:
 *
 *   original          removed and replaced keep the old text, highlighted keeps
 *                     its text, added and commented vanish.
 *   final             the same when the change is rejected; otherwise added,
 *                     replaced and highlighted keep the new text and removed
 *                     and commented vanish.
 *   review            pending changes render as markup. Accepted and rejected
 *                     ones render as resolved plain text, exactly as final and
 *                     original would.
 */
export function selectRendering(mode, status, type) {
  if (mode === 'review' && status === 'pending') return 'markup';
  const keepsOld = mode === 'original' || status === 'rejected';
  if (keepsOld) {
    if (type === 'removed' || type === 'replaced') return 'old';
    if (type === 'highlighted') return 'new';
    return 'none';
  }
  if (type === 'added' || type === 'replaced' || type === 'highlighted') return 'new';
  return 'none';
}

/**
 * Read a balanced group starting at `source[start]`, which must be the opening
 * delimiter. Brackets are only closed at brace depth zero, so an option value
 * such as `comment={a, b]}` survives.
 */
function readGroup(source, start, open, close) {
  if (source[start] !== open) return null;
  let braces = 0;
  let depth = 0;
  for (let i = start; i < source.length; i += 1) {
    const c = source[i];
    if (c === '\\') {
      i += 1;
      continue;
    }
    if (c === '{') braces += 1;
    else if (c === '}') braces -= 1;
    if (open === '[' && braces > 0) continue;
    if (c === open) depth += 1;
    else if (c === close) {
      depth -= 1;
      if (depth === 0) return { value: source.slice(start + 1, i), next: i + 1 };
    }
  }
  return null;
}

/** Split on commas that sit outside braces. */
function splitTopLevel(text) {
  const parts = [];
  let depth = 0;
  let current = '';
  for (let i = 0; i < text.length; i += 1) {
    const c = text[i];
    if (c === '{') depth += 1;
    if (c === '}') depth -= 1;
    if (c === ',' && depth === 0) {
      parts.push(current);
      current = '';
      continue;
    }
    current += c;
  }
  parts.push(current);
  return parts.map((p) => p.trim()).filter((p) => p.length > 0);
}

function unwrap(value) {
  const trimmed = value.trim();
  return trimmed.startsWith('{') && trimmed.endsWith('}') ? trimmed.slice(1, -1) : trimmed;
}

/**
 * Parse an optional argument. A bracket group without `=` is the legacy
 * reviewer label rather than a key list, which is the form
 * `\txreplace[Reviewer]{old}{new}` uses.
 */
function parseOptions(raw) {
  if (raw === undefined || raw.trim() === '') return {};
  if (!raw.includes('=')) return { label: raw.trim() };
  const options = {};
  for (const pair of splitTopLevel(raw)) {
    const eq = pair.indexOf('=');
    if (eq === -1) continue;
    options[pair.slice(0, eq).trim()] = unwrap(pair.slice(eq + 1));
  }
  return options;
}

function latexColor(value, index) {
  if (!value) return FALLBACK_COLORS[index % FALLBACK_COLORS.length];
  // `green!50!black` and friends: the first name carries the hue.
  const base = value.split('!')[0].trim().toLowerCase();
  return COLORS[base] || FALLBACK_COLORS[index % FALLBACK_COLORS.length];
}

function escapeHtml(text) {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

/** Strip the handful of TeX spellings that would otherwise show as source. */
function plainText(text) {
  return text
    .replace(/\\[,;:!]/g, ' ')
    .replace(/~/g, ' ')
    .replace(/\\%/g, '%')
    .replace(/\\&/g, '&')
    .replace(/\\_/g, '_');
}

/**
 * Render a document body.
 *
 * @param {string} source  the body of a LaTeX document, without the preamble
 * @param {'review'|'final'|'original'} mode
 * @returns {{html: string, text: string, changes: number, pending: number}}
 */
export function render(source, mode) {
  const authors = new Map();
  let authorIndex = 0;

  /** Everything between `\begin{document}` and `\end{document}`, if present. */
  const begun = source.indexOf('\\begin{document}');
  const ended = source.indexOf('\\end{document}');
  let preamble = '';
  let body = source;
  if (begun !== -1) {
    preamble = source.slice(0, begun);
    body = source.slice(begun + '\\begin{document}'.length, ended === -1 ? undefined : ended);
  }

  // Author definitions are read from wherever they appear, since the preamble
  // is where the examples put them.
  const definition = /\\txdefineauthor\s*(\[[^\]]*\])?\s*\{([^}]*)\}/g;
  for (const match of `${preamble}${body}`.matchAll(definition)) {
    const options = parseOptions(match[1] ? match[1].slice(1, -1) : '');
    authors.set(match[2].trim(), {
      name: options.name || match[2].trim(),
      color: latexColor(options.color, authorIndex),
    });
    authorIndex += 1;
  }

  const html = [];
  const text = [];
  let changes = 0;
  let pending = 0;

  const push = (htmlPart, textPart) => {
    html.push(htmlPart);
    text.push(textPart === undefined ? htmlPart : textPart);
  };

  let literal = '';
  const flushLiteral = () => {
    if (literal === '') return;
    const clean = plainText(literal);
    // A blank line is a paragraph break, as in LaTeX.
    push(escapeHtml(clean).replace(/\n[ \t]*\n/g, '</p><p>'), clean);
    literal = '';
  };

  for (let i = 0; i < body.length; ) {
    if (body[i] !== '\\') {
      literal += body[i];
      i += 1;
      continue;
    }

    const name = /^\\([a-zA-Z]+)/.exec(body.slice(i));
    if (!name) {
      // An escaped character such as `\%`.
      literal += body.slice(i, i + 2);
      i += 2;
      continue;
    }

    const command = name[1];
    const known = COMMANDS[command];
    const silent = SILENT[command];
    if (!known && silent === undefined) {
      literal += name[0];
      i += name[0].length;
      continue;
    }

    let cursor = i + name[0].length;
    while (body[cursor] === ' ' || body[cursor] === '\n') cursor += 1;

    let optionText;
    const optional = readGroup(body, cursor, '[', ']');
    if (optional) {
      optionText = optional.value;
      cursor = optional.next;
      while (body[cursor] === ' ' || body[cursor] === '\n') cursor += 1;
    }

    const wanted = known ? known.args : silent;
    const args = [];
    let complete = true;
    for (let a = 0; a < wanted; a += 1) {
      const group = readGroup(body, cursor, '{', '}');
      if (!group) {
        complete = false;
        break;
      }
      args.push(group.value);
      cursor = group.next;
    }

    if (!complete) {
      // Leave an unfinished command visible rather than swallowing input.
      literal += body.slice(i, cursor);
      i = cursor;
      continue;
    }

    if (!known) {
      flushLiteral();
      i = cursor;
      continue;
    }

    const options = parseOptions(optionText);
    const status = options.status || 'pending';
    const type = known.type;
    const old = type === 'added' || type === 'commented' ? '' : args[0];
    const fresh = type === 'replaced' ? args[1] : args[0];

    const author = options.author ? authors.get(options.author) : undefined;
    const label = options.label || (author ? options.author : '');
    // Author colours come from `\txdefineauthor` and are therefore fixed hexes,
    // chosen against paper. The stylesheet lifts them for the dark theme rather
    // than the renderer guessing which theme is on screen.
    const color = author ? author.color : 'var(--tx-blue)';

    flushLiteral();
    changes += 1;
    if (status === 'pending') pending += 1;

    const choice = selectRendering(mode, status, type);
    const oldText = plainText(old);
    const newText = plainText(fresh);

    if (choice === 'old') push(escapeHtml(oldText), oldText);
    else if (choice === 'new') push(escapeHtml(newText), newText);
    else if (choice === 'markup') {
      const tag = label
        ? `<sup class="tx-play__author" style="--tx-author-color:${color}">${escapeHtml(label)}</sup>`
        : '';
      if (type === 'added') {
        push(`<ins class="tx-play__ins" style="--tx-author-color:${color}">${escapeHtml(newText)}</ins>${tag}`, newText);
      } else if (type === 'removed') {
        push(`<del class="tx-play__del" style="--tx-author-color:${color}">${escapeHtml(oldText)}</del>${tag}`, oldText);
      } else if (type === 'replaced') {
        push(
          `<del class="tx-play__del tx-play__del--fixed">${escapeHtml(oldText)}</del>` +
            `<ins class="tx-play__ins tx-play__ins--fixed">${escapeHtml(newText)}</ins>${tag}`,
          `${oldText} ${newText}`
        );
      } else if (type === 'highlighted') {
        push(`<mark class="tx-play__mark">${escapeHtml(newText)}</mark>${tag}`, newText);
      } else {
        push(`<span class="tx-play__comment">[${escapeHtml(newText)}]</span>`, newText);
      }
      if (options.comment) {
        const note = plainText(options.comment);
        push(`<span class="tx-play__comment">[${escapeHtml(note)}]</span>`, note);
      }
    }

    i = cursor;
  }
  flushLiteral();

  return {
    html: `<p>${html.join('')}</p>`,
    text: text.join(''),
    changes,
    pending,
  };
}
