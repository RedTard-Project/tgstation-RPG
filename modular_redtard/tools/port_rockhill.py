import collections
import json
import os
import re
import shutil
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dmi

CONFIG = 'modular_redtard/rockhill/config.json'
OUT_DIR = 'modular_redtard/rockhill/ported'
ICON_DIR = 'modular_redtard/rockhill/icons'
REPORT = 'modular_redtard/rockhill/PORTED_CONTENT.md'
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
ONMOB_TAGS = {'onback': 'ROGUE_ONMOB_BACK', 'onbelt': 'ROGUE_ONMOB_HIP'}
DEFINE_VALUES = {}
ARMOR_DATUMS = {}
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
EDGES_FILE = 'turf_edges.dm'


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
                if not rest.startswith('('):
                    DEFINE_VALUES[dm.group(1)] = rest.strip()
                continue
            if line.startswith('#'):
                continue
            if not line.startswith(('\t', ' ')):
                m = TYPE_LINE.match(line)
                if m and '/proc/' not in m.group(1) and '/verb/' not in m.group(1):
                    current = m.group(1)
                    types[current]
                else:
                    current = None
                    pm = PROC_LINE.match(line)
                    if pm:
                        PROCS[pm.group(1)].add(pm.group(2))
                        bodies = {'pre_equip': ('/datum/outfit/', PRE_EQUIP), 'getonmobprop': ('/obj/item', ONMOB)}.get(pm.group(2))
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


def runtime_path(path, rules):
    rule = replacement_for(path, rules)
    if rule is None:
        return path
    if rule.get('drop'):
        return None
    if rule.get('rebase'):
        return rule['rebase'] + path[len(rule['prefix']):]
    return rule['to']


def literal(value, tg_names):
    if value is None:
        return None
    v = value.strip()
    if v in ('TRUE', 'FALSE', 'null') or NUMBER.match(v):
        return v
    if STRING_LITERAL.match(v) or (v.startswith('{"') and v.endswith('"}')):
        return v
    if ICON_LITERAL.match(v):
        return v
    if re.match(r'^[A-Z_][A-Z0-9_]*$', v) and v in tg_names:
        return v
    return None


def main():
    if not os.path.exists(CONFIG):
        raise SystemExit('run from the repository root')
    cfg = json.load(open(CONFIG, encoding='utf-8'))
    code_root = cfg['source']['code_root']
    port = cfg['port']
    rules = cfg['replacements']
    print('parsing', code_root)
    types, _ = parse_codebase(code_root)
    rw = Codebase(types)
    print('ratwood types:', len(types))
    declared = declared_paths(DECLARATION_ROOTS, [OUT_DIR])
    tg_names = tg_defines('code')
    usage, per_level = map_usage(cfg['source']['local'])

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
    outfit_items = set()
    for dressed in role_outfits.values():
        outfit_items |= set(dressed['slots'].values())
        outfit_items |= {item for item, _ in dressed['contents'] or []}
    generated = generate(cfg, port, rules, rw, declared, tg_names, usage, outfit_items)
    generate_onmob(generated)
    generate_jobs(cfg, rw, usage, role_outfits, declared | generated)


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


def generate_onmob(generated):
    owners = set()
    for path in generated:
        if not path.startswith('/obj/item/'):
            continue
        parts = path.split('/')
        for k in range(4, len(parts) + 1):
            prefix = '/'.join(parts[:k])
            if prefix in ONMOB:
                owners.add(prefix)
    blocks = []
    for owner in sorted(owners):
        body = ONMOB[owner]
        found = parse_onmob(body)
        inherits = any('..()' in line for line in body)
        if not found and inherits:
            continue
        block = [f'{owner}/rogue_onmob_prop(tag)']
        if found:
            block.append('\tswitch(tag)')
            for tag, value in found.items():
                block += [f'\t\tif({ONMOB_TAGS[tag]})', f'\t\t\treturn {value}']
        block.append('\treturn ..()' if inherits else '\treturn null')
        blocks.append(block)
    open(f'{OUT_DIR}/onmob.dm', 'w', encoding='utf-8', newline='\n').write('\n\n'.join('\n'.join(b) for b in blocks) + '\n')
    print(f'onmob.dm: {len(blocks)} on-body prop overrides')


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


