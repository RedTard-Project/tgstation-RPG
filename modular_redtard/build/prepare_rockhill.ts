import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

const CONFIG_PATH = 'modular_redtard/rockhill/config.json';
const SHARED_DIR = 'modular_redtard/rockhill';
const TMP_DIR = 'tmp/modular_redtard/rockhill';
const DECLARATION_DIRS = ['code', 'modular_redtard'];
const PACK_DIR = path.posix.join(TMP_DIR, 'pack');
const PACK_ROOT = path.resolve(PACK_DIR);
const PACK_GIT_DIR = path.join(PACK_ROOT, '.git');
const LEVEL_LINE = /^\(\d+,\d+,\d+\) = \{"$/;
const TILE_OPEN = /^"([^"]+)" = \($/;
const TURF_VARS = new Set(['dir', 'name', 'desc', 'color']);
const REPLACED_VARS = new Set(['dir', 'pixel_x', 'pixel_y']);
const KEPT_VARS = new Set(['dir', 'pixel_x', 'pixel_y', 'name', 'desc', 'icon_state', 'color']);
const CLOSED_TURF_REMOVED = ['/obj/structure/mineral_door', '/obj/structure/stairs', '/obj/structure/window', '/obj/effect/decal'];
const GROUNDLESS_TURFS = ['/turf/open/water', '/turf/open/transparent', '/turf/open/openspace', '/turf/open/lava'];
const ONE_PER_TILE = ['/obj/structure/chair', '/obj/structure/closet', '/obj/structure/table'];
const NO_IDENTICAL = ['/obj/machinery', '/obj/structure/window'];
const MAPLINT_SCRIPT = 'modular_redtard/tools/run_maplint.py';
const ROLE_TITLES = 'modular_redtard/rockhill/ported/titles.json';
const START_LANDMARK = '/obj/effect/landmark/start/rockhill';
const DECAL_PREFIX = '/obj/effect/decal';
const SPAWN_ROOT = '/obj/effect/landmark/start';
const LATEJOIN_TARGET = '/obj/effect/landmark/latejoin';
const AREA_FLAGS = 'modular_redtard/rockhill/ported/areas.json';
const TEMPLATE_DIR = 'dungeon_generator';
const NO_SKY_TRAIT = 'NoDayorWeather';
const TRANSPARENT_TURFS = ['/turf/open/transparent', '/turf/closed/transparent'];
const KEY_ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

type Rule = { prefix: string; to?: string; rebase?: string; drop?: boolean; exact?: boolean; reskin?: boolean; port?: Record<string, unknown> };

type TitleSource = { file: string; name: string; kind: 'png' | 'dmi'; origin: string };

type Config = {
  source: { name: string; project: string; repository: string; branch: string; map: string; map_json?: string; always_other_z?: string[]; templates?: string; pack: string[] };
  title: { prefix: string; sources: TitleSource[] };
  output: { map: string; map_json: string; title_dir: string };
  replacements: Rule[];
  map_vars?: Record<string, string[]>;
};

type Pop = { path: string; vars: Array<{ name: string; lines: string[] }> };

type Model = { key: string; pops: Pop[]; sourceTurf?: string };

type Sunlight = { levels: string[]; tiles: number; models: number };

type Traits = Record<string, unknown>;

type MapSource = { label: string; name: string; file: string; output: string; traits: Traits[]; template?: boolean };

type Converted = { source: MapSource; header: string[]; models: Model[]; levels: string[] };

type Written = { source: MapSource; sunlight: Sunlight; size: Size; levels: number; usage: Map<string, number> };

type Tally = { kept: number; replaced: number; dropped: number; missing: number };

type Size = { width: number; height: number };

type Declarations = { types: Set<string>; abstract: Set<string> };

type Problems = {
  fatal: Map<string, number>;
  missingObjects: Map<string, number>;
  abstractPlaced: Map<string, number>;
  brokenTiles: string[];
  lostTiles: number;
  stacked: number;
  turfStates: { mapped: number; dropped: number };
  staleRules: string[];
};

