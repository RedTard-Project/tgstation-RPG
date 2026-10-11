import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { framesOf, parseDmi, writePng } from './title_frames.ts';

const CONFIG_PATH = 'modular_redtard/rockhill/config.json';
const SHARED_DIR = 'modular_redtard/rockhill';
const TMP_DIR = 'tmp/modular_redtard/rockhill';
const DECLARATION_DIRS = ['code', 'modular_redtard'];
const DOWNLOAD_TIMEOUT_MS = 180000;
const LEVEL_LINE = /^\(\d+,\d+,\d+\) = \{"$/;
const TILE_OPEN = /^"([^"]+)" = \($/;
const TURF_VARS = new Set(['dir']);
const REPLACED_VARS = new Set(['dir', 'pixel_x', 'pixel_y']);
const KEPT_VARS = new Set(['dir', 'pixel_x', 'pixel_y', 'name', 'desc', 'icon_state', 'color']);
const CLOSED_TURF_REMOVED = ['/obj/structure/mineral_door', '/obj/structure/stairs', '/obj/structure/window', '/obj/structure/roguewindow', '/obj/effect/decal'];
const GROUNDLESS_TURFS = ['/turf/open/water', '/turf/open/transparent', '/turf/open/openspace', '/turf/open/lava'];
const DECAL_PREFIX = '/obj/effect/decal';
const SPAWN_ROOT = '/obj/effect/landmark/start';
const LATEJOIN_TARGET = '/obj/effect/landmark/latejoin';

type Rule = { prefix: string; to?: string; rebase?: string; drop?: boolean; exact?: boolean; reskin?: boolean };

type TitleSource = { file: string; name: string; kind: 'png' | 'dmi'; origin: string };

type Config = {
  source: { name: string; project: string; url: string; local?: string };
  title: { prefix: string; sources: TitleSource[] };
  output: { map: string; map_json: string; title_dir: string };
  replacements: Rule[];
};

type Pop = { path: string; vars: Array<{ name: string; lines: string[] }> };

type Model = { key: string; pops: Pop[] };

type Tally = { kept: number; replaced: number; dropped: number; missing: number };

type Size = { width: number; height: number };

export async function prepareRockhill(): Promise<void> {
  const config = readConfig();
  fs.mkdirSync(TMP_DIR, { recursive: true });

  const source = await downloadText(config.source.url, config.source.local, 'map');
  const lines = source.split(/\r?\n/);
  const levelStart = lines.findIndex((line) => LEVEL_LINE.test(line));
  if (levelStart < 0) {
    throw new Error('the source map has no level sections');
  }
  const header = lines.slice(0, levelStart).filter((line) => line.startsWith('//'));
  const models = parseModels(lines.slice(0, levelStart));
  const levels = lines.slice(levelStart);

  const declared = declaredTypes();
  checkReplacementTargets(config.replacements, declared);

  const tally: Record<string, Tally> = {};
  const fatal = new Map<string, number>();
  const missingObjects = new Map<string, number>();
  const targets = new Map<string, number>();
  for (const model of models) {
    model.pops = convertPops(model, config.replacements, declared, tally, fatal, missingObjects, targets);
  }
  if (fatal.size) {
    throw new Error(`the map uses turf/area types the compile lacks; port them with modular_redtard/tools/port_rockhill.py or add a replacement:\n  ${[...fatal.keys()].sort().join('\n  ')}`);
  }
  if (missingObjects.size) {
    console.warn(`modular_redtard: WARNING - ${missingObjects.size} object type(s) are neither ported nor replaced and were dropped (see report.md next to ${config.output.map}).`);
  }

  const usage = tileUsage(models, levels);
  const spawns = [...usage.entries()].filter(([atomPath]) => atomPath.startsWith(`${SPAWN_ROOT}/`)).reduce((total, [, count]) => total + count, 0);
  if (!spawns) {
    throw new Error(`the converted map has no ${SPAWN_ROOT} landmark; port or replace the start landmarks`);
  }
  const latejoins = usage.get(LATEJOIN_TARGET) || 0;

  const out: string[] = [...header];
  for (const model of models) {
    out.push(`"${model.key}" = (`, ...emitPops(model.pops));
  }
  out.push(...levels);
  const text = out.join('\n');
  fs.mkdirSync(path.dirname(config.output.map), { recursive: true });
  fs.writeFileSync(`${config.output.map}.tmp`, text.endsWith('\n') ? text : `${text}\n`);
  fs.renameSync(`${config.output.map}.tmp`, config.output.map);

  const size = mapSize(levels);
  const mapJson = JSON.parse(fs.readFileSync(path.join(SHARED_DIR, 'rockhill.json'), 'utf-8'));
  mapJson.world_size = [size.width, size.height];
  fs.mkdirSync(path.dirname(config.output.map_json), { recursive: true });
  fs.writeFileSync(config.output.map_json, `${JSON.stringify(mapJson, null, '\t')}\n`);

  const titles = await installTitles(config);
  writeReport(config, tally, missingObjects, targets, titles, size, spawns, latejoins);
}