def generate(cfg, port, rules, rw, declared, tg_names, usage, extra_items):
    categories = port['categories']
    chosen = collections.defaultdict(list)
    skipped = collections.Counter()
    port_usage = collections.Counter(usage)
    for spawner in [p for p in usage if p.startswith('/obj/effect/spawner/')]:
        for item, _ in loot_entries(rw.resolve(spawner, 'loot')):
            port_usage[item] += 0
    for item in extra_items:
        port_usage[item] += 0
    for path, count in sorted(port_usage.items()):
        if replacement_for(path, rules) or path in declared:
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
        rel = m.group(1).replace('\\', '/')
        src = os.path.join(cfg['source']['code_root'], rel)
        if not os.path.exists(src):
            return None
        dest_rel = rel[len('icons/'):] if rel.startswith('icons/') else rel
        dest = f'{ICON_DIR}/{dest_rel}'
        icons[src] = dest
        return f"'{dest}'"

    sheet_states = {}

    def slot_worn_icon(path, sheets):
        flags = rw.resolve(path, 'slot_flags') or ''
        state = next((v.strip().strip('"') for v in (rw.resolve(path, 'item_state'), rw.resolve(path, 'icon_state')) if v and v.strip() != 'null'), '')
        for flag, sheet in sheets.items():
            if flag not in re.findall(r'ITEM_SLOT_[A-Z_]+', flags):
                continue
            src = os.path.join(cfg['source']['code_root'], sheet)
            if src not in sheet_states:
                sheet_states[src] = {s['name'] for s in dmi.read(src).states} if os.path.exists(src) else set()
            if state in sheet_states[src]:
                return f"'{sheet}'"
        return None

    generated = {p for paths in chosen.values() for p in paths}
    used_turfs = sorted(p for p in usage if p.startswith('/turf/'))
    runtime = {p: runtime_path(p, rules) for p in used_turfs}
    reskins = [p for p in used_turfs if (replacement_for(p, rules) or {}).get('reskin')]
    valid = declared | generated | {runtime[p] for p in reskins}
    sheets = {}
    families = port['smoothing_families']

    def family_of(path):
        best = None
        for prefix, group in families.items():
            if (path == prefix or path.startswith(prefix + '/')) and (best is None or len(prefix) > len(best[0])):
                best = (prefix, group)
        return best[1] if best else None

    def smooth_targets(path):
        raw = rw.resolve(path, 'canSmoothWith') or ''
        found = set()
        for entry in re.findall(r'(/turf/[A-Za-z0-9_/]+)', raw):
            for q in used_turfs:
                if (q == entry or q.startswith(entry + '/')) and runtime[q] in valid:
                    found.add(runtime[q])
            if entry in valid and replacement_for(entry, rules) is None:
                found.add(entry)
        return sorted(found)

    def convert_sheet(raw_icon, preview):
        m = ICON_LITERAL.match((raw_icon or '').strip())
        if not m:
            return None
        src = os.path.join(cfg['source']['code_root'], m.group(1))
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

    def smoothing_lines(path):
        flags = rw.resolve(path, 'smooth') or ''
        if 'SMOOTH_TRUE' not in flags and 'SMOOTH_MORE' not in flags:
            return None
        group = family_of(path)
        if not group:
            return None
        raw = rw.resolve(path, 'smooth_icon')
        if not raw or raw.strip() == 'null':
            raw = rw.resolve(path, 'icon')
        prefix = convert_sheet(raw, (rw.resolve(path, 'icon_state') or '').strip().strip('"'))
        if not prefix:
            return None
        friends = {group} | {family_of(p) for p in smooth_targets(path)} - {None}
        return [
            f"\ticon = '{SMOOTH_DIR}/{prefix}.dmi'",
            f'\ticon_state = "{prefix}-0"',
            f'\tbase_icon_state = "{prefix}"',
            '\tsmoothing_flags = SMOOTH_BITMASK',
            f'\tsmoothing_groups = {group}',
            f"\tcanSmoothWith = {' + '.join(sorted(friends))}",
        ]

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
    if os.path.isdir(SMOOTH_DIR):
        shutil.rmtree(SMOOTH_DIR)
    report_rows = collections.defaultdict(list)
    smoothed = collections.Counter()
    for cat in categories:
        paths = chosen.get(cat['file'], [])
        if not paths:
            continue
        blocks = []
        grafted = set()
        for path in paths:
            g = graft_point(path, declared)
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
        for path in paths:
            block = [path]
            block += cat.get('_graft_blocks', {}).get(path, [])
            smooth = smoothing_lines(path) if cat.get('smoothing') else None
            for name in cat['vars']:
                if smooth and name in ('icon', 'icon_state'):
                    continue
                source_name = cat.get('rename', {}).get(name, name)
                value = rw.resolve(path, source_name)
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
                    armor = armor_type_value(rw.resolve(path, 'armor'), port['armor'])
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
                if value is None:
                    continue
                block.append(f'\t{name} = {value}')
            own_worn = rw.resolve(path, cat.get('rename', {}).get('worn_icon', 'worn_icon'))
            for name, sheets in cat.get('slot_worn_icons', {}).items():
                if name in cat['vars'] or (own_worn and own_worn.strip() != 'null'):
                    continue
                sheet = slot_worn_icon(path, sheets)
                if sheet:
                    block.append(f'\t{name} = {icon_ref(sheet)}')
            for name, value in cat.get('fixed_vars', {}).items():
                block.append(f'\t{name} = {value}')
            if smooth:
                block += smooth
                smoothed['bitmask'] += 1
            elif cat.get('smoothing') and path.startswith('/turf/closed') and family_of(path):
                block.append(f'\tsmoothing_groups = {family_of(path)}')
            elif cat.get('smoothing') and edge_receiver(path):
                block.append('\tsmoothing_flags = SMOOTH_BITMASK_CARDINALS')
                edge_sources[path] = smooth_targets(path)
                smoothed['edges'] += 1
            blocks.append(block)
            report_rows[cat['file']].append((path, usage[path]))
        text = '\n\n'.join('\n'.join(b) for b in blocks) + '\n'
        open(f"{OUT_DIR}/{cat['file']}", 'w', encoding='utf-8', newline='\n').write(text)
        print(f"{cat['file']}: {len(paths)} types")

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
        prefix = convert_sheet(raw_icon, (rw.resolve(path, 'icon_state') or '').strip().strip('"'))
        if prefix:
            block += [f"\ticon = '{SMOOTH_DIR}/{prefix}.dmi'", f'\ticon_state = "{prefix}-0"', f'\tbase_icon_state = "{prefix}"']
        else:
            icon = icon_ref(raw_icon) if raw_icon else None
            state = literal(rw.resolve(path, 'icon_state'), tg_names)
            if icon:
                block.append(f'\ticon = {icon}')
            if state:
                block.append(f'\ticon_state = {state}')
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

    for rel in port.get('extra_icons', []):
        src = os.path.join(cfg['source']['code_root'], rel)
        icons[src] = f"{ICON_DIR}/{rel[len('icons/'):] if rel.startswith('icons/') else rel}"

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

    for src, dest in icons.items():
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copyfile(src, dest)
    print('icons copied:', len(icons), 'bytes:', sum(os.path.getsize(d) for d in icons.values()))

    with open(REPORT, 'w', encoding='utf-8', newline='\n') as out:
        out.write('# Ported Ratwood content\n\n')
        out.write('Generated by `modular_redtard/tools/port_rockhill.py` from the Ratwood-2.0 code tree and the Rockhill map. ')
        out.write('Each type keeps its Ratwood path, so the map loads it unchanged; `parent_type` grafts the Ratwood branch onto a TG or module base. ')
        out.write('Re-run the tool after the map gains new types (the map generator fails on a missing turf or area and warns on a missing object).\n\n')
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
            rel = os.path.relpath(src, cfg['source']['code_root']).replace('\\', '/')
            out.write(f'- `{dest}` from Ratwood `{rel}`\n')
    print('report:', REPORT, 'skipped types:', len(skipped))
    return generated