export async function prepareRockhill(): Promise<void> {
  const config = readConfig();
  fs.mkdirSync(TMP_DIR, { recursive: true });
  const mapJson = JSON.parse(fs.readFileSync(path.join(SHARED_DIR, 'rockhill.json'), 'utf-8'));
  const station: MapSource = { label: 'map', name: config.source.name, file: config.source.map, output: config.output.map, traits: mapJson.traits };
  const pack = fetchPack(config);
  const sources = [station, ...extraMaps(config, pack, mapJson.traits), ...templateMaps(config)];

  const declarations = declaredTypes();
  const declared = declarations.types;
  const problems: Problems = {
    fatal: new Map(),
    missingObjects: new Map(),
    abstractPlaced: new Map(),
    brokenTiles: [],
    lostTiles: 0,
    stacked: 0,
    turfStates: { mapped: 0, dropped: 0 },
    staleRules: staleReplacementTargets(config.replacements, declared),
  };
  const tally: Record<string, Tally> = {};
  const targets = new Map<string, number>();

  const converted: Converted[] = [];
  for (const source of sources) {
    const lines = readPacked(config, pack, source.file).split(/\r?\n/);
    const levelStart = lines.findIndex((line) => LEVEL_LINE.test(line));
    if (levelStart < 0) {
      throw new Error(`${source.file} has no level sections`);
    }
    const models = parseModels(lines.slice(0, levelStart));
    for (const model of models) {
      model.sourceTurf = lastTurf(model.pops);
      model.pops = convertPops(model, config.replacements, config.map_vars || {}, declarations, tally, problems, targets);
    }
    const header = lines.slice(0, levelStart).filter((line) => line.startsWith('//'));
    converted.push({ source, header, models, levels: lines.slice(levelStart) });
  }
  reportProblems(config, problems);

  const extraDir = path.posix.join(path.posix.dirname(config.output.map), 'otherz');
  fs.rmSync(extraDir, { recursive: true, force: true });
  fs.rmSync(path.posix.join(path.posix.dirname(config.output.map), TEMPLATE_DIR), { recursive: true, force: true });
  const written: Written[] = converted.map((map) => {
    const zLevels = levelCount(map.levels);
    if (map.source !== station && !map.source.template && map.source.traits.length !== zLevels) {
      throw new Error(`${map.source.file} has ${zLevels} z-level(s) but its Ratwood map config lists ${map.source.traits.length} trait set(s)`);
    }
    const sunlight = map.source.template || map.source.traits.some((level) => level[NO_SKY_TRAIT]) ? { levels: map.levels, tiles: 0, models: 0 } : applySunlight(map.models, map.levels, declared);
    writeMap(map.source.output, map.header, map.models, sunlight.levels);
    return { source: map.source, sunlight, size: mapSize(sunlight.levels), levels: zLevels, usage: tileUsage(map.models, sunlight.levels) };
  });

  const count = (atomPath: (candidate: string) => boolean) => written.reduce((total, map) => total + [...map.usage.entries()].filter(([candidate]) => atomPath(candidate)).reduce((sum, [, n]) => sum + n, 0), 0);
  const spawns = count((candidate) => candidate.startsWith(`${SPAWN_ROOT}/`));
  if (!spawns) {
    throw new Error(`the converted maps have no ${SPAWN_ROOT} landmark; port or replace the start landmarks`);
  }
  const latejoins = count((candidate) => candidate === LATEJOIN_TARGET);

  const size = written[0].size;
  mapJson.world_size = [size.width, size.height];
  mapJson.other_z = written.slice(1).filter((map) => !map.source.template).map((map) => ({
    name: map.source.name,
    map_path: path.posix.relative('_maps', path.posix.dirname(map.source.output)),
    map_file: path.posix.basename(map.source.output),
    traits: map.source.traits,
  }));
  fs.mkdirSync(path.dirname(config.output.map_json), { recursive: true });
  fs.writeFileSync(config.output.map_json, `${JSON.stringify(mapJson, null, '\t')}\n`);

  const titles = await installTitles(config);
  writeReport(config, tally, problems, targets, titles, written, spawns, latejoins);
  const lintGroups = new Map<string, string[]>();
  for (const map of written) {
    const label = map.source.template ? `Dungeon Generator - ${path.posix.basename(path.posix.dirname(map.source.output))}` : `Map - ${config.source.name}`;
    lintGroups.set(label, [...(lintGroups.get(label) || []), map.source.output]);
  }
  for (const [label, maps] of lintGroups) {
    runMaplint(label, maps);
  }
}

