// Chat translation check: runs the chat panel's own engine (tgui/rogue_panel/localization/translate.ts, under
// happy-dom from tgui/node_modules) over the chat lines of the DM code, as the server would send them, and prints what
// stays English.
//
// The dictionary is built as localization/dictionary.dm builds it. The lines are read from the code: the messages of
// to_chat, visible_message, audible_message, balloon_alert(_to_viewers), message_admins, say, examine (". +=" in an
// examine proc, examine_list +=) and of the module's own procs that pass a parameter on to one of these (found by
// the script). A message is a whole call argument: span_*() wraps it in its span, as the macro does; a ternary or a
// pick() inside it gives one variant per branch; a local variable gives the strings assigned to it in the proc, a var
// of a type the strings the module's types set it to, a one-line formatter proc its return. Other interpolations get
// samples: a character name (Cyrillic, with cases, as a player sets them), an item and a body part from the dictionary,
// a number, a pronoun. Pronouns go in four passes: he, she, they, it. What the script cannot follow stays a sample
// and is printed in braces next to the line.
//
// A line is "ok" when no English word is left in every variant and pass, "missing" when nothing changed, "partial"
// otherwise. Balloon alerts and speech are counted apart: a balloon is drawn over the map (maptext), not in the chat,
// and the panel never sees it; speech reaches the chat as its own text node inside TG's speech markup.
//
//   bun modular_redtard/tools/chat_check.ts [folder ...] [options]
//     folder           a folder or file under the root, e.g. combat or rockhill/ported (default: all)
//     --list=WHAT      print the lines: missing, partial, ok, unresolved, apart (balloons, speech), all
//     --save=FILE      save every English variant with its translation, and the messages read (file and DM source)
//     --diff=FILE      compare with a saved run and print every translation that changed: a pattern taking a line
//                      it should not shows here (run it with --root=code too: TG's lines are the bigger corpus)
//     --root=DIR       scan DIR instead of modular_redtard, e.g. --root=code: TG's lines as a regression corpus
//     --strings=DIR    read the dictionary from DIR instead of localization/strings (an older copy, to compare)
//     --kinds=K,...    only these kinds (chat, visible, audible, examine, admin, wrapper, balloon, say)
//     --one-pass       only the "he" pass
//     --scope=FILE     only the messages a saved run (--save) already had, by file and DM source: a baseline, so lines
//                      that other work added or rewrote since are left out
//     --brief          with --list: the "he" pass only, six variants at most
//     --warnings       print the dictionary's warnings (a key in two files, a bad line or regex)
import {
  existsSync,
  readdirSync,
  readFileSync,
  statSync,
  writeFileSync,
} from 'node:fs';
import { join, relative, resolve } from 'node:path';

import { Window } from '../../tgui/node_modules/happy-dom/lib/index.js';

const MODULE = resolve(import.meta.dir, '..');
const REPO = resolve(MODULE, '..');

// --- options ---------------------------------------------------------------------------------------------------------
const options: Record<string, string> = {};
const targets: string[] = [];
for (const arg of process.argv.slice(2)) {
  const option = arg.match(/^--([\w-]+)(?:=(.*))?$/);
  if (option) {
    options[option[1]] = option[2] ?? 'true';
  } else {
    targets.push(arg.replace(/\\/g, '/').replace(/\/$/, ''));
  }
}
const ROOT = options.root ? resolve(REPO, options.root) : MODULE;
const LIST = new Set((options.list ?? '').split(',').filter(Boolean));
const KINDS = options.kinds ? new Set(options.kinds.split(',')) : null;
const STRINGS = options.strings
  ? resolve(REPO, options.strings)
  : join(MODULE, 'localization', 'strings');

// --- DOM for translate.ts ------------------------------------------------------------------------------------------------
const window = new Window();
const globals = globalThis as Record<string, unknown>;
globals.window = window;
globals.document = window.document;
globals.Node = window.Node;
globals.Element = window.Element;
globals.HTMLElement = window.HTMLElement;
const { loadDeclensions, loadDictionary, setLang, translateNode } =
  await import('../tgui/rogue_panel/localization/translate.ts');

// --- dictionary, as localization/dictionary.dm builds it ---------------------------------------------------------------
type Cases = Partial<
  Record<'nom' | 'gen' | 'dat' | 'acc' | 'ins' | 'pre', string>
>;
const CASES = ['nom', 'gen', 'dat', 'acc', 'ins', 'pre'] as const;
const warnings: string[] = [];

function stringsPairs(file: string): [string, string][] {
  const path = join(STRINGS, file);
  if (!existsSync(path)) {
    warnings.push(`missing strings file ${file}`);
    return [];
  }
  const pairs: [string, string][] = [];
  readFileSync(path, 'utf8')
    .split('\n')
    .forEach((raw, index) => {
      const line = raw.trim();
      if (!line || line.startsWith('#')) return;
      const at = line.indexOf(' = ');
      if (at < 0) {
        warnings.push(`${file}:${index + 1} has no " = ", skipped`);
        return;
      }
      const key = line.slice(0, at).trim();
      const value = line.slice(at + 3).trim();
      if (key && value)
        pairs.push([
          key.replaceAll('\\n', '\n'),
          value.replaceAll('\\n', '\n'),
        ]);
    });
  return pairs;
}

/** Later files win a collision, as the comment in dictionary.dm says; a collision between files is reported. */
function mergeInto<T>(
  target: Record<string, T>,
  from: Record<string, T>,
  file: string,
  owners: Record<string, string>,
) {
  for (const key in from) {
    if (key in target && owners[key] !== file) {
      warnings.push(`"${key}" is in both ${owners[key]} and ${file}`);
    }
    target[key] = from[key];
    owners[key] = file;
  }
}

function stringsNouns(file: string): Record<string, Cases> {
  const nouns: Record<string, Cases> = {};
  for (const [key, value] of stringsPairs(file)) {
    const forms = value.split('|');
    if (forms.length !== CASES.length) {
      warnings.push(
        `${file} "${key}" lists ${forms.length} forms, expected ${CASES.length}`,
      );
      continue;
    }
    const cases: Cases = {};
    CASES.forEach((name, index) => {
      const form = forms[index].trim();
      if (form) cases[name] = form;
    });
    if (Object.keys(cases).length) nouns[key] = cases;
  }
  return nouns;
}

function stringsTable(file: string): Record<string, string> {
  const table: Record<string, string> = {};
  for (const [key, value] of stringsPairs(file)) table[key] = value;
  return table;
}

const nouns: Record<string, Cases> = {};
const nounOwners: Record<string, string> = {};
for (const file of [
  'items.txt',
  'module_items.txt',
  'nouns.txt',
  'module_nouns.txt',
]) {
  mergeInto(nouns, stringsNouns(file), file, nounOwners);
}
const fragments: Record<string, string> = {};
const fragmentOwners: Record<string, string> = {};
for (const file of [
  'fragments.txt',
  'speech.txt',
  'medical.txt',
  'world.txt',
  'status.txt',
  'module_fragments.txt',
]) {
  mergeInto(fragments, stringsTable(file), file, fragmentOwners);
}
const patterns: { re: string; ru: string }[] = [];
for (const file of ['module_patterns.txt', 'patterns.txt']) {
  for (const [re, ru] of stringsPairs(file)) {
    try {
      new RegExp(re);
    } catch (error) {
      warnings.push(`${file}: bad regex ${re}: ${(error as Error).message}`);
    }
    patterns.push({ re, ru });
  }
}
loadDictionary({
  version: 1,
  nouns,
  honorifics: stringsNouns('honorifics.txt'),
  fragments,
  patterns,
});
setLang('ru');

// --- samples -------------------------------------------------------------------------------------------------------------
// Character names come with the cases their players give them; written in Cyrillic, so a name the pattern leaves
// alone is no English left behind. Items and body parts are dictionary words: an undeclined one stays English.
const SAMPLE_NAMES: [string, Cases][] = [
  [
    'Ивар',
    {
      nom: 'Ивар',
      gen: 'Ивара',
      dat: 'Ивару',
      acc: 'Ивара',
      ins: 'Иваром',
      pre: 'Иваре',
    },
  ],
  [
    'Марта',
    {
      nom: 'Марта',
      gen: 'Марты',
      dat: 'Марте',
      acc: 'Марту',
      ins: 'Мартой',
      pre: 'Марте',
    },
  ],
  [
    'Бьорн',
    {
      nom: 'Бьорн',
      gen: 'Бьорна',
      dat: 'Бьорну',
      acc: 'Бьорна',
      ins: 'Бьорном',
      pre: 'Бьорне',
    },
  ],
];
loadDeclensions(Object.fromEntries(SAMPLE_NAMES));
const SAMPLES: Record<SlotKind, string[]> = {
  name: SAMPLE_NAMES.map(([name]) => name),
  item: ['sword', 'torch', 'apple'],
  zone: ['left arm', 'head', 'chest'],
  number: ['5', '3', '12'],
  pronoun: [],
  dynamic: SAMPLE_NAMES.map(([name]) => name),
};
/** Latin words a translated line may keep. */
const LATIN_ALLOWED = new Set([
  'PQ',
  'OOC',
  'LOOC',
  'ID',
  'HP',
  'ckey',
  'BYOND',
  'Discord',
  'TGUI',
  'Alt',
  'Shift',
  'Ctrl',
  'DM',
  'TG',
  'IC',
]);

