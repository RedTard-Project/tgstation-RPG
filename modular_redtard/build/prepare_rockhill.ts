import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

const CONFIG_PATH = 'modular_redtard/rockhill/config.json';
const SHARED_DIR = 'modular_redtard/rockhill';
const TMP_DIR = 'tmp/modular_redtard/rockhill';
const DECLARATION_DIRS = ['code', 'modular_redtard'];
const DOWNLOAD_TIMEOUT_MS = 180000;
const LEVEL_LINE = /^\(\d+,\d+,\d+\) = \{"/;
const TILE_OPEN = /^"([^"]+)" = \($/;

type Rule = { prefix: string; to?: string; drop?: boolean };

type Config = {
  source: { name: string; project: string; url: string; local?: string };
  title: { url: string; local?: string; file: string };
  output: { map: string; map_json: string; title_dir: string };
  rules: Rule[];
  spawn?: { path: string; turf: string };
};

type Item = { kind: 'raw'; text: string } | { kind: 'tile'; key: string; atoms: string[] };

type Counts = { kept: number; replaced: number; dropped: number };

export async function prepareRockhill(): Promise<void> {
  const config = readConfig();
  fs.mkdirSync(TMP_DIR, { recursive: true });

  const source = await downloadText(config.source.url, config.source.local, 'map');
  const { dictionary, levels } = splitMap(source);
  const items = parseDictionary(dictionary);

  const counts: Record<string, Counts> = {};
  const unmatched = new Map<string, number>();
  const usedTargets = new Map<string, number>();
  const resolvedItems: Array<{ raw: string } | { key: string; atoms: string[] }> = [];

  for (const item of items) {
    if (item.kind === 'raw') {
      resolvedItems.push({ raw: item.text });
      continue;
    }
    const atoms: string[] = [];
    for (const atom of item.atoms) {
      const { path: atomPath, vars } = splitAtom(atom);
      const category = atomPath.split('/')[1] || 'other';
      const bucket = (counts[category] ||= { kept: 0, replaced: 0, dropped: 0 });
      const resolved = resolve(atomPath, config.rules);
      if (!resolved) {
        unmatched.set(atomPath, (unmatched.get(atomPath) || 0) + 1);
        bucket.dropped++;
        continue;
      }
      if (resolved.drop) {
        bucket.dropped++;
        continue;
      }
      const target = resolved.to as string;
      if (target === atomPath) {
        bucket.kept++;
      } else {
        bucket.replaced++;
      }
      usedTargets.set(target, (usedTargets.get(target) || 0) + 1);
      atoms.push(target + keepDir(vars));
    }
    if (!atoms.length) {
      throw new Error(`tile ${item.key} lost every atom; check the rules`);
    }
    resolvedItems.push({ key: item.key, atoms });
  }

  const declared = declaredTypes();
  const missing = [...usedTargets.keys()].filter((target) => !declared.has(target));
  if (missing.length) {
    throw new Error(`rules point at types the code does not declare: ${missing.join(', ')}`);
  }

  if (config.spawn) {
    const placed = placeSpawn(config.spawn, resolvedItems, levels);
    usedTargets.set(config.spawn.path, (usedTargets.get(config.spawn.path) || 0) + 1);
    console.log(`modular_redtard: spawn landmark ${config.spawn.path} placed on level 1 at ${placed}`);
  }

  const rewritten: string[] = [];
  for (const entry of resolvedItems) {
    if ('raw' in entry) {
      rewritten.push(entry.raw);
      continue;
    }
    rewritten.push(`"${entry.key}" = (`);
    entry.atoms.forEach((atom, index) => {
      rewritten.push(atom + (index === entry.atoms.length - 1 ? ')' : ','));
    });
  }

  const output = [...rewritten, ...levels].join('\n');
  fs.mkdirSync(path.dirname(config.output.map), { recursive: true });
  fs.writeFileSync(config.output.map, output.endsWith('\n') ? output : output + '\n');

  copyFileOverwrite(path.join(SHARED_DIR, 'rockhill.json'), config.output.map_json);
  await installTitle(config);
  writeReport(config, counts, unmatched, usedTargets);
}

function readConfig(): Config {
  const config = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8')) as Config;
  if (!config.source?.url || !config.output?.map || !Array.isArray(config.rules)) {
    throw new Error(`${CONFIG_PATH} must define source.url, output.map and rules`);
  }
  return config;
}