function extraMaps(config: Config, pack: string, stationTraits: Traits[]): MapSource[] {
  if (!config.source.map_json) {
    return [];
  }
  const world = JSON.parse(readPacked(config, pack, config.source.map_json)) as { other_z?: string[] };
  world.other_z = [...(world.other_z || []), ...(config.source.always_other_z || [])];
  const level = (index: number): Traits => {
    const template = stationTraits[index === 0 ? 0 : Math.min(1, stationTraits.length - 1)] || {};
    return Object.fromEntries(Object.entries(template).filter(([key]) => key !== 'Up' && key !== 'Down'));
  };
  const out: MapSource[] = [];
  for (const entry of world.other_z || []) {
    const conf = JSON.parse(readPacked(config, pack, entry)) as { map_name: string; map_path: string; map_file: string; traits?: Traits[] };
    const id = path.posix.basename(conf.map_file, '.dmm');
    const traits = conf.traits?.length ? conf.traits : [{}];
    out.push({
      label: id,
      name: conf.map_name,
      file: `_maps/${conf.map_path}/${conf.map_file}`,
      output: path.posix.join(path.posix.dirname(config.output.map), 'otherz', `${id}.dmm`),
      traits: traits.map((own, index) => ({ ...level(index), ...Object.fromEntries(Object.entries(own).filter(([key]) => key !== 'Name')) })),
    });
  }
  return out;
}

function templateMaps(config: Config): MapSource[] {
  if (!config.source.templates || !fs.existsSync(config.source.templates)) {
    return [];
  }
  const manifest = JSON.parse(fs.readFileSync(config.source.templates, 'utf-8')) as Array<{ source: string; output: string }>;
  return manifest.map((entry) => ({
    label: path.posix.basename(entry.source, '.dmm'),
    name: path.posix.basename(entry.source, '.dmm'),
    file: entry.source,
    output: entry.output,
    traits: [],
    template: true,
  }));
}

function writeMap(output: string, header: string[], models: Model[], levels: string[]): void {
  const out: string[] = [...header];
  for (const model of models) {
    out.push(`"${model.key}" = (`, ...emitPops(model.pops));
  }
  out.push('', ...levels);
  const text = out.join('\n');
  fs.mkdirSync(path.dirname(output), { recursive: true });
  fs.writeFileSync(`${output}.tmp`, text.endsWith('\n') ? text : `${text}\n`);
  fs.renameSync(`${output}.tmp`, output);
}

function levelCount(levels: string[]): number {
  let count = 0;
  for (const line of levels) {
    const header = /^\(\d+,\d+,(\d+)\) = \{"$/.exec(line);
    if (header) count = Math.max(count, Number(header[1]));
  }
  return count;
}

function readConfig(): Config {
  const config = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8')) as Config;
  if (!config.source?.repository || !config.source.branch || !config.source.map || !config.source.pack?.length || !config.output?.map || !Array.isArray(config.replacements)) {
    throw new Error(`${CONFIG_PATH} must define source.repository, source.branch, source.map, source.pack, output.map and replacements`);
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

function staleReplacementTargets(rules: Rule[], declared: Set<string>): string[] {
  return rules
    .filter((rule) => (rule.to && !declared.has(rule.to)) || (rule.rebase && !declared.has(rule.rebase)))
    .map((rule) => `${rule.prefix} -> ${rule.to || rule.rebase}`)
    .sort();
}

function counted(entries: Map<string, number>): string {
  return [...entries.entries()]
    .sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]))
    .map(([atomPath, count]) => `${atomPath} (${count})`)
    .join('\n  ');
}