type Pass = 'he' | 'she' | 'they' | 'it';
const PASSES: Pass[] = options['one-pass']
  ? ['he']
  : ['he', 'she', 'they', 'it'];
// TG's p_*() (code/__HELPERS/pronouns.dm). A first argument TRUE is a gender no switch knows: "it" forms, lowercase.
const PRONOUNS: Record<string, Record<Pass, string>> = {
  they: { he: 'he', she: 'she', they: 'they', it: 'it' },
  their: { he: 'his', she: 'her', they: 'their', it: 'its' },
  theirs: { he: 'his', she: 'hers', they: 'theirs', it: 'its' },
  them: { he: 'him', she: 'her', they: 'them', it: 'it' },
  have: { he: 'has', she: 'has', they: 'have', it: 'has' },
  are: { he: 'is', she: 'is', they: 'are', it: 'is' },
  were: { he: 'was', she: 'was', they: 'were', it: 'was' },
  do: { he: 'does', she: 'does', they: 'do', it: 'does' },
  theyve: { he: "he's", she: "she's", they: "they've", it: "it's" },
  theyre: { he: "he's", she: "she's", they: "they're", it: "it's" },
  s: { he: 's', she: 's', they: '', it: 's' },
  es: { he: 'es', she: 'es', they: '', it: 'es' },
  themselves: {
    he: 'himself',
    she: 'herself',
    they: 'themselves',
    it: 'itself',
  },
};

// --- DM source -------------------------------------------------------------------------------------------------------
/** Comments blanked out; masked also blanks the inside of every string, so code searches never look into text. */
function scan(text: string): { clean: string; masked: string } {
  const clean: string[] = [];
  const masked: string[] = [];
  const stack: { mode: 'code' | 'str' | 'lstr' | 'interp'; depth: number }[] = [
    { mode: 'code', depth: 0 },
  ];
  const inString = () =>
    stack.some((s) => s.mode === 'str' || s.mode === 'lstr');
  const put = (c: string, hide: boolean) => {
    clean.push(c);
    masked.push(hide && c !== '\n' ? ' ' : c);
  };
  let i = 0;
  while (i < text.length) {
    const top = stack[stack.length - 1];
    const c = text[i];
    const d = text[i + 1];
    if (top.mode === 'code' || top.mode === 'interp') {
      if (top.mode === 'code' && c === '/' && d === '/') {
        while (i < text.length && text[i] !== '\n') {
          clean.push(' ');
          masked.push(' ');
          i++;
        }
        continue;
      }
      if (top.mode === 'code' && c === '/' && d === '*') {
        let depth = 0;
        while (i < text.length) {
          if (text[i] === '/' && text[i + 1] === '*') depth++;
          if (text[i] === '*' && text[i + 1] === '/') {
            depth--;
            clean.push(' ', ' ');
            masked.push(' ', ' ');
            i += 2;
            if (!depth) break;
            continue;
          }
          const keep = text[i] === '\n' ? '\n' : ' ';
          clean.push(keep);
          masked.push(keep);
          i++;
        }
        continue;
      }
      if (c === '{' && d === '"') {
        const hide = inString();
        put(c, hide);
        put(d, hide);
        stack.push({ mode: 'lstr', depth: 0 });
        i += 2;
        continue;
      }
      if (c === '"') {
        put(c, inString());
        stack.push({ mode: 'str', depth: 0 });
        i++;
        continue;
      }
      if (c === "'") {
        const hide = inString();
        put(c, hide);
        i++;
        while (i < text.length && text[i] !== "'" && text[i] !== '\n') {
          if (text[i] === '\\') {
            put(text[i], true);
            i++;
          }
          if (i < text.length) put(text[i], true);
          i++;
        }
        if (text[i] === "'") {
          put("'", hide);
          i++;
        }
        continue;
      }
      if (top.mode === 'interp') {
        if (c === '[') top.depth++;
        if (c === ']') {
          if (!top.depth) {
            stack.pop();
            put(c, true);
            i++;
            continue;
          }
          top.depth--;
        }
      }
      put(c, inString());
      i++;
      continue;
    }
    if (c === '\\') {
      put(c, true);
      if (i + 1 < text.length) put(text[i + 1], true);
      i += 2;
      continue;
    }
    if (c === '[') {
      put(c, true);
      stack.push({ mode: 'interp', depth: 0 });
      i++;
      continue;
    }
    if (top.mode === 'str' && (c === '"' || c === '\n')) {
      stack.pop();
      put(c, inString());
      i++;
      continue;
    }
    if (top.mode === 'lstr' && c === '"' && d === '}') {
      stack.pop();
      const hide = inString();
      put(c, hide);
      put(d, hide);
      i += 2;
      continue;
    }
    put(c, true);
    i++;
  }
  return { clean: clean.join(''), masked: masked.join('') };
}

/** The index of the bracket closing the one at `open`, in masked text. */
function closing(masked: string, open: number): number {
  let depth = 0;
  for (let i = open; i < masked.length; i++) {
    const c = masked[i];
    if (c === '(' || c === '[' || c === '{') depth++;
    else if (c === ')' || c === ']' || c === '}') {
      depth--;
      if (!depth) return i;
    }
  }
  return -1;
}

/** Top-level comma split of clean[from, to), found in masked. */
function splitArgs(
  clean: string,
  masked: string,
  from: number,
  to: number,
): { text: string; at: number }[] {
  const args: { text: string; at: number }[] = [];
  let depth = 0;
  let start = from;
  for (let i = from; i < to; i++) {
    const c = masked[i];
    if (c === '(' || c === '[' || c === '{') depth++;
    else if (c === ')' || c === ']' || c === '}') depth--;
    else if (c === ',' && !depth) {
      args.push({ text: clean.slice(start, i), at: start });
      start = i + 1;
    }
  }
  if (clean.slice(start, to).trim())
    args.push({ text: clean.slice(start, to), at: start });
  return args;
}

/** Where the statement that starts at `from` ends: a line break outside brackets and not escaped. */
function statementEnd(masked: string, from: number): number {
  let depth = 0;
  for (let i = from; i < masked.length; i++) {
    const c = masked[i];
    if (c === '(' || c === '[' || c === '{') depth++;
    else if (c === ')' || c === ']' || c === '}') {
      if (!depth) return i;
      depth--;
    } else if (
      (c === '\n' &&
        !depth &&
        !/\\\s*$/.test(masked.slice(Math.max(from, i - 8), i))) ||
      (c === ';' && !depth)
    ) {
      return i;
    }
  }
  return masked.length;
}

// --- expressions ---------------------------------------------------------------------------------------------------------
type Seg = { text: string } | { macro: string } | { expr: string };
type Ast =
  | { t: 'str'; segs: Seg[] }
  | { t: 'id'; name: string }
  | { t: 'num'; value: string }
  | { t: 'path'; value: string }
  | { t: 'member'; obj: Ast; name: string }
  | { t: 'call'; callee: Ast; args: { name?: string; value: Ast }[] }
  | { t: 'index'; obj: Ast; index: Ast }
  | { t: 'tern'; cond: Ast; a: Ast; b: Ast }
  | { t: 'bin'; op: string; l: Ast; r: Ast }
  | { t: 'un'; op: string; e: Ast }
  | { t: 'raw'; src: string };

type Token =
  | { k: 'str'; segs: Seg[] }
  | { k: 'id' | 'num' | 'path' | 'op'; v: string };

const MACROS =
  /^(?:the|The|a|A|an|An|he|He|she|She|his|His|him|Him|her|Her|hers|Hers|himself|herself|s|proper|improper|icon|ref|th|roman|Roman)\b/;

/** A DM string's body: text, text macros and embedded expressions. */
function parseString(body: string): Seg[] {
  const segs: Seg[] = [];
  let text = '';
  const flush = () => {
    if (text) segs.push({ text });
    text = '';
  };
  for (let i = 0; i < body.length; i++) {
    const c = body[i];
    if (c === '\\') {
      const rest = body.slice(i + 1);
      const macro = rest.match(MACROS);
      if (macro) {
        flush();
        segs.push({ macro: macro[0] });
        i += macro[0].length;
        continue;
      }
      const e = body[i + 1];
      i++;
      if (e === 'n') text += '\n';
      else if (e === 't') text += '\t';
      else if (e === '<') text += '&lt;';
      else if (e === '>') text += '&gt;';
      else if (e === '\n') {
        // A line continued: DM drops the break and the next line's indentation.
        while (body[i + 1] === '\t' || body[i + 1] === ' ') i++;
      } else if (e !== undefined) text += e;
      continue;
    }
    if (c === '[') {
      let depth = 0;
      let j = i + 1;
      let quote = 0;
      for (; j < body.length; j++) {
        const ch = body[j];
        if (ch === '\\') {
          j++;
          continue;
        }
        if (ch === '"') quote ^= 1;
        if (quote) continue;
        if (ch === '[') depth++;
        if (ch === ']') {
          if (!depth) break;
          depth--;
        }
      }
      flush();
      segs.push({ expr: body.slice(i + 1, j) });
      i = j;
      continue;
    }
    text += c;
  }
  flush();
  return segs;
}