function readConfig(): Config {
  const config = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8')) as Config;
  if (!config.source?.url || !config.output?.map || !Array.isArray(config.replacements)) {
    throw new Error(`${CONFIG_PATH} must define source.url, output.map and replacements`);
  }
  return config;
}

function parseModels(lines: string[]): Model[] {
  const models: Model[] = [];
  let index = 0;
  while (index < lines.length) {
    const match = TILE_OPEN.exec(lines[index]);
    index++;
    if (!match) {
      continue;
    }
    const pops: Pop[] = [];
    let closed = false;
    while (!closed) {
      const line = lines[index];
      if (line === undefined) {
        throw new Error(`tile ${match[1]} is never closed`);
      }
      index++;
      if (line.endsWith('{')) {
        const pop: Pop = { path: line.slice(0, -1), vars: [] };
        while (true) {
          const varLine = lines[index];
          if (varLine === undefined) {
            throw new Error(`unterminated var block for ${pop.path} in tile ${match[1]}`);
          }
          index++;
          const close = /^\s*\}([,)])$/.exec(varLine);
          if (close) {
            closed = close[1] === ')';
            break;
          }
          const block = [varLine];
          while (insideLongString(block)) {
            const next = lines[index];
            if (next === undefined) {
              throw new Error(`unterminated string for ${pop.path} in tile ${match[1]}`);
            }
            index++;
            block.push(next);
          }
          block[block.length - 1] = block[block.length - 1].replace(/;$/, '');
          const name = /^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=/.exec(block[0]);
          pop.vars.push({ name: name ? name[1] : '', lines: block });
        }
        pops.push(pop);
      } else {
        closed = line.endsWith(')');
        pops.push({ path: line.slice(0, -1), vars: [] });
      }
    }
    models.push({ key: match[1], pops });
  }
  return models;
}

function insideLongString(block: string[]): boolean {
  const text = block.join('\n');
  return text.split('{"').length > text.split('"}').length;
}

function longestRule(atomPath: string, rules: Rule[]): Rule | null {
  let best: Rule | null = null;
  for (const rule of rules) {
    const matched = rule.exact ? atomPath === rule.prefix : atomPath === rule.prefix || atomPath.startsWith(`${rule.prefix}/`);
    if (matched && (!best || rule.prefix.length > best.prefix.length)) {
      best = rule;
    }
  }
  return best;
}

function checkReplacementTargets(rules: Rule[], declared: Set<string>): void {
  const stale = rules.filter((rule) => rule.to && !declared.has(rule.to)).map((rule) => `${rule.prefix} -> ${rule.to}`);
  if (stale.length) {
    throw new Error(`${CONFIG_PATH} replaces into types the compile lacks:\n  ${stale.join('\n  ')}`);
  }
}