function reportProblems(config: Config, problems: Problems): void {
  if (problems.staleRules.length) {
    console.warn(`modular_redtard: WARNING - ${CONFIG_PATH} has ${problems.staleRules.length} replacement(s) pointing at a type the compile lacks; atoms they catch are reported below as missing:\n  ${problems.staleRules.join('\n  ')}`);
  }
  if (problems.missingObjects.size) {
    console.warn(`modular_redtard: WARNING - ${config.source.name} places ${problems.missingObjects.size} object type(s) that are neither ported nor replaced; they are dropped from the map (placements in brackets):\n  ${counted(problems.missingObjects)}`);
  }
  if (problems.abstractPlaced.size) {
    console.warn(`modular_redtard: WARNING - ${config.source.name} places ${problems.abstractPlaced.size} abstract type(s) (abstract_type = own path); retarget them at a concrete subtype:\n  ${counted(problems.abstractPlaced)}`);
  }
  if (!problems.fatal.size && !problems.brokenTiles.length) {
    return;
  }
  const lines = [`${config.source.name} (${config.source.repository} ${config.source.branch}:${config.source.map}) cannot be converted; the generated map was NOT updated.`];
  if (problems.fatal.size) {
    lines.push(`Area/turf types the compile lacks (placements in brackets); ${problems.lostTiles} tile model(s) lose their area or turf to them, and such a tile breaks the map loader:\n  ${counted(problems.fatal)}`);
  }
  if (problems.brokenTiles.length) {
    lines.push(`${problems.brokenTiles.length} tile model(s) end up without exactly one area and a turf:\n  ${problems.brokenTiles.slice(0, 20).join('\n  ')}${problems.brokenTiles.length > 20 ? '\n  ...' : ''}`);
  }
  lines.push(`Port them: run python modular_redtard/tools/port_rockhill.py (it syncs its Ratwood cache to ${config.source.repository} ${config.source.branch}, the branch the map comes from) and commit the result, or add a replacement rule.`);
  throw new Error(lines.join('\n'));
}

export function printMapFailure(error: unknown): void {
  console.error('');
  console.error('============================================================');
  console.error(' MAP GENERATION FAILED - the generated .dmm was NOT updated');
  console.error('============================================================');
  console.error(error instanceof Error ? error.message : String(error));
  console.error('============================================================');
}

function lastTurf(pops: Pop[]): string {
  const turfs = pops.filter((pop) => pop.path.startsWith('/turf/'));
  return turfs.length ? turfs[turfs.length - 1].path : '';
}

