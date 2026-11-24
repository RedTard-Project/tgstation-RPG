import fs from 'node:fs';
import { DreamDaemon, DreamMaker } from '../../tools/build/lib/byond';
import { prepareRockhill, printMapFailure, runBootstrapPython } from './prepare_rockhill.ts';

const UPSTREAM_DME = 'tgstation.dme';
const MODULE_INCLUDE = '#include "modular_redtard\\_module.dme"';
const END_INCLUDE = '// END_INCLUDE';
/// TG's defines the module changes before TG's code reads them (modular_redtard/maps/z_depth.dm): included right after them.
const LAYERS_INCLUDE = '#include "code\\__DEFINES\\layers.dm"';
const EARLY_DEFINES_INCLUDE = '#include "modular_redtard\\maps\\z_depth.dm"';
const FINAL_DMB = 'tgstation.dmb';
const FINAL_RSC = 'tgstation.rsc';
const BUILD_BASE = 'tgstation.redtard.m';
const TEST_BASE = 'tgstation.redtard.test';
const CI_LOG_DIR = 'data/logs/ci';
const NEXT_MAP = 'data/next_map.json';
const NEXT_MAP_BACKUP = 'data/next_map.json.redtard-backup';
const LOWMEM_MARKER = 'redtard_lowmem';
const PREREQUISITES = ['icon-cutter', 'behavior-tree-compiler', 'tgui', 'tg-font'];
const CONTENT_CHECK = 'modular_redtard/tools/check_modular_content.py';
const BUILD_STAMP = '.cache/modular_redtard/build_stamp.json';
// What the game binary is compiled from: TG's own list (tools/build/build.ts, DmTarget) and the module with the value
// files it compiles in. The light launch compiles only when one of these is newer than the binary.
const DM_INPUTS = [
  'tgstation.dme',
  '_maps/map_files/generic',
  'code',
  'html',
  'icons',
  'interface',
  'sound',
  'tgui/public/tgui.html',
  'modular_redtard',
  'config/redtard/mechanics',
];
// Folders of the module that hold no game source, and files that are never compiled in.
const DM_INPUT_SKIP_FOLDERS = [
  'modular_redtard/build',
  'modular_redtard/tools',
  'modular_redtard/tgui',
  'modular_redtard/tests',
];
const DM_INPUT_SKIP_FILES = /\.(md|py|pyc|ts|cmd|sh|log|int|lk|rsc|dmb)$/i;
// What the tgui bundles are built from (TG's TguiTarget and the module's two bundles) and what must exist after it.
const INTERFACE_INPUTS = [
  'tgui/packages',
  'tgui/rspack.config.ts',
  'tgui/package.json',
  'tgui/bun.lock',
  'tgui/tsconfig.json',
  'modular_redtard/tgui',
];
const INTERFACE_OUTPUTS = [
  'tgui/public/tgui.bundle.js',
  'tgui/public/tgui.bundle.css',
  'tgui/public/tgui-panel.bundle.js',
  'tgui/public/tgui-rogue-lobby.bundle.js',
  'tgui/public/tgui-rogue-panel.bundle.js',
];
// When the compile of the game binary began: sources are compared with this moment, not with the binary's own time,
// so a file saved while the compiler ran counts as changed.
let compileStartedAt = 0;
// The list of the binary's source files at that moment (scanSources()).
let compileSourceList = '';
const MODULE_DEFINES = ['MINIMAL_CENTCOM'];
const ROGUE_LOBBY_CONFIG = '../modular_redtard/tgui/rspack.rogue_lobby.ts';
const ROGUE_LOBBY_INPUTS = ['modular_redtard/tgui', 'tgui/packages/tgui-lobby', 'tgui/rspack.config.ts'];
const ROGUE_LOBBY_OUTPUTS = ['tgui/public/tgui-rogue-lobby.bundle.js', 'tgui/public/tgui-rogue-lobby.bundle.css'];
const ROGUE_PANEL_CONFIG = '../modular_redtard/tgui/rspack.rogue_panel.ts';
const ROGUE_PANEL_INPUTS = ['modular_redtard/tgui/rogue_panel', 'modular_redtard/tgui/rspack.rogue_panel.ts', 'tgui/packages/tgui-panel', 'tgui/packages/tgui', 'tgui/rspack.config.ts'];
const ROGUE_PANEL_OUTPUTS = ['tgui/public/tgui-rogue-panel.bundle.js', 'tgui/public/tgui-rogue-panel.bundle.css'];

