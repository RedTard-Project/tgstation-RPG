import collections
from collections import OrderedDict
import glob
import json
import os
import re
import shutil
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dmi

CONFIG = 'modular_redtard/rockhill/config.json'
OUT_DIR = 'modular_redtard/rockhill/ported'
ICON_DIR = 'modular_redtard/rockhill/icons'
REPORT = 'modular_redtard/rockhill/PORTED_CONTENT.md'
CHECKOUT = '.cache/ratwood'
BLANK_WORN = 'modular_redtard/rockhill/icons/blank_worn.dmi'
FEMALE_WORN_SUFFIX = '_f'
TG_WORN_SLOTS = ('ITEM_SLOT_BACK', 'ITEM_SLOT_ID', 'ITEM_SLOT_GLOVES', 'ITEM_SLOT_EYES', 'ITEM_SLOT_EARS', 'ITEM_SLOT_NECK', 'ITEM_SLOT_MASK', 'ITEM_SLOT_BELT')
WEAR_COVERAGE = {'/obj/item/clothing/gloves': ('hands', {'HAND_LEFT', 'HAND_RIGHT'}), '/obj/item/clothing/shoes': ('feet', {'FOOT_LEFT', 'FOOT_RIGHT'})}
DECLARATION_ROOTS = ['code', 'modular_redtard']

TYPE_LINE = re.compile(r'^(/[A-Za-z0-9_/]+)\s*$')
VAR_LINE = re.compile(r'^(?:var/(?:[A-Za-z0-9_]+/)*)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+)$')
DEFINE_LINE = re.compile(r'^\s*#define\s+([A-Za-z_][A-Za-z0-9_]*)\b')
STRING_LITERAL = re.compile(r'^"(?:[^"\\\[]|\\.)*"$')
ICON_LITERAL = re.compile(r"^'([^']+)'$")
NUMBER = re.compile(r'^-?\d+(?:\.\d+)?$')
COLOR = re.compile(r'^"#[0-9A-Fa-f]{3,8}"$')
PROC_LINE = re.compile(r'^(/[A-Za-z0-9_/]+?)/(?:proc/|verb/)?([A-Za-z_][A-Za-z0-9_]*)\(')
PROCS = collections.defaultdict(set)
PRE_EQUIP = {}
ONMOB = {}
INIT_BODIES = {}
FILL_BODIES = {}
STORAGE_NEW = {}
HOLD_LIST = re.compile(r'(?:typecacheof|set_holdable)\(\s*list\(')
NEW_IN_SRC = re.compile(r'new\s+(/obj/item/[A-Za-z0-9_/]+)\s*\(\s*src\s*\)')
LOOT_LIST = re.compile(r'\bloot\s*=\s*list\(([^)]*)\)')
PROB_CALL = re.compile(r'\bprob\((\d+)\)')
ONMOB_TAGS = ('onback', 'onbelt', 'gen', 'wielded')
DEFINE_VALUES = {}
SOURCE_REVISION = []
ARMOR_DATUMS = {}
ROGUE_ARMOR_DATUMS = {}
USED_INTENTS = set()
BAKE_JOBS = collections.defaultdict(dict)
BAKE_NAMES = {}
ABOVE_KEYS = ('northabove', 'southabove', 'eastabove', 'westabove')
ALT_GRIP_ROOT = '/datum/alt_grip'
DEFAULT_INTENTS = ('/datum/intent/use',)
BLANK_USERS = set()
FEMALE_USERS = set()
BITMASK_TURFS = set()
NO_SPRITE = []
LISTINGS = {}
LICENSE_FILE = re.compile(r'(?i)^(licen[cs]e|copying)([-_.][\w.-]*)?$')
CURRENT = [None]
RESTRICTED = collections.defaultdict(set)
UNREVIEWED = collections.defaultdict(set)


def asset_license(rel):
    parts = rel.split('/')[:-1]
    for depth in range(len(parts), 0, -1):
        folder = os.path.join(CHECKOUT, *parts[:depth])
        if folder not in LISTINGS:
            LISTINGS[folder] = {name.lower(): name for name in os.listdir(folder)} if os.path.isdir(folder) else {}
        for name in LISTINGS[folder].values():
            if LICENSE_FILE.match(name) and os.path.isfile(os.path.join(folder, name)):
                return '/'.join(parts[:depth] + [name])
    return None


def asset_allowed(rel, assets):
    license = asset_license(rel)
    if license is None or license in assets.get('reviewed_licenses', []):
        return True
    if license in assets.get('restricted_licenses', []):
        RESTRICTED[license].add(CURRENT[0])
    else:
        UNREVIEWED[license].add(rel)
    return False


def exact_case(root, rel):
    parts = rel.replace('\\', '/').split('/')
    current = root
    fixed = []
    for part in parts:
        if current not in LISTINGS:
            LISTINGS[current] = {name.lower(): name for name in os.listdir(current)} if os.path.isdir(current) else {}
        name = LISTINGS[current].get(part.lower(), part)
        fixed.append(name)
        current = os.path.join(current, name)
    return '/'.join(fixed)
COVERAGE_MAP = {
    'HEAD': 'HEAD', 'MOUTH': 'HEAD', 'NOSE': 'HEAD', 'EARS': 'HEAD', 'HAIR': 'HEAD', 'LEFT_EYE': 'HEAD', 'RIGHT_EYE': 'HEAD',
    'CHEST': 'CHEST', 'VITALS': 'CHEST', 'GROIN': 'GROIN', 'NECK': 'NECK',
    'LEG_LEFT': 'LEG_LEFT', 'LEG_RIGHT': 'LEG_RIGHT', 'FOOT_LEFT': 'FOOT_LEFT', 'FOOT_RIGHT': 'FOOT_RIGHT',
    'ARM_LEFT': 'ARM_LEFT', 'ARM_RIGHT': 'ARM_RIGHT', 'HAND_LEFT': 'HAND_LEFT', 'HAND_RIGHT': 'HAND_RIGHT',
}
OUTFIT_SLOTS = {
    'head': 'head', 'mask': 'mask', 'mouth': 'mouth', 'neck': 'neck', 'cloak': 'cloak', 'armor': 'suit',
    'shirt': 'shirt', 'pants': 'uniform', 'wrists': 'wrists', 'gloves': 'gloves', 'shoes': 'shoes',
    'belt': 'belt', 'beltl': 'l_pocket', 'beltr': 'r_pocket', 'backl': 'back', 'backr': 'backr',
    'ring': 'ring', 'l_hand': 'l_hand', 'r_hand': 'r_hand',
}
SLOT_FLAG_MAP = {
    'ITEM_SLOT_PANTS': 'ITEM_SLOT_ICLOTHING', 'ITEM_SLOT_ICLOTHING': 'ITEM_SLOT_ICLOTHING',
    'ITEM_SLOT_SHIRT': 'ITEM_SLOT_ROGUE_SHIRT', 'ITEM_SLOT_ARMOR': 'ITEM_SLOT_OCLOTHING',
    'ITEM_SLOT_OCLOTHING': 'ITEM_SLOT_OCLOTHING', 'ITEM_SLOT_SHOES': 'ITEM_SLOT_FEET',
    'ITEM_SLOT_GLOVES': 'ITEM_SLOT_GLOVES', 'ITEM_SLOT_RING': 'ITEM_SLOT_ROGUE_RING',
    'ITEM_SLOT_MOUTH': 'ITEM_SLOT_ROGUE_MOUTH', 'ITEM_SLOT_MASK': 'ITEM_SLOT_MASK', 'ITEM_SLOT_HEAD': 'ITEM_SLOT_HEAD',
    'ITEM_SLOT_CLOAK': 'ITEM_SLOT_ROGUE_CLOAK', 'ITEM_SLOT_NECK': 'ITEM_SLOT_NECK', 'ITEM_SLOT_BELT': 'ITEM_SLOT_BELT',
    'ITEM_SLOT_BACK_R': 'ITEM_SLOT_BACK', 'ITEM_SLOT_BACK_L': 'ITEM_SLOT_BACK', 'ITEM_SLOT_BACK': 'ITEM_SLOT_BACK',
    'ITEM_SLOT_HIP': 'ITEM_SLOT_POCKETS', 'ITEM_SLOT_WRISTS': 'ITEM_SLOT_ROGUE_WRISTS',
}
SMOOTH_DIR = 'modular_redtard/rockhill/icons/smooth'
SOUND_DIR = 'modular_redtard/rockhill/sound'
EDGES_FILE = 'turf_edges.dm'
SMOOTHING_FILE = '_smoothing.dm'
AREAS_JSON = 'areas.json'
SUNLIT_LEAF = 'sunlit'
TG_LAYERS = 'code/__DEFINES/layers.dm'
SMOOTH_BITS = {'SMOOTH_TRUE': 1, 'SMOOTH_MORE': 2, 'SMOOTH_DIAGONAL': 4, 'SMOOTH_BORDER': 8}
BYOND_LAYERS = {'AREA_LAYER': '1', 'TURF_LAYER': '2', 'OBJ_LAYER': '3', 'MOB_LAYER': '4', 'FLY_LAYER': '5', 'EFFECTS_LAYER': '5000', 'TOPDOWN_LAYER': '10000', 'BACKGROUND_LAYER': '20000'}
BYOND_DIRECTIONS = {'NORTH', 'SOUTH', 'EAST', 'WEST', 'NORTHEAST', 'NORTHWEST', 'SOUTHEAST', 'SOUTHWEST', 'UP', 'DOWN'}
TURF_GROUP_BASE = 1000
OBJ_GROUP_BASE = 2000


def strip_comments(text):
    out = []
    i = 0
    n = len(text)
    state = None
    while i < n:
        c = text[i]
        nxt = text[i + 1] if i + 1 < n else ''
        if state == 'block':
            if c == '*' and nxt == '/':
                state = None
                i += 2
                continue
            if c == '\n':
                out.append(c)
            i += 1
            continue
        if state == 'dq':
            out.append(c)
            if c == '\\':
                out.append(nxt)
                i += 2
                continue
            if c == '"' or c == '\n':
                state = None
            i += 1
            continue
        if state == 'sq':
            out.append(c)
            if c == "'" or c == '\n':
                state = None
            i += 1
            continue
        if state == 'long':
            out.append(c)
            if c == '"' and nxt == '}':
                out.append(nxt)
                state = None
                i += 2
                continue
            i += 1
            continue
        if c == '/' and nxt == '*':
            state = 'block'
            i += 2
            continue
        if c == '/' and nxt == '/':
            while i < n and text[i] != '\n':
                i += 1
            continue
        if c == '{' and nxt == '"':
            out.append('{"')
            state = 'long'
            i += 2
            continue
        if c == '"':
            state = 'dq'
        elif c == "'":
            state = 'sq'
        out.append(c)
        i += 1
    return ''.join(out)


def included_files(code_root):
    dme = [f for f in os.listdir(code_root) if f.endswith('.dme')]
    if len(dme) != 1:
        raise SystemExit(f'expected one .dme in {code_root}, found {dme}')
    files = []
    for line in open(os.path.join(code_root, dme[0]), encoding='utf-8', errors='ignore'):
        m = re.match(r'^#include "(.+)"', line.strip())
        if m and m.group(1).endswith('.dm'):
            files.append(os.path.join(code_root, m.group(1).replace('\\', '/')))
    return files


def parse_codebase(code_root):
    types = collections.defaultdict(dict)
    defines = set()
    for path in included_files(code_root):
        if not os.path.exists(path):
            continue
        text = strip_comments(open(path, encoding='utf-8', errors='ignore').read())
        lines = text.split('\n')
        current = None
        i = 0
        while i < len(lines):
            line = lines[i].rstrip()
            i += 1
            if not line.strip():
                continue
            dm = DEFINE_LINE.match(line)
            if dm:
                defines.add(dm.group(1))
                rest = line[dm.end():]
                while rest.rstrip().endswith('\\') and i < len(lines):
                    rest = rest.rstrip()[:-1] + ' ' + lines[i].strip()
                    i += 1
                if not rest.startswith('('):
                    DEFINE_VALUES[dm.group(1)] = rest.strip()
                continue
            if line.startswith('#'):
                continue
            if not line.startswith(('\t', ' ')):
                m = TYPE_LINE.match(line)
                if m and '/proc/' not in m.group(1) and '/verb/' not in m.group(1):
                    current = m.group(1).rstrip("/")
                    types[current]
                else:
                    current = None
                    pm = PROC_LINE.match(line)
                    if pm:
                        PROCS[pm.group(1)].add(pm.group(2))
                        bodies = {
                            'pre_equip': ('/datum/outfit/', PRE_EQUIP),
                            'getonmobprop': ('/obj/item', ONMOB),
                            'Initialize': (('/turf/', '/obj/structure', '/obj/machinery', '/obj/item'), INIT_BODIES),
                            'PopulateContents': ('/obj/structure/closet', FILL_BODIES),
                            'New': ('/datum/component/storage', STORAGE_NEW),
                        }.get(pm.group(2))
                        if bodies and pm.group(1).startswith(bodies[0]):
                            body = []
                            while i < len(lines) and (not lines[i].strip() or lines[i].startswith(('\t', ' '))):
                                body.append(lines[i].rstrip())
                                i += 1
                            bodies[1][pm.group(1)] = body
                continue
            if current is None:
                continue
            body = line[1:] if line.startswith('\t') else line.lstrip(' ')
            if body.startswith(('\t', ' ')):
                continue
            m = VAR_LINE.match(body.strip())
            if not m:
                continue
            name, value = m.group(1), m.group(2).strip()
            while value.endswith('\\') and i < len(lines):
                value = value[:-1].rstrip() + ' ' + lines[i].strip()
                i += 1
            if value.startswith('list('):
                while value.count('(') > value.count(')') and i < len(lines):
                    value = value + ' ' + lines[i].strip()
                    i += 1
            if value.startswith('{"') and not value.endswith('"}'):
                parts = [value]
                while i < len(lines) and not parts[-1].rstrip().endswith('"}'):
                    parts.append(lines[i].rstrip())
                    i += 1
                value = '\n'.join(parts)
            types[current][name] = value
    return types, defines


class Codebase:
    def __init__(self, types):
        self.types = types

    def parent(self, path):
        pt = self.types.get(path, {}).get('parent_type')
        if pt and pt.startswith('/'):
            return pt
        if path.count('/') <= 1:
            return None
        return path.rsplit('/', 1)[0]

    def resolve(self, path, var):
        seen = set()
        p = path
        while p and p not in seen:
            seen.add(p)
            value = self.types.get(p, {}).get(var)
            if value is not None:
                return value
            p = self.parent(p)
        return None


def declared_paths(roots, exclude):
    declared = set()
    exclude = [os.path.normpath(e) for e in exclude]
    for root in roots:
        for dp, dn, fn in os.walk(root):
            if any(os.path.normpath(dp).startswith(e) for e in exclude):
                continue
            for f in fn:
                if not f.endswith('.dm'):
                    continue
                for line in open(os.path.join(dp, f), encoding='utf-8', errors='ignore'):
                    m = re.match(r'^(/[A-Za-z0-9_/]+)', line)
                    if not m:
                        continue
                    parts = m.group(1).split('/')
                    for k in range(2, len(parts) + 1):
                        declared.add('/'.join(parts[:k]))
    if len(declared) < 10000:
        raise SystemExit(f'type scanner found only {len(declared)} paths; run from the repository root')
    return declared


def tg_defines(root):
    names = set()
    for dp, dn, fn in os.walk(os.path.join(root, '__DEFINES')):
        for f in fn:
            if f.endswith('.dm'):
                for line in open(os.path.join(dp, f), encoding='utf-8', errors='ignore'):
                    m = DEFINE_LINE.match(line)
                    if m:
                        names.add(m.group(1))
    return names


def random_pick(rw, path):
    p = path
    while p:
        body = '\n'.join(INIT_BODIES.get(p, []))
        if body:
            match = re.search(r'pick\(\s*list\(([^)]*)\)\s*\)', body)
            if match and 'INITIALIZE_HINT_QDEL' in body and re.search(r'\bnew\b', body):
                return [found for found, _ in list_paths(match.group(1))]
            return []
        p = rw.parent(p)
    return []


def state_leaf(state):
    return 'state_' + re.sub(r'[^A-Za-z0-9_]', '_', state)


def smooth_bits(raw):
    value = (raw or '').strip()
    if NUMBER.match(value):
        return int(float(value))
    bits = 0
    for token in re.findall(r'[A-Z_]+', value):
        bits |= SMOOTH_BITS.get(token, 0)
    return bits