function applySunlight(models: Model[], levels: string[], declared: Set<string>): Sunlight {
  const flags = JSON.parse(fs.readFileSync(AREA_FLAGS, 'utf-8')) as { sunlit: string; outdoors: string[] };
  const outdoors = new Set(flags.outdoors);
  const byKey = new Map(models.map((model) => [model.key, model]));
  const columns = new Map<string, number[]>();
  let height = -1;
  levels.forEach((line, index) => {
    const header = /^\((\d+),\d+,(\d+)\) = \{"$/.exec(line);
    if (!header) return;
    const rows: number[] = [];
    for (let row = index + 1; levels[row] !== '"}'; row++) rows.push(row);
    if (height >= 0 && rows.length !== height) {
      throw new Error(`level column ${header[1]},${header[2]} is ${rows.length} tiles high, others are ${height}; the sunlight pass needs equal levels`);
    }
    height = rows.length;
    columns.set(`${header[1]},${header[2]}`, rows);
  });
  const under = (atomPath: string, prefixes: string[]) => prefixes.some((prefix) => atomPath === prefix || atomPath.startsWith(`${prefix}/`));
  const areaOf = (model: Model) => model.pops[model.pops.length - 1].path;
  const transparent = (model: Model) => under(model.sourceTurf || '', TRANSPARENT_TURFS);
  const closed = (model: Model) => under(model.sourceTurf || '', ['/turf/closed']);
  const modelAt = (x: string, row: number, z: number) => {
    const rows = columns.get(`${x},${z}`);
    return rows ? byKey.get(levels[rows[row]]) : undefined;
  };
  const skyVisible = (x: string, row: number, z: number, model: Model): boolean => {
    if (closed(model)) return transparent(model);
    let current = model;
    for (let level = z + 1; ; level++) {
      const above = modelAt(x, row, level);
      if (!above) return outdoors.has(areaOf(current));
      if (!transparent(above)) return false;
      current = above;
    }
  };
  const used = new Set(models.map((model) => model.key));
  const keyLength = models[0].key.length;
  let counter = 0;
  const freshKey = () => {
    while (true) {
      let value = counter++;
      let key = '';
      for (let i = 0; i < keyLength; i++) {
        key = KEY_ALPHABET[value % KEY_ALPHABET.length] + key;
        value = Math.floor(value / KEY_ALPHABET.length);
      }
      if (value) throw new Error(`no free ${keyLength}-letter tile keys left for the sunlit tile models`);
      if (!used.has(key)) {
        used.add(key);
        return key;
      }
    }
  };
  const sunlitKeys = new Map<string, string>();
  const out = [...levels];
  let tiles = 0;
  for (const [position, rows] of columns) {
    const [x, z] = position.split(',');
    rows.forEach((lineIndex, row) => {
      const model = byKey.get(levels[lineIndex]);
      if (!model || closed(model) || !skyVisible(x, row, Number(z), model)) return;
      const area = `${areaOf(model)}/${flags.sunlit}`;
      if (!declared.has(area)) {
        throw new Error(`${area} is not declared; re-run python modular_redtard/tools/port_rockhill.py so every map area gets its sunlit subtype`);
      }
      let key = sunlitKeys.get(model.key);
      if (!key) {
        key = freshKey();
        sunlitKeys.set(model.key, key);
        const lit: Model = { key, pops: [...model.pops.slice(0, -1), { path: area, vars: [] }], sourceTurf: model.sourceTurf };
        models.push(lit);
        byKey.set(key, lit);
      }
      out[lineIndex] = key;
      tiles++;
    });
  }
  return { levels: out, tiles, models: sunlitKeys.size };
}

function convertPops(model: Model, rules: Rule[], mapVars: Record<string, string[]>, declarations: Declarations, tally: Record<string, Tally>, problems: Problems, targets: Map<string, number>): Pop[] {
  const declared = declarations.types;
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
      const missing = kind === 'turf' || kind === 'area' ? problems.fatal : problems.missingObjects;
      missing.set(pop.path, (missing.get(pop.path) || 0) + 1);
      bucket.missing++;
      continue;
    }
    if (declarations.abstract.has(target)) {
      problems.abstractPlaced.set(target, (problems.abstractPlaced.get(target) || 0) + 1);
    }
    let placed = target;
    const stateEdit = kind === 'turf' ? pop.vars.find((entry) => entry.name === 'icon_state') : undefined;
    if (stateEdit) {
      const state = /^\s*icon_state\s*=\s*"([^"[\\]*)"/.exec(stateEdit.lines[0])?.[1];
      const variant = state === undefined ? '' : `${target}/state_${state.replace(/[^A-Za-z0-9_]/g, '_')}`;
      if (variant && declared.has(variant)) {
        placed = variant;
        problems.turfStates.mapped++;
      } else {
        problems.turfStates.dropped++;
      }
    }
    const replaced = target !== pop.path;
    if (replaced) {
      bucket.replaced++;
    } else {
      bucket.kept++;
    }
    targets.set(placed, (targets.get(placed) || 0) + 1);
    const allowed = kind === 'area' ? new Set<string>() : kind === 'turf' ? TURF_VARS : replaced && !rule?.port ? REPLACED_VARS : KEPT_VARS;
    const extra = Object.entries(mapVars).filter(([prefix]) => under(prefix)).flatMap(([, names]) => names);
    const vars = pop.vars.filter((entry) => allowed.has(entry.name) || extra.includes(entry.name));
    kept.push({ path: placed, vars: placed === START_LANDMARK || placed.startsWith(`${START_LANDMARK}/`) ? landmarkVars(vars) : vars });
  }
  const areas = kept.filter((pop) => pop.path === '/area' || pop.path.startsWith('/area/'));
  const turfs = kept.filter((pop) => pop.path.startsWith('/turf/'));
  if (areas.length !== 1 || !turfs.length) {
    if (model.pops.some((pop) => problems.fatal.has(pop.path))) {
      problems.lostTiles++;
    } else {
      problems.brokenTiles.push(`"${model.key}": ${areas.length} area(s), ${turfs.length} turf(s)`);
    }
    return kept;
  }
  const objects = kept.filter((pop) => pop.path !== '/area' && !pop.path.startsWith('/area/') && !pop.path.startsWith('/turf/'));
  return [...withoutStacking(objects, problems), turfs[turfs.length - 1], areas[0]];
}