type BuildOptions = {
  target: string;
  defines: string[];
  dmVersion: string | null;
  warningsAsErrors: boolean;
  ignoreWarningCodes: string[];
  port: string;
  map: string;
  era: string;
  focus: boolean;
  noBuild: boolean;
  rebuild: boolean;
  maps: boolean;
  noRun: boolean;
  noDungeon: boolean;
  rawArgs: string[];
  parameterArgs: string[];
};

async function main() {
  const options = parseArgs(process.argv.slice(2));
  switch (options.target) {
    case 'dm':
    case 'build':
      await runPrerequisites();
      await compileModular(BUILD_BASE, ['CBT', ...options.defines], options);
      promoteArtifacts(options);
      break;
    case 'server':
      await runPrerequisites();
      await compileModular(BUILD_BASE, ['CBT', ...options.defines], options);
      promoteArtifacts(options);
      resetNextMapForNormalStart();
      await DreamDaemon({ dmbFile: FINAL_DMB, namedDmVersion: options.dmVersion }, options.port, '-trusted');
      break;
    case 'lowmem':
      // The light launch is for getting onto the test map fast (owner's decision 2026-11-24): tgui is rebuilt when its
      // sources changed, the game is compiled when its sources changed, and nothing else runs. The maps of Rockhill are
      // not touched at all — no question to the map source's server, no comparison, no conversion, no maplint (--maps
      // asks for them) — and the content check is left to the dm target.
      if (!options.noBuild) {
        const stale = options.rebuild ? 'asked with --rebuild' : binaryStaleness(options);
        const interfaceStale = options.rebuild ? 'asked with --rebuild' : interfaceStaleness();
        // TG's own build decides what of its prerequisites to redo, but asking it takes seconds: it is asked only when
        // something it builds from has changed.
        if (stale || interfaceStale) {
          console.log(`modular_redtard: running the prerequisites (${interfaceStale ?? stale}).`);
          await runPrerequisites();
        } else {
          console.log('modular_redtard: tgui is newer than its sources: prerequisites skipped.');
        }
        if (stale) {
          console.log(`modular_redtard: compiling the game (${stale}).`);
          await compileModular(BUILD_BASE, ['CBT', ...options.defines], options, !options.maps);
          promoteArtifacts(options);
        } else {
          console.log(`modular_redtard: ${FINAL_DMB} is newer than everything it is compiled from: compile skipped (--rebuild compiles anyway).`);
        }
      }
      await runLowMemory(options);
      break;
    case 'dm-test':
      await runPrerequisites();
      await runTests(options);
      break;
    case 'clean':
    case 'clean-all':
      removeModularArtifacts();
      await runUpstream(options.rawArgs);
      break;
    default:
      console.warn(`modular_redtard: target "${options.target}" is passed to the upstream build without the module.`);
      await runUpstream(options.rawArgs);
      return;
  }
  console.log(`modular_redtard: target "${options.target}" completed.`);
}

function parseArgs(args: string[]): BuildOptions {
  const options: BuildOptions = {
    target: 'build',
    defines: [],
    dmVersion: null,
    warningsAsErrors: false,
    ignoreWarningCodes: [],
    port: '1337',
    map: 'runtimestation',
    era: 'medieval',
    focus: false,
    noBuild: false,
    rebuild: false,
    maps: false,
    noRun: false,
    // The light launch takes the lightest form of whatever map it is given: no dungeon level unless --dungeon asks.
    noDungeon: true,
    rawArgs: args,
    parameterArgs: [],
  };
  let targetIndex = -1;
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    const value = () => {
      const next = args[++i];
      if (next === undefined) {
        throw new Error(`Missing value for ${arg}`);
      }
      return next;
    };
    if (arg === '--define' || arg === '-D') {
      options.defines.push(value());
    } else if (arg.startsWith('-D') && arg.length > 2) {
      options.defines.push(arg.slice(2));
    } else if (arg === '--dm-version') {
      options.dmVersion = value();
    } else if (arg === '--warning' || arg === '-W') {
      options.warningsAsErrors ||= value() === 'error';
    } else if (arg.startsWith('-W') && arg.length > 2) {
      options.warningsAsErrors ||= arg.slice(2) === 'error';
    } else if (arg === '--no-warning' || arg === '-I') {
      options.ignoreWarningCodes.push(value());
    } else if (arg.startsWith('-I') && arg.length > 2) {
      options.ignoreWarningCodes.push(arg.slice(2));
    } else if (arg === '--port' || arg === '-p') {
      options.port = value();
    } else if (arg === '--map') {
      options.map = value();
    } else if (arg === '--era') {
      options.era = value().toLowerCase();
      if (options.era !== 'medieval' && options.era !== 'modern') {
        throw new Error(`--era takes "medieval" or "modern", not "${options.era}"`);
      }
    } else if (arg === '--focus') {
      options.focus = true;
    } else if (arg === '--no-build') {
      options.noBuild = true;
    } else if (arg === '--rebuild') {
      options.rebuild = true;
    } else if (arg === '--maps') {
      options.maps = true;
    } else if (arg === '--no-run') {
      options.noRun = true;
    } else if (arg === '--no-dungeon') {
      options.noDungeon = true;
    } else if (arg === '--dungeon') {
      options.noDungeon = false;
    } else if (!arg.startsWith('-') && targetIndex === -1) {
      options.target = arg;
      targetIndex = i;
    }
  }
  options.parameterArgs = args.filter((_, index) => index !== targetIndex);
  return options;
}