def smooth_rule(rw, path):
    bits = smooth_bits(rw.resolve(path, 'smooth'))
    if not bits & (SMOOTH_BITS['SMOOTH_TRUE'] | SMOOTH_BITS['SMOOTH_MORE']):
        return None
    raw = (rw.resolve(path, 'canSmoothWith') or '').strip()
    return {
        'more': bool(bits & SMOOTH_BITS['SMOOTH_MORE']),
        'entries': None if not raw or raw == 'null' else re.findall(r'(/(?:turf|obj)/[A-Za-z0-9_/]+)', raw),
        'diagonal': (rw.resolve(path, 'smooth_diag') or 'TRUE').strip() not in ('FALSE', '0'),
        'border': bool(bits & SMOOTH_BITS['SMOOTH_BORDER']),
    }


def smooth_matches(path, rule, candidates):
    if rule['entries'] is None:
        return [path] if path in candidates else []
    return sorted(q for q in candidates if any(q == e or (rule['more'] and q.startswith(e + '/')) for e in rule['entries']))


def group_define(runtime):
    return 'SMOOTH_GROUP_ROCKHILL_' + re.sub(r'[^A-Za-z0-9]+', '_', runtime.split('/', 2)[2]).upper().strip('_')


def define_number(expr, table, depth=0):
    if depth > 16:
        raise ValueError(expr)

    def value_of(match):
        name = match.group(0)
        raw = BYOND_LAYERS.get(name) if name in BYOND_LAYERS else table.get(name)
        if raw is None:
            raise ValueError(name)
        return '(' + repr(define_number(raw, table, depth + 1)) + ')'

    text = re.sub(r'[A-Za-z_][A-Za-z0-9_]*', value_of, (expr or '').strip())
    if not text or not re.fullmatch(r'[\d\s.+\-*/()]+', text):
        raise ValueError(expr)
    return float(eval(text, {'__builtins__': {}}))


def tg_define_values(path):
    values = {}
    for line in open(path, encoding='utf-8', errors='ignore'):
        m = re.match(r'^\s*#define\s+([A-Za-z_][A-Za-z0-9_]*)\s+(.+?)\s*(?://.*)?$', line)
        if m:
            values[m.group(1)] = m.group(2)
    return values


def number_or_none(raw, table):
    try:
        return define_number(raw, table) if raw else None
    except ValueError:
        return None


def layer_expression(raw, value, tg_values):
    m = re.fullmatch(r'([A-Z_][A-Z0-9_]*)(?:\s*([+-])\s*(\d+(?:\.\d+)?))?', raw.strip())
    if m:
        tg = number_or_none(m.group(1), tg_values)
        ours = number_or_none(m.group(1), DEFINE_VALUES)
        if tg is not None and ours is not None and abs(tg - ours) < 1e-9 and tg < define_number('TOPDOWN_LAYER', tg_values):
            return m.group(1) if not m.group(2) else f'{m.group(1)} {m.group(2)} {m.group(3)}'
    return f'{value:g}'



def placement_lines(rw, path, runtime, tg_values):
    plane = number_or_none(rw.resolve(path, 'plane') or rw.types.get('/atom', {}).get('plane'), DEFINE_VALUES)
    raw_layer = rw.resolve(path, 'layer')
    layer = number_or_none(raw_layer, DEFINE_VALUES)
    decal = boundary_match(runtime, '/obj/effect/decal') or boundary_match(runtime, '/obj/effect/turf_decal')
    base_plane = 'FLOOR_PLANE' if decal else 'GAME_PLANE'
    if plane is None:
        kind = 'floor' if decal else 'game'
    elif plane <= define_number('WALL_PLANE', DEFINE_VALUES):
        kind = 'floor'
    elif plane < define_number('GAME_PLANE_FOV_HIDDEN', DEFINE_VALUES):
        kind = 'lower'
    elif plane == define_number('GAME_PLANE_FOV_HIDDEN', DEFINE_VALUES):
        kind = 'game'
    else:
        kind = 'upper'
    tg_plane = {'floor': 'FLOOR_PLANE', 'lower': 'GAME_PLANE', 'game': 'GAME_PLANE', 'upper': 'ABOVE_GAME_PLANE'}[kind]
    lines = [f'\tplane = {tg_plane}'] if tg_plane != base_plane else []
    if kind == 'floor':
        if not decal:
            lines.append('\tlayer = ABOVE_OPEN_TURF_LAYER')
        return lines
    if layer is None:
        if decal:
            lines.append('\tlayer = LOW_OBJ_LAYER')
        return lines
    if kind == 'lower' and layer > define_number('BELOW_MOB_LAYER', tg_values):
        lines.append('\tlayer = BELOW_MOB_LAYER')
        return lines
    lines.append(f'\tlayer = {layer_expression(raw_layer, layer, tg_values)}')
    return lines


def turf_state_edits(map_path):
    edits = set()
    current = None
    for line in open(map_path, encoding='utf-8'):
        line = line.rstrip('\n')
        if line.startswith('('):
            break
        match = re.match(r'^(/turf/[A-Za-z0-9_/]+)\{$', line)
        if match:
            current = match.group(1)
            continue
        if current:
            state = re.match(r'^\s*icon_state = "([^"\[\\]*)";?$', line)
            if state:
                edits.add((current, state.group(1)))
            if re.match(r'^\s*\}[,)]$', line):
                current = None
    return edits


def source_maps(cfg, rw=None):
    maps = [cfg['source']['map']]
    listing = cfg['source'].get('map_json')
    entries = []
    if listing:
        world = json.load(open(os.path.join(CHECKOUT, listing), encoding='utf-8'))
        entries += world.get('other_z', [])
    entries += cfg['source'].get('always_other_z', [])
    for entry in entries:
        conf = json.load(open(os.path.join(CHECKOUT, entry), encoding='utf-8'))
        maps.append(f"_maps/{conf['map_path']}/{conf['map_file']}")
    spec = cfg['port'].get('dungeon_templates')
    if spec and rw:
        maps += [template['source'] for template in dungeon_templates(rw, spec)]
    return maps


def dungeon_templates(rw, spec):
    out = []
    for path in sorted(rw.types):
        if not boundary_match(path, spec['prefix']):
            continue
        mappath = (rw.resolve(path, 'mappath') or '').strip().strip('"')
        abstract = (rw.resolve(path, 'abstract_type') or '').strip() == path
        if abstract or mappath in ('', 'null'):
            continue
        rel = mappath[len('_maps/'):] if mappath.startswith('_maps/') else mappath
        out.append({'type': path, 'source': mappath, 'output': f"{spec['output_dir']}/{rel.split('/', 1)[1] if '/' in rel else rel}"})
    return out