function splitMap(text: string): { dictionary: string[]; levels: string[] } {
  const lines = text.split(/\r?\n/);
  const start = lines.findIndex((line) => LEVEL_LINE.test(line));
  if (start < 0) {
    throw new Error('the source map has no level sections');
  }
  return { dictionary: lines.slice(0, start), levels: lines.slice(start) };
}

function parseDictionary(lines: string[]): Item[] {
  const items: Item[] = [];
  let open: { key: string; atoms: string[] } | null = null;
  let pending = '';
  for (const line of lines) {
    if (open === null) {
      const match = TILE_OPEN.exec(line.trimEnd());
      if (match) {
        open = { key: match[1], atoms: [] };
      } else if (line.length) {
        items.push({ kind: 'raw', text: line });
      }
      continue;
    }
    pending = pending ? `${pending}\n${line}` : line;
    const depth = (pending.match(/\{/g) || []).length - (pending.match(/\}/g) || []).length;
    if (depth > 0) {
      continue;
    }
    const text = pending.trim();
    pending = '';
    const closes = text.endsWith(')');
    open.atoms.push(text.replace(/[,)]$/, ''));
    if (closes) {
      items.push({ kind: 'tile', key: open.key, atoms: open.atoms });
      open = null;
    }
  }
  if (open !== null) {
    throw new Error(`tile ${open.key} is never closed`);
  }
  return items;
}

type Entry = { raw: string } | { key: string; atoms: string[] };

function placeSpawn(spawn: { path: string; turf: string }, items: Entry[], levels: string[]): string {
  const headers: Array<{ x: number; index: number }> = [];
  levels.forEach((line, index) => {
    const match = /^\((\d+),\d+,1\) = \{"$/.exec(line);
    if (match) {
      headers.push({ x: Number(match[1]), index });
    }
  });
  if (!headers.length) {
    throw new Error('level 1 has no blocks to place the spawn landmark in');
  }
  headers.sort((a, b) => a.x - b.x);
  const block = headers[Math.floor(headers.length / 2)];
  let end = block.index + 1;
  while (end < levels.length && levels[end] !== '"}') {
    end++;
  }
  const middle = block.index + 1 + Math.floor((end - block.index - 1) / 2);
  const oldKey = levels[middle].trim();
  const old = items.find((entry) => 'key' in entry && entry.key === oldKey) as { key: string; atoms: string[] } | undefined;
  if (!old) {
    throw new Error(`tile ${oldKey} at the spawn position is not in the dictionary`);
  }
  const used = new Set(items.filter((entry) => 'key' in entry).map((entry) => (entry as { key: string }).key));
  const keyLength = oldKey.length;
  let newKey = '';
  for (let n = 26 ** keyLength - 1; n >= 0; n--) {
    let candidate = '';
    let rest = n;
    for (let i = 0; i < keyLength; i++) {
      candidate = String.fromCharCode(97 + (rest % 26)) + candidate;
      rest = Math.floor(rest / 26);
    }
    if (!used.has(candidate)) {
      newKey = candidate;
      break;
    }
  }
  if (!newKey) {
    throw new Error('no unused tile key left for the spawn landmark');
  }
  items.push({ key: newKey, atoms: [...old.atoms, spawn.path] });
  levels[middle] = newKey;
  return `block x=${block.x}, line ${middle - block.index}`;
}

function splitAtom(atom: string): { path: string; vars: string } {
  const brace = atom.indexOf('{');
  return brace < 0 ? { path: atom, vars: '' } : { path: atom.slice(0, brace), vars: atom.slice(brace) };
}

function keepDir(vars: string): string {
  const match = /\bdir = (\d+)/.exec(vars);
  return match ? `{dir = ${match[1]}}` : '';
}

function resolve(atomPath: string, rules: Rule[]): { to?: string; drop: boolean } | null {
  for (const rule of rules) {
    if (atomPath === rule.prefix || atomPath.startsWith(rule.prefix + '/')) {
      return rule.drop ? { drop: true } : { to: rule.to, drop: false };
    }
  }
  return null;
}

function declaredTypes(): Set<string> {
  const types = new Set<string>();
  for (const root of DECLARATION_DIRS) {
    for (const file of walk(root)) {
      if (!file.endsWith('.dm')) continue;
      for (const line of fs.readFileSync(file, 'utf-8').split('\n')) {
        const match = /^(\/[a-zA-Z0-9_/]+)/.exec(line);
        if (!match) continue;
        const segments = match[1].split('/').filter(Boolean);
        for (let depth = 1; depth <= segments.length; depth++) {
          types.add('/' + segments.slice(0, depth).join('/'));
        }
      }
    }
  }
  return types;
}

function walk(root: string): string[] {
  const files: string[] = [];
  for (const entry of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, entry.name);
    if (entry.isDirectory()) {
      files.push(...walk(full));
    } else {
      files.push(full);
    }
  }
  return files;
}