function tokenize(src: string): Token[] {
  const { clean } = scan(src);
  const tokens: Token[] = [];
  let i = 0;
  while (i < clean.length) {
    const c = clean[i];
    if (/\s/.test(c)) {
      i++;
      continue;
    }
    if (c === '"' || (c === '{' && clean[i + 1] === '"')) {
      const long = c === '{';
      let j = i + (long ? 2 : 1);
      let depth = 0;
      let quoteInExpr = false;
      for (; j < clean.length; j++) {
        const ch = clean[j];
        if (ch === '\\') {
          j++;
          continue;
        }
        if (depth) {
          if (ch === '"') quoteInExpr = !quoteInExpr;
          if (quoteInExpr) continue;
          if (ch === '[') depth++;
          if (ch === ']') depth--;
          continue;
        }
        if (ch === '[') {
          depth++;
          continue;
        }
        if (long ? ch === '"' && clean[j + 1] === '}' : ch === '"') break;
      }
      tokens.push({
        k: 'str',
        segs: parseString(clean.slice(i + (long ? 2 : 1), j)),
      });
      i = j + (long ? 2 : 1);
      continue;
    }
    if (c === "'") {
      const j = clean.indexOf("'", i + 1);
      tokens.push({ k: 'path', v: clean.slice(i, j + 1) });
      i = j < 0 ? clean.length : j + 1;
      continue;
    }
    const num = clean
      .slice(i)
      .match(/^(?:\d+\.?\d*(?:e[+-]?\d+)?|0x[\da-f]+)/i);
    if (num) {
      tokens.push({ k: 'num', v: num[0] });
      i += num[0].length;
      continue;
    }
    const path = clean
      .slice(i)
      .match(/^\/(?:[A-Za-z_][\w]*)(?:\/[A-Za-z_][\w]*)*/);
    if (path && (!tokens.length || tokens[tokens.length - 1].k === 'op')) {
      tokens.push({ k: 'path', v: path[0] });
      i += path[0].length;
      continue;
    }
    const id = clean.slice(i).match(/^[A-Za-z_]\w*/);
    if (id) {
      tokens.push({ k: 'id', v: id[0] });
      i += id[0].length;
      continue;
    }
    const op = clean
      .slice(i)
      .match(
        /^(?:\?\.|\?:|==|!=|<=|>=|&&|\|\||\+\+|--|\+=|-=|<<|>>|~=|~!|[-+*/%<>!=?:.,()[\]&|^~])/,
      );
    tokens.push({ k: 'op', v: op ? op[0] : c });
    i += op ? op[0].length : 1;
  }
  return tokens;
}

class Parser {
  i = 0;
  constructor(readonly tokens: Token[]) {}
  peek(v?: string) {
    const token = this.tokens[this.i];
    if (v === undefined) return token;
    return token && token.k !== 'str' && token.v === v ? token : undefined;
  }
  take(v: string) {
    if (this.peek(v)) {
      this.i++;
      return true;
    }
    return false;
  }
  expr(): Ast {
    const cond = this.binary(0);
    if (this.take('?')) {
      const a = this.expr();
      this.take(':');
      const b = this.expr();
      return { t: 'tern', cond, a, b };
    }
    return cond;
  }
  static LEVELS = [
    ['||'],
    ['&&'],
    ['|', '&', '^'],
    ['==', '!=', '~=', '~!', '<', '>', '<=', '>=', 'in'],
    ['<<', '>>'],
    ['+', '-'],
    ['*', '/', '%'],
  ];
  binary(level: number): Ast {
    if (level >= Parser.LEVELS.length) return this.unary();
    let left = this.binary(level + 1);
    for (;;) {
      const token = this.peek();
      if (
        !token ||
        token.k === 'str' ||
        !Parser.LEVELS[level].includes(token.v)
      )
        return left;
      if (token.k === 'id' && token.v !== 'in') return left;
      this.i++;
      left = { t: 'bin', op: token.v, l: left, r: this.binary(level + 1) };
    }
  }
  unary(): Ast {
    for (const op of ['!', '-', '~', '++', '--']) {
      if (this.take(op)) return { t: 'un', op, e: this.unary() };
    }
    return this.postfix(this.primary());
  }
  primary(): Ast {
    const token = this.tokens[this.i++];
    if (!token) return { t: 'raw', src: '' };
    if (token.k === 'str') return { t: 'str', segs: token.segs };
    if (token.k === 'num') return { t: 'num', value: token.v };
    if (token.k === 'path') return { t: 'path', value: token.v };
    if (token.k === 'id') return { t: 'id', name: token.v };
    if (token.v === '(') {
      const inner = this.expr();
      this.take(')');
      return inner;
    }
    if (token.v === '.') return { t: 'id', name: '.' };
    return { t: 'raw', src: token.v };
  }
  postfix(ast: Ast): Ast {
    for (;;) {
      if (this.take('(')) {
        const args: { name?: string; value: Ast }[] = [];
        while (this.peek() && !this.peek(')')) {
          let name: string | undefined;
          const token = this.peek();
          const next = this.tokens[this.i + 1];
          if (token?.k === 'id' && next && next.k === 'op' && next.v === '=') {
            name = token.v;
            this.i += 2;
          }
          args.push({ name, value: this.expr() });
          if (!this.take(',')) break;
        }
        this.take(')');
        ast = { t: 'call', callee: ast, args };
      } else if (this.peek('.') || this.peek('?.')) {
        this.i++;
        const token = this.tokens[this.i];
        if (token?.k === 'id') {
          this.i++;
          ast = { t: 'member', obj: ast, name: token.v };
        }
      } else if (this.take('[')) {
        const index = this.expr();
        this.take(']');
        ast = { t: 'index', obj: ast, index };
      } else {
        return ast;
      }
    }
  }
}

const astCache = new Map<string, Ast>();
function parse(src: string): Ast {
  let ast = astCache.get(src);
  if (!ast) {
    const parser = new Parser(tokenize(src));
    ast = parser.expr();
    if (parser.i < parser.tokens.length) ast = { t: 'raw', src };
    astCache.set(src, ast);
  }
  return ast;
}

function show(ast: Ast): string {
  switch (ast.t) {
    case 'id':
      return ast.name;
    case 'num':
      return ast.value;
    case 'path':
      return ast.value;
    case 'member':
      return `${show(ast.obj)}.${ast.name}`;
    case 'call':
      return `${show(ast.callee)}(${ast.args.map((arg) => show(arg.value)).join(', ')})`;
    case 'index':
      return `${show(ast.obj)}[${show(ast.index)}]`;
    case 'tern':
      return `${show(ast.cond)} ? ${show(ast.a)} : ${show(ast.b)}`;
    case 'bin':
      return `${show(ast.l)} ${ast.op} ${show(ast.r)}`;
    case 'un':
      return `${ast.op}${show(ast.e)}`;
    case 'str':
      return '"…"';
    default:
      return ast.src;
  }
}

// --- files, procs and scopes ---------------------------------------------------------------------------------------------
type Proc = {
  file: SourceFile;
  type: string;
  name: string;
  params: string[];
  start: number;
  end: number;
};
type SourceFile = {
  rel: string;
  clean: string;
  masked: string;
  lines: number[];
  procs: Proc[];
};

function lineOf(file: SourceFile, at: number): number {
  let lo = 0;
  let hi = file.lines.length - 1;
  while (lo < hi) {
    const mid = (lo + hi + 1) >> 1;
    if (file.lines[mid] <= at) lo = mid;
    else hi = mid - 1;
  }
  return lo + 1;
}

const indentOf = (line: string) =>
  (line.match(/^[\t ]*/)?.[0] ?? '').replace(/ {4}/g, '\t').length;
const PROC_HEADER =
  /^(\/[\w/]*?)?(?:\/?(?:proc|verb)\/)?\/?(\w+)\s*\(([^)]*)\)\s*$/;