function checkModularContent(): void {
  const { status, output } = runBootstrapPython([CONTENT_CHECK]);
  if (status === 0) {
    console.log(`modular_redtard: content check (${CONTENT_CHECK}): clean`);
  } else {
    console.warn(`modular_redtard: WARNING - content check (${CONTENT_CHECK}, the TG unit-test rules for our types):\n${output}`);
  }
}

/// quick: the compile alone, without the maps of Rockhill and the content check (the light launch).
async function compileModular(baseName: string, defines: string[], options: BuildOptions, quick = false) {
  compileStartedAt = Date.now();
  compileSourceList = scanSources(DM_INPUTS, DM_INPUT_SKIP_FILES, Number.POSITIVE_INFINITY).list;
  if (quick) {
    console.log('modular_redtard: light launch: the maps of Rockhill are left as they are (--maps prepares them), no content check.');
  } else {
    try {
      await prepareRockhill();
    } catch (error) {
      printMapFailure(error);
      process.exit(1);
    }
    checkModularContent();
  }
  const dme = fs.readFileSync(UPSTREAM_DME, 'utf-8');
  if (!dme.includes(END_INCLUDE)) {
    throw new Error(`${UPSTREAM_DME} has no ${END_INCLUDE} marker`);
  }
  if (!dme.includes(LAYERS_INCLUDE)) {
    throw new Error(`${UPSTREAM_DME} has no ${LAYERS_INCLUDE}`);
  }
  const withEarlyDefines = dme.includes(EARLY_DEFINES_INCLUDE)
    ? dme
    : dme.replace(LAYERS_INCLUDE, `${LAYERS_INCLUDE}\n${EARLY_DEFINES_INCLUDE}`);
  const withModule = withEarlyDefines.includes(MODULE_INCLUDE)
    ? withEarlyDefines
    : withEarlyDefines.replace(END_INCLUDE, `${MODULE_INCLUDE}\n${END_INCLUDE}`);
  fs.writeFileSync(`${baseName}.dme`, withModule);
  try {
    await DreamMaker(`${baseName}.dme`, {
      defines: [...MODULE_DEFINES, ...defines],
      warningsAsErrors: options.warningsAsErrors,
      ignoreWarningCodes: options.ignoreWarningCodes,
      namedDmVersion: options.dmVersion,
    });
  } finally {
    removeIfExists(`${baseName}.dme`);
    removeIfExists(`${baseName}.int`);
  }
}

function promoteArtifacts(options: BuildOptions) {
  fs.copyFileSync(`${BUILD_BASE}.dmb`, FINAL_DMB);
  fs.copyFileSync(`${BUILD_BASE}.rsc`, FINAL_RSC);
  removeIfExists(`${BUILD_BASE}.dmb`);
  removeIfExists(`${BUILD_BASE}.rsc`);
  // What the game binary was compiled with and when: the light launch compiles again when it is asked for other
  // defines, when a source changed after the compile began, or when something else has replaced the binary since.
  writeStamp({
    defines: buildDefines(options),
    started: compileStartedAt,
    built: fs.statSync(FINAL_DMB).mtimeMs,
    sources: compileSourceList,
  });
}

