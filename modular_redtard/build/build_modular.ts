import fs from 'node:fs';
import { DreamDaemon, DreamMaker } from '../../tools/build/lib/byond';
import { prepareRockhill } from './prepare_rockhill.ts';

const UPSTREAM_DME = 'tgstation.dme';
const MODULE_INCLUDE = '#include "modular_redtard\\_module.dme"';
const END_INCLUDE = '// END_INCLUDE';
const FINAL_DMB = 'tgstation.dmb';
const FINAL_RSC = 'tgstation.rsc';
const BUILD_BASE = 'tgstation.redtard.m';
const TEST_BASE = 'tgstation.redtard.test';
const CI_LOG_DIR = 'data/logs/ci';
const NEXT_MAP = 'data/next_map.json';
const NEXT_MAP_BACKUP = 'data/next_map.json.redtard-backup';
const LOWMEM_MARKER = 'redtard_lowmem';
const PREREQUISITES = ['icon-cutter', 'behavior-tree-compiler', 'tgui', 'tg-font'];

type BuildOptions = {
  target: string;
  defines: string[];
  dmVersion: string | null;
  warningsAsErrors: boolean;
  ignoreWarningCodes: string[];
  port: string;
  map: string;
  focus: boolean;
  noBuild: boolean;
  noRun: boolean;
  rawArgs: string[];
  parameterArgs: string[];
};

async function main() {
  const options = parseArgs(process.argv.slice(2));
  switch (options.target) {
    case 'dm':
    case 'build':
      await runUpstream(PREREQUISITES);
      await compileModular(BUILD_BASE, ['CBT', ...options.defines], options);
      promoteArtifacts();
      break;
    case 'server':
      await runUpstream(PREREQUISITES);
      await compileModular(BUILD_BASE, ['CBT', ...options.defines], options);
      promoteArtifacts();
      resetNextMapForNormalStart();
      await DreamDaemon({ dmbFile: FINAL_DMB, namedDmVersion: options.dmVersion }, options.port, '-trusted');
      break;
    case 'lowmem':
      if (!options.noBuild) {
        await runUpstream(PREREQUISITES);
        await compileModular(BUILD_BASE, ['CBT', ...options.defines], options);
        promoteArtifacts();
      }
      await runLowMemory(options);
      break;
    case 'dm-test':
      await runUpstream(PREREQUISITES);
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
    focus: false,
    noBuild: false,
    noRun: false,
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
    } else if (arg === '--focus') {
      options.focus = true;
    } else if (arg === '--no-build') {
      options.noBuild = true;
    } else if (arg === '--no-run') {
      options.noRun = true;
    } else if (!arg.startsWith('-') && targetIndex === -1) {
      options.target = arg;
      targetIndex = i;
    }
  }
  options.parameterArgs = args.filter((_, index) => index !== targetIndex);
  return options;
}

async function compileModular(baseName: string, defines: string[], options: BuildOptions) {
  await prepareRockhill();
  const dme = fs.readFileSync(UPSTREAM_DME, 'utf-8');
  if (!dme.includes(END_INCLUDE)) {
    throw new Error(`${UPSTREAM_DME} has no ${END_INCLUDE} marker`);
  }
  const withModule = dme.includes(MODULE_INCLUDE)
    ? dme
    : dme.replace(END_INCLUDE, `${MODULE_INCLUDE}\n${END_INCLUDE}`);
  fs.writeFileSync(`${baseName}.dme`, withModule);
  try {
    await DreamMaker(`${baseName}.dme`, {
      defines,
      warningsAsErrors: options.warningsAsErrors,
      ignoreWarningCodes: options.ignoreWarningCodes,
      namedDmVersion: options.dmVersion,
    });
  } finally {
    removeIfExists(`${baseName}.dme`);
    removeIfExists(`${baseName}.int`);
  }
}

function promoteArtifacts() {
  fs.copyFileSync(`${BUILD_BASE}.dmb`, FINAL_DMB);
  fs.copyFileSync(`${BUILD_BASE}.rsc`, FINAL_RSC);
  removeIfExists(`${BUILD_BASE}.dmb`);
  removeIfExists(`${BUILD_BASE}.rsc`);
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
  restoreNextMap();
  fs.mkdirSync('data', { recursive: true });
  if (fs.existsSync(NEXT_MAP)) {
    fs.renameSync(NEXT_MAP, NEXT_MAP_BACKUP);
  }
  fs.writeFileSync(NEXT_MAP, `${JSON.stringify(map, null, '\t')}\n`);
  console.log(`modular_redtard: low-memory launch of ${map.map_name} on port ${options.port}: no mining level, no space ruins.`);
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