function readFile(path: string): SourceFile {
  const { clean, masked } = scan(
    readFileSync(path, 'utf8').replace(/\r\n?/g, '\n'),
  );
  const file: SourceFile = {
    rel: relative(ROOT, path).replace(/\\/g, '/'),
    clean,
    masked,
    lines: [0],
    procs: [],
  };
  for (let i = 0; i < masked.length; i++)
    if (masked[i] === '\n') file.lines.push(i + 1);
  const text = masked.split('\n');
  let type = '';
  let open: Proc | null = null;
  let openIndent = 0;
  const close = (lineIndex: number) => {
    if (open) {
      open.end = file.lines[lineIndex] ?? masked.length;
      file.procs.push(open);
      open = null;
    }
  };
  text.forEach((line, index) => {
    if (!line.trim() || line.trimStart().startsWith('#')) return;
    const indent = indentOf(line);
    if (open && indent <= openIndent) close(index);
    if (indent === 0) {
      const header = line.trim().match(PROC_HEADER);
      if (header && line.startsWith('/')) {
        type = header[1] ?? '';
        open = {
          file,
          type,
          name: header[2],
          params: params(header[3]),
          start: file.lines[index],
          end: masked.length,
        };
        openIndent = 0;
      } else if (line.startsWith('/')) {
        type = line.trim().replace(/\s*\{?$/, '');
      }
      return;
    }
    if (!open && indent === 1) {
      const header = line
        .trim()
        .match(/^(?:proc\/|verb\/)?(\w+)\s*\(([^)]*)\)\s*$/);
      if (
        header &&
        !/^(if|for|while|switch|spawn|do|else|var|return|sleep)$/.test(
          header[1],
        )
      ) {
        open = {
          file,
          type,
          name: header[1],
          params: params(header[2]),
          start: file.lines[index],
          end: masked.length,
        };
        openIndent = 1;
      }
    }
  });
  close(text.length);
  return file;
}

function params(list: string): string[] {
  return list
    .split(',')
    .map((param) => param.split('=')[0].trim().split('/').pop() ?? '')
    .filter(Boolean);
}

function procAt(file: SourceFile, at: number): Proc | undefined {
  return file.procs.find((proc) => proc.start <= at && at < proc.end);
}

function dmFiles(dir: string): string[] {
  const out: string[] = [];
  for (const name of readdirSync(dir)) {
    const path = join(dir, name);
    if (statSync(path).isDirectory()) {
      if (name !== 'node_modules' && !name.startsWith('.'))
        out.push(...dmFiles(path));
    } else if (name.endsWith('.dm')) out.push(path);
  }
  return out;
}

const files = dmFiles(ROOT).sort().map(readFile);

// Module-wide indexes: string defines, global lists, single-statement formatters, type vars set to strings.
const defines = new Map<string, string>();
const globalLists = new Map<string, Ast>();
const formatters = new Map<string, { proc: Proc; returns: Ast[] }>();
/** "var/greet_text = ..." and "greet_text = ..." in type definitions, outside procs: what a var may hold. */
const typeVars = new Map<string, { file: SourceFile; ast: Ast }[]>();
const TYPE_VAR_IGNORED =
  /^(name|desc|icon|icon_state|base_icon_state|worn_icon|worn_icon_state|lefthand_file|righthand_file|real_name|gender|color|parent_type|type|tag|id|key|sound|path|layer|plane|alpha)$/;