/// What the last builds of this wrapper did, for the light launch to tell what it can skip (BUILD_STAMP).
type BuildStamp = {
  /// Defines the game binary was compiled with.
  defines?: string[];
  /// When that compile began.
  started?: number;
  /// The binary's own time right after it: another tool's binary in its place has another one.
  built?: number;
  /// The list of the binary's source files as that compile found it (scanSources()): a file added or removed since.
  sources?: string;
  /// When the last run of the prerequisites (TG's tgui and the module's bundles) that ended well began.
  prerequisites?: number;
  /// The list of the source files of tgui as that run found it.
  interfaceSources?: string;
};

function readStamp(): BuildStamp {
  try {
    return JSON.parse(fs.readFileSync(BUILD_STAMP, 'utf-8')) ?? {};
  } catch {
    return {};
  }
}

function writeStamp(patch: BuildStamp): void {
  fs.mkdirSync(BUILD_STAMP.slice(0, BUILD_STAMP.lastIndexOf('/')), { recursive: true });
  fs.writeFileSync(BUILD_STAMP, `${JSON.stringify({ ...readStamp(), ...patch })}\n`);
}

function buildDefines(options: BuildOptions): string[] {
  return [...MODULE_DEFINES, 'CBT', ...options.defines].sort();
}

/// Why the game binary has to be compiled again, or null when it is newer than every file it is compiled from and was
/// compiled with the same defines. The light launch asks: a compile is most of its wait, and most launches follow a
/// change in tgui or no change at all.
function binaryStaleness(options: BuildOptions): string | null {
  if (options.dmVersion) {
    return 'a BYOND version is named';
  }
  if (!fs.existsSync(FINAL_DMB) || !fs.existsSync(FINAL_RSC)) {
    return `no ${FINAL_DMB}`;
  }
  const stamp = readStamp();
  if (!stamp.started || !stamp.built) {
    return 'no record of the last compile';
  }
  if (JSON.stringify(stamp.defines) !== JSON.stringify(buildDefines(options))) {
    return 'the defines differ from the last compile';
  }
  if (fs.statSync(FINAL_DMB).mtimeMs !== stamp.built) {
    return `${FINAL_DMB} is not the one this wrapper compiled last`;
  }
  const scan = scanSources(DM_INPUTS, DM_INPUT_SKIP_FILES, stamp.started);
  if (scan.changed) {
    return `${scan.changed} changed`;
  }
  if (scan.list !== stamp.sources) {
    return 'a source file was added or removed';
  }
  return null;
}

/// Why the prerequisites have to run again (TG's tgui bundles and the module's own), or null when no source of theirs has
/// changed since they last ran to the end. What TG's other prerequisites build from (cut icons, behaviour trees) is among
/// the sources of the game binary, so binaryStaleness() answers for them.
function interfaceStaleness(): string | null {
  const stamp = readStamp();
  if (!stamp.prerequisites) {
    return 'no record of the last prerequisites run';
  }
  for (const output of INTERFACE_OUTPUTS) {
    if (!fs.existsSync(output)) {
      return `no ${output}`;
    }
  }
  const scan = scanSources(INTERFACE_INPUTS, null, stamp.prerequisites);
  if (scan.changed) {
    return `${scan.changed} changed`;
  }
  if (scan.list !== stamp.interfaceSources) {
    return 'a source file of tgui was added or removed';
  }
  return null;
}

/// The source files under the inputs: the first of them changed after the moment `since`, and their list as one value
/// (their count and a hash of their names), by which a file added or removed is told. The times of folders are not
/// looked at: a folder's time also moves when an editor saves a file in it through a temporary one, be it a note that is
/// not a source at all. node_modules is passed over; with skipFiles (the sources of the game binary) so are the files it
/// matches and the module's folders that hold no game source (DM_INPUT_SKIP_FOLDERS).
function scanSources(inputs: string[], skipFiles: RegExp | null, since: number): { changed: string | null; list: string } {
  const names: string[] = [];
  let changed: string | null = null;
  const visitFile = (path: string) => {
    if (skipFiles?.test(path)) {
      return;
    }
    names.push(path);
    if (!changed && fs.statSync(path).mtimeMs > since) {
      changed = path;
    }
  };
  const visitFolder = (path: string) => {
    for (const entry of fs.readdirSync(path, { withFileTypes: true })) {
      const child = `${path}/${entry.name}`;
      if (entry.isDirectory()) {
        if (entry.name !== 'node_modules' && !(skipFiles && DM_INPUT_SKIP_FOLDERS.includes(child))) {
          visitFolder(child);
        }
      } else {
        visitFile(child);
      }
    }
  };
  for (const input of inputs) {
    if (!fs.existsSync(input)) {
      continue;
    }
    if (fs.statSync(input).isDirectory()) {
      visitFolder(input);
    } else {
      visitFile(input);
    }
  }
  names.sort();
  return { changed, list: `${names.length}:${Bun.hash(names.join('\n'))}` };
}