let roleTitlesCache: Record<string, string> | null = null;

function roleTitles(): Record<string, string> {
  if (!roleTitlesCache) {
    roleTitlesCache = fs.existsSync(ROLE_TITLES) ? (JSON.parse(fs.readFileSync(ROLE_TITLES, 'utf-8')) as Record<string, string>) : {};
  }
  return roleTitlesCache;
}

function landmarkVars(vars: Pop['vars']): Pop['vars'] {
  const titles = roleTitles();
  const role = (raw: string) => titles[raw] || raw;
  return vars.flatMap((entry) => {
    const text = entry.lines.join(' ');
    if (entry.name === 'name') {
      const quoted = /"([^"]*)"/.exec(text);
      return quoted ? [{ name: 'name', lines: [`\tname = "${role(quoted[1])}"`] }] : [];
    }
    if (entry.name === 'jobspawn_override') {
      const roles = [...text.matchAll(/"([^"]*)"/g)].map((match) => match[1]).filter((name) => titles[name]).map((name) => `"${titles[name]}"`);
      return roles.length ? [{ name: 'rockhill_latejoin_roles', lines: [`\trockhill_latejoin_roles = list(${roles.join(', ')})`] }] : [];
    }
    return [entry];
  });
}

function withoutStacking(objects: Pop[], problems: Problems): Pop[] {
  const families = new Set<string>();
  const identical = new Set<string>();
  return objects.filter((pop) => {
    const under = (prefix: string) => pop.path === prefix || pop.path.startsWith(`${prefix}/`);
    const family = ONE_PER_TILE.find(under);
    const signature = NO_IDENTICAL.some(under) ? `${pop.path}${JSON.stringify(pop.vars.map((entry) => entry.lines))}` : null;
    if ((family && families.has(family)) || (signature && identical.has(signature))) {
      problems.stacked++;
      return false;
    }
    if (family) families.add(family);
    if (signature) identical.add(signature);
    return true;
  });
}

export function runBootstrapPython(args: string[]): { status: number | null; output: string } {
  const python = process.platform === 'win32' ? 'tools\\bootstrap\\python.bat' : 'tools/bootstrap/python';
  const quoted = process.platform === 'win32' ? args.map((arg) => (/\s/.test(arg) ? `"${arg}"` : arg)) : args;
  const result = spawnSync(python, quoted, { encoding: 'utf-8', shell: process.platform === 'win32' });
  return { status: result.status, output: `${result.stdout || ''}${result.stderr || ''}`.trim() };
}