def generate_dungeon_templates(rw, spec, tg_names):
    templates = dungeon_templates(rw, spec)
    blocks = []
    for path in sorted(p for p in rw.types if boundary_match(p, spec['prefix']) and p != spec['prefix']):
        block = [path]
        if (rw.types[path].get('abstract_type') or '').strip() == path:
            block.append(f'\tabstract_type = {path}')
        for name in spec['vars']:
            value = literal(rw.types[path].get(name), tg_names)
            if value is not None:
                block.append(f'\t{name} = {value}')
        found = next((t for t in templates if t['type'] == path), None)
        if found:
            block.append(f'\tmappath = "{found["output"]}"')
        blocks.append(block)
    open(f"{OUT_DIR}/{spec['file']}", 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
    open(spec['manifest'], 'w', encoding='utf-8', newline='\n').write(json.dumps([{'source': t['source'], 'output': t['output']} for t in templates], indent='\t') + '\n')
    print(f"{spec['file']}: {len(blocks)} dungeon templates, {len(templates)} maps")


SKILL_CALL = re.compile(r'\b(?:H|human|user)\.(?:mind\??\.)?(adjust_skillrank(?:_up_to)?)\(\s*(/datum/skill/[A-Za-z0-9_/]+)\s*,\s*([A-Z_0-9]+|-?\d+)')
STAT_CALL = re.compile(r'\b(?:H|human|user)\.change_stat\(\s*(STATKEY_[A-Z]+|"[a-z]+")\s*,\s*(-?\d+)\s*\)')
TRAIT_CALL = re.compile(r'\bADD_TRAIT\(\s*(?:H|human|user)\s*,\s*(TRAIT_[A-Z0-9_]+)\s*,')
CONTROL_LINE = re.compile(r'^(if|else|for|switch|while|do)\b(.*)$')
ROGUE_TRAITS_FILE = 'code/__DEFINES/traits.dm'


def unconditional_lines(body):
    lines = []
    stack = []
    for line in body:
        text = line.strip()
        if not text:
            continue
        indent = len(line) - len(line.lstrip('\t'))
        while stack and stack[-1][0] >= indent:
            stack.pop()
        control = CONTROL_LINE.match(text)
        if control:
            mind_only = control.group(1) == 'if' and re.fullmatch(r'\(\s*H\.mind\s*\)', control.group(2).strip()) is not None
            stack.append((indent, mind_only))
            continue
        if all(ok for _, ok in stack):
            lines.append(text)
    return lines


def rogue_trait_table():
    text = strip_comments(open(os.path.join(CHECKOUT, ROGUE_TRAITS_FILE), encoding='utf-8', errors='ignore').read())
    start = text.find('GLOBAL_LIST_INIT(roguetraits, list(')
    if start < 0:
        raise SystemExit(f'{ROGUE_TRAITS_FILE}: no roguetraits list')
    body = text[start:text.find('\n))', start)]
    table = {}
    for name, span, desc in re.findall(r'(TRAIT_[A-Z0-9_]+)\s*=\s*(span_[a-z_]+)\(\s*("(?:[^"\\]|\\.)*")\s*\)', body):
        if STRING_LITERAL.match(desc):
            table[name] = (span, desc)
    return table


def generate_traits(cfg, tg_names, needed):
    spec = cfg['traits']
    table = rogue_trait_table()
    extra = spec.get('extra', {})
    for name, entry in {**extra, **spec.get('descriptions', {})}.items():
        table[name] = (entry['span'], json.dumps(entry['text']))
    wanted = sorted(set(table) | set(needed))
    defines = []
    skipped = []
    for name in wanted:
        if name in tg_names:
            continue
        value = json.dumps(extra[name]['value']) if name in extra else DEFINE_VALUES.get(name, '').strip()
        if not STRING_LITERAL.match(value):
            skipped.append(name)
            continue
        defines.append(f'#define {name} {value}')
    known = (set(tg_names) | {line.split()[1] for line in defines})
    descriptions = [f'\t{name} = {span}({desc}),' for name, (span, desc) in sorted(table.items()) if name in known and span in tg_names]
    out = defines + ['', 'GLOBAL_LIST_INIT(rogue_trait_descriptions, list('] + descriptions + ['\t))']
    open(spec['output'], 'w', encoding='utf-8', newline='\n').write('\n'.join(out) + '\n')
    print(f"traits: {len(defines)} defines, {len(descriptions)} descriptions, {len(skipped)} without a string value")
    return known


def role_attributes(rw, job, advclass, outfit_source, attr_cfg):
    scale = attr_cfg['level_scale']
    stats = collections.Counter()
    skills = {}
    traits = []

    def stat_key(token):
        return attr_cfg['stats'].get(expand_define(token).strip('"'))

    def level(token):
        value = expand_define(token)
        return int(float(value)) * scale if NUMBER.match(value) else None

    def raise_skill(path, token, additive):
        value = level(token)
        if value is None:
            return
        skills[path] = skills.get(path, 0) + value if additive else max(skills.get(path, 0), value)

    if advclass:
        for token, amount in re.findall(r'(STATKEY_[A-Z]+|"[a-z]+")\s*=\s*(-?\d+)', rw.resolve(advclass, 'subclass_stats') or ''):
            if stat_key(token):
                stats[stat_key(token)] += int(amount)
        for path, token in re.findall(r'(/datum/skill/[A-Za-z0-9_/]+)\s*=\s*([A-Z_0-9]+|\d+)', rw.resolve(advclass, 'subclass_skills') or ''):
            raise_skill(path, token, False)
        traits += re.findall(r'(TRAIT_[A-Z0-9_]+)', rw.resolve(advclass, 'traits_applied') or '')
    else:
        for token, amount in re.findall(r'(STATKEY_[A-Z]+|"[a-z]+")\s*=\s*(-?\d+)', rw.resolve(job, 'job_stats') or ''):
            if stat_key(token):
                stats[stat_key(token)] += int(amount)
    traits += re.findall(r'(TRAIT_[A-Z0-9_]+)', rw.resolve(job, 'job_traits') or '')
    parts = (outfit_source or '').split('/')
    for k in range(3, len(parts) + 1):
        outfit = '/'.join(parts[:k])
        for text in unconditional_lines(PRE_EQUIP.get(outfit, [])):
            for call, path, token in SKILL_CALL.findall(text):
                raise_skill(path, token, call == 'adjust_skillrank')
            for token, amount in STAT_CALL.findall(text):
                if stat_key(token):
                    stats[stat_key(token)] += int(amount)
            traits += TRAIT_CALL.findall(text)
    traits += attr_cfg.get('extra_traits', {}).get(job, [])
    return {'stats': {k: v for k, v in stats.items() if v}, 'skills': skills, 'traits': list(dict.fromkeys(traits))}


def generate_skills(cfg, rw):
    spec = cfg['attributes']
    blocks = []
    for path, meta in spec['meta'].items():
        if path not in rw.types:
            raise SystemExit(f'attributes.meta: {path} is not a Ratwood skill')
        target = spec['skill_target'] + path[len(spec['skill_root']):]
        block = [target]
        for var in ('name', 'desc'):
            value = string_value(rw.resolve(path, var))
            if value and value != '""':
                block.append(f'\t{var} = {value}')
        block.append(f"\tcategory = {meta['category']}")
        block.append(f"\tdifficulty = {meta['difficulty']}")
        if meta.get('governing'):
            block.append(f"\tgoverning_attribute = {meta['governing']}")
        if meta.get('defaults'):
            block += ['\tdefault_attributes = list('] + [f'\t\t{k} = {v},' for k, v in meta['defaults'].items()] + ['\t\t)']
        dreams = [d for d in re.findall(r'"(?:[^"\\]|\\.)*"', rw.resolve(path, 'dreams') or '') if STRING_LITERAL.match(d)]
        if dreams:
            block += ['\tdreams = list('] + [f'\t\t{d},' for d in dreams] + ['\t\t)']
        blocks.append(block)
    missing = sorted(p for p in rw.types if p.startswith(spec['skill_root'] + '/') and p not in spec['meta'] and (rw.types[p].get('abstract_type') or '').strip() != p)
    if missing:
        raise SystemExit('Ratwood skills without attributes.meta entries:\n  ' + '\n  '.join(missing))
    open(f"{OUT_DIR}/{spec['skills_file']}", 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
    print(f"{spec['skills_file']}: {len(blocks)} skills")


def generate_attribute_sheets(cfg, rw, jobs, role_outfits, known_traits):
    spec = cfg['attributes']
    blocks = []
    per_job = {}
    unknown_skills = collections.Counter()
    unknown_traits = collections.Counter()
    for job in jobs:
        dressed = role_outfits.get(job, {})
        data = role_attributes(rw, job, dressed.get('advclass'), dressed.get('source'), spec)
        entries = [f'\t\t{stat} = {amount},' for stat, amount in sorted(data['stats'].items())]
        for path, value in sorted(data['skills'].items()):
            if path not in spec['meta']:
                unknown_skills[path] += 1
                continue
            entries.append(f"\t\t{spec['skill_target'] + path[len(spec['skill_root']):]} = {min(value, 60)},")
        traits = []
        for trait in data['traits']:
            if trait in known_traits:
                traits.append(trait)
            else:
                unknown_traits[trait] += 1
        sheet = None
        if entries:
            sheet = spec['sheet_root'] + job[len(JOB_ROOT):]
            blocks.append([sheet, '\traw_attribute_list = list('] + entries + ['\t\t)'])
        per_job[job] = {'sheet': sheet, 'traits': traits}
    open(f"{OUT_DIR}/{spec['sheets_file']}", 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
    print(f"{spec['sheets_file']}: {len(blocks)} role sheets")
    if unknown_skills:
        print('  skills without a port:', ', '.join(f'{p} ({n})' for p, n in unknown_skills.most_common()))
    if unknown_traits:
        print('  traits without a define:', ', '.join(f'{p} ({n})' for p, n in unknown_traits.most_common()))
    return per_job


def map_usage(map_path):
    lines = open(map_path, encoding='utf-8').read().split('\n')
    models = {}
    tiles = collections.Counter()
    levels = collections.defaultdict(collections.Counter)
    i = 0
    while i < len(lines):
        m = re.match(r'^"([^"]+)" = \($', lines[i])
        if m:
            paths = []
            j = i + 1
            while True:
                pm = re.match(r'^(/[A-Za-z0-9_/]+)', lines[j])
                if pm:
                    paths.append(pm.group(1))
                if re.match(r'^\s*\}?\)$', lines[j]) or lines[j].endswith(')'):
                    break
                j += 1
            models[m.group(1)] = paths
            i = j + 1
            continue
        m = re.match(r'^\((\d+),(\d+),(\d+)\) = \{"$', lines[i])
        if m:
            z = int(m.group(3))
            j = i + 1
            while lines[j] != '"}':
                tiles[lines[j]] += 1
                levels[z][lines[j]] += 1
                j += 1
            i = j + 1
            continue
        i += 1
    usage = collections.Counter()
    for key, count in tiles.items():
        for p in models[key]:
            usage[p] += count
    per_level = {}
    for z, counter in levels.items():
        c = collections.Counter()
        for key, count in counter.items():
            for p in models[key]:
                c[p] += count
        per_level[z] = c
    return usage, per_level


def boundary_match(path, prefix):
    return path == prefix or path.startswith(prefix + '/')


def replacement_for(path, rules):
    best = None
    for rule in rules:
        matched = path == rule['prefix'] if rule.get('exact') else boundary_match(path, rule['prefix'])
        if matched and (best is None or len(rule['prefix']) > len(best['prefix'])):
            best = rule
    return best


def loot_entries(raw):
    if not raw:
        return []
    return [(item, int(weight) if weight else 1) for item, weight in re.findall(r'(/obj/item/[A-Za-z0-9_/]+)\s*(?:=\s*(\d+))?', raw)]


def closet_fill(rw, path):
    contents, loot, chance = [], [], 100
    p = path
    while p and p.startswith('/obj/structure/closet'):
        for bodies in (INIT_BODIES, FILL_BODIES):
            body = '\n'.join(bodies.get(p, []))
            contents += NEW_IN_SRC.findall(body)
            m = LOOT_LIST.search(body)
            if m and not loot:
                loot = [(item, int(float(weight)) if weight else 1) for item, weight in list_paths(m.group(1))]
                pm = PROB_CALL.search(body)
                chance = int(pm.group(1)) if pm else 100
        p = rw.parent(p)
    return contents, loot, chance


def runtime_path(path, rules):
    rule = replacement_for(path, rules)
    if rule is None:
        return path
    if rule.get('drop'):
        return None
    if rule.get('rebase'):
        return rule['rebase'] + path[len(rule['prefix']):]
    return rule['to']


def tg_spelling(text):
    return re.sub(r'eciev', lambda m: m.group(0)[:2] + m.group(0)[3] + m.group(0)[2] + m.group(0)[4], text, flags=re.IGNORECASE)


def literal(value, tg_names):
    if value is None:
        return None
    v = value.strip()
    if v in ('TRUE', 'FALSE', 'null') or NUMBER.match(v):
        return v
    if STRING_LITERAL.match(v) or (v.startswith('{"') and v.endswith('"}')):
        return tg_spelling(v)
    if ICON_LITERAL.match(v):
        return v
    if re.match(r'^[A-Z_][A-Z0-9_]*$', v) and (v in tg_names or v in BYOND_DIRECTIONS):
        return v
    time = re.fullmatch(r'(\d+(?:\.\d+)?)\s*(SECONDS|MINUTES|DECISECONDS)', v)
    if time:
        return f'{time.group(1)} {time.group(2)}'
    return None


def checkout_root():
    return os.path.abspath(CHECKOUT)


def checkout_git_dir():
    return os.path.join(checkout_root(), '.git')


def same_path(a, b):
    return os.path.normcase(os.path.normpath(os.path.abspath(a))) == os.path.normcase(os.path.normpath(os.path.abspath(b)))


def git_env():
    env = dict(os.environ, GIT_CEILING_DIRECTORIES=os.path.dirname(checkout_root()))
    for name in ('GIT_DIR', 'GIT_WORK_TREE', 'GIT_INDEX_FILE', 'GIT_COMMON_DIR'):
        env.pop(name, None)
    return env


def git(*args):
    command = ['git', '--git-dir', checkout_git_dir(), '--work-tree', checkout_root(), '-c', 'gc.auto=0', '-c', 'maintenance.auto=false', *args]
    return subprocess.run(command, check=True, capture_output=True, text=True, env=git_env(), cwd=os.path.dirname(checkout_root())).stdout


def checkout_valid():
    if not os.path.isfile(os.path.join(checkout_git_dir(), 'HEAD')):
        return False
    result = subprocess.run(['git', '--git-dir', checkout_git_dir(), 'rev-parse', '--absolute-git-dir'], capture_output=True, text=True, env=git_env(), cwd=os.path.dirname(checkout_root()))
    return result.returncode == 0 and same_path(result.stdout.strip(), checkout_git_dir())


def sync_source(source):
    cache_root = os.path.abspath('.cache')
    if not same_path(os.path.dirname(checkout_root()), cache_root) or same_path(checkout_git_dir(), '.git'):
        raise SystemExit(f'refusing to use {checkout_root()} as the Ratwood cache: it must be a folder inside {cache_root}')
    if not checkout_valid():
        if os.path.exists(checkout_root()):
            print('the Ratwood cache', CHECKOUT, 'is not a valid git repository; recloning it')
            shutil.rmtree(checkout_root())
        os.makedirs(os.path.dirname(checkout_root()), exist_ok=True)
        print('cloning', source['repository'], source['branch'], 'into', CHECKOUT)
        subprocess.run(['git', 'clone', '--depth', '1', '--filter=blob:none', '--no-checkout', '--config', 'gc.auto=0', '--config', 'maintenance.auto=false', '--branch', source['branch'], source['repository'], checkout_root()], check=True, env=git_env(), cwd=os.path.dirname(checkout_root()))
        if not checkout_valid():
            raise SystemExit(f'{CHECKOUT}: the fresh clone is not a valid git repository; refusing to run git there')
    elif '--no-pull' not in sys.argv:
        print('syncing', CHECKOUT, 'to', source['repository'], source['branch'])
        git('remote', 'set-url', 'origin', source['repository'])
        git('fetch', '--depth', '1', 'origin', source['branch'])
        git('reset', '--hard', 'FETCH_HEAD')
    git('config', 'gc.auto', '0')
    git('config', 'maintenance.auto', 'false')
    git('sparse-checkout', 'set', '--no-cone', *source['sparse'])
    git('read-tree', '-mu', 'HEAD')
    absent = [os.path.relpath(path, CHECKOUT).replace('\\', '/') for path in included_files(CHECKOUT) if not os.path.exists(path)]
    if absent:
        git('sparse-checkout', 'add', *('/' + path for path in absent))
        git('read-tree', '-mu', 'HEAD')
    absent = [path for path in included_files(CHECKOUT) if not os.path.exists(path)]
    if absent:
        raise SystemExit('files the Ratwood .dme includes are missing from ' + CHECKOUT + ':\n  ' + '\n  '.join(absent))
    SOURCE_REVISION[:] = git('log', '-1', '--format=%H %cs').split()
    print('ratwood revision:', ' '.join(SOURCE_REVISION))


def main():
    if not os.path.exists(CONFIG):
        raise SystemExit('run from the repository root')
    cfg = json.load(open(CONFIG, encoding='utf-8'))
    code_root = CHECKOUT
    sync_source(cfg['source'])
    port = cfg['port']
    rules = cfg['replacements']
    print('parsing', code_root)
    types, _ = parse_codebase(code_root)
    rw = Codebase(types)
    print('ratwood types:', len(types))
    declared = declared_paths(DECLARATION_ROOTS, [OUT_DIR])
    tg_declared = declared_paths(['code'], [])
    tg_names = tg_defines('code')
    maps = source_maps(cfg, rw)
    usage, per_level = map_usage(os.path.join(CHECKOUT, maps[0]))
    station_usage = collections.Counter(usage)
    for extra in maps[1:]:
        usage.update(map_usage(os.path.join(CHECKOUT, extra))[0])
    print('maps:', ', '.join(maps))

    if '--inventory' in sys.argv:
        for z in sorted(per_level):
            c = per_level[z]
            areas = collections.Counter()
            for p, n in c.items():
                if p.startswith('/area/'):
                    areas['/'.join(p.split('/')[:4])] += n
            print(f'z{z}:', ', '.join(f'{a} {n}' for a, n in areas.most_common(4)))
        for kind in ('/area', '/turf', '/obj', '/mob'):
            todo = collections.Counter()
            for p, n in usage.items():
                if p.split('/')[1] != kind[1:]:
                    continue
                rule = replacement_for(p, rules)
                if rule or p in declared:
                    continue
                todo[p] = n
            print(f'{kind}: {len(todo)} unported, unreplaced types, {sum(todo.values())} uses')
        return

    jobs = select_jobs(cfg, rw)
    role_outfits = {job: role_outfit(rw, job) for job in jobs}
    class_jobs = collections.defaultdict(list)
    for job in jobs:
        if len(role_outfits[job]['subclasses']) > 1:
            for advclass in role_outfits[job]['subclasses']:
                class_jobs[advclass].append(job)
    class_outfits = {advclass: outfit_slots(rw, rw.resolve(advclass, 'outfit')) for advclass in class_jobs}
    outfit_items = set()
    for dressed in list(role_outfits.values()) + list(class_outfits.values()):
        outfit_items |= set(dressed['slots'].values())
        outfit_items |= {item for item, _ in dressed['contents'] or []}
    mapgen = mapgen_spec(rw, usage)
    mapgen_types = {path for gen in mapgen.values() for module in gen['modules'] for key in ('spawnableAtoms', 'spawnableTurfs') for path, _ in module[key]}
    fill_items = set(cfg['port'].get('extra_types', []))
    for path in set(usage) | mapgen_types:
        if path.startswith('/obj/structure'):
            fill_items |= set(random_pick(rw, path))
    for path in usage:
        if (replacement_for(path, rules) or {}).get('port', {}).get('fill'):
            contents, loot, _ = closet_fill(rw, path)
            fill_items |= set(contents) | {item for item, _ in loot}
    generated = generate(cfg, port, rules, rw, declared, tg_declared, tg_names, usage, outfit_items | mapgen_types | fill_items, set(jobs))
    generate_mapgen(mapgen, rules, declared | generated, tg_names)
    role_traits = set()
    for job in jobs:
        dressed = role_outfits.get(job, {})
        role_traits |= set(role_attributes(rw, job, dressed.get('advclass'), dressed.get('source'), cfg['attributes'])['traits'])
    for advclass, owners in class_jobs.items():
        role_traits |= set(role_attributes(rw, owners[0], advclass, class_outfits[advclass]['source'], cfg['attributes'])['traits'])
    known_traits = generate_traits(cfg, tg_names, role_traits)
    generate_skills(cfg, rw)
    role_attrs = generate_attribute_sheets(cfg, rw, jobs, role_outfits, known_traits)
    generate_jobs(cfg, rw, usage, role_outfits, declared | generated, station_usage, role_attrs)
    generate_advclasses(cfg, rw, class_jobs, class_outfits, declared | generated, known_traits)


MAPGEN_LANDMARK = '/obj/effect/landmark/mapGenerator'
MAPGEN_WEIGHTED = ('spawnableAtoms', 'spawnableTurfs')
MAPGEN_PATHS = ('allowed_turfs', 'excluded_turfs', 'allowed_areas')
MAPGEN_SCALARS = ('clusterCheckFlags', 'clusterMin', 'clusterMax', 'include_subtypes')


def list_paths(raw):
    return [(p, w) for p, w in re.findall(r'(/[A-Za-z0-9_/]+)\s*(?:=\s*(-?[\d.]+))?', raw or '')]


def mapgen_spec(rw, usage):
    spec = {}
    for landmark in sorted(p for p in usage if p.startswith(MAPGEN_LANDMARK + '/')):
        generator = (rw.resolve(landmark, 'mapGeneratorType') or '').strip()
        if not generator.startswith('/datum/'):
            continue
        modules = []
        for module, _ in list_paths(rw.resolve(generator, 'modules')):
            data = {'path': module}
            for key in MAPGEN_WEIGHTED:
                data[key] = list_paths(rw.resolve(module, key))
            for key in MAPGEN_PATHS:
                data[key] = [p for p, _ in list_paths(rw.resolve(module, key))]
            for key in MAPGEN_SCALARS:
                data[key] = rw.resolve(module, key)
            modules.append(data)
        spec[landmark] = {'generator': generator, 'modules': modules}
    return spec


def generate_mapgen(spec, rules, valid, tg_names):
    implicit = {v.rsplit('/', k)[0] for v in valid for k in range(1, v.count('/'))}

    def kept(path, atoms):
        rule = replacement_for(path, rules)
        if rule and (atoms and not rule.get('rebase')):
            return None
        target = runtime_path(path, rules)
        return target if target in valid or (not atoms and target in implicit) else None

    blocks = []
    emitted = set()
    for landmark, gen in spec.items():
        name = gen['generator'].rsplit('/', 1)[1]
        generator = f'/datum/map_generator/rockhill/{name}'
        blocks.append([landmark, f'\tmapGeneratorType = {generator}'])
        if generator in emitted:
            continue
        emitted.add(generator)
        module_paths = []
        for module in gen['modules']:
            path = f"/datum/map_generator_module/rockhill/{module['path'].rsplit('/', 1)[1]}"
            block = [path]
            for key in MAPGEN_WEIGHTED:
                entries = {}
                for p, w in module[key]:
                    target = kept(p, key == 'spawnableAtoms')
                    if target:
                        entries[target] = w or '1'
                entries = list(entries.items())
                if entries:
                    block.append(f'\t{key} = list(' + ', '.join(f'{p} = {w}' for p, w in entries) + ')')
            skip = False
            for key in MAPGEN_PATHS:
                if not module[key]:
                    continue
                entries = sorted({kept(p, False) for p in module[key]} - {None})
                if not entries:
                    skip = key != 'excluded_turfs'
                    continue
                block.append(f'\t{key} = list(' + ', '.join(entries) + ')')
            for key in MAPGEN_SCALARS:
                value = literal(module[key], tg_names)
                if value is not None:
                    block.append(f'\t{key} = {value}')
            if skip:
                continue
            module_paths.append(path)
            if path not in emitted:
                emitted.add(path)
                blocks.append(block)
        blocks.append([generator, '\tmodules = list(' + ', '.join(module_paths) + ')'])
    open(f'{OUT_DIR}/mapgen.dm', 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
    print(f'mapgen.dm: {len(spec)} landmarks, {len(emitted)} generator and module types')


def parse_look_line(text, look):
    if 'dir' not in look and re.fullmatch(r'dir\s*=\s*pick\(\s*(?:GLOB\.cardinals|NORTH\s*,\s*SOUTH\s*,\s*(?:EAST\s*,\s*WEST|WEST\s*,\s*EAST))\s*\)', text):
        look['dir'] = True
        return
    m = re.fullmatch(r'icon_state\s*=\s*(.+)', text)
    if not m or 'icon' in look:
        return
    value = m.group(1).strip()
    if re.fullmatch(r'[A-Za-z_]\w*', value):
        look['icon'] = ('var', value)
        return
    lit = re.fullmatch(r'"([^"\[\]]*)"', value)
    if lit:
        look['icon'] = ('state', lit.group(1))
        return
    var = re.fullmatch(r'"(\[(?:initial\()?icon_state\)?\])?([^"\[\]]*)\[(rand|pick)\(([\d\s,]+)\)\]([^"\[\]]*)"', value)
    if not var:
        return
    numbers = sorted(int(n) for n in var.group(4).split(',') if n.strip())
    if var.group(3) == 'rand':
        low, high = numbers[0], numbers[-1]
    elif numbers == list(range(numbers[0], numbers[-1] + 1)):
        low, high = numbers[0], numbers[-1]
    else:
        return
    look['icon'] = ('variant', (bool(var.group(1)), var.group(2), var.group(5), low, high))


def parse_look(body):
    look = {}
    guard = False
    for line in body:
        text = line.strip()
        if not text or text.startswith('//'):
            continue
        indent = len(line) - len(line.lstrip('\t'))
        if indent == 1:
            guard = re.fullmatch(r'if\s*\(\s*icon_state\s*==\s*(?:"[^"]*"|initial\(icon_state\))\s*\)', text) is not None
            if not guard:
                parse_look_line(text, look)
        elif indent == 2 and guard:
            parse_look_line(text, look)
    return look


def runtime_look(rw, path):
    look = {}
    seen = set()
    p = path
    while p and p not in seen:
        seen.add(p)
        if p in INIT_BODIES:
            for aspect, value in parse_look(INIT_BODIES[p]).items():
                look.setdefault(aspect, value)
        p = rw.parent(p)
    if look.get('icon', (None,))[0] == 'var':
        value = (rw.resolve(path, look['icon'][1]) or '').strip()
        if re.fullmatch(r'"[^"\[\]]*"', value):
            look['icon'] = ('state', value.strip('"'))
        else:
            del look['icon']
    return look


def init_overlay(rw, path):
    p = path
    seen = set()
    while p and p not in seen:
        seen.add(p)
        body = '\n'.join(INIT_BODIES.get(p, []))
        if body:
            found = re.search(r'mutable_appearance\(\s*icon\s*,\s*"([^"\[\]]+)"', body)
            if found and 'add_overlay(' in body:
                return found.group(1)
        p = rw.parent(p)
    return None


def parse_onmob(body):
    text = '\n'.join(body)
    found = {}
    for tag in ONMOB_TAGS:
        label = re.search(r'if\(([^)]*"' + tag + r'"[^)]*)\)', text)
        if not label:
            continue
        ret = re.compile(r'return\b\s*(list\(|null\b)?').search(text, label.end())
        if not ret:
            continue
        if ret.group(1) != 'list(':
            found[tag] = 'null'
            continue
        depth = 1
        k = ret.end()
        while k < len(text) and depth:
            depth += {'(': 1, ')': -1}.get(text[k], 0)
            k += 1
        inner = text[ret.end():k - 1]
        pairs = [p.strip() for p in inner.split(',') if p.strip()]
        if pairs and all(re.fullmatch(r'"\w+"\s*=\s*-?\d+(?:\.\d+)?', p) for p in pairs):
            found[tag] = 'list(' + ', '.join(re.sub(r'\s*=\s*', ' = ', p) for p in pairs) + ')'
    return found


def onmob_numbers(raw):
    """A getonmobprop list literal as {key: number}."""
    return {key: float(value) if '.' in value else int(value) for key, value in re.findall(r'"(\w+)"\s*=\s*(-?\d+(?:\.\d+)?)', raw or '')}


def onmob_prop(rw, path, tag):
    """The getonmobprop table an item answers for a tag ("gen", "wielded", "onbelt", "onback"), walking its
    parents as Ratwood's `return ..()` does; None when a type stops the walk without one."""
    p = path
    while p and p.startswith('/obj/item'):
        body = ONMOB.get(p)
        if body is not None:
            found = parse_onmob(body)
            if tag in found:
                return None if found[tag] == 'null' else onmob_numbers(found[tag])
            if not any('..()' in line for line in body):
                return None
        p = rw.parent(p)
    return None


def onmob_parts(prop, behind):
    """Whether the table draws anything in front of the body (above = 1) or behind it (above = 0)."""
    return any(prop.get(key) == (0 if behind else 1) for key in ABOVE_KEYS)


def bake_name(group, base, signature):
    """A state name in a baked sheet group: the sprite's own state, or "<state>~<n>" when another item with the
    same sprite holds it differently."""
    name = base
    n = 1
    while BAKE_NAMES.get((group, name), signature) != signature:
        n += 1
        name = f'{base}~{n}'
    BAKE_NAMES[(group, name)] = signature
    return name


def bake_jobs(out, name, icon, state, prop, mirrored):
    """Queues the front and behind states a table draws; returns how many it queued (none when no side is drawn)."""
    queued = 0
    for behind in (False, True):
        if onmob_parts(prop, behind):
            job_name = f'{name}_behind' if behind else name
            BAKE_JOBS[out][job_name] = {'name': job_name, 'icon': icon, 'state': state, 'prop': prop, 'mirrored': mirrored, 'behind': behind}
            queued += 1
    return queued


def write_bake_manifest(spec):
    sheets = [{'out': out, 'states': [jobs[name] for name in sorted(jobs)]} for out, jobs in sorted(BAKE_JOBS.items())]
    manifest = {'mask32': spec['mask32'], 'mask64': spec['mask64'], 'canvas': 64, 'sheets': sheets}
    with open(spec['manifest'], 'w', encoding='utf-8', newline='\n') as handle:
        json.dump(manifest, handle, indent='\t', sort_keys=True)
        handle.write('\n')
    print(f"{spec['manifest']}: {len(sheets)} sheets, {sum(len(s['states']) for s in sheets)} states to bake")


def graft_point(path, declared):
    parts = path.split('/')
    for k in range(3, len(parts) + 1):
        candidate = '/'.join(parts[:k])
        if candidate not in declared:
            return candidate
    return None


def category_for(path, categories):
    best = None
    for cat in categories:
        for prefix in cat['prefixes']:
            if boundary_match(path, prefix) and (best is None or len(prefix) > best[1]):
                best = (cat, len(prefix))
    return best[0] if best else None


def generate(cfg, port, rules, rw, declared, tg_declared, tg_names, usage, extra_items, jobs=frozenset()):
    categories = port['categories']
    tg_values = tg_define_values(TG_LAYERS)
    outdoor_areas = []
    chosen = collections.defaultdict(list)
    skipped = collections.Counter()
    port_usage = collections.Counter(usage)
    for spawner in [p for p in usage if p.startswith('/obj/effect/spawner/')]:
        for item, _ in loot_entries(rw.resolve(spawner, 'loot')):
            port_usage[item] += 0
    for item in extra_items:
        port_usage[item] += 0
    for path in list(port_usage):
        for name in port.get('linked_types', []):
            for item, _ in list_paths(rw.resolve(path, name)):
                port_usage[item] += 0
    for path, count in sorted(port_usage.items()):
        if replacement_for(path, rules) or path in tg_declared:
            continue
        cat = category_for(path, categories)
        if cat is None:
            skipped[path] = count
            continue
        chosen[cat['file']].append(path)

    icons = {}

    def icon_ref(raw):
        m = ICON_LITERAL.match(raw.strip())
        if not m:
            return None
        rel = exact_case(CHECKOUT, m.group(1))
        src = os.path.join(CHECKOUT, rel)
        if not os.path.exists(src) or not asset_allowed(rel, port.get('assets', {})):
            return None
        dest_rel = rel[len('icons/'):] if rel.startswith('icons/') else rel
        dest = f'{ICON_DIR}/{dest_rel}'
        icons[src] = dest
        return f"'{dest}'"

    sheet_states = {}

    def sheet_states_of(ref):
        rel = ref.strip("'")
        src = next((source for source, dest in icons.items() if dest == rel), rel)
        if src not in sheet_states:
            sheet_states[src] = dmi.state_names(src) if os.path.exists(src) else set()
        return sheet_states[src]

    runtime_sounds = {}

    sounds = {}

    def sound_ref(raw):
        rel = exact_case(CHECKOUT, ICON_LITERAL.match(raw.strip()).group(1))
        src = os.path.join(CHECKOUT, rel)
        if not os.path.exists(src) or not asset_allowed(rel, port.get('assets', {})):
            return None
        sounds[src] = f"{SOUND_DIR}/{rel[len('sound/'):] if rel.startswith('sound/') else rel}"
        return f"'{sounds[src]}'"

    def runtime_sound(rel, root):
        dest = f"{root}/{rel[len('sound/'):] if rel.startswith('sound/') else rel}"
        runtime_sounds[os.path.join(CHECKOUT, rel)] = dest
        return dest

    grid_spec = port.get('grid_storage', {})
    grid_used = set()

    def grid_type(component):
        component = (component or '').strip()
        if not grid_spec or not boundary_match(component, grid_spec['from']):
            return None
        grid_used.add(component)
        return grid_spec['to'] + component[len(grid_spec['from']):]

    def added_storage(path):
        p = path
        while p:
            body = INIT_BODIES.get(p)
            if body is not None:
                found = re.search(r'AddComponent\((/datum/component/storage[A-Za-z0-9_/]*)', '\n'.join(body))
                if found:
                    return found.group(1)
                if not any('..()' in line for line in body):
                    return None
            p = rw.parent(p)
        return None

    def grid_storage_lines(path):
        lines = []
        if boundary_match(path, '/obj/item/storage'):
            target = grid_type(rw.resolve(path, 'component_type'))
            if target:
                lines.append(f'\tstorage_type = {target}')
        target = grid_type(added_storage(path))
        if target:
            lines.append(f'\trogue_storage_type = {target}')
        return lines

    def fix_sprites(path, block):
        values = {}
        for line in block[1:]:
            name, sep, value = line.strip().partition(' = ')
            if sep:
                values[name] = value

        def text(name):
            value = values.get(name, '')
            return value[1:-1] if len(value) > 1 and value[0] == '"' and value[-1] == '"' else None

        def put(name, value):
            block[:] = [line for line in block if not line.startswith(f'\t{name} = ')]
            block.append(f'\t{name} = {value}')

        if any(path in users for users in RESTRICTED.values()):
            NO_SPRITE.append((path, 'restricted licence', text('icon_state') or ''))
            put('icon_state', 'null')
            put('inhand_icon_state', 'null')
            put('worn_icon', f"'{BLANK_WORN}'")
            put('worn_icon_state', 'null')
            BLANK_USERS.add(path)
            return
        world = values.get('icon')
        state = text('icon_state')
        if world and ICON_LITERAL.match(world) and state is not None and state not in sheet_states_of(world):
            NO_SPRITE.append((path, world.strip("'"), state))
            put('icon_state', 'null')

        hands = [values.get(name) for name in ('lefthand_file', 'righthand_file')]
        if any(ICON_LITERAL.match(sheet or '') for sheet in hands):
            held = text('inhand_icon_state')
            fits = held is not None and all(ICON_LITERAL.match(sheet or '') and held in sheet_states_of(sheet) for sheet in hands)
            put('inhand_icon_state', f'"{held}"' if fits else 'null')

        flags = values.get('slot_flags', '')
        wearable = bool(flags) or boundary_match(path, '/obj/item/clothing')
        pockets = ('ITEM_SLOT_POCKETS', 'ITEM_SLOT_LPOCKET', 'ITEM_SLOT_RPOCKET')
        carried = pockets + ('ITEM_SLOT_BACK', 'ITEM_SLOT_BELT')
        if not wearable or (any(pocket in flags for pocket in pockets) and all(slot in carried for slot in re.findall(r'ITEM_SLOT_[A-Z_]+', flags))):
            return
        sheet = values.get('worn_icon')
        sheet_states_here = sheet_states_of(sheet) if sheet and ICON_LITERAL.match(sheet) else set()
        look = next((state for state in (text('icon_state'), text('worn_icon_state')) if state and state in sheet_states_here), None)
        if look:
            put('worn_icon_state', f'"{look}"')
            ratwood_slots = set(re.findall(r'ITEM_SLOT_[A-Z_]+', rw.resolve(path, 'slot_flags') or ''))
            if look + FEMALE_WORN_SUFFIX in sheet_states_of(sheet) and ratwood_slots & set(port.get('female_worn_slots', [])):
                put('rogue_female_worn', 'TRUE')
                FEMALE_USERS.add(path)
            return
        if sheet or any(slot in flags for slot in TG_WORN_SLOTS) or boundary_match(path, '/obj/item/clothing'):
            BLANK_USERS.add(path)
            put('worn_icon', f"'{BLANK_WORN}'")
            put('worn_icon_state', 'null')

    def bake_onmob(path, block, spec):
        """Held, belted and slung sprites of Ratwood's experimental_* items as jobs for ai-skills
        bake_onmob_sheets.py: TG lefthand/righthand sheets (inhand_icon_state = the sprite's state, "_wielded" and
        the alternate grips' suffixes beside it) and one sheet of back/hip states, "_behind" for the parts under
        the body. The item then draws with TG's own inhand code and no icon() at runtime."""
        values = {}
        for line in block[1:]:
            name, sep, value = line.strip().partition(' = ')
            if sep:
                values[name] = value

        def put(name, value):
            block[:] = [line for line in block if not line.startswith(f'\t{name} = ')]
            block.append(f'\t{name} = {value}')

        icon = (values.get('icon') or '').strip("'")
        state = (values.get('icon_state') or '').strip('"')
        if not icon.startswith(ICON_DIR + '/') or not state or state == 'null':
            return
        states = sheet_states_of(f"'{icon}'")
        sheets = f"{spec['dir']}/{icon[len(ICON_DIR) + 1:-len('.dmi')]}"
        flag = lambda name: (rw.resolve(path, name) or '').strip() in ('TRUE', '1')
        if flag('experimental_inhand') and onmob_prop(rw, path, 'gen'):
            hands = {'': onmob_prop(rw, path, 'gen')}
            wielded = onmob_prop(rw, path, 'wielded')
            if wielded:
                hands['_wielded'] = wielded
            for grip in alt_grip_paths(rw, rw.resolve(path, 'alt_grips')):
                prop = re.search(r'"altgrip"\s*=\s*list\((.*?)\)', rw.resolve(grip, 'onmobprop_overrides') or '', re.S)
                if prop and onmob_numbers(prop.group(1)):
                    hands['_' + grip.rsplit('/', 1)[1]] = onmob_numbers(prop.group(1))
            name = bake_name((icon, 'hands'), state, json.dumps(hands, sort_keys=True))
            queued = 0
            sprites = [(name, state)]
            if name == state:
                sprites += [(state + suffix, state + suffix) for suffix in spec.get('variants', []) if state + suffix in states]
                sprites += [(state.replace(old, new), state.replace(old, new)) for old, new in spec.get('swaps', []) if old in state and state.replace(old, new) in states]
            for baked, sprite in sprites:
                if baked != name and bake_name((icon, 'hands'), baked, json.dumps(hands, sort_keys=True)) != baked:
                    continue
                for suffix, prop in hands.items():
                    queued += bake_jobs(f'{sheets}_righthand.dmi', baked + suffix, icon, sprite, prop, False)
                    queued += bake_jobs(f'{sheets}_lefthand.dmi', baked + suffix, icon, sprite, prop, True)
            if queued:
                put('lefthand_file', f"'{sheets}_lefthand.dmi'")
                put('righthand_file', f"'{sheets}_righthand.dmi'")
                put('inhand_icon_state', 'null' if name == state else f'"{name}"')
                put('inhand_x_dimension', '64')
                put('inhand_y_dimension', '64')
                put('rogue_baked_inhand', 'TRUE')
        worn = {}
        if flag('experimental_onback') and onmob_prop(rw, path, 'onback'):
            worn['back'] = onmob_prop(rw, path, 'onback')
        if flag('experimental_onhip') and onmob_prop(rw, path, 'onbelt'):
            worn['hip'] = onmob_prop(rw, path, 'onbelt')
        if worn:
            name = bake_name((icon, 'worn'), state, json.dumps(worn, sort_keys=True))
            out = f'{sheets}_onmob.dmi'
            queued = 0
            if 'back' in worn:
                queued += bake_jobs(out, f'back_{name}', icon, state, worn['back'], True)
                queued += bake_jobs(out, f'backr_{name}', icon, state, worn['back'], False)
            if 'hip' in worn:
                queued += bake_jobs(out, f'hipl_{name}', icon, state, worn['hip'], True)
                queued += bake_jobs(out, f'hipr_{name}', icon, state, worn['hip'], False)
            if queued:
                put('rogue_onmob_sheet', f"'{out}'")
                if name != state:
                    put('rogue_onmob_state', f'"{name}"')

    def slot_worn_icon(path, sheets):
        """The slot's default sheet of Ratwood's update_inv_* when it holds the worn state; Ratwood draws worn
        sprites by icon_state (item_state is for hands), so that is tried first."""
        flags = rw.resolve(path, 'slot_flags') or ''
        states = [v.strip().strip('"') for v in (rw.resolve(path, 'icon_state'), rw.resolve(path, 'item_state')) if v and v.strip() != 'null']
        for flag, sheet in sheets.items():
            if flag not in re.findall(r'ITEM_SLOT_[A-Z_]+', flags):
                continue
            src = os.path.join(CHECKOUT, sheet)
            if src not in sheet_states:
                sheet_states[src] = {s['name'] for s in dmi.read(src).states} if os.path.exists(src) else set()
            if any(state in sheet_states[src] for state in states):
                return f"'{sheet}'"
        return None

    generated = {p for paths in chosen.values() for p in paths}
    grip_paths = {g for paths in chosen.values() for p in paths if p.startswith('/obj/item') for g in alt_grip_paths(rw, rw.resolve(p, 'alt_grips'))}
    generated |= grip_paths
    used_turfs = sorted(p for p in usage if p.startswith('/turf/'))
    runtime = {p: runtime_path(p, rules) for p in used_turfs}
    reskins = [p for p in used_turfs if (replacement_for(p, rules) or {}).get('reskin')]
    valid = declared | generated | {runtime[p] for p in reskins}
    valid |= {'/'.join(p.split('/')[:k]) for p in generated for k in range(3, p.count('/') + 1)}
    valid |= {runtime_path(p, rules) for p in usage if (replacement_for(p, rules) or {}).get('rebase') and replacement_for(p, rules).get('port')}
    sheets = {}
    used_objs = sorted(p for p in usage if p.startswith('/obj/'))
    smooth_candidates = set(used_turfs) | set(used_objs)
    smoothing_paths = {p for cat in categories if cat.get('smoothing') for p in chosen.get(cat['file'], [])} | set(reskins)
    if os.path.isdir(SMOOTH_DIR):
        shutil.rmtree(SMOOTH_DIR)

    def convert_sheet(raw_icon, preview):
        m = ICON_LITERAL.match((raw_icon or '').strip())
        if not m:
            return None
        src = os.path.join(CHECKOUT, m.group(1))
        if not os.path.exists(src):
            return None
        if src not in sheets:
            sheet = dmi.read(src)
            if sheet.frame_width != 32 or sheet.frame_height != 32 or not dmi.has_corners(sheet):
                sheets[src] = None
            else:
                prefix = os.path.splitext(os.path.basename(src))[0]
                os.makedirs(SMOOTH_DIR, exist_ok=True)
                dmi.write(f'{SMOOTH_DIR}/{prefix}.dmi', 32, 32, dmi.corners_to_bitmask(sheet, prefix, preview))
                sheets[src] = prefix
        return sheets[src]

    state_edits = sorted(set().union(*(turf_state_edits(os.path.join(CHECKOUT, source)) for source in source_maps(cfg))))
    bitmask = {}
    for path in sorted(smoothing_paths):
        if not smooth_rule(rw, path):
            continue
        raw = rw.resolve(path, 'smooth_icon')
        if not raw or raw.strip() == 'null':
            raw = rw.resolve(path, 'icon')
        prefix = convert_sheet(raw, (rw.resolve(path, 'icon_state') or '').strip().strip('"'))
        if prefix:
            bitmask[path] = prefix
    BITMASK_TURFS.update(bitmask)
    state_variants = collections.defaultdict(set)
    for path, state in state_edits:
        target = runtime_path(path, rules)
        if (target in valid or target in generated) and path not in bitmask and not (replacement_for(path, rules) or {}).get('reskin') and runtime_look(rw, path).get('icon', (None, None))[0] != 'state':
            state_variants[path].add(f'{target}/{state_leaf(state)}')

    def matched_runtimes(path):
        found = set()
        for q in smooth_matches(path, smooth_rule(rw, path), smooth_candidates):
            target = runtime_path(q, rules)
            if target and target in valid:
                found.add(target)
        return found

    friends = {path: matched_runtimes(path) for path in bitmask}
    owners = {runtime_path(p, rules) for p in bitmask} | {t for found in friends.values() for t in found}
    group_numbers = {o: TURF_GROUP_BASE + i for i, o in enumerate(sorted(o for o in owners if o.startswith('/turf/')))}
    group_numbers.update({o: -(OBJ_GROUP_BASE + i) for i, o in enumerate(sorted(o for o in owners if not o.startswith('/turf/')))})
    group_defines = {o: group_define(o) for o in owners}
    if len(set(group_defines.values())) != len(group_defines):
        raise SystemExit('two smoothing owners map to the same group define')
    grouped = set()

    def group_list(targets):
        return ' + '.join(group_defines[t] for t in sorted(targets, key=lambda t: group_numbers[t]))

    def group_lines(target):
        if target not in group_defines:
            return []
        grouped.add(target)
        return [f'\tsmoothing_groups = {group_defines[target]}']

    def smooth_targets(path):
        rule = smooth_rule(rw, path)
        if not rule:
            return []
        found = set()
        for q in smooth_matches(path, rule, set(used_turfs)):
            if runtime[q] in valid:
                found.add(runtime[q])
                found |= state_variants.get(q, set())
        return sorted(found)

    def smoothing_lines(path):
        prefix = bitmask.get(path)
        if not prefix:
            return None
        rule = smooth_rule(rw, path)
        lines = [
            f"\ticon = '{SMOOTH_DIR}/{prefix}.dmi'",
            f'\ticon_state = "{prefix}-0"',
            f'\tbase_icon_state = "{prefix}"',
        ]
        if friends[path]:
            flags = 'SMOOTH_BITMASK' if rule['diagonal'] else 'SMOOTH_BITMASK_CARDINALS'
            if rule['border']:
                flags += ' | SMOOTH_BORDER'
            lines += [f'\tsmoothing_flags = {flags}', f'\tcanSmoothWith = {group_list(friends[path])}']
        else:
            lines += ['\tsmoothing_flags = NONE', '\tcanSmoothWith = null']
        own = runtime_path(path, rules)
        return lines + (group_lines(own) or ['\tsmoothing_groups = null'])

    def edge_receiver(path):
        p = path
        while p and p.startswith('/turf/open'):
            if 'cardinal_smooth' in PROCS.get(p, ()):
                return 'SMOOTH_FALSE' not in (rw.resolve(path, 'smooth') or 'SMOOTH_FALSE') and bool(smooth_targets(path))
            p = rw.parent(p)
        return False

    edge_states = {}
    edge_overrides = {}
    edge_sources = {}
    for path in used_turfs:
        target = runtime[path]
        if not target or target not in valid:
            continue
        state = string_value(rw.resolve(path, 'neighborlay'))
        if state and state != '""':
            edge_states[target] = state
        override = string_value(rw.resolve(path, 'neighborlay_override'))
        if override and override != '""':
            edge_overrides[target] = override

    if os.path.isdir(OUT_DIR):
        shutil.rmtree(OUT_DIR)
    os.makedirs(OUT_DIR)
    report_rows = collections.defaultdict(list)
    smoothed = collections.Counter()
    for cat in categories:
        paths = chosen.get(cat['file'], [])
        if not paths:
            continue
        blocks = []
        grafted = set()
        for path in paths:
            g = graft_point(path, tg_declared)
            if g and any(boundary_match(g, n) or g.startswith(n + '/') for n in cat.get('natural', [])):
                continue
            if g and g not in grafted and cat.get('graft'):
                grafted.add(g)
                block = [g, f"\tparent_type = {cat['graft']}"]
                for name, value in cat.get('graft_vars', {}).items():
                    block.append(f'\t{name} = {value}')
                if g not in paths:
                    blocks.append(block)
                else:
                    cat.setdefault('_graft_blocks', {})[g] = block[1:]
        if cat.get('sound_vars'):
            fetch_sources([f for p in paths for source_name in cat['sound_vars'].values() for f in sound_files(rw.resolve(p, source_name))])
        if cat.get('sound_lists'):
            fetch_sources([f for p in paths for name in cat['sound_lists'] for f in sound_files(rw.resolve(p, cat.get('rename', {}).get(name, name)))])
        for path in paths:
            CURRENT[0] = path
            block = [path]
            block += cat.get('_graft_blocks', {}).get(path, [])
            smooth = smoothing_lines(path) if cat.get('smoothing') else None
            for name in cat['vars']:
                if smooth and name in ('icon', 'icon_state'):
                    continue
                if name == 'layer' and cat.get('placement'):
                    continue
                source_name = cat.get('rename', {}).get(name, name)
                value = rw.resolve(path, source_name)
                if name in cat.get('skip_default', []) and (value or 'null').strip() in ('null', '0', 'FALSE', '""'):
                    continue
                if name in cat.get('mapped_vars', {}):
                    mapped = cat['mapped_vars'][name].get((value or '').strip().strip('()').strip())
                    if mapped:
                        block.append(f'\t{name} = {mapped}')
                    continue
                if name in cat.get('clothing_only', []) and not path.startswith('/obj/item/clothing/'):
                    continue
                if name in cat.get('numeric_vars', []):
                    number = define_value_number(value)
                    if number is not None and not (number == 0 and name in cat.get('skip_default', [])) and number != cat.get('numeric_defaults', {}).get(name):
                        block.append(f'\t{name} = {number}')
                    continue
                if name in cat.get('grip_lists', []):
                    entries = [p for p in alt_grip_paths(rw, value) if p in valid]
                    if entries:
                        block.append(f'\t{name} = list(' + ', '.join(entries) + ')')
                    elif (value or '').strip() == 'null' and alt_grip_paths(rw, rw.resolve(rw.parent(path), name)):
                        block.append(f'\t{name} = null')
                    continue
                if name in cat.get('intent_lists', []):
                    entries = intent_paths(rw, value)
                    if entries and tuple(entries) != DEFAULT_INTENTS:
                        USED_INTENTS.update(entries)
                        block.append(f'\t{name} = list(' + ', '.join(entries) + ')')
                    continue
                if name in cat.get('skill_vars', []):
                    target = skill_target(cfg, value)
                    if target:
                        block.append(f'\t{name} = {target}')
                    continue
                if name in cat.get('stat_lists', {}):
                    stat_map = cat['stat_lists'][name]
                    entries = []
                    for source_var, stat in stat_map['stats'].items():
                        number = define_value_number(rw.resolve(path, source_var))
                        if number is not None and number != stat_map['default']:
                            entries.append(f'{stat} = {number}')
                    if entries:
                        block.append(f'\t{name} = list(' + ', '.join(entries) + ')')
                    continue
                if name in cat.get('string_lists', []):
                    entries = string_list(value)
                    if entries:
                        block.append(f'\t{name} = list(' + ', '.join(entries) + ')')
                    continue
                if name in cat.get('string_define_vars', []):
                    expanded = expand_define(value)
                    if STRING_LITERAL.match(expanded):
                        block.append(f'\t{name} = {expanded}')
                    continue
                if name in cat.get('sound_lists', []):
                    refs = [ref for ref in (sound_ref(f"'{f}'") for f in sound_files(value)) if ref]
                    if refs:
                        block.append(f'\t{name} = list(' + ', '.join(refs) + ')')
                    continue
                if name == 'rogue_armor':
                    armor = rogue_armor_value(rw.resolve(path, 'armor'))
                    if armor:
                        block.append(f'\trogue_armor = {armor}')
                    continue
                if name in cat.get('flag_vars', []):
                    if value is not None:
                        kept = [token for token in re.findall(r'[A-Z_][A-Z0-9_]*', value) if token in tg_names]
                        block.append(f'\t{name} = ' + (' | '.join(kept) if kept else 'NONE'))
                    continue
                if name in cat.get('paths', []):
                    target = runtime_path(value.strip(), rules) if value and value.strip().startswith('/') else None
                    if target in valid:
                        block.append(f'\t{name} = {target}')
                    continue
                if name in cat.get('path_lists', []):
                    entries = [runtime_path(p, rules) for p, _ in list_paths(value)]
                    entries = [p for p in entries if p in valid]
                    if entries:
                        block.append(f'\t{name} = list(' + ', '.join(entries) + ')')
                    continue
                if name in cat.get('true_only', []):
                    if value and value.strip() == 'TRUE':
                        block.append(f'\t{name} = TRUE')
                    continue
                if name == 'slot_flags':
                    flags = slot_flags_value(value)
                    if flags:
                        block.append(f'\tslot_flags = {flags}')
                    continue
                if name == 'armor_type':
                    armor = armor_type_value(rw.resolve(path, 'armor'), port['armor'], armor_wear(path, coverage_value(rw.resolve(path, 'body_parts_covered'))))
                    if armor:
                        block.append(f'\tarmor_type = {armor}')
                    continue
                if name == 'body_parts_covered':
                    covered = coverage_value(value)
                    if covered:
                        block.append(f'\tbody_parts_covered = {covered}')
                    continue
                if name == 'loot':
                    entries = [(item, weight) for item, weight in loot_entries(value) if item in valid]
                    if entries:
                        block += ['\tloot = list('] + [f'\t\t{item} = {weight},' for item, weight in entries] + ['\t\t)']
                    continue
                if name == 'worn_icon' and (not value or value.strip() == 'null'):
                    value = slot_worn_icon(path, cat.get('slot_worn_icons', {}).get(name, {})) or value
                if value and ICON_LITERAL.match(value.strip()):
                    value = icon_ref(value)
                else:
                    value = literal(value, tg_names)
                if value is None or cat.get('value_defaults', {}).get(name) == value:
                    continue
                block.append(f'\t{name} = {value}')
            own_worn = rw.resolve(path, cat.get('rename', {}).get('worn_icon', 'worn_icon'))
            for name, slot_sheets in cat.get('slot_worn_icons', {}).items():
                if name in cat['vars'] or (own_worn and own_worn.strip() != 'null'):
                    continue
                sheet = slot_worn_icon(path, slot_sheets)
                if sheet:
                    block.append(f'\t{name} = {icon_ref(sheet)}')
            if cat.get('sprite_checks'):
                fix_sprites(path, block)
            if cat.get('bake') and port.get('bake'):
                bake_onmob(path, block, port['bake'])
            if cat.get('runtime_look') and not smooth:
                look = runtime_look(rw, path)
                kind, data = look.get('icon', (None, None))
                if kind == 'state':
                    block = [line for line in block if not line.startswith('\ticon_state = ')]
                    block.append(f'\ticon_state = "{data}"')
                elif kind == 'variant':
                    current, prefix, suffix, low, high = data
                    if current:
                        prefix = (rw.resolve(path, 'icon_state') or '').strip().strip('"') + prefix
                    block += [f'\trockhill_variant = "{prefix}#{suffix}"', f'\trockhill_variant_min = {low}', f'\trockhill_variant_max = {high}']
                if look.get('dir'):
                    block.append('\trockhill_random_dir = TRUE')
            if cat.get('random_pick'):
                picks = [target for target in (runtime_path(found, rules) for found in random_pick(rw, path)) if target in valid]
                if picks:
                    block.append('\trockhill_random_pick = list(' + ', '.join(picks) + ')')
            for name, value in cat.get('fixed_vars', {}).items():
                block.append(f'\t{name} = {value}')
            if cat.get('grid_storage'):
                block += grid_storage_lines(path)
            for name, source_name in cat.get('sound_vars', {}).items():
                files = [f for f in sound_files(rw.resolve(path, source_name)) if os.path.exists(os.path.join(CHECKOUT, f))]
                listed = ', '.join(f'"{runtime_sound(f, cat["runtime_sounds"])}"' for f in files)
                block.append(f'\t{name} = ' + (f'list({listed})' if files else 'null'))
            if cat.get('placement'):
                block += placement_lines(rw, path, path, tg_values)
            for prefix, names in cat.get('type_vars', {}).items():
                if boundary_match(path, prefix):
                    for name in names:
                        raw = rw.resolve(path, name)
                        value = literal(raw, tg_names)
                        if value is None and (raw or '').strip().startswith('list('):
                            pairs = [(p, n) for p, n in re.findall(r'(/[a-z][A-Za-z0-9_/]+)\s*=\s*(-?\d+(?:\.\d+)?)', raw) if p in valid]
                            value = 'list(' + ', '.join(f'{p} = {n}' for p, n in pairs) + ')' if pairs else None
                        if value is not None:
                            block.append(f'\t{name} = {value}')
            if cat.get('init_overlays'):
                overlay = init_overlay(rw, path)
                if overlay:
                    block.append(f'\trockhill_overlay = "{overlay}"')
            if smooth:
                block += smooth
                smoothed['bitmask'] += 1
            else:
                block += group_lines(path)
                if cat.get('smoothing') and edge_receiver(path):
                    block.append('\tsmoothing_flags = SMOOTH_BITMASK_CARDINALS')
                    edge_sources[path] = smooth_targets(path)
                    smoothed['edges'] += 1
            blocks.append(block)
            if cat.get('sunlit'):
                blocks.append([f'{path}/{SUNLIT_LEAF}', '\trockhill_sunlit = TRUE', '\tbase_lighting_alpha = 255', '\tbase_lighting_color = COLOR_STARLIGHT'])
                if (rw.resolve(path, 'outdoors') or '').strip() in ('TRUE', '1'):
                    outdoor_areas.append(path)
            report_rows[cat['file']].append((path, usage[path]))
        text = '\n\n'.join('\n'.join(b) for b in blocks) + '\n'
        open(f"{OUT_DIR}/{cat['file']}", 'w', encoding='utf-8', newline='\n').write(text)
        print(f"{cat['file']}: {len(paths)} types")

    if grid_spec:
        generate_grid_storage(rw, grid_spec, grid_used, tg_names, valid, rules)
    if port.get('dungeon_templates'):
        generate_dungeon_templates(rw, port['dungeon_templates'], tg_names)

    rogue_armor_lines = []
    for path, fields in sorted(ROGUE_ARMOR_DATUMS.items()):
        rogue_armor_lines += [path] + [f'\t{k} = {v}' for k, v in fields.items() if v] + ['']
    open(f'{OUT_DIR}/rogue_armor.dm', 'w', encoding='utf-8', newline='\n').write('\n'.join(rogue_armor_lines).rstrip() + '\n')
    print(f'rogue_armor.dm: {len(ROGUE_ARMOR_DATUMS)} armor datums')
    generate_alt_grips(rw, port.get('alt_grips', {}), sorted(grip_paths))
    generate_intents(rw, port.get('intents', {}), sound_ref, valid)

    armor_lines = []
    for path, fields in sorted(ARMOR_DATUMS.items()):
        armor_lines += [path] + [f'\t{k} = {v}' for k, v in fields.items() if v] + ['']
    open(f'{OUT_DIR}/armor.dm', 'w', encoding='utf-8', newline='\n').write('\n'.join(armor_lines).rstrip() + '\n')
    print(f'armor.dm: {len(ARMOR_DATUMS)} armor datums')

    reskin_blocks = []
    for path in reskins:
        target = runtime[path]
        block = [target]
        if path in declared:
            block.append(f'\tparent_type = {path}')
        for name, value in port.get('reskin_vars', {}).items():
            block.append(f'\t{name} = {value}')
        for name in ('name', 'desc'):
            value = literal(rw.resolve(path, name), tg_names)
            if value is not None:
                block.append(f'\t{name} = {value}')
        raw_icon = rw.resolve(path, 'icon')
        smooth = smoothing_lines(path)
        if smooth:
            block += smooth
            smoothed['bitmask'] += 1
        else:
            icon = icon_ref(raw_icon) if raw_icon else None
            state = literal(rw.resolve(path, 'icon_state'), tg_names)
            if icon:
                block.append(f'\ticon = {icon}')
            if state:
                block.append(f'\ticon_state = {state}')
            block += group_lines(target) or ['\tsmoothing_groups = null']
            block.append('\tcanSmoothWith = null')
            if edge_receiver(path):
                block.append('\tsmoothing_flags = SMOOTH_BITMASK_CARDINALS')
                edge_sources[target] = smooth_targets(path)
                smoothed['edges'] += 1
            else:
                block.append('\tsmoothing_flags = NONE')
        reskin_blocks.append(block)
        report_rows['turfs_reskin.dm'].append((path, usage[path]))
    open(f'{OUT_DIR}/turfs_reskin.dm', 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in reskin_blocks) + '\n')
    print(f'turfs_reskin.dm: {len(reskin_blocks)} types')


    for rel in port.get('extra_sounds', []):
        if not sound_ref(f"'{rel}'"):
            raise SystemExit(f'extra_sounds: {rel} is missing from the Ratwood checkout or not licensed')

    ported = set(generated)
    rebased = collections.defaultdict(list)
    for path in sorted(usage):
        rule = replacement_for(path, rules) or {}
        spec = rule.get('port')
        if not rule.get('rebase') or not spec:
            continue
        block = [runtime_path(path, rules)]
        for name in spec['vars']:
            if name == 'layer' and spec.get('placement'):
                continue
            value = rw.resolve(path, name)
            if name in spec.get('path_strings', []):
                entries = [p for p, _ in list_paths(value)]
                value = ('list(' + ', '.join(f'"{p}"' for p in entries) + ')') if entries else None
            elif name in spec.get('ported_paths', []):
                raw = (value or '').strip()
                target = runtime_path(raw, rules) if raw.startswith('/') else None
                value = 'null' if raw == 'null' else (target if target in ported else None)
            elif name in spec.get('paths', []):
                target = runtime_path(value.strip(), rules) if value and value.strip().startswith('/') else None
                value = target if target in valid or target in jobs else None
            elif name in spec.get('define_strings', []):
                expanded = expand_define(value)
                value = expanded if expanded and STRING_LITERAL.match(expanded) else None
            elif name in spec.get('string_lists', []):
                entries = re.findall(r'"((?:[^"\\]|\\.)*)"', value or '')
                value = ('list(' + ', '.join(f'"{entry}"' for entry in entries) + ')') if entries else None
            elif name in spec.get('sounds', []) and value and ICON_LITERAL.match(value.strip()):
                value = sound_ref(value)
            elif value and ICON_LITERAL.match(value.strip()):
                value = icon_ref(value)
            else:
                value = literal(value, tg_names)
            if value is not None:
                block.append(f'\t{name} = {value}')
        if spec.get('runtime_look'):
            look = runtime_look(rw, path)
            kind, data = look.get('icon', (None, None))
            if kind == 'state':
                block = [line for line in block if not line.startswith('\ticon_state = ')] + [f'\ticon_state = "{data}"']
            elif kind == 'variant':
                current, prefix, suffix, low, high = data
                if current:
                    prefix = (rw.resolve(path, 'icon_state') or '').strip().strip('"') + prefix
                block += [f'\trockhill_variant = "{prefix}#{suffix}"', f'\trockhill_variant_min = {low}', f'\trockhill_variant_max = {high}']
            if look.get('dir'):
                block.append('\trockhill_random_dir = TRUE')
        if spec.get('placement'):
            block += placement_lines(rw, path, block[0], tg_values)
        if spec.get('fill'):
            contents, loot, chance = closet_fill(rw, path)
            contents = [p for p in (runtime_path(c, rules) for c in contents) if p in valid]
            loot = [(p, w) for p, w in ((runtime_path(i, rules), w) for i, w in loot) if p in valid]
            if contents:
                block.append('\trockhill_contents = list(' + ', '.join(contents) + ')')
            if loot:
                block += ['\trockhill_loot = list('] + [f'\t\t{p} = {w},' for p, w in loot] + ['\t\t)']
                if chance != 100:
                    block.append(f'\trockhill_loot_chance = {chance}')
        rebased[spec['file']].append(block)
        report_rows.setdefault(spec['file'], []).append((path, usage[path]))
        generated.add(block[0])
    state_blocks = []
    for path, variants in sorted(state_variants.items()):
        for variant in sorted(variants):
            state = next(state for p, state in state_edits if p == path and variant.endswith('/' + state_leaf(state)))
            state_blocks.append([variant, f'\ticon_state = "{state}"', '\trockhill_variant = null'])
    open(f'{OUT_DIR}/turf_states.dm', 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in state_blocks) + '\n')
    print(f'turf_states.dm: {len(state_blocks)} turf subtypes for map icon_state edits')

    for file, blocks in rebased.items():
        open(f'{OUT_DIR}/{file}', 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
        print(f'{file}: {len(blocks)} rebased types')

    smoothing_out = [f'#define {group_defines[o]} {"S_TURF" if group_numbers[o] >= 0 else "S_OBJ"}({abs(group_numbers[o])})' for o in sorted(owners, key=lambda o: group_numbers[o])]
    for owner in sorted(owners - grouped):
        smoothing_out += ['', owner, f'\tsmoothing_groups = {group_defines[owner]}']
    open(f'{OUT_DIR}/{SMOOTHING_FILE}', 'w', encoding='utf-8', newline='\n').write('\n'.join(smoothing_out) + '\n')
    print(f'{SMOOTHING_FILE}: {len(owners)} smoothing groups, {len(owners - grouped)} set on types declared elsewhere')
    open(f'{OUT_DIR}/{AREAS_JSON}', 'w', encoding='utf-8', newline='\n').write(json.dumps({'sunlit': SUNLIT_LEAF, 'outdoors': sorted(outdoor_areas)}, indent='\t') + '\n')

    for rel in port.get('extra_icons', []):
        found = sorted(glob.glob(os.path.join(CHECKOUT, rel))) if any(c in rel for c in '*?[') else [os.path.join(CHECKOUT, rel)]
        for source in found:
            icons[source] = icon_dest(os.path.relpath(source, CHECKOUT).replace(os.sep, '/'))

    edge_lines = []
    for name in ('rockhill_turf_edges', 'rockhill_turf_edge_overrides', 'rockhill_turf_edge_sources'):
        edge_lines.append(f'GLOBAL_LIST_INIT({name}, {name}())')
    edge_lines += ['', '/proc/rockhill_turf_edges()', '\treturn list(']
    edge_lines += [f'\t\t{p} = {s},' for p, s in sorted(edge_states.items())]
    edge_lines += ['\t\t)', '', '/proc/rockhill_turf_edge_overrides()', '\treturn list(']
    edge_lines += [f'\t\t{p} = {s},' for p, s in sorted(edge_overrides.items())]
    edge_lines += ['\t\t)', '', '/proc/rockhill_turf_edge_sources()', '\treturn list(']
    for p, sources in sorted(edge_sources.items()):
        edge_lines.append(f'\t\t{p} = list(')
        edge_lines += [f'\t\t\t{s},' for s in sorted(set(sources))]
        edge_lines.append('\t\t\t),')
    edge_lines.append('\t\t)')
    open(f'{OUT_DIR}/{EDGES_FILE}', 'w', encoding='utf-8', newline='\n').write('\n'.join(edge_lines) + '\n')
    print(f"smoothing: {smoothed['bitmask']} bitmask types from {sum(1 for v in sheets.values() if v)} sheets, {smoothed['edges']} edge receivers, {len(edge_states)} edge sources")

    if UNREVIEWED:
        raise SystemExit('assets under a licence nobody has reviewed; add each licence to port.assets.reviewed_licenses or restricted_licenses in ' + CONFIG + ':\n  ' + '\n  '.join(f'{license}: {len(files)} file(s), e.g. {sorted(files)[0]}' for license, files in sorted(UNREVIEWED.items())))
    for license in port.get('assets', {}).get('restricted_licenses', []):
        folder = os.path.dirname(license)
        copied = f"{ICON_DIR}/{folder[len('icons/'):] if folder.startswith('icons/') else folder}"
        if os.path.isdir(copied):
            shutil.rmtree(copied)
            print('removed restricted copies:', copied)
    if BLANK_USERS:
        os.makedirs(os.path.dirname(BLANK_WORN), exist_ok=True)
        dmi.write(BLANK_WORN, 32, 32, [('', bytes(32 * 32 * 4))])
        print(f'blank worn sheet: {len(BLANK_USERS)} wearables without a worn sprite')
    print(f'female worn sprites: {len(FEMALE_USERS)} wearables')
    for src, dest in list(icons.items()) + list(sounds.items()):
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copyfile(src, dest)
    for src, dest in runtime_sounds.items():
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copyfile(src, dest)
    extra_files = port.get('extra_files', {})
    fetch_sources(list(extra_files))
    for rel, dest in extra_files.items():
        src = os.path.join(CHECKOUT, rel)
        if not os.path.exists(src):
            raise SystemExit(f'extra_files: {rel} is missing from the Ratwood checkout')
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copyfile(src, dest)
    print('extra files copied:', len(extra_files))
    for root in {cat['runtime_sounds'] for cat in categories if cat.get('runtime_sounds')}:
        os.makedirs(root, exist_ok=True)
        open(f'{root}/.gitignore', 'w', encoding='utf-8', newline='\n').write('*\n!.gitignore\n')
    print('icons copied:', len(icons), 'bytes:', sum(os.path.getsize(d) for d in icons.values()))
    print('runtime sounds copied:', len(runtime_sounds), 'bytes:', sum(os.path.getsize(d) for d in runtime_sounds.values()))
    print('sounds copied:', len(sounds))

    with open(REPORT, 'w', encoding='utf-8', newline='\n') as out:
        out.write('# Ported Ratwood content\n\n')
        out.write('Generated by `modular_redtard/tools/port_rockhill.py` from the Ratwood-2.0 code tree and the Rockhill map. ')
        out.write('Each type keeps its Ratwood path, so the map loads it unchanged; `parent_type` grafts the Ratwood branch onto a TG or module base. ')
        out.write('Re-run the tool after the map gains new types (the map generator fails on a missing turf or area and warns on a missing object).\n\n')
        if SOURCE_REVISION:
            out.write(f'Ratwood revision: `{SOURCE_REVISION[0]}` ({SOURCE_REVISION[1]}).\n\n')
        for file in [cat['file'] for cat in categories] + ['turfs_reskin.dm']:
            rows = report_rows.get(file, [])
            if not rows:
                continue
            out.write(f"## {file} ({len(rows)} types)\n\n| Type | Tiles |\n|---|---|\n")
            for path, count in sorted(rows, key=lambda r: -r[1]):
                out.write(f'| `{path}` | {count} |\n')
            out.write('\n')
        out.write(f'## Not ported ({len(skipped)} types, dropped from the map)\n\n| Type | Tiles |\n|---|---|\n')
        for path, count in skipped.most_common():
            out.write(f'| `{path}` | {count} |\n')
        out.write('\n## Icons\n\n')
        for src, dest in sorted(icons.items(), key=lambda kv: kv[1]):
            rel = os.path.relpath(src, CHECKOUT).replace('\\', '/')
            out.write(f'- `{dest}` from Ratwood `{rel}`\n')
        if RESTRICTED:
            out.write('\n## Restricted assets (not copied)\n\n')
            out.write('Their folder carries a proprietary licence that forbids redistribution and use outside Ratwood (`port.assets.restricted_licenses`). The port never copies them; the types that use them get no sprite.\n\n')
            for license, users in sorted(RESTRICTED.items()):
                out.write(f'- `{license}`: {", ".join(f"`{user}`" for user in sorted(users))}\n')
        if NO_SPRITE:
            out.write(f'\n## Items without a world sprite ({len(NO_SPRITE)})\n\n')
            out.write('Ratwood names an `icon_state` its sheet does not have (a sprite chosen at runtime, or a broken one). The port writes `icon_state = null`, as TG does for an item with no sprite, so the TG icon tests pass and the item stays listed here.\n\n| Type | Sheet | Missing state |\n|---|---|---|\n')
            for path, sheet, state in sorted(NO_SPRITE):
                out.write(f'| `{path}` | `{sheet}` | `{state}` |\n')
        if BLANK_USERS:
            out.write(f'\n## Wearables without a worn sprite ({len(BLANK_USERS)})\n\n')
            out.write(f'No sheet holds their worn state: `worn_icon = \'{BLANK_WORN}\'` (one empty state) and `worn_icon_state = null`, the TG way to say "no worn sprite".\n\n')
            for path in sorted(BLANK_USERS):
                out.write(f'- `{path}`\n')
        if extra_files:
            out.write('\n## Files\n\n')
            for rel, dest in sorted(extra_files.items(), key=lambda kv: kv[1]):
                out.write(f'- `{dest}` from Ratwood `{rel}`\n')
        if runtime_sounds:
            out.write('\n## Runtime sounds (not committed)\n\n')
            out.write('Area music and ambience are copied into a folder git ignores and are read from disk at runtime; part of the music is third-party commercial tracks (see Ratwood `sound/music/credits.txt`), so the repository does not redistribute them. A missing file is skipped.\n\n')
            for src, dest in sorted(runtime_sounds.items(), key=lambda kv: kv[1]):
                rel = os.path.relpath(src, CHECKOUT).replace('\\', '/')
                out.write(f'- `{dest}` from Ratwood `{rel}`\n')
        if sounds:
            out.write('\n## Sounds\n\n')
            for src, dest in sorted(sounds.items(), key=lambda kv: kv[1]):
                rel = os.path.relpath(src, CHECKOUT).replace('\\', '/')
                out.write(f'- `{dest}` from Ratwood `{rel}`\n')
    if port.get('bake'):
        write_bake_manifest(port['bake'])
    print('report:', REPORT, 'skipped types:', len(skipped))
    return generated


SOUND_LITERAL = re.compile(r"'(sound/[^']+?\.(?:ogg|wav|mp3))'")


def sound_files(raw):
    text = raw or ''
    for _ in range(8):
        names = [name for name in set(re.findall(r'\b[A-Z_][A-Z0-9_]*\b', text)) if name in DEFINE_VALUES]
        if not names:
            break
        for name in names:
            text = re.sub(rf'\b{name}\b', lambda _match, value=DEFINE_VALUES[name]: value, text)
    return SOUND_LITERAL.findall(text)


def fetch_sources(paths):
    absent = sorted({p for p in paths if not os.path.exists(os.path.join(CHECKOUT, p))})
    if absent:
        git('sparse-checkout', 'add', *('/' + p for p in absent))
        git('read-tree', '-mu', 'HEAD')
    missing = [p for p in absent if not os.path.exists(os.path.join(CHECKOUT, p))]
    if missing:
        print('runtime sounds missing from Ratwood:', ', '.join(missing))


def held_paths(body):
    text = '\n'.join(body)
    found = HOLD_LIST.search(text)
    if not found:
        return None
    depth = 1
    k = found.end()
    while k < len(text) and depth:
        depth += {'(': 1, ')': -1}.get(text[k], 0)
        k += 1
    return re.findall(r'/[A-Za-z0-9_]+(?:/[A-Za-z0-9_]+)*', text[found.end():k - 1])


def generate_grid_storage(rw, spec, used, tg_names, valid, rules):
    root = spec['from']
    chain = set()
    for component in used:
        p = component
        while p and boundary_match(p, root):
            chain.add(p)
            p = rw.parent(p)
    blocks = []
    holders = 0
    for component in sorted(chain, key=lambda p: (p.count('/'), p)):
        target = spec['to'] + component[len(root):]
        block = [target]
        for name, source in spec['vars'].items():
            raw = rw.resolve(component, source) if component == root else rw.types.get(component, {}).get(source)
            value = literal(raw, tg_names)
            if value is not None:
                block.append(f'\t{name} = {value}')
        blocks.append(block)
        held = held_paths(STORAGE_NEW.get(component, []))
        if held is not None:
            kept = sorted({runtime_path(p, rules) for p in held} & valid)
            blocks.append([f'{target}/New()', '\t. = ..()', '\tset_holdable(list(' + ', '.join(kept) + '))'])
            holders += 1
    open(f'{OUT_DIR}/{spec["file"]}', 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
    print(f'{spec["file"]}: {len(chain)} grid storages, {holders} with a can-hold list')


def icon_dest(rel):
    return f"{ICON_DIR}/{rel[len('icons/'):] if rel.startswith('icons/') else rel}"


JOB_ROOT = '/datum/job/roguetown'
ADVCLASS_ROOT = '/datum/advclass'
ADVCLASS_TARGET = '/datum/rockhill_advclass'
ADVCLASS_OUTFIT = '/datum/outfit/job/roguetown/rockhill_class'
ADVCLASS_SHEET = '/datum/attribute_holder/sheet/job/rockhill_class'
ADVCLASS_FILE = 'advclasses.dm'
LANDMARK_ROOT = '/obj/effect/landmark/start'
LANDMARK_REBASE = '/obj/effect/landmark/start/rockhill'


def string_value(raw):
    if raw is None:
        return None
    v = raw.strip()
    if STRING_LITERAL.match(v):
        return tg_spelling(v)
    return None


def number_value(raw):
    if raw is None or not NUMBER.match(raw.strip()):
        return None
    return int(float(raw.strip()))


def define_name(title):
    return 'JOB_ROCKHILL_' + re.sub(r'[^A-Z0-9]+', '_', title.upper()).strip('_')


def tg_job_titles():
    titles = set()
    for line in open('code/__DEFINES/jobs.dm', encoding='utf-8', errors='ignore'):
        m = re.match(r'^#define JOB_[A-Z0-9_]+\s+"([^"]+)"', line)
        if m:
            titles.add(m.group(1))
    return titles


def map_adjustment(path):
    text = strip_comments(open(path, encoding='utf-8', errors='ignore').read())
    def block(name):
        m = re.search(name + r'\s*=\s*list\(', text)
        if not m:
            return ''
        depth = 1
        i = m.end()
        while i < len(text) and depth:
            depth += {'(': 1, ')': -1}.get(text[i], 0)
            i += 1
        return text[m.end():i - 1]
    blacklist = set(re.findall(r'(/datum/job/roguetown/[\w/]+)', block('blacklist')))
    slots = {p: int(n) for p, n in re.findall(r'(/datum/job/roguetown/[\w/]+)\s*=\s*(\d+)', block('slot_adjust'))}
    titles = {}
    for p, body in re.findall(r'(/datum/job/roguetown/[\w/]+)\s*=\s*list\(([^)]*)\)', block('title_adjust')):
        titles[p] = re.findall(r'"([^"]+)"', body)
    return blacklist, slots, titles


def expand_define(raw):
    value = (raw or '').strip()
    for _ in range(8):
        if re.match(r'^[A-Z_][A-Z0-9_]*$', value) and value in DEFINE_VALUES:
            value = DEFINE_VALUES[value].strip()
        else:
            break
    return value


def coverage_value(raw):
    tokens = set()
    stack = re.findall(r'[A-Z_][A-Z0-9_]*', raw or '')
    seen = set()
    while stack:
        token = stack.pop()
        if token in seen:
            continue
        seen.add(token)
        value = DEFINE_VALUES.get(token, '')
        if value and not re.match(r'^\(?\s*1\s*<<', value) and re.search(r'[A-Z]', value):
            stack += re.findall(r'[A-Z_][A-Z0-9_]*', value)
            continue
        if token in COVERAGE_MAP:
            tokens.add(COVERAGE_MAP[token])
    return '|'.join(sorted(tokens)) if tokens else None


def armor_wear(path, coverage):
    if boundary_match(path, '/obj/item/clothing/under'):
        return 'under'
    for root, (wear, extremity) in WEAR_COVERAGE.items():
        if boundary_match(path, root) and set((coverage or '|'.join(extremity)).split('|')) == extremity:
            return wear
    return None


def armor_numbers(raw):
    """Ratings of a Ratwood armor list; values may be numbers or tier defines (ARMOR_PLATE -> list("blunt" = DR_LIGHT, ...))."""
    value = expand_define(raw)
    numbers = {}
    for key, token in re.findall(r'"(\w+)"\s*=\s*([A-Za-z0-9_.\-]+)', value or ''):
        number = define_value_number(token)
        if number is not None:
            numbers[key] = float(number)
    return numbers


def armor_type_value(raw, armor_cfg, wear=None):
    numbers = armor_numbers(raw)
    if not numbers:
        return None
    tiers = max(numbers.values()) <= armor_cfg.get('max_tier', 5)
    scale, cap = armor_cfg['scale'], armor_cfg['cap']
    def scaled(n):
        if tiers:
            # Ratwood DR tiers: damage * 1 / (1 + coefficient * tier) reaches the body; TG armor is the percent stopped.
            return int(round(100 * (1 - 1 / (1 + armor_cfg['dr_coefficient'] * max(n, 0)))))
        return int(round(min(max(n, 0) * scale, cap)))
    fields = {
        'fire': scaled(numbers.get('fire', 0)),
        'acid': scaled(numbers.get('acid', 0)),
    }
    if not any(fields.values()):
        return None
    name = (raw or '').strip()
    if re.match(r'^ARMOR_[A-Z0-9_]+$', name):
        leaf = 'rockhill_' + name[len('ARMOR_'):].lower()
    else:
        leaf = 'rockhill_f{fire}_a{acid}'.format(**fields)
    if wear in ('hands', 'feet'):
        leaf += '_' + wear
    path = ('/datum/armor/clothing_under/' if wear == 'under' else '/datum/armor/') + leaf
    ARMOR_DATUMS[path] = fields
    return path


def rogue_armor_value(raw):
    numbers = {k: int(n) for k, n in armor_numbers(raw).items()}
    fields = OrderedDict((k, max(0, numbers.get(k, 0))) for k in ('blunt', 'slash', 'stab', 'piercing', 'fire', 'acid', 'magic'))
    if not any(fields.values()):
        return None
    name = (raw or '').strip()
    if re.match(r'^ARMOR_[A-Z0-9_]+$', name):
        leaf = name[len('ARMOR_'):].lower()
    else:
        leaf = 'b{blunt}_s{slash}_t{stab}_p{piercing}_f{fire}_a{acid}'.format(**fields)
    path = '/datum/rogue_armor/' + leaf
    ROGUE_ARMOR_DATUMS[path] = fields
    return path


def define_value_number(raw):
    if raw is None:
        return None
    value = expand_define(raw.strip())
    for _ in range(4):
        stripped = value.strip()
        if stripped.startswith('(') and stripped.endswith(')'):
            value = expand_define(stripped[1:-1])
        else:
            break
    value = value.strip()
    if not NUMBER.match(value):
        return None
    number = float(value)
    return int(number) if number == int(number) else number


def alt_grip_paths(rw, raw):
    """Grip datums of a Ratwood item's alt_grips, a list or a define such as LONGSWORD_STOCK_ALT_GRIPS."""
    out = []
    for path in re.findall(r'/datum/alt_grip[A-Za-z0-9_/]*', expand_define(raw or '')):
        path = path.rstrip('/')
        if path in rw.types and path not in out:
            out.append(path)
    return out


def assigned_numbers(raw):
    """"key" = value pairs of a list literal, values turned into numbers through the defines."""
    out = OrderedDict()
    for key, token in re.findall(r'"(\w+)"\s*=\s*([A-Za-z0-9_.\-]+)', raw or ''):
        number = define_value_number(token)
        if number is not None:
            out[key] = number
    return out


def generate_alt_grips(rw, spec, grips):
    """Alternate grips of Azure Peak as Ratwood has them (alt_grip.dm): name, two hands, skill rank, traits, intents, on-hand pose, stat changes."""
    blocks = []
    for path in grips:
        block = [path]
        name = string_value(rw.resolve(path, 'name'))
        if name:
            block.append(f'\tname = {name}')
        if (rw.resolve(path, 'two_handed') or '').strip() in ('TRUE', '1'):
            block.append('\ttwo_handed = TRUE')
        rank = define_value_number(rw.resolve(path, 'skill_req'))
        if rank:
            block.append(f'\tskill_rank = {rank}')
        traits = [t for t in re.findall(r'TRAIT_[A-Z0-9_]+', rw.resolve(path, 'trait_applied') or '') if t in DEFINE_VALUES]
        if traits:
            block.append('\ttrait_applied = list(' + ', '.join(traits) + ')')
        intents = intent_paths(rw, rw.resolve(path, 'grip_intents'))
        if intents:
            USED_INTENTS.update(intents)
            block.append('\tgrip_intents = list(' + ', '.join(intents) + ')')
        if re.search(r'"altgrip"\s*=\s*list\(', rw.resolve(path, 'onmobprop_overrides') or ''):
            block.append(f'\tinhand_suffix = "_{path.rsplit("/", 1)[1]}"')
        for source_name in spec.get('stat_vars', ['var_overrides', 'additive_var_overrides']):
            numbers = assigned_numbers(rw.resolve(path, source_name))
            if numbers:
                block.append(f'\t{source_name} = list(' + ', '.join(f'"{k}" = {v}' for k, v in numbers.items()) + ')')
        blocks.append(block)
    open(f"{OUT_DIR}/{spec.get('file', 'alt_grips.dm')}", 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
    print(f"{spec.get('file', 'alt_grips.dm')}: {len(blocks)} alternate grips")


def intent_paths(rw, raw):
    out = []
    for token in re.findall(r'(/datum/intent[A-Za-z0-9_/]*|[A-Z_][A-Z0-9_]*)', raw or ''):
        path = token if token.startswith('/') else expand_define(token)
        if path.startswith('/datum/intent') and path in rw.types and path not in out:
            out.append(path)
    return out


def skill_target(cfg, raw):
    spec = cfg['attributes']
    path = (raw or '').strip()
    if path in spec['meta']:
        return spec['skill_target'] + path[len(spec['skill_root']):]
    return None


def string_list(raw):
    out = []
    for token in re.findall(r'"(?:[^"\\]|\\.)*"|[A-Z_][A-Z0-9_]*', raw or ''):
        value = token if token.startswith('"') else expand_define(token)
        if STRING_LITERAL.match(value) and value not in out:
            out.append(value)
    return out


def intent_effect_lines(rw, path, spec):
    """The status effect a Ratwood effect intent puts on a hit (intent_effect, target_parts) as data: name, stat changes, duration, zones."""
    effect = (rw.resolve(path, 'intent_effect') or '').strip()
    if not effect.startswith('/datum/status_effect') or effect not in rw.types:
        return []
    stats = [f"{spec['stats'][key]} = {value}" for key, value in re.findall(r'(STATKEY_[A-Z]+)\s*=\s*(-?[\d.]+)', rw.resolve(effect, 'effectedstats') or '') if key in spec['stats']]
    if not stats:
        return []
    lines = ['\teffect_stats = list(' + ', '.join(stats) + ')']
    raw_duration = (rw.resolve(effect, 'duration') or '').strip()
    seconds = re.fullmatch(r'([\d.]+)\s*SECONDS', raw_duration)
    duration = float(seconds.group(1)) * 10 if seconds else define_value_number(raw_duration)
    if duration:
        lines.append(f'\teffect_duration = {int(duration) if duration == int(duration) else duration}')
    alert = (rw.resolve(effect, 'alert_type') or '').strip()
    name = string_value(rw.resolve(alert, 'name')) if alert in rw.types else None
    if name:
        lines.append(f'\teffect_name = {name}')
    zones = [expand_define(token) for token in re.findall(r'BODY_ZONE_[A-Z_]+', rw.resolve(path, 'target_parts') or '')]
    zones = [zone for zone in zones if STRING_LITERAL.match(zone)]
    if zones:
        lines.append('\teffect_zones = list(' + ', '.join(zones) + ')')
    return lines


def generate_intents(rw, spec, sound_ref, valid=frozenset()):
    renames = spec.get('rename', {})
    numeric = spec.get('numeric', [])
    flags = spec.get('flags', [])
    strings = spec.get('strings', [])
    blocks = []
    fetch_sources([f for path in USED_INTENTS for f in sound_files(rw.resolve(path, 'hitsound'))])
    for path in sorted(USED_INTENTS):
        block = [path]
        for name in strings:
            value = string_value(rw.resolve(path, renames.get(name, name)))
            if value is None:
                value = expand_define(rw.resolve(path, renames.get(name, name)) or '')
                value = value if STRING_LITERAL.match(value) else None
            if value is not None and not (value == '""' and name in spec.get('strings_skip_empty', [])):
                block.append(f'\t{name} = {value}')
        verbs = string_list(rw.resolve(path, 'attack_verb'))
        if verbs:
            block.append('\tattack_verb = list(' + ', '.join(verbs) + ')')
        defaults = spec.get('numeric_defaults', {})
        for name in numeric:
            number = define_value_number(rw.resolve(path, renames.get(name, name)))
            if number is not None and (name not in defaults or number != defaults[name]):
                block.append(f'\t{name} = {number}')
        true_only = spec.get('flags_true_only', [])
        for name in flags:
            value = (rw.resolve(path, renames.get(name, name)) or '').strip()
            if value in ('TRUE', 'FALSE', '0', '1'):
                if name in true_only and value not in ('TRUE', '1'):
                    continue
                block.append(f"\t{name} = {'TRUE' if value in ('TRUE', '1') else 'FALSE'}")
        for name in spec.get('paths', []):
            raw = (rw.resolve(path, name) or '').strip()
            if raw.startswith('/') and raw in valid:
                block.append(f'\t{name} = {raw}')
        if spec.get('effects'):
            block += intent_effect_lines(rw, path, spec['effects'])
        sounds = sound_files(rw.resolve(path, 'hitsound'))
        refs = [ref for ref in (sound_ref(f"'{f}'") for f in sounds) if ref]
        if refs:
            block.append('\thitsound = list(' + ', '.join(refs) + ')')
        blocks.append(block)
    open(f"{OUT_DIR}/{spec.get('file', 'intents.dm')}", 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
    print(f"{spec.get('file', 'intents.dm')}: {len(blocks)} intents")


def slot_flags_value(raw):
    if not raw:
        return None
    mapped = sorted({SLOT_FLAG_MAP[t] for t in re.findall(r'ITEM_SLOT_[A-Z_]+', raw) if t in SLOT_FLAG_MAP})
    return '|'.join(mapped) if mapped else None


def masculine(text):
    return 'should_wear_masc_clothes' in text or re.search(r'gender\s*==\s*MALE\b', text) is not None


def feminine(text):
    return 'should_wear_femme_clothes' in text or re.search(r'gender\s*==\s*FEMALE\b', text) is not None


def parse_pre_equip(body):
    slots = {}
    contents = None
    stack = []
    chains = {}
    switches = {}
    choices = {}
    i = 0
    while i < len(body):
        line = body[i]
        i += 1
        text = line.strip()
        if not text:
            continue
        indent = len(line) - len(line.lstrip('\t'))
        while stack and stack[-1][0] >= indent:
            stack.pop()
        listed = re.match(r'^var/(?:list/)?(\w+)\s*=\s*list\(', text)
        if listed:
            gathered = text
            while gathered.count('(') > gathered.count(')') and i < len(body):
                gathered += ' ' + body[i].strip()
                i += 1
            first = re.search(r'(/obj/item/[A-Za-z0-9_/]+)', gathered)
            if first:
                choices[listed.group(1)] = first.group(1)
            continue
        if text.startswith('switch'):
            switches[indent] = False
            stack.append((indent, True))
            continue
        if re.match(r'^if\b', text):
            parent = stack[-1][0] if stack else -1
            if parent in switches and not switches[parent]:
                switches[parent] = True
                accepted = True
            elif parent in switches:
                accepted = False
            elif 'prob(' in text:
                accepted = True
                chains[indent] = 'taken'
            elif 'map_name' in text or 'current_map' in text:
                accepted = False
                chains[indent] = 'else'
            else:
                accepted = masculine(text) or re.match(r'^if\s*\(\s*H\.mind\s*\)$', text) is not None
                chains[indent] = 'else' if feminine(text) else 'masc'
            stack.append((indent, accepted))
            continue
        if re.match(r'^else\s+if\b', text):
            stack.append((indent, chains.get(indent) != 'taken' and masculine(text)))
            continue
        if re.match(r'^else\b', text):
            stack.append((indent, chains.get(indent) == 'else'))
            continue
        if re.match(r'^(for|while)\b', text):
            stack.append((indent, False))
            continue
        if not all(ok for _, ok in stack):
            continue
        m = re.match(r'^(\w+)\s*=\s*(/obj/item/[A-Za-z0-9_/]+)\s*$', text)
        if m and m.group(1) in OUTFIT_SLOTS:
            slots[m.group(1)] = m.group(2)
            continue
        m = re.match(r'^(\w+)\s*=\s*(\w+)\[', text)
        if m and m.group(1) in OUTFIT_SLOTS and m.group(2) in choices:
            slots[m.group(1)] = choices[m.group(2)]
            continue
        if re.match(r'^backpack_contents\s*=\s*list\(', text):
            gathered = text
            while gathered.count('(') > gathered.count(')') and i < len(body):
                gathered += ' ' + body[i].strip()
                i += 1
            contents = [(p, int(n) if n else 1) for p, n in re.findall(r'(/obj/item/[A-Za-z0-9_/]+)\s*(?:=\s*(\d+))?', gathered)]
    return slots, contents


def job_subclasses(rw, job):
    subclasses = re.findall(r'(/datum/advclass/[A-Za-z0-9_/]+)', rw.resolve(job, 'job_subclasses') or '')
    if not subclasses:
        tags = set(re.findall(r'(CTAG_[A-Z0-9_]+)', rw.resolve(job, 'advclass_cat_rolls') or ''))
        if tags:
            subclasses = sorted(p for p in rw.types if p.startswith('/datum/advclass/') and tags & set(re.findall(r'(CTAG_[A-Z0-9_]+)', rw.resolve(p, 'category_tags') or '')) and rw.resolve(p, 'outfit'))
    return [p for p in dict.fromkeys(subclasses) if p in rw.types]


def role_outfit(rw, job):
    """What a role wears at roundstart: Ratwood equips the job's own outfit at spawn and the subclass outfit over it
    once a class is picked. The first subclass that dresses the role is taken (a Wretch's first class, the licker,
    brings no clothes); a map branch of pre_equip (`map_name == "Desert Town"`) falls through to its else."""
    subclasses = job_subclasses(rw, job)
    base = outfit_slots(rw, rw.resolve(job, 'outfit') or '')

    def over_base(worn):
        contents = worn['contents'] if worn['contents'] is not None else base['contents']
        return {'source': worn['source'] or base['source'], 'slots': {**base['slots'], **worn['slots']}, 'contents': contents}

    chosen = next((advclass for advclass in subclasses if outfit_slots(rw, rw.resolve(advclass, 'outfit') or '')['slots']), subclasses[0] if subclasses else None)
    dressed = over_base(outfit_slots(rw, rw.resolve(chosen, 'outfit') or '')) if chosen else base
    dressed['advclass'] = chosen
    dressed['subclasses'] = subclasses
    return dressed


def outfit_slots(rw, source):
    source = (source or '').strip()
    chain = []
    parts = source.split('/')
    for k in range(3, len(parts) + 1):
        chain.append('/'.join(parts[:k]))
    ratwood_slots = {}
    contents = []
    for outfit in chain:
        for slot, value in rw.types.get(outfit, {}).items():
            path = re.match(r'^(/obj/item/[A-Za-z0-9_/]+)$', value.strip())
            if slot in OUTFIT_SLOTS and path:
                ratwood_slots[slot] = path.group(1)
            elif slot == 'backpack_contents' and value.strip().startswith('list('):
                contents = [(p, int(n) if n else 1) for p, n in re.findall(r'(/obj/item/[A-Za-z0-9_/]+)\s*(?:=\s*(\d+))?', value)]
        if outfit in PRE_EQUIP:
            found, items = parse_pre_equip(PRE_EQUIP[outfit])
            ratwood_slots.update(found)
            if items is not None:
                contents = items
    tg = {OUTFIT_SLOTS[slot]: path for slot, path in ratwood_slots.items() if slot not in ('backl', 'backr')}
    backs = [ratwood_slots[slot] for slot in ('backl', 'backr') if slot in ratwood_slots]
    backs.sort(key=lambda path: not path.startswith('/obj/item/storage'))
    tg.update(zip(('back', 'backr'), backs))
    return {'source': source, 'slots': tg, 'contents': contents}


def generate_advclasses(cfg, rw, class_jobs, class_outfits, valid, known_traits):
    spec = cfg['attributes']
    blocks = []
    for advclass in sorted(class_jobs):
        suffix = advclass[len(ADVCLASS_ROOT):]
        owners = class_jobs[advclass]
        name = string_value(rw.resolve(advclass, 'name')) or '"' + suffix.rsplit('/', 1)[1] + '"'
        dressed = class_outfits[advclass]
        outfit = ADVCLASS_OUTFIT + suffix
        block = [outfit, f'\tname = {name}', f'\tjobtype = {owners[0]}']
        for var in ('uniform', 'shirt', 'suit', 'cloak', 'head', 'mask', 'mouth', 'neck', 'gloves', 'wrists', 'ring', 'shoes', 'belt', 'back', 'backr', 'l_pocket', 'r_pocket', 'l_hand', 'r_hand'):
            item = dressed['slots'].get(var)
            if item and item in valid:
                block.append(f'\t{var} = {item}')
        contents = [(item, count) for item, count in (dressed['contents'] or []) if item in valid]
        if contents and dressed['slots'].get('back') in valid:
            block += ['\tbackpack_contents = list('] + [f'\t\t{item} = {count},' for item, count in contents] + ['\t\t)']
        blocks.append(block)
        data = role_attributes(rw, owners[0], advclass, dressed['source'], spec)
        entries = [f'\t\t{stat} = {amount},' for stat, amount in sorted(data['stats'].items())]
        for path, value in sorted(data['skills'].items()):
            if path in spec['meta']:
                entries.append(f"\t\t{spec['skill_target'] + path[len(spec['skill_root']):]} = {min(value, 60)},")
        sheet = None
        if entries:
            sheet = ADVCLASS_SHEET + suffix
            blocks.append([sheet, '\traw_attribute_list = list('] + entries + ['\t\t)'])
        block = [ADVCLASS_TARGET + suffix, f'\tname = {name}', f'\toutfit = {outfit}']
        tutorial = string_value(rw.resolve(advclass, 'tutorial'))
        if tutorial and '[' not in tutorial:
            block.append(f'\tdesc = {tutorial}')
        if sheet:
            block.append(f'\tattribute_sheet = {sheet}')
        traits = [trait for trait in data['traits'] if trait in known_traits]
        if traits:
            block += ['\trockhill_traits = list('] + [f'\t\t{trait},' for trait in traits] + ['\t\t)']
        slots = number_value(rw.resolve(advclass, 'maximum_possible_slots'))
        if slots is not None and slots >= 0:
            block.append(f'\tmaximum_slots = {slots}')
        blocks.append(block)
    open(f'{OUT_DIR}/{ADVCLASS_FILE}', 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
    print(f'{ADVCLASS_FILE}: {len(class_jobs)} subclasses for {len({job for owners in class_jobs.values() for job in owners})} roles')


def select_jobs(cfg, rw):
    jobs_cfg = cfg['jobs']
    departments = jobs_cfg['departments']
    blacklist, _, _ = map_adjustment(os.path.join(CHECKOUT, cfg['source']['map_adjustment']))
    taken = tg_job_titles()
    retitle = {p: f'"{t}"' for p, t in jobs_cfg.get('retitle', {}).items()}
    ported = []
    collisions = []
    for path in sorted(p for p in rw.types if p.startswith(JOB_ROOT + '/')):
        if path in blacklist:
            continue
        dept = (rw.resolve(path, 'department_flag') or '').strip()
        if dept not in departments:
            continue
        positions = max(number_value(rw.resolve(path, 'total_positions')) or 0, number_value(rw.resolve(path, 'spawn_positions')) or 0)
        title = retitle.get(path) or string_value(rw.resolve(path, 'title'))
        if positions <= 0 or not title:
            continue
        if title.strip('"') in taken:
            collisions.append(f'{path} {title}')
        ported.append(path)
    if collisions:
        raise SystemExit('role titles collide with TG job titles; add them to jobs.retitle in the config:\n  ' + '\n  '.join(collisions))
    return ported


def generate_jobs(cfg, rw, usage, role_outfits, valid, station_usage, role_attrs=None):
    jobs_cfg = cfg['jobs']
    departments = jobs_cfg['departments']
    blacklist, slots, retitles = map_adjustment(os.path.join(CHECKOUT, cfg['source']['map_adjustment']))
    retitle = {p: f'"{t}"' for p, t in jobs_cfg.get('retitle', {}).items()}
    taken = tg_job_titles()
    ported = select_jobs(cfg, rw)

    titles = {p: retitle.get(p) or string_value(rw.resolve(p, 'title')) for p in ported}
    seen = {}
    for p, t in titles.items():
        if t in seen:
            raise SystemExit(f'{p} and {seen[t]} share the title {t}')
        seen[t] = p
    defines = {p: define_name(t.strip('"')) for p, t in titles.items()}
    access_traits = set()
    for prefix, var in jobs_cfg.get('access_traits', {}).items():
        for used in usage:
            if boundary_match(used, prefix):
                expanded = expand_define(rw.resolve(used, var))
                if expanded and STRING_LITERAL.match(expanded):
                    access_traits.add(expanded)

    lines = [f'#define {defines[p]} {titles[p]}' for p in ported]
    open(f'{OUT_DIR}/_job_titles.dm', 'w', encoding='utf-8', newline='\n').write('\n'.join(lines) + '\n')

    blocks = []
    abstract = set()
    for p in ported:
        parts = p.split('/')
        for k in range(len(JOB_ROOT.split('/')) + 1, len(parts)):
            parent = '/'.join(parts[:k])
            if parent not in ported:
                abstract.add(parent)
    for parent in sorted(abstract):
        blocks.append([parent, f'\tabstract_type = {parent}'])
    outfits = {}
    for p in ported:
        dept = rw.resolve(p, 'department_flag').strip()
        raw_outfit = (rw.resolve(p, 'outfit') or '').strip()
        outfit = raw_outfit if raw_outfit.startswith('/datum/outfit/job/roguetown/') and raw_outfit not in outfits.values() else '/datum/outfit/job/roguetown/' + p[len(JOB_ROOT) + 1:]
        outfits[p] = outfit
        tag = 'ROCKHILL_' + re.sub(r'[^A-Z0-9]+', '_', p[len(JOB_ROOT) + 1:].upper())
        total = number_value(rw.resolve(p, 'total_positions')) or 0
        spawn = number_value(rw.resolve(p, 'spawn_positions'))
        spawn = total if spawn is None else spawn
        block = [p, f'\ttitle = {defines[p]}']
        desc = string_value(rw.resolve(p, 'tutorial'))
        if desc:
            block.append(f'\tdescription = {desc}')
        block += [f'\ttotal_positions = {total}', f'\tspawn_positions = {spawn}', f'\tconfig_tag = "{tag}"', f'\toutfit = {outfit}']
        order = number_value(rw.resolve(p, 'display_order'))
        if order is not None:
            block.append(f'\tdisplay_order = {order}')
        block += ['\tdepartments_list = list(', f"\t\t{departments[dept]},", '\t\t)']
        traits = sorted(set(expand_define(token) for token in re.findall(r'[A-Z_][A-Z0-9_]*', rw.resolve(p, 'job_traits') or '')) & access_traits)
        if traits:
            block += ['\tmind_traits = list('] + [f'\t\t{trait},' for trait in traits] + ['\t\t)']
        if role_outfits.get(p, {}).get('advclass'):
            block.append(f'\trockhill_advclass = "{role_outfits[p]["advclass"]}"')
        subclasses = role_outfits.get(p, {}).get('subclasses', [])
        if len(subclasses) > 1:
            block += ['\trockhill_advclasses = list('] + [f'\t\t{ADVCLASS_TARGET}{advclass[len(ADVCLASS_ROOT):]},' for advclass in subclasses] + ['\t\t)']
        attrs = (role_attrs or {}).get(p, {})
        if attrs.get('sheet'):
            block.append(f"\tattribute_sheet = {attrs['sheet']}")
        if attrs.get('traits'):
            block += ['\trockhill_traits = list('] + [f'\t\t{trait},' for trait in attrs['traits']] + ['\t\t)']
        alternates = []
        f_title = string_value(rw.resolve(p, 'f_title'))
        if f_title and f_title != titles[p] and f_title.strip('"') not in taken:
            alternates.append(f_title)
        for extra in retitles.get(p, []):
            quoted = f'"{extra}"'
            if quoted != titles[p] and quoted not in alternates:
                alternates.append(quoted)
        if alternates:
            block += ['\talternate_titles = list('] + [f'\t\t{a},' for a in alternates] + ['\t\t)']
        blocks.append(block)
    for p in ported:
        block = [outfits[p], f'\tname = {defines[p]}', f'\tjobtype = {p}']
        dressed = role_outfits.get(p, {'slots': {}, 'contents': []})
        for var in ('uniform', 'shirt', 'suit', 'cloak', 'head', 'mask', 'mouth', 'neck', 'gloves', 'wrists', 'ring', 'shoes', 'belt', 'back', 'backr', 'l_pocket', 'r_pocket', 'l_hand', 'r_hand'):
            item = dressed['slots'].get(var)
            if item and item in valid:
                block.append(f'\t{var} = {item}')
        contents = [(item, count) for item, count in (dressed['contents'] or []) if item in valid]
        if contents and dressed['slots'].get('back') in valid:
            block += ['\tbackpack_contents = list('] + [f'\t\t{item} = {count},' for item, count in contents] + ['\t\t)']
        blocks.append(block)
    open(f'{OUT_DIR}/jobs.dm', 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')

    by_suffix = {p.rsplit('/', 1)[1]: p for p in ported}
    by_title = {}
    for p in ported:
        for var in ('title', 'f_title'):
            source_title = string_value(rw.resolve(p, var))
            if source_title:
                by_title.setdefault(source_title.strip('"'), p)
        for extra in retitles.get(p, []):
            by_title.setdefault(extra, p)
    title_map = {source: titles[p].strip('"') for source, p in by_title.items()}
    open(f'{OUT_DIR}/titles.json', 'w', encoding='utf-8', newline='\n').write(json.dumps(title_map, indent='\t', ensure_ascii=False, sort_keys=True) + '\n')
    landmark_roles = {lm: role for lm, role in jobs_cfg.get('landmark_roles', {}).items() if role in ported}
    marks = []
    matched = 0
    late = {r['prefix'] for r in cfg['replacements'] if r.get('to') == '/obj/effect/landmark/latejoin'}
    for lm in sorted(p for p in usage if p.startswith(LANDMARK_ROOT + '/')):
        if any(lm == pre or lm.startswith(pre + '/') for pre in late):
            continue
        target = LANDMARK_REBASE + lm[len(LANDMARK_ROOT):]
        source_name = (string_value(rw.resolve(lm, 'name')) or '').strip('"')
        job = by_title.get(source_name) or by_suffix.get(lm.rsplit('/', 1)[1]) or landmark_roles.get(lm)
        roles = [title_map[role.strip('"')] for role in re.findall(r'"[^"]*"', rw.resolve(lm, 'jobspawn_override') or '') if role.strip('"') in title_map]
        block = [target]
        if job:
            block.append(f'\tname = {defines[job]}')
            matched += 1
        elif lm in station_usage:
            block.append('\tname = JOB_ASSISTANT')
        if roles:
            block.append('\trockhill_latejoin_roles = list(' + ', '.join(f'"{role}"' for role in roles) + ')')
        marks.append(block)
    open(f'{OUT_DIR}/landmarks.dm', 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in marks) + '\n')

    map_json_path = 'modular_redtard/rockhill/rockhill.json'
    map_json = json.load(open(map_json_path, encoding='utf-8'))
    changes = {}
    for p, n in sorted(slots.items()):
        if p in titles:
            changes[titles[p].strip('"')] = {'total_positions': n, 'spawn_positions': n}
    map_json['job_changes'] = changes
    open(map_json_path, 'w', encoding='utf-8', newline='\n').write(json.dumps(map_json, indent='\t') + '\n')

    with open(REPORT, 'a', encoding='utf-8', newline='\n') as out:
        out.write(f'\n## Jobs ({len(ported)} roles, {matched} of {len(marks)} start landmarks bound to a role)\n\n| Role | Title | Department |\n|---|---|---|\n')
        for p in ported:
            out.write(f"| `{p}` | {titles[p].strip(chr(34))} | {departments[rw.resolve(p, 'department_flag').strip()]} |\n")
    print(f'jobs: {len(ported)} roles, {len(abstract)} abstract parents, landmarks {matched}/{len(marks)} bound, job_changes {len(changes)}')


if __name__ == '__main__':
    main()