async function runTests(options: BuildOptions) {
  const defines = ['CBT', 'CIBUILDING', ...options.defines];
  if (options.focus) {
    defines.push('REDTARD_TEST_FOCUS');
  }
  await compileModular(TEST_BASE, defines, options);
  if (options.noRun) {
    for (const ext of ['dmb', 'rsc', 'dyn.rsc', 'lk']) {
      removeIfExists(`${TEST_BASE}.${ext}`);
    }
    console.log('modular_redtard: test build compiled; --no-run, no world booted.');
    return;
  }
  restoreNextMap();
  fs.rmSync(CI_LOG_DIR, { recursive: true, force: true });
  fs.mkdirSync('data', { recursive: true });
  const mapJson = `_maps/map_jsons/${options.map}.json`;
  const hadNextMap = fs.existsSync(NEXT_MAP);
  if (!hadNextMap) {
    fs.copyFileSync(mapJson, NEXT_MAP);
  }
  try {
    await DreamDaemon(
      { dmbFile: `${TEST_BASE}.dmb`, namedDmVersion: options.dmVersion },
      '-close',
      '-trusted',
      '-verbose',
      '-params',
      'log-directory=ci',
    );
  } catch (error) {
    console.warn(`modular_redtard: DreamDaemon exited with ${error}`);
  } finally {
    removeIfExists(`${TEST_BASE}.dmb`);
    removeIfExists(`${TEST_BASE}.rsc`);
    removeIfExists(`${TEST_BASE}.dyn.rsc`);
    removeIfExists(`${TEST_BASE}.lk`);
    if (!hadNextMap) {
      removeIfExists(NEXT_MAP);
    }
  }
  const cleanRun = `${CI_LOG_DIR}/clean_run.lk`;
  if (!fs.existsSync(cleanRun)) {
    console.error(`modular_redtard: test run was not clean, see ${CI_LOG_DIR}`);
    process.exit(1);
  }
  console.log(fs.readFileSync(cleanRun, 'utf-8'));
}