for (const file of files) {
  const lines = file.masked.split('\n');
  lines.forEach((line, index) => {
    const at = file.lines[index];
    if (indentOf(line) < 1 || procAt(file, at)) return;
    const match = line.match(/^\s+(?:var\/(?:\w+\/)*)?(\w+)\s*=(?!=)\s*/);
    if (!match || TYPE_VAR_IGNORED.test(match[1])) return;
    const from = at + match[0].length;
    const rhs = file.clean.slice(from, statementEnd(file.masked, from)).trim();
    if (!rhs.includes('"')) return;
    const entries = typeVars.get(match[1]) ?? [];
    entries.push({ file, ast: parse(rhs) });
    typeVars.set(match[1], entries);
  });
}
for (const file of files) {
  for (const match of file.clean.matchAll(/^#define\s+(\w+)\s+(".*")\s*$/gm))
    defines.set(match[1], match[2]);
  for (const match of file.masked.matchAll(/GLOBAL_LIST_INIT\((\w+),/g)) {
    const open = (match.index ?? 0) + match[0].indexOf('(');
    const end = closing(file.masked, open);
    const args = splitArgs(file.clean, file.masked, open + 1, end);
    if (args[1]) globalLists.set(match[1], parse(args[1].text));
  }
  for (const proc of file.procs) {
    const body = file.clean.slice(proc.start, proc.end).split('\n').slice(1);
    const statements = body.map((line) => line.trim()).filter(Boolean);
    const returns = statements.filter((line) => line.startsWith('return '));
    const other = statements.filter(
      (line) =>
        !line.startsWith('return ') && !/^(if|else|switch)\b/.test(line),
    );
    if (
      returns.length &&
      !other.length &&
      returns.some((line) => line.includes('"'))
    ) {
      formatters.set(proc.name, {
        proc,
        returns: returns.map((line) => parse(line.slice(7))),
      });
    }
  }
}

// --- evaluation --------------------------------------------------------------------------------------------------------
type SlotKind = 'name' | 'item' | 'zone' | 'number' | 'pronoun' | 'dynamic';
type Slot = {
  slot: SlotKind;
  key: string;
  pronoun?: string;
  lower?: boolean;
  cap?: boolean;
  lc?: boolean;
};
type Piece = string | Slot | { macro: string };
type Variant = Piece[];
const MAX_VARIANTS = 64;
/** A type var's values: one per type that sets it, so the cap is wider. */
const MAX_TYPE_VALUES = 400;

type Context = {
  file: SourceFile;
  proc?: Proc;
  env?: Map<string, Variant[] | null>;
  visiting: Set<string>;
  forwards?: { name: string; index: number }[];
};

function product(a: Variant[], b: Variant[]): Variant[] {
  if (a.length * b.length <= MAX_VARIANTS)
    return a.flatMap((x) => b.map((y) => [...x, ...y]));
  const n = Math.min(MAX_VARIANTS, Math.max(a.length, b.length));
  return Array.from({ length: n }, (_, i) => [
    ...a[i % a.length],
    ...b[i % b.length],
  ]);
}

function union(...sets: Variant[][]): Variant[] {
  return unionCapped(MAX_VARIANTS, ...sets);
}

function unionCapped(cap: number, ...sets: Variant[][]): Variant[] {
  const out: Variant[] = [];
  const seen = new Set<string>();
  for (const set of sets) {
    for (const v of set) {
      const key = JSON.stringify(v);
      if (!seen.has(key) && out.length < cap) {
        seen.add(key);
        out.push(v);
      }
    }
  }
  return out;
}

const ZONE_RE =
  /(?:^|[._])(?:zone|zones|part|parts|limb|limbs|bodypart|bodyparts|BP|affecting|limb_name|body_zone|def_zone|target_zone|plaintext_zone|zone_name|hit_zone|organ_name|selected_zone|location)$/i;
const ITEM_RE =
  /(?:^|[._])(?:I|W|O|A|P|item|items|weapon|held|held_item|tool|thing|obj|object|food|ingredient|used_item|attacking_item|our_weapon|their_weapon|offhand|blade|shield|armor|armour|clothing|garment|ammo|projectile|flying|product|result|coin|coins|key|container|vessel|stack|sheet|ore|ingot|bar|plank|log|meat|seed|seeds|crop|reagent_container|pot|pan|bowl|cup|bottle|tongs|hammer|anvil|tray|ware|wares|output|made|crafted|loot|material|fuel|torch|lamp|lantern|bucket|cloth|rag|bandage|gear|saddle|bard|caparison|structure|machine|door|bed|chair|table|ingredient_name|item_name|weapon_name|knife|flare|sheathed|surprise|shot|hitby|worn|place|movable_parent|lever|trap|lock|scabbard|sheath|oar|boat|tree|window|wall|home_wall|gate|chain|tile|turf|fire|fireplace|campfire|torch_item|lamp_item|candle|wood|stone|rock|bait|catch|fish|animal_item|hide|pelt|skin|carcass|offering|gift|letter|book|scroll|note|paper|parcel|attachment|pot|pan)$/i;
const NUMBER_RE =
  /(?:^|[._])(?:amount|amt|count|chance|percent|pct|num|number|cost|price|value|total|delay|time|seconds|minutes|level|stage|stacks|charges|uses|pq|triumphs?|cash|money|mammons?|balance|tax|fee|reward|revenue|profit|sum|debt|loan|wage|pay|quantity|quality|weight|integrity|durability|health|damage_amount|their_chance|our_chance|minstr|wdefense|unarmed_bonus|force|bonus|penalty|round_\w+|days?|hours?|year|month|age|speed|range|heat|temperature|temp|progress|difficulty|tier|rank|max|min|current|needed|required|left|remaining|limit|capacity|size|length|len|index|i|j|x|y|z)$/i;
const NAME_RE =
  /^(?:src|usr|user|users|target|attacker|defender|victim|M|H|L|C|G|mob|living|carbon|human|owner|holder|grabbed|grabber|taker|opponent|charger|source|onlooker|person|patient|rider|mount|animal|creature|beast|biter|struck|hitter|striker|dodger|parrier|blocker|thrower|catcher|shooter|caster|buyer|seller|customer|trader|merchant|steward|payer|payee|player|character|body|corpse|witness|viewer|watcher|sleeper|eater|drinker|cook|crafter|smith|worker|miner|farmer|tamer|pet|friend|enemy|foe|other|partner|carrier|carried|puller|pulled|pusher|pushed|leader|follower|guard|lord|ruler|king|queen|noble|migrant|newcomer|joiner|admin|client|C_target|living_target|carbon_target|human_target|new_mob|old_mob|attacker_mob|target_mob|user_mob|parent|giver|receiver|recipient|sender|helper|kicker|traveler|traveller|guardian|bitten|shoved|biter|thief|robber|climber|rower|sleeper|dreamer|pet_mob|tamed|tamer_mob|horse|cow|beast_mob|prey|hunter|attacker_human|defender_human|howner|wearer|knocker|opener|locker|picker|miner_mob|crafter_mob)$/i;

function classify(ast: Ast, ctx: Context): Slot {
  const key = show(ast);
  if (ast.t === 'call') {
    const callee =
      ast.callee.t === 'member'
        ? ast.callee.name
        : ast.callee.t === 'id'
          ? ast.callee.name
          : '';
    const pronoun = callee.match(/^p_(\w+)$/);
    if (pronoun) {
      const base = pronoun[1].toLowerCase();
      const first = ast.args[0]?.value;
      const forced = first?.t === 'id' && first.name === 'TRUE';
      return {
        slot: 'pronoun',
        key,
        pronoun: base,
        cap: pronoun[1] !== base,
        lower: forced,
      };
    }
    if (
      /^(round|max|min|ceil|floor|num2text|text2num|length|LAZYLEN|abs|clamp|CEILING|FLOOR|rand|percent|DisplayTimeText)$/i.test(
        callee,
      )
    ) {
      return { slot: 'number', key };
    }
    if (/^(parse_zone|rogue_zone_name|check_zone|zone_name)$/i.test(callee))
      return { slot: 'zone', key };
    if (
      /(held_item|get_active_held_item|get_inactive_held_item|get_item_by_slot)/.test(
        callee,
      )
    )
      return { slot: 'item', key };
    if (
      /^(capitalize|uppertext|lowertext|html_encode|strip_html\w*|trim|initial)$/.test(
        callee,
      ) &&
      ast.args[0]
    ) {
      return classify(ast.args[0].value, ctx);
    }
    return { slot: 'dynamic', key };
  }
  if (ast.t === 'num' || (ast.t === 'bin' && /^[-+*/%]$/.test(ast.op)))
    return { slot: 'number', key };
  // TG's examine keeps pronouns in locals: var/t_He = p_They(), t_his = p_their()...
  const local =
    ast.t === 'id'
      ? ast.name.match(/^t_(He|he|His|his|Him|him|Has|has|Is|is|Es|es|S|s)$/)
      : null;
  if (local) {
    const bases: Record<string, string> = {
      he: 'they',
      his: 'their',
      him: 'them',
      has: 'have',
      is: 'are',
      es: 'es',
      s: 's',
    };
    return {
      slot: 'pronoun',
      key,
      pronoun: bases[local[1].toLowerCase()],
      cap: /^[A-Z]/.test(local[1]),
    };
  }
  let base = ast;
  let named = false;
  if (
    base.t === 'member' &&
    /^(name|real_name|declent_ru|plaintext_zone)$/.test(base.name)
  ) {
    if (base.name === 'plaintext_zone') return { slot: 'zone', key };
    named = base.name === 'name';
    base = base.obj;
  }
  const last =
    base.t === 'member' ? base.name : base.t === 'id' ? base.name : '';
  if (
    base.t === 'member' &&
    /^(owner|loc|buckled|pulledby|pulling|grabbedby|user|wearer|holder)$/.test(
      last,
    )
  ) {
    return { slot: 'name', key };
  }
  if (last === 'src' || last === 'parent') {
    const type = ctx.proc?.type ?? '';
    if (
      /^\/(mob|datum\/(mind|component|status_effect))/.test(type) ||
      type === ''
    )
      return { slot: 'name', key };
    return { slot: 'item', key };
  }
  if (ZONE_RE.test(last)) return { slot: 'zone', key };
  if (NAME_RE.test(last)) return { slot: 'name', key };
  if (ITEM_RE.test(last)) return { slot: 'item', key };
  if (NUMBER_RE.test(last)) return { slot: 'number', key };
  // The name of something the code holds (a recipe, a needed part, a material): a thing more often than not.
  if (named) return { slot: 'item', key };
  return { slot: 'dynamic', key };
}

/** The strings an identifier gets in its proc: every "x = ..." (variants), "x += ..." (each with and without). */
function resolveId(name: string, ctx: Context): Variant[] | null {
  if (ctx.env?.has(name)) return ctx.env.get(name) ?? null;
  if (name === 'null') return [['']];
  if (defines.has(name))
    return evaluate(parse(defines.get(name) as string), ctx);
  const proc = ctx.proc;
  if (!proc || ctx.visiting.has(name)) return null;
  const { clean, masked } = proc.file;
  const body = masked.slice(proc.start, proc.end);
  const firstBreak = body.indexOf('\n');
  const re = new RegExp(
    `(^|[^\\w.])(?:var/(?:\\w+/)*)?${name}\\s*(\\+=|=)(?!=)`,
    'gm',
  );
  let base: Variant[] = [];
  const suffixes: Variant[][] = [];
  ctx.visiting.add(name);
  try {
    for (const match of body.matchAll(re)) {
      const at = (match.index ?? 0) + match[1].length;
      if (at < firstBreak) continue;
      const from = proc.start + (match.index ?? 0) + match[0].length;
      const to = statementEnd(masked, from);
      const rhs = clean.slice(from, to).trim();
      if (!rhs) continue;
      const value = evaluate(parse(rhs), ctx);
      if (!value) continue;
      if (match[2] === '+=') suffixes.push(value);
      else base = union(base, value);
    }
  } finally {
    ctx.visiting.delete(name);
  }
  if (!base.length) {
    // Not set in the proc: a var of the type (src's), unless it is a parameter or a local.
    if (
      proc.params.includes(name) ||
      new RegExp(`var/(?:\\w+/)*${name}\\b`).test(body)
    )
      return null;
    return typeVarValues(name, ctx);
  }
  for (const suffix of suffixes) base = union(base, product(base, suffix));
  return base;
}

function typeVarValues(name: string, ctx: Context): Variant[] | null {
  const entries = typeVars.get(name);
  if (!entries || TYPE_VAR_IGNORED.test(name) || ctx.visiting.has(`tv:${name}`))
    return null;
  ctx.visiting.add(`tv:${name}`);
  try {
    const values = entries
      .map((entry) =>
        evaluate(entry.ast, { file: entry.file, visiting: ctx.visiting }),
      )
      .filter((v): v is Variant[] => !!v);
    return values.length ? unionCapped(MAX_TYPE_VALUES, ...values) : null;
  } finally {
    ctx.visiting.delete(`tv:${name}`);
  }
}

/** The list a pick() argument names: list(...) in the proc, a global list, or a list literal. */
function listItems(ast: Ast, ctx: Context): Ast[] | null {
  if (ast.t === 'call' && ast.callee.t === 'id' && ast.callee.name === 'list')
    return ast.args.map((arg) => arg.value);
  if (ast.t === 'member' && ast.obj.t === 'id' && ast.obj.name === 'GLOB') {
    const list = globalLists.get(ast.name);
    return list ? listItems(list, ctx) : null;
  }
  if (
    ast.t === 'member' &&
    typeVars.has(ast.name) &&
    !TYPE_VAR_IGNORED.test(ast.name)
  ) {
    const items = (typeVars.get(ast.name) ?? []).flatMap(
      (entry) => listItems(entry.ast, ctx) ?? [],
    );
    return items.length ? items : null;
  }
  if (ast.t === 'id' && ctx.proc && !ctx.visiting.has(`list:${ast.name}`)) {
    const proc = ctx.proc;
    const body = proc.file.masked.slice(proc.start, proc.end);
    const re = new RegExp(
      `(^|[^\\w.])(?:var/(?:\\w+/)*)?${ast.name}\\s*(\\+=|=)(?!=)`,
      'gm',
    );
    const items: Ast[] = [];
    ctx.visiting.add(`list:${ast.name}`);
    for (const match of body.matchAll(re)) {
      const from = proc.start + (match.index ?? 0) + match[0].length;
      const rhs = proc.file.clean
        .slice(from, statementEnd(proc.file.masked, from))
        .trim();
      const value = parse(rhs);
      const inner = listItems(value, ctx);
      if (inner) items.push(...inner);
      else if (match[2] === '+=') items.push(value);
    }
    ctx.visiting.delete(`list:${ast.name}`);
    return items.length ? items : null;
  }
  return null;
}

const SPAN_CLASSES: Record<string, string> = {
  span_red: 'red',
  span_bold: 'bold',
  span_italics: 'italics',
};
/** Expressions the script cannot read, spelled out. The strike's notes (combat/chat.dm) come in elements of their own
 * after the strike's text, so the strike line is translated without them; they are checked as lines of their own. */
const KNOWN = new Map<string, Variant[]>([
  ['jointext(rogue_strike_notes, "…")', [['']]],
  ['jointext(target.rogue_strike_notes, "…")', [['']]],
  ['skill.name', [['Sword-fighting'], ['Unarmed']]],
  // clothing/slots.dm: two rings, as english_list() joins two titles.
  [
    'english_list(rings)',
    [
      [
        "<img src='icon.png'> <em>кольцо</em> and <img src='icon.png'> <em>перстень</em>",
      ],
    ],
  ],
  // combat/alt_grip.dm, rockhill/ported/alt_grips.dm: the grips there are.
  ['grip.name', [['halfsword'], ['mordhau']]],
]);
/** Module procs whose text the script cannot follow (loops), by what they return. */
const KNOWN_CALLS: Record<
  string,
  (args: Ast[], ctx: Context) => Variant[] | null
> = {
  // combat/armor.dm: the label in its tier's colour, then a dot per tier.
  // combat/blade.dm, intents.dm: a sentence on the edge, a number.
  rogue_edge_text: () => [
    ['The edge is chipped and blunt.'],
    ['The edge is chipped.'],
    ['The edge is sharp.'],
  ],
  rogue_wdefense: () => [[{ slot: 'number', key: 'rogue_wdefense()' }]],
  // TG's examine_title(): the icon, then the name (already Russian for a Russian reader) in <em>.
  examine_title: () => [["<img src='icon.png'> <em>меч</em>"]],
  rogue_tier_rating: (args, ctx) => {
    const label = args[0] ? evaluate(args[0], ctx) : null;
    return label
      ? wrap(
          label,
          "<font color='#c0a739'>",
          "</font> <font color='#c0a739'>&#9679;</font><font color='#404040'>&#9675;</font>",
        )
      : null;
  },
};

function wrap(variants: Variant[], open: string, close: string): Variant[] {
  return variants.map((v) => [open, ...v, close]);
}

function transform(
  variants: Variant[],
  how: 'capitalize' | 'upper' | 'lower',
): Variant[] {
  return variants.map((v) => {
    if (how === 'capitalize') {
      const [first, ...rest] = v;
      if (typeof first === 'string')
        return [first.charAt(0).toUpperCase() + first.slice(1), ...rest];
      if (first && 'slot' in first) return [{ ...first, cap: true }, ...rest];
      return v;
    }
    return v.map((p) => {
      if (typeof p === 'string')
        return how === 'upper' ? p.toUpperCase() : p.toLowerCase();
      return 'slot' in p ? { ...p, lc: how === 'lower' } : p;
    });
  });
}

/** String variants of an expression, or null when it is no string the code spells out. */
function evaluate(ast: Ast, ctx: Context): Variant[] | null {
  const known = KNOWN.get(show(ast));
  if (known) return known;
  switch (ast.t) {
    case 'str': {
      let out: Variant[] = [[]];
      for (const seg of ast.segs) {
        if ('text' in seg) out = out.map((v) => [...v, seg.text]);
        else if ('macro' in seg)
          out = out.map((v) => [...v, { macro: seg.macro }]);
        else out = product(out, interpolate(parse(seg.expr), ctx));
      }
      return out;
    }
    case 'tern': {
      const a = evaluate(ast.a, ctx);
      const b = evaluate(ast.b, ctx);
      if (!a && !b) return null;
      return union(a ?? interpolate(ast.a, ctx), b ?? interpolate(ast.b, ctx));
    }
    case 'bin': {
      if (ast.op === '+') {
        const l = evaluate(ast.l, ctx);
        const r = evaluate(ast.r, ctx);
        if (!l && !r) return null;
        return product(
          l ?? interpolate(ast.l, ctx),
          r ?? interpolate(ast.r, ctx),
        );
      }
      if (ast.op === '||') {
        const l = evaluate(ast.l, ctx);
        const r = evaluate(ast.r, ctx);
        if (!l && !r) return null;
        return union(l ?? [], r ?? []);
      }
      return null;
    }
    case 'id':
      return resolveId(ast.name, ctx);
    case 'member':
      return typeVarValues(ast.name, ctx);
    case 'call': {
      const callee =
        ast.callee.t === 'id'
          ? ast.callee.name
          : ast.callee.t === 'member'
            ? ast.callee.name
            : '';
      const arg = (index: number) => ast.args[index]?.value;
      if (KNOWN_CALLS[callee])
        return KNOWN_CALLS[callee](
          ast.args.map((a) => a.value),
          ctx,
        );
      if (/^span_\w+$/.test(callee) && arg(0)) {
        // A call inside the span (span_userdanger(rogue_zone_name(zone))) prints something: a sample.
        const inner =
          evaluate(arg(0) as Ast, ctx) ??
          (arg(0)?.t === 'call' ? [[classify(arg(0) as Ast, ctx)]] : null);
        if (!inner) return null;
        const cls = SPAN_CLASSES[callee] ?? callee.slice(5);
        return wrap(inner, `<span class='${cls}'>`, '</span>');
      }
      if (/^(boxed_message|examine_block|custom_boxed_message)$/.test(callee)) {
        const inner = evaluate(
          ast.args[ast.args.length - 1]?.value ?? { t: 'raw', src: '' },
          ctx,
        );
        return inner
          ? wrap(inner, "<div class='boxed_message'>", '</div>')
          : null;
      }
      if (callee === 'pick' || callee === 'pick_weight') {
        const items =
          ast.args.length === 1
            ? (listItems(ast.args[0].value, ctx) ?? [ast.args[0].value])
            : ast.args.map((a) => a.value);
        const values = items.map((item) => evaluate(item, ctx));
        if (values.every((v) => !v)) return null;
        return unionCapped(
          MAX_TYPE_VALUES,
          ...values.map((v, i) => v ?? interpolate(items[i], ctx)),
        );
      }
      if (callee === 'capitalize' && arg(0)) {
        const inner = evaluate(arg(0) as Ast, ctx);
        return inner ? transform(inner, 'capitalize') : null;
      }
      if (
        /^(uppertext|lowertext|UPPER_TEXT|LOWER_TEXT)$/.test(callee) &&
        arg(0)
      ) {
        const inner = evaluate(arg(0) as Ast, ctx);
        if (!inner) return null;
        return transform(inner, /^upper/i.test(callee) ? 'upper' : 'lower');
      }
      if (
        /^(html_encode|trim|strip_html\w*|copytext|initial)$/.test(callee) &&
        arg(0)
      )
        return evaluate(arg(0) as Ast, ctx);
      const formatter = formatters.get(callee);
      if (formatter && !ctx.visiting.has(`fmt:${callee}`)) {
        const env = new Map<string, Variant[] | null>();
        formatter.proc.params.forEach((param, index) => {
          const given = ast.args[index]?.value;
          env.set(
            param,
            given ? (evaluate(given, ctx) ?? interpolate(given, ctx)) : [['']],
          );
        });
        const inner: Context = {
          file: formatter.proc.file,
          proc: formatter.proc,
          env,
          visiting: ctx.visiting,
        };
        ctx.visiting.add(`fmt:${callee}`);
        try {
          const values = formatter.returns
            .map((ret) => evaluate(ret, inner))
            .filter((v): v is Variant[] => !!v);
          return values.length ? union(...values) : null;
        } finally {
          ctx.visiting.delete(`fmt:${callee}`);
        }
      }
      return null;
    }
    default:
      return null;
  }
}

/** What an embedded [expression] prints: its strings if the code spells them out, a sample otherwise. */
function interpolate(ast: Ast, ctx: Context): Variant[] {
  return evaluate(ast, ctx) ?? [[classify(ast, ctx)]];
}

// --- messages ------------------------------------------------------------------------------------------------------------
type Kind =
  | 'chat'
  | 'visible'
  | 'audible'
  | 'examine'
  | 'admin'
  | 'wrapper'
  | 'balloon'
  | 'say';
const COUNTED_APART: Kind[] = ['balloon', 'say'];
type Message = {
  file: string;
  line: number;
  kind: Kind;
  source: string;
  variants: Variant[] | null;
  status?: 'ok' | 'partial' | 'missing' | 'skip' | 'unresolved';
  results?: { en: string; ru: string; ok: boolean; pass: Pass }[];
  dynamic?: string[];
};

/** Calls whose arguments are chat text: the argument positions and named arguments that are messages. */
const CALLS: Record<string, { kind: Kind; args: number[]; named?: RegExp }> = {
  to_chat: { kind: 'chat', args: [1], named: /^(html|text)$/ },
  visible_message: {
    kind: 'visible',
    args: [0, 1, 2],
    named: /^(message|self_message|blind_message)$/,
  },
  audible_message: {
    kind: 'audible',
    args: [0, 1, 3],
    named: /^(message|deaf_message|self_message)$/,
  },
  show_message: { kind: 'chat', args: [0, 2], named: /^(msg|alt_msg)$/ },
  message_admins: { kind: 'admin', args: [0] },
  send_to_playing_players: { kind: 'chat', args: [0] },
  balloon_alert: { kind: 'balloon', args: [1] },
  balloon_alert_to_viewers: {
    kind: 'balloon',
    args: [0, 1],
    named: /^(message|self_message)$/,
  },
  say: { kind: 'say', args: [0], named: /^message$/ },
};

/** The module's procs that hand a parameter on to a chat call, found as the script reads the calls. */
const wrappers = new Map<string, { kind: Kind; args: Set<number> }>();
const EXAMINE_PROC =
  /^(examine|examine_more|examine_tags|examine_descriptor|get_examine_\w+|on_examine\w*|\w*_examine\w*)$/;

function collect(): Message[] {
  const messages: Message[] = [];
  const seen = new Set<string>();
  const add = (
    file: SourceFile,
    at: number,
    kind: Kind,
    source: string,
    proc: Proc | undefined,
  ) => {
    const key = `${file.rel}:${at}`;
    if (seen.has(key)) return;
    seen.add(key);
    const ctx: Context = { file, proc, visiting: new Set() };
    const ast = parse(source);
    // A wrapper's own call of its parameter is no line: its callers' arguments are.
    const peeled = peel(ast);
    const forwarded = (
      peeled.t === 'bin' && peeled.op === '||' ? [peeled.l, peeled.r] : [peeled]
    ).filter(
      (side): side is { t: 'id'; name: string } =>
        side.t === 'id' &&
        !!proc?.params.includes(side.name) &&
        !resolveId(side.name, ctx),
    );
    if (proc && forwarded.length) {
      const entry = wrappers.get(proc.name) ?? {
        kind,
        args: new Set<number>(),
      };
      for (const side of forwarded)
        entry.args.add(proc.params.indexOf(side.name));
      wrappers.set(proc.name, entry);
      return;
    }
    // Not text: a range, a list of mobs, a define standing for a number.
    if (
      peeled.t === 'num' ||
      (peeled.t === 'id' &&
        /^[A-Z0-9_]+$/.test(peeled.name) &&
        !defines.has(peeled.name))
    )
      return;
    if (
      peeled.t === 'call' &&
      peeled.callee.t === 'id' &&
      peeled.callee.name === 'list'
    )
      return;
    const variants = evaluate(ast, ctx);
    const line = lineOf(file, at);
    const same = `${file.rel}:${line}:${JSON.stringify(variants ?? source)}`;
    if (seen.has(same)) return;
    seen.add(same);
    messages.push({
      file: file.rel,
      line,
      kind,
      source: source.trim(),
      variants,
    });
  };
  // Twice: the second pass reads the calls of the wrappers the first one found.
  for (let pass = 0; pass < 3; pass++) {
    const names = [...Object.keys(CALLS), ...wrappers.keys()];
    const callRe = new RegExp(`(?<![\\w/])(${names.join('|')})\\s*\\(`, 'g');
    for (const file of files) {
      for (const match of file.masked.matchAll(callRe)) {
        const at = match.index ?? 0;
        const lineStart = file.masked.lastIndexOf('\n', at) + 1;
        if (/^\s*\/|proc\//.test(file.masked.slice(lineStart, at))) continue;
        const open = at + match[0].length - 1;
        const end = closing(file.masked, open);
        if (end < 0) continue;
        const proc = procAt(file, at);
        const call = CALLS[match[1]];
        const wrapper = wrappers.get(match[1]);
        if (!call && wrapper && proc?.name === match[1]) continue;
        const args = splitArgs(file.clean, file.masked, open + 1, end);
        args.forEach((arg, index) => {
          const named = arg.text.match(/^\s*(\w+)\s*=(?!=)/);
          const wanted = call
            ? named
              ? call.named?.test(named[1])
              : call.args.includes(index)
            : !named && wrapper?.args.has(index);
          if (!wanted) return;
          const text = named ? arg.text.slice(named[0].length) : arg.text;
          if (!text.trim()) return;
          const kind = call
            ? call.kind
            : COUNTED_APART.includes(wrapper?.kind as Kind)
              ? (wrapper?.kind as Kind)
              : 'wrapper';
          add(file, arg.at + (named ? named[0].length : 0), kind, text, proc);
        });
      }
      if (pass) continue;
      // Examine: ". += ..." in an examine proc, "examine_list += ..." anywhere.
      for (const match of file.masked.matchAll(
        /(^|[^\w.])(\.|examine_list|examine_text|examine_texts)\s*(\+=|\|=)/gm,
      )) {
        const at = (match.index ?? 0) + match[0].length;
        const proc = procAt(file, at);
        if (match[2] === '.' && !(proc && EXAMINE_PROC.test(proc.name)))
          continue;
        const end = statementEnd(file.masked, at);
        const rhs = file.clean.slice(at, end);
        const ast = parse(rhs);
        if (
          ast.t === 'call' &&
          ast.callee.t === 'id' &&
          ast.callee.name === 'list'
        ) {
          const open = file.masked.indexOf('(', at);
          for (const item of splitArgs(
            file.clean,
            file.masked,
            open + 1,
            closing(file.masked, open),
          )) {
            add(file, item.at, 'examine', item.text, proc);
          }
        } else {
          add(file, at, 'examine', rhs, proc);
        }
      }
    }
  }
  return messages;
}

function peel(ast: Ast): Ast {
  if (ast.t === 'call') {
    const callee = ast.callee.t === 'id' ? ast.callee.name : '';
    if (
      (/^span_\w+$/.test(callee) ||
        /^(boxed_message|examine_block)$/.test(callee)) &&
      ast.args.length === 1
    ) {
      return peel(ast.args[0].value);
    }
  }
  if (ast.t === 'str' && ast.segs.length === 1 && 'expr' in ast.segs[0])
    return peel(parse(ast.segs[0].expr));
  return ast;
}

// --- rendering and translation -------------------------------------------------------------------------------------------
function render(variant: Variant, pass: Pass): string {
  const samples = new Map<string, string>();
  const used: Record<string, number> = {};
  const sample = (slot: Slot): string => {
    if (slot.slot === 'pronoun') {
      const forms = PRONOUNS[slot.pronoun ?? ''];
      const word = forms ? forms[slot.lower ? 'it' : pass] : 'they';
      return slot.cap ? word.charAt(0).toUpperCase() + word.slice(1) : word;
    }
    const pool = slot.slot === 'dynamic' ? 'name' : slot.slot;
    const key = `${pool}:${slot.key}`;
    let value = samples.get(key);
    if (value === undefined) {
      const index = used[pool] ?? 0;
      used[pool] = index + 1;
      value = SAMPLES[pool][index % SAMPLES[pool].length];
      samples.set(key, value);
    }
    if (slot.lc) return value.toLowerCase();
    return slot.cap ? value.charAt(0).toUpperCase() + value.slice(1) : value;
  };
  let html = '';
  for (let i = 0; i < variant.length; i++) {
    const piece = variant[i];
    if (typeof piece === 'string') {
      html += piece;
      continue;
    }
    if ('slot' in piece) {
      html += sample(piece);
      continue;
    }
    // DM's text macros look at the next embedded value: a thing gets an article, a proper name none. Text spelled out
    // in the code (a ternary, a var's strings) counts as a thing when it starts lowercase, as DM tells improper names.
    const following = variant
      .slice(i + 1)
      .find((p) => typeof p !== 'string' || p.trim());
    const next =
      following && typeof following !== 'string' && 'slot' in following
        ? following
        : undefined;
    const thing = next
      ? next.slot === 'item' || next.slot === 'zone'
      : typeof following === 'string' && /^\s*[a-z]/.test(following);
    const cap = /^[A-Z]/.test(piece.macro);
    const lower = piece.macro.toLowerCase();
    let word = '';
    if (lower === 'the') word = thing ? 'the' : '';
    else if (lower === 'a' || lower === 'an') {
      const noun = next
        ? sample(next)
        : typeof following === 'string'
          ? following.trim()
          : '';
      word = thing ? (/^[aeiou]/i.test(noun) ? 'an' : 'a') : '';
    } else if (
      ['he', 'she', 'his', 'him', 'her', 'hers', 'himself', 'herself'].includes(
        lower,
      )
    ) {
      word = {
        he: 'they',
        she: 'they',
        his: 'their',
        him: 'them',
        her: 'their',
        hers: 'theirs',
        himself: 'themselves',
        herself: 'themselves',
      }[lower] as string;
      word =
        PRONOUNS[
          word === 'they'
            ? 'they'
            : word === 'their'
              ? 'their'
              : word === 'them'
                ? 'them'
                : word === 'theirs'
                  ? 'theirs'
                  : 'themselves'
        ][pass];
    } else if (lower === 's') word = 's';
    else if (lower === 'th') word = 'th';
    if (cap) word = word.charAt(0).toUpperCase() + word.slice(1);
    if (
      !word &&
      html.endsWith(' ') &&
      typeof variant[i + 1] === 'string' &&
      (variant[i + 1] as string).startsWith(' ')
    ) {
      html = html.slice(0, -1);
    }
    if (
      !word &&
      typeof variant[i + 1] === 'string' &&
      (variant[i + 1] as string).startsWith(' ') &&
      (!html || html.endsWith('>'))
    ) {
      variant = [
        ...variant.slice(0, i + 1),
        (variant[i + 1] as string).slice(1),
        ...variant.slice(i + 2),
      ];
    }
    html += word;
  }
  return html;
}

const LATIN = /[A-Za-z]{2,}|\bI\b/g;
function leftover(text: string): string[] {
  return (text.match(LATIN) ?? []).filter((word) => !LATIN_ALLOWED.has(word));
}

function literalText(variant: Variant): string {
  return variant
    .filter((p): p is string => typeof p === 'string')
    .join(' ')
    .replace(/<[^>]*>/g, ' ')
    .replace(/&\w+;/g, ' ');
}

function translate(html: string): { en: string; ru: string } {
  const root = document.createElement('div');
  root.className = 'ChatMessage';
  root.innerHTML = html;
  const en = root.textContent ?? '';
  translateNode(root);
  return { en, ru: root.textContent ?? '' };
}

function check(message: Message): void {
  if (!message.variants) {
    message.status = 'unresolved';
    return;
  }
  const english = message.variants.filter(
    (v) => leftover(literalText(v)).length,
  );
  if (!english.length) {
    message.status = 'skip';
    return;
  }
  const dynamic = new Set<string>();
  for (const v of english)
    for (const p of v)
      if (typeof p !== 'string' && 'slot' in p && p.slot === 'dynamic')
        dynamic.add(p.key);
  message.dynamic = [...dynamic];
  const results: { en: string; ru: string; ok: boolean; pass: Pass }[] = [];
  const seen = new Set<string>();
  for (const variant of english) {
    for (const pass of PASSES) {
      const html = render(variant, pass);
      if (seen.has(html)) continue;
      seen.add(html);
      const { en, ru } = translate(html);
      results.push({
        en: en.trim(),
        ru: ru.trim(),
        ok: ru !== en && !leftover(ru).length && !/\$\d/.test(ru),
        pass,
      });
    }
  }
  message.results = results;
  const ok = results.filter((r) => r.ok).length;
  const changed = results.filter((r) => r.en !== r.ru).length;
  message.status =
    ok === results.length ? 'ok' : changed === 0 ? 'missing' : 'partial';
}

// --- run -----------------------------------------------------------------------------------------------------------------
const all = collect();
const selected = all.filter(
  (m) =>
    (!targets.length ||
      targets.some(
        (t) =>
          m.file === t || m.file.startsWith(`${t}/`) || m.file === `${t}.dm`,
      )) &&
    (!KINDS || KINDS.has(m.kind)),
);
for (const message of selected) check(message);
/** A saved run: the translation of every English variant, and the messages it read (file and DM source). */
type Saved = { translations: Record<string, string>; sources: string[] };
const sourceKey = (m: Message) => `${m.file}|${m.source.replace(/\s+/g, ' ')}`;
function readSaved(path: string): Saved {
  const data = JSON.parse(readFileSync(path, 'utf8'));
  return data.translations ? data : { translations: data, sources: [] };
}
// --scope: only the messages a saved run already had (a baseline, by file and DM source), so lines that other work
// added or rewrote since are left out.
if (options.scope) {
  const baseline = new Set(readSaved(options.scope).sources);
  const kept = selected.filter((m) => baseline.has(sourceKey(m)));
  selected.length = 0;
  selected.push(...kept);
}

const folderOf = (file: string) =>
  file.startsWith('rockhill/ported/')
    ? 'rockhill/ported'
    : file.includes('/')
      ? file.split('/')[0]
      : '.';
type Row = {
  total: number;
  ok: number;
  partial: number;
  missing: number;
  unresolved: number;
  apart: number;
  apartOk: number;
};
const rows = new Map<string, Row>();
const row = (name: string) => {
  let r = rows.get(name);
  if (!r) {
    r = {
      total: 0,
      ok: 0,
      partial: 0,
      missing: 0,
      unresolved: 0,
      apart: 0,
      apartOk: 0,
    };
    rows.set(name, r);
  }
  return r;
};
for (const message of selected) {
  if (message.status === 'skip') continue;
  for (const r of [row(folderOf(message.file)), row('ВСЕГО')]) {
    if (COUNTED_APART.includes(message.kind)) {
      if (message.status !== 'unresolved') r.apart++;
      if (message.status === 'ok') r.apartOk++;
      continue;
    }
    if (message.status === 'unresolved') {
      r.unresolved++;
      continue;
    }
    r.total++;
    r[message.status as 'ok' | 'partial' | 'missing']++;
  }
}

if (LIST.size) {
  const wanted = (m: Message) =>
    LIST.has('all') ||
    LIST.has(m.status as string) ||
    (LIST.has('apart') && COUNTED_APART.includes(m.kind));
  let current = '';
  for (const message of selected) {
    if (message.status === 'skip' || !wanted(message)) continue;
    if (message.file !== current) {
      current = message.file;
      console.log(`\n== ${current}`);
    }
    const flag = message.dynamic?.length
      ? `  {${message.dynamic.join('; ')}}`
      : '';
    console.log(`  ${message.line} [${message.kind}] ${message.status}${flag}`);
    if (!message.results) {
      console.log(
        `    src: ${message.source.replace(/\s+/g, ' ').slice(0, 200)}`,
      );
      continue;
    }
    let shownResults = 0;
    for (const result of message.results) {
      if (message.status === 'partial' && result.ok && !LIST.has('all'))
        continue;
      // --brief: the "he" pass only, a few variants.
      if (options.brief && (result.pass !== 'he' || ++shownResults > 6))
        continue;
      console.log(`    EN: ${result.en}`);
      if (result.ru !== result.en) console.log(`    RU: ${result.ru}`);
    }
  }
  console.log('');
}

if (options.save) {
  const saved: Saved = { translations: {}, sources: selected.map(sourceKey) };
  for (const message of selected)
    for (const result of message.results ?? [])
      saved.translations[result.en] = result.ru;
  writeFileSync(options.save, JSON.stringify(saved, null, 1));
}
if (options.diff) {
  const before = readSaved(options.diff).translations;
  let changed = 0;
  const shown = new Set<string>();
  for (const message of selected) {
    for (const result of message.results ?? []) {
      const old = before[result.en];
      if (old === undefined || old === result.ru || shown.has(result.en))
        continue;
      shown.add(result.en);
      changed++;
      const wasDone = old !== result.en;
      console.log(
        `${wasDone ? 'ИЗМЕНЕНО' : 'НОВОЕ'} ${message.file}:${message.line}\n    EN: ${result.en}`,
      );
      if (wasDone) console.log(`    было: ${old}`);
      console.log(`    стало: ${result.ru}`);
    }
  }
  console.log(`\nпереводов изменилось: ${changed}`);
}

if (warnings.length && options.warnings) {
  console.log(`Словарь: ${warnings.length} предупреждений`);
  for (const warning of warnings) console.log(`  ${warning}`);
}
const pad = (s: string | number, n: number) => String(s).padStart(n);
console.log(
  `${'папка'.padEnd(18)}${pad('строк', 7)}${pad('готово', 8)}${pad('частично', 10)}${pad('нет', 6)}${pad('%', 6)}${pad('неразобр.', 11)}${pad('шарики+речь', 13)}`,
);
const names = [...rows.keys()].filter((n) => n !== 'ВСЕГО').sort();
for (const name of [...names, 'ВСЕГО']) {
  const r = rows.get(name) as Row;
  const percent = r.total ? Math.round((100 * r.ok) / r.total) : 0;
  console.log(
    `${name.padEnd(18)}${pad(r.total, 7)}${pad(r.ok, 8)}${pad(r.partial, 10)}${pad(r.missing, 6)}${pad(percent, 6)}${pad(r.unresolved, 11)}${pad(`${r.apartOk}/${r.apart}`, 13)}`,
  );
}
if (warnings.length && !options.warnings)
  console.log(
    `(словарь: ${warnings.length} предупреждений, --warnings — показать)`,
  );