function convertPops(model: Model, rules: Rule[], declared: Set<string>, tally: Record<string, Tally>, fatal: Map<string, number>, missingObjects: Map<string, number>, targets: Map<string, number>): Pop[] {
  const kept: Pop[] = [];
  const sourceTurfs = model.pops.filter((pop) => pop.path.startsWith('/turf/'));
  const sourceTurf = sourceTurfs.length ? sourceTurfs[sourceTurfs.length - 1].path : '';
  const closed = sourceTurf.startsWith('/turf/closed/');
  const groundless = GROUNDLESS_TURFS.some((prefix) => sourceTurf === prefix || sourceTurf.startsWith(`${prefix}/`));
  for (const pop of model.pops) {
    const kind = pop.path.split('/')[1] || 'other';
    const bucket = (tally[kind] ||= { kept: 0, replaced: 0, dropped: 0, missing: 0 });
    const rule = longestRule(pop.path, rules);
    if (rule?.drop) {
      bucket.dropped++;
      continue;
    }
    const target = rule?.rebase ? `${rule.rebase}${pop.path.slice(rule.prefix.length)}` : rule?.to || pop.path;
    const under = (prefix: string) => [pop.path, target].some((candidate) => candidate === prefix || candidate.startsWith(`${prefix}/`));
    if ((closed && CLOSED_TURF_REMOVED.some(under)) || (groundless && under(DECAL_PREFIX))) {
      bucket.dropped++;
      continue;
    }
    if (!declared.has(target)) {
      if (kind === 'turf' || kind === 'area') {
        fatal.set(pop.path, (fatal.get(pop.path) || 0) + 1);
      } else {
        missingObjects.set(pop.path, (missingObjects.get(pop.path) || 0) + 1);
      }
      bucket.missing++;
      continue;
    }
    const replaced = target !== pop.path;
    if (replaced) {
      bucket.replaced++;
    } else {
      bucket.kept++;
    }
    targets.set(target, (targets.get(target) || 0) + 1);
    const allowed = kind === 'area' ? new Set<string>() : kind === 'turf' ? TURF_VARS : replaced ? REPLACED_VARS : KEPT_VARS;
    kept.push({ path: target, vars: pop.vars.filter((entry) => allowed.has(entry.name)) });
  }
  const areas = kept.filter((pop) => pop.path === '/area' || pop.path.startsWith('/area/'));
  const turfs = kept.filter((pop) => pop.path.startsWith('/turf/'));
  if (areas.length !== 1 || !turfs.length) {
    throw new Error(`tile ${model.key} needs one area and a turf after conversion, has ${areas.length} area(s) and ${turfs.length} turf(s)`);
  }
  const objects = kept.filter((pop) => pop.path !== '/area' && !pop.path.startsWith('/area/') && !pop.path.startsWith('/turf/'));
  return [...objects, turfs[turfs.length - 1], areas[0]];
}

function emitPops(pops: Pop[]): string[] {
  const lines: string[] = [];
  pops.forEach((pop, index) => {
    const end = index === pops.length - 1 ? ')' : ',';
    if (!pop.vars.length) {
      lines.push(`${pop.path}${end}`);
      return;
    }
    lines.push(`${pop.path}{`);
    pop.vars.forEach((entry, varIndex) => {
      const block = entry.lines.map((line, lineIndex) => (lineIndex === 0 ? `\t${line.trim()}` : line));
      if (varIndex < pop.vars.length - 1) {
        block[block.length - 1] = `${block[block.length - 1]};`;
      }
      lines.push(...block);
    });
    lines.push(`\t}${end}`);
  });
  return lines;
}

function tileUsage(models: Model[], levels: string[]): Map<string, number> {
  const byKey = new Map(models.map((model) => [model.key, model.pops.map((pop) => pop.path)]));
  const usage = new Map<string, number>();
  for (const line of levels) {
    const paths = byKey.get(line);
    if (!paths) {
      continue;
    }
    for (const atomPath of paths) {
      usage.set(atomPath, (usage.get(atomPath) || 0) + 1);
    }
  }
  return usage;
}