async function runLowMemory(options: BuildOptions) {
  const source = `_maps/map_jsons/${options.map}.json`;
  if (!fs.existsSync(source)) {
    throw new Error(`No map config ${source}`);
  }
  const map = JSON.parse(fs.readFileSync(source, 'utf-8'));
  map.minetype = 'none';
  map.space_ruin_levels = 0;
  map.space_empty_levels = 1;
  map[LOWMEM_MARKER] = true;
  // The test map runs every rule of Roguetown (owner's decision 2026-11-24): the light launch loads its map as a
  // medieval one, whatever era its own config names (maps/era.dm reads "era"). --era modern leaves the map its own era,
  // as the light launch was before: then only the module's combat is on (rogue_combat_enabled()).
  const ownEra = map.era ?? 'modern';
  if (options.era === 'medieval') {
    map.era = 'medieval';
  }
  // The dungeon level is skipped on load (maps/other_z.dm), like Ratwood's and Vanderlin's NO_DUNGEON.
  if (options.noDungeon) {
    map.no_dungeon = true;
  }
  if (options.noRun) {
    console.log(`modular_redtard: --no-run: ${map.map_name} (era ${map.era ?? 'modern'}) is ready to launch; nothing is started and ${NEXT_MAP} is left alone.`);
    return;
  }
  restoreNextMap();
  fs.mkdirSync('data', { recursive: true });
  if (fs.existsSync(NEXT_MAP)) {
    fs.renameSync(NEXT_MAP, NEXT_MAP_BACKUP);
  }
  fs.writeFileSync(NEXT_MAP, `${JSON.stringify(map, null, '\t')}\n`);
  console.log(`modular_redtard: low-memory launch of ${map.map_name} on port ${options.port}: no mining level, no space ruins${options.noDungeon ? ', no dungeon' : ''}; era ${map.era ?? 'modern'}${map.era !== ownEra ? ` (the map's own is ${ownEra}; --era modern keeps it)` : ''}.`);
  try {
    await DreamDaemon({ dmbFile: FINAL_DMB, namedDmVersion: options.dmVersion }, options.port, '-trusted');
  } finally {
    restoreNextMap();
  }
}

function resetNextMapForNormalStart() {
  for (const file of [NEXT_MAP, NEXT_MAP_BACKUP]) {
    removeIfExists(file);
  }
}

function restoreNextMap() {
  if (fs.existsSync(NEXT_MAP)) {
    let ours = false;
    try {
      ours = JSON.parse(fs.readFileSync(NEXT_MAP, 'utf-8'))[LOWMEM_MARKER] === true;
    } catch {
      ours = false;
    }
    if (!ours) {
      return;
    }
    fs.rmSync(NEXT_MAP);
  }
  if (fs.existsSync(NEXT_MAP_BACKUP)) {
    fs.renameSync(NEXT_MAP_BACKUP, NEXT_MAP);
  }
}

async function runPrerequisites() {
  const began = Date.now();
  const interfaceSources = scanSources(INTERFACE_INPUTS, null, Number.POSITIVE_INFINITY).list;
  await runUpstream(PREREQUISITES);
  // The medieval main menu (modular_redtard/lobby/rogue_lobby.dm) and the chat panel with the translation
  // (modular_redtard/localization/panel.dm).
  await buildModuleBundle('tgui-rogue-lobby', ROGUE_LOBBY_CONFIG, ROGUE_LOBBY_INPUTS, ROGUE_LOBBY_OUTPUTS);
  await buildModuleBundle('tgui-rogue-panel', ROGUE_PANEL_CONFIG, ROGUE_PANEL_INPUTS, ROGUE_PANEL_OUTPUTS);
  // The light launch skips all of this while no source of tgui has changed since (interfaceStaleness()).
  writeStamp({ prerequisites: began, interfaceSources });
}

/// A bundle of the module, built with its own rspack config over TG's after TG's tgui, and only when its sources
/// (or the TG packages it draws on) are newer than the bundle.
async function buildModuleBundle(name: string, config: string, inputs: string[], outputs: string[]) {
  const newest = Math.max(...inputs.map(newestMtime));
  const built = Math.min(...outputs.map((file) => (fs.existsSync(file) ? fs.statSync(file).mtimeMs : 0)));
  if (built > newest) {
    console.log(`modular_redtard: ${name} is up to date`);
    return;
  }
  const proc = Bun.spawn(['bun', 'run', 'rspack', 'build', '--config', config], {
    cwd: 'tgui',
    stdin: 'inherit',
    stdout: 'inherit',
    stderr: 'inherit',
  });
  const code = await proc.exited;
  if (code !== 0) {
    throw new Error(`${name} build exited with code ${code}`);
  }
  // rspack leaves a bundle that came out the same untouched, and it then stayed older than its sources: the bundle was
  // built anew by every build. Its time says when it was last found current.
  const now = new Date();
  for (const file of outputs) {
    if (fs.existsSync(file)) {
      fs.utimesSync(file, now, now);
    }
  }
}

function newestMtime(path: string): number {
  if (!fs.existsSync(path)) {
    return 0;
  }
  const stat = fs.statSync(path);
  if (!stat.isDirectory()) {
    return stat.mtimeMs;
  }
  let newest = stat.mtimeMs;
  for (const entry of fs.readdirSync(path)) {
    if (entry !== 'node_modules') {
      newest = Math.max(newest, newestMtime(`${path}/${entry}`));
    }
  }
  return newest;
}

async function runUpstream(args: string[]) {
  const command =
    process.platform === 'win32'
      ? ['cmd.exe', '/c', 'tools\\build\\build.bat', ...args]
      : ['sh', 'tools/build/build.sh', ...args];
  const proc = Bun.spawn(command, { stdin: 'inherit', stdout: 'inherit', stderr: 'inherit' });
  const code = await proc.exited;
  if (code !== 0) {
    throw new Error(`upstream build exited with code ${code}`);
  }
}

function removeModularArtifacts() {
  for (const base of [BUILD_BASE, TEST_BASE]) {
    for (const ext of ['dme', 'dmb', 'rsc', 'dyn.rsc', 'int', 'lk']) {
      removeIfExists(`${base}.${ext}`);
    }
  }
}

function removeIfExists(path: string) {
  fs.rmSync(path, { force: true });
}

if (import.meta.main) {
  try {
    await main();
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}