async function downloadText(url: string, local: string | undefined, label: string): Promise<string> {
  const bytes = await downloadBytes(url, local, label);
  return Buffer.from(bytes).toString('utf-8');
}

async function downloadBytes(url: string, local: string | undefined, label: string): Promise<Uint8Array> {
  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), DOWNLOAD_TIMEOUT_MS);
    try {
      const response = await fetch(url, { signal: controller.signal });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      console.log(`modular_redtard: downloaded the ${label} from ${url}`);
      return new Uint8Array(await response.arrayBuffer());
    } finally {
      clearTimeout(timeout);
    }
  } catch (error) {
    console.log(`modular_redtard: ${label}: fetch failed (${String(error)}), retrying with curl.`);
  }

  const download = path.join(TMP_DIR, `curl-${label}`);
  const result = spawnSync(process.platform === 'win32' ? 'curl.exe' : 'curl', ['-L', '--fail', '--silent', '--show-error', '--output', download, url], { encoding: 'utf-8' });
  if (result.status === 0) {
    console.log(`modular_redtard: downloaded the ${label} with curl from ${url}`);
    return new Uint8Array(fs.readFileSync(download));
  }

  if (local && fs.existsSync(local)) {
    console.log(`modular_redtard: ${label}: download failed, using the local copy ${local}`);
    return new Uint8Array(fs.readFileSync(local));
  }
  throw new Error(`could not download the ${label} from ${url}: ${result.stderr}`);
}

async function installTitle(config: Config): Promise<void> {
  const shared = path.join(SHARED_DIR, 'title', config.title.file);
  if (!fs.existsSync(shared)) {
    const bytes = await downloadBytes(config.title.url, config.title.local, 'title');
    fs.mkdirSync(path.dirname(shared), { recursive: true });
    fs.writeFileSync(shared, bytes);
  }
  fs.mkdirSync(config.output.title_dir, { recursive: true });
  fs.copyFileSync(shared, path.join(config.output.title_dir, config.title.file));
}

function copyFileOverwrite(from: string, to: string): void {
  fs.mkdirSync(path.dirname(to), { recursive: true });
  fs.copyFileSync(from, to);
}

function writeReport(config: Config, counts: Record<string, Counts>, unmatched: Map<string, number>, usedTargets: Map<string, number>): void {
  const lines = [`# ${config.source.name} port report`, '', `source: ${config.source.url}`, `output: ${config.output.map}`, ''];
  lines.push('| category | kept | replaced | dropped |', '|---|---|---|---|');
  for (const category of Object.keys(counts).sort()) {
    const c = counts[category];
    lines.push(`| ${category} | ${c.kept} | ${c.replaced} | ${c.dropped} |`);
  }
  lines.push('', 'targets used:');
  for (const [target, count] of [...usedTargets.entries()].sort((a, b) => b[1] - a[1])) {
    lines.push(`- ${target}: ${count}`);
  }
  if (unmatched.size) {
    lines.push('', 'no rule matched (dropped):');
    for (const [atomPath, count] of [...unmatched.entries()].sort((a, b) => b[1] - a[1]).slice(0, 200)) {
      lines.push(`- ${atomPath}: ${count}`);
    }
  }
  fs.mkdirSync(TMP_DIR, { recursive: true });
  fs.writeFileSync(path.join(TMP_DIR, 'report.md'), lines.join('\n') + '\n');
  const total = Object.values(counts).reduce((sum, c) => sum + c.kept + c.replaced + c.dropped, 0);
  const replaced = Object.values(counts).reduce((sum, c) => sum + c.replaced, 0);
  const dropped = Object.values(counts).reduce((sum, c) => sum + c.dropped, 0);
  console.log(`modular_redtard: ${config.source.name} ready: ${total} atoms, ${replaced} replaced, ${dropped} dropped. Report: ${TMP_DIR}/report.md`);
}

if (import.meta.main) {
  try {
    await prepareRockhill();
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}