function mapSize(levels: string[]): Size {
  let width = 0;
  let height = 0;
  let open = -1;
  levels.forEach((line, index) => {
    const header = /^\((\d+),\d+,\d+\) = \{"$/.exec(line);
    if (header) {
      width = Math.max(width, Number(header[1]));
      open = index;
    } else if (line === '"}' && open >= 0) {
      height = Math.max(height, index - open - 1);
      open = -1;
    }
  });
  return { width, height };
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
  if (types.size < 10000) {
    throw new Error(`type scanner found only ${types.size} declared paths; run from the repository root`);
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

async function installTitles(config: Config): Promise<number> {
  const dir = config.output.title_dir;
  fs.mkdirSync(dir, { recursive: true });
  for (const name of fs.readdirSync(dir)) {
    if (name.startsWith('Rockhill+')) {
      fs.rmSync(path.join(dir, name));
    }
  }
  let written = 0;
  for (const source of config.title.sources) {
    const from = path.join(SHARED_DIR, 'title', source.file);
    if (!fs.existsSync(from)) {
      throw new Error(`title asset ${from} is missing; copy it from ${source.origin}`);
    }
    const bytes = new Uint8Array(fs.readFileSync(from));
    if (source.kind === 'png') {
      fs.writeFileSync(path.join(dir, `${config.title.prefix}${source.name}.png`), bytes);
      written++;
      continue;
    }
    const frames = framesOf(parseDmi(bytes));
    frames.forEach((frame, index) => {
      writePng(path.join(dir, `${config.title.prefix}${source.name}-${String(index + 1).padStart(3, '0')}.png`), frame);
    });
    written += frames.length;
  }
  return written;
}

function writeReport(config: Config, tally: Record<string, Tally>, missingObjects: Map<string, number>, targets: Map<string, number>, titles: number, size: Size, spawns: number, latejoins: number): void {
  const lines = [`# ${config.source.name} port report`, '', `source: ${config.source.url}`, `output: ${config.output.map}`, `world size: ${size.width}x${size.height}`, `spawn tiles: ${spawns}, latejoin tiles: ${latejoins}`, `title screens: ${titles}`, ''];
  lines.push('| kind | kept | replaced | dropped | missing |', '|---|---|---|---|---|');
  for (const kind of Object.keys(tally).sort()) {
    const t = tally[kind];
    lines.push(`| ${kind} | ${t.kept} | ${t.replaced} | ${t.dropped} | ${t.missing} |`);
  }
  lines.push('', 'replacement targets:');
  for (const rule of config.replacements.filter((entry) => entry.to)) {
    lines.push(`- ${rule.prefix} -> ${rule.to}: ${targets.get(rule.to as string) || 0} placements`);
  }
  if (missingObjects.size) {
    lines.push('', 'object types neither ported nor replaced (dropped):');
    for (const [atomPath, count] of [...missingObjects.entries()].sort((a, b) => b[1] - a[1])) {
      lines.push(`- ${atomPath}: ${count}`);
    }
  }
  const report = path.join(path.dirname(config.output.map), 'report.md');
  fs.writeFileSync(report, `${lines.join('\n')}\n`);
  const sum = (field: keyof Tally) => Object.values(tally).reduce((total, t) => total + t[field], 0);
  console.log(`modular_redtard: ${config.source.name} ready (${size.width}x${size.height}): ${sum('kept')} kept, ${sum('replaced')} replaced, ${sum('dropped')} dropped, ${sum('missing')} missing; ${spawns} spawn and ${latejoins} latejoin tiles. Report: ${report}`);
}

if (import.meta.main) {
  try {
    await prepareRockhill();
  } catch (error) {
    console.error('');
    console.error('============================================================');
    console.error(' MAP GENERATION FAILED - the generated .dmm was NOT updated');
    console.error('============================================================');
    console.error(error instanceof Error ? error.message : String(error));
    console.error('============================================================');
    process.exit(1);
  }
}