function runMaplint(label: string, maps: string[]): void {
  const list = path.posix.join(TMP_DIR, 'maplint.txt');
  fs.writeFileSync(list, `${maps.join('\n')}\n`);
  const { status, output } = runBootstrapPython([MAPLINT_SCRIPT, '--list', list]);
  const summaryLine = /^maplint: (\d+)\/(\d+)$/;
  const lines = output.split(/\r?\n/);
  const summary = lines.map((line) => summaryLine.exec(line.trim())).find(Boolean);
  const counts = summary ? `${summary[1]}/${summary[2]}` : `?/${maps.length}`;
  if (status === 0) {
    console.log(`modular_redtard: maplint: ${label} - [${counts}]`);
    return;
  }
  const details = lines.filter((line) => !summaryLine.test(line.trim())).join('\n').trim();
  console.warn(`modular_redtard: WARNING - maplint (tools/maplint, the TG map rules): ${label} - [${counts}]\n${details}`);
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

function declaredTypes(): Declarations {
  const types = new Set<string>();
  const abstract = new Set<string>();
  for (const root of DECLARATION_DIRS) {
    for (const file of walk(root)) {
      if (!file.endsWith('.dm')) continue;
      let current: string | null = null;
      for (const raw of fs.readFileSync(file, 'utf-8').split('\n')) {
        const line = raw.replace(/\r$/, '');
        const own = /^\s+abstract_type\s*=\s*(\/[\w/]+)\s*$/.exec(line);
        if (own) {
          if (own[1] === current) abstract.add(current);
          continue;
        }
        const match = /^(\/[a-zA-Z0-9_/]+)/.exec(line);
        if (!match) continue;
        current = /^(\/[\w/]+)\s*$/.test(line) ? match[1] : null;
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
  return { types, abstract };
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

function fetchPack(config: Config): string {
  const { repository, branch, pack } = config.source;
  const remote = `refs/remotes/origin/${branch}`;
  assertPackLocation();
  if (!packRepositoryValid(remote)) {
    fs.rmSync(PACK_ROOT, { recursive: true, force: true });
    runGit(['clone', '--quiet', '--depth', '1', '--filter=blob:none', '--no-checkout', '--config', 'gc.auto=0', '--config', 'maintenance.auto=false', '--branch', branch, repository, PACK_ROOT]);
    if (!packRepositoryValid(remote)) {
      throw new Error(`${PACK_DIR}: the fresh clone is not a valid git repository; refusing to run git there`);
    }
  } else {
    packGit(['remote', 'set-url', 'origin', repository]);
    packGit(['fetch', '--quiet', '--depth', '1', '--filter=blob:none', 'origin', `+refs/heads/${branch}:${remote}`]);
  }
  packGit(['config', 'core.sparseCheckout', 'true']);
  packGit(['config', 'gc.auto', '0']);
  packGit(['config', 'maintenance.auto', 'false']);
  fs.mkdirSync(path.join(PACK_GIT_DIR, 'info'), { recursive: true });
  fs.writeFileSync(path.join(PACK_GIT_DIR, 'info', 'sparse-checkout'), `${pack.join('\n')}\n`);
  packGit(['checkout', '--quiet', '--force', '--detach', remote]);
  const commit = packGit(['rev-parse', '--short', 'HEAD']);
  const files = packGit(['ls-files', '-t']).split('\n').filter((line) => line.startsWith('H ')).map((line) => line.slice(2));
  const bytes = files.reduce((total, file) => total + fs.statSync(path.join(PACK_ROOT, file)).size, 0);
  console.log(`modular_redtard: ${config.source.project} ${branch} @ ${commit}: ${files.length} map file(s), ${(bytes / 1048576).toFixed(1)} MB, fetched as one git pack (source.pack in ${CONFIG_PATH})`);
  return PACK_DIR;
}

function samePath(a: string, b: string): boolean {
  const normal = (value: string) => {
    const resolved = path.resolve(value).replace(/\\/g, '/').replace(/\/+$/, '');
    return process.platform === 'win32' ? resolved.toLowerCase() : resolved;
  };
  return normal(a) === normal(b);
}

function assertPackLocation(): void {
  const tmpRoot = path.resolve(TMP_DIR);
  if (!PACK_ROOT.startsWith(tmpRoot + path.sep) || samePath(PACK_GIT_DIR, path.resolve('.git'))) {
    throw new Error(`refusing to use ${PACK_ROOT} as the map pack: it must be a folder inside ${tmpRoot}`);
  }
}

function packRepositoryValid(remote: string): boolean {
  if (!fs.existsSync(path.join(PACK_GIT_DIR, 'HEAD'))) {
    return false;
  }
  const gitDir = gitResult(['--git-dir', PACK_GIT_DIR, 'rev-parse', '--absolute-git-dir']);
  if (gitDir.status !== 0 || !samePath((gitDir.stdout || '').trim(), PACK_GIT_DIR)) {
    return false;
  }
  return gitResult(['--git-dir', PACK_GIT_DIR, 'rev-parse', '--verify', '--quiet', remote]).status === 0;
}

function readPacked(config: Config, pack: string, file: string): string {
  const full = path.posix.join(pack, file);
  if (!fs.existsSync(full)) {
    throw new Error(`${config.source.project} ${config.source.branch} has no ${file} in the pack; add its folder to source.pack in ${CONFIG_PATH} (or the file is gone upstream)`);
  }
  return fs.readFileSync(full, 'utf-8');
}

function packGit(args: string[]): string {
  return runGit(['--git-dir', PACK_GIT_DIR, '--work-tree', PACK_ROOT, '-c', 'gc.auto=0', '-c', 'maintenance.auto=false', ...args]);
}

function gitResult(args: string[]) {
  const env: Record<string, string | undefined> = { ...process.env, GIT_CEILING_DIRECTORIES: path.dirname(PACK_ROOT) };
  for (const name of ['GIT_DIR', 'GIT_WORK_TREE', 'GIT_INDEX_FILE', 'GIT_COMMON_DIR']) {
    delete env[name];
  }
  fs.mkdirSync(path.dirname(PACK_ROOT), { recursive: true });
  return spawnSync('git', args, { encoding: 'utf-8', cwd: path.dirname(PACK_ROOT), env });
}

function runGit(args: string[]): string {
  const result = gitResult(args);
  if (result.error) {
    throw new Error(`git is required to fetch the ${PACK_DIR} map pack: ${String(result.error)}`);
  }
  if (result.status !== 0) {
    throw new Error(`git ${args.join(' ')} failed for ${PACK_DIR}:\n${`${result.stdout || ''}${result.stderr || ''}`.trim()}`);
  }
  return (result.stdout || '').trim();
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
    fs.copyFileSync(from, path.join(dir, `${config.title.prefix}${source.name}.${source.kind}`));
    written++;
  }
  return written;
}

function writeReport(config: Config, tally: Record<string, Tally>, problems: Problems, targets: Map<string, number>, titles: number, maps: Written[], spawns: number, latejoins: number): void {
  const missingObjects = problems.missingObjects;
  const station = maps[0];
  const lines = [`# ${config.source.name} port report`, '', `source: ${config.source.repository} ${config.source.branch}:${config.source.map}`, `output: ${config.output.map}`, `world size: ${station.size.width}x${station.size.height}`, `spawn tiles: ${spawns}, latejoin tiles: ${latejoins}`, `title screens: ${titles}`, ''];
  lines.push('| map | size | z-levels | sunlit tiles (open sky above, Ratwood roof rule) | output |', '|---|---|---|---|---|');
  for (const map of maps) {
    lines.push(`| ${map.source.name} | ${map.size.width}x${map.size.height} | ${map.levels} | ${map.sunlight.tiles} in ${map.sunlight.models} split tile models | \`${map.source.output}\` |`);
  }
  lines.push('');
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
  if (problems.abstractPlaced.size) {
    lines.push('', 'abstract types placed on the map:');
    for (const [atomPath, count] of [...problems.abstractPlaced.entries()].sort((a, b) => b[1] - a[1])) {
      lines.push(`- ${atomPath}: ${count}`);
    }
  }
  lines.push('', `turf icon_state edits: ${problems.turfStates.mapped} moved to state_* subtypes (rockhill/ported/turf_states.dm), ${problems.turfStates.dropped} dropped (smoothing, a look Ratwood forces at load, or not ported yet)`);
  lines.push('', `stacked duplicates removed (one chair/table/closet per tile, no identical machinery or windows - the TG maplint rules): ${problems.stacked}`);
  if (problems.staleRules.length) {
    lines.push('', 'replacement rules pointing at missing types:', ...problems.staleRules.map((rule) => `- ${rule}`));
  }
  const report = path.join(path.dirname(config.output.map), 'report.md');
  fs.writeFileSync(report, `${lines.join('\n')}\n`);
  const sum = (field: keyof Tally) => Object.values(tally).reduce((total, t) => total + t[field], 0);
  const extras = maps.slice(1).filter((map) => !map.source.template).map((map) => `${map.source.name} ${map.size.width}x${map.size.height}x${map.levels}`).join(', ');
  const templates = maps.filter((map) => map.source.template).length;
  console.log(`modular_redtard: ${config.source.name} ready (${station.size.width}x${station.size.height}${extras ? `; other z: ${extras}` : ''}${templates ? `; ${templates} dungeon templates` : ''}):${sum('kept')} kept, ${sum('replaced')} replaced, ${sum('dropped')} dropped, ${sum('missing')} missing, ${problems.stacked} stacked duplicates removed; ${spawns} spawn and ${latejoins} latejoin tiles. Report: ${report}`);
}

if (import.meta.main) {
  try {
    await prepareRockhill();
  } catch (error) {
    printMapFailure(error);
    process.exit(1);
  }
}