JOB_ROOT = '/datum/job/roguetown'
LANDMARK_ROOT = '/obj/effect/landmark/start'
LANDMARK_REBASE = '/obj/effect/landmark/start/rockhill'


def string_value(raw):
    if raw is None:
        return None
    v = raw.strip()
    if STRING_LITERAL.match(v):
        return v
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


def armor_type_value(raw, armor_cfg):
    value = expand_define(raw)
    numbers = {k: float(n) for k, n in re.findall(r'"(\w+)"\s*=\s*(-?\d+(?:\.\d+)?)', value)}
    if not numbers:
        return None
    scale, cap = armor_cfg['scale'], armor_cfg['cap']
    def scaled(n):
        return int(round(min(max(n, 0) * scale, cap)))
    fields = {
        'melee': scaled(sum(numbers.get(k, 0) for k in ('blunt', 'slash', 'stab')) / 3),
        'bullet': scaled(numbers.get('piercing', 0)),
        'fire': scaled(numbers.get('fire', 0)),
        'acid': scaled(numbers.get('acid', 0)),
    }
    if not any(fields.values()):
        return None
    name = (raw or '').strip()
    if re.match(r'^ARMOR_[A-Z0-9_]+$', name):
        path = '/datum/armor/rockhill_' + name[len('ARMOR_'):].lower()
    else:
        path = '/datum/armor/rockhill_m{melee}_b{bullet}_f{fire}_a{acid}'.format(**fields)
    ARMOR_DATUMS[path] = fields
    return path


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


def role_outfit(rw, job):
    subclasses = re.findall(r'(/datum/advclass/[A-Za-z0-9_/]+)', rw.resolve(job, 'job_subclasses') or '')
    if not subclasses:
        tags = set(re.findall(r'(CTAG_[A-Z0-9_]+)', rw.resolve(job, 'advclass_cat_rolls') or ''))
        if tags:
            subclasses = sorted(p for p in rw.types if p.startswith('/datum/advclass/') and tags & set(re.findall(r'(CTAG_[A-Z0-9_]+)', rw.resolve(p, 'category_tags') or '')) and rw.resolve(p, 'outfit'))
    source = (rw.resolve(subclasses[0], 'outfit') if subclasses else None) or rw.resolve(job, 'outfit') or ''
    source = source.strip()
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


def select_jobs(cfg, rw):
    jobs_cfg = cfg['jobs']
    departments = jobs_cfg['departments']
    blacklist, _, _ = map_adjustment(cfg['source']['map_adjustment'])
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


def generate_jobs(cfg, rw, usage, role_outfits, valid):
    jobs_cfg = cfg['jobs']
    departments = jobs_cfg['departments']
    blacklist, slots, retitles = map_adjustment(cfg['source']['map_adjustment'])
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

    lines = [f'#define {defines[p]} {titles[p]}' for p in ported]
    open(f'{OUT_DIR}/job_titles.dm', 'w', encoding='utf-8', newline='\n').write('\n'.join(lines) + '\n')

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
    marks = []
    matched = 0
    late = {r['prefix'] for r in cfg['replacements'] if r.get('to') == '/obj/effect/landmark/latejoin'}
    for lm in sorted(p for p in usage if p.startswith(LANDMARK_ROOT + '/')):
        if any(lm == pre or lm.startswith(pre + '/') for pre in late):
            continue
        target = LANDMARK_REBASE + lm[len(LANDMARK_ROOT):]
        job = by_suffix.get(lm.rsplit('/', 1)[1])
        if job:
            marks.append([target, f'\tname = {defines[job]}'])
            matched += 1
        else:
            marks.append([target, '\tparent_type = /obj/effect/landmark/start/assistant'])
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
