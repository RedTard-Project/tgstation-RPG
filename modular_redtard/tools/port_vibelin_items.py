"""K3g: Vibelin's own items (the ones no other build of the module's four has) as flat type blocks of the module.

    py -3 modular_redtard/tools/port_vibelin_items.py [--refresh-selection] [--groups weapon,...] [--lists DIR] [--dry-run]

Reads modular_redtard/items_vibelin/port.json. The types are the rows of items_vibelin/selection.tsv whose pick is
"vibelin"; --refresh-selection writes that file from the K1v lists (missing_vibelin.tsv, duplicates.tsv), checking
every pair K1v made by name against the paths and sprites of both types: a pair whose types share neither the last
path segment, nor the sprite, nor most of the path is a false pair, and the Vibelin type is then Vibelin's to port.
The same check is made for the Vibelin types K1v took for "already in the module" by name.

Each type is flattened through Vibelin's own inheritance with the dm_type_port.py engine of ai-skills (read-only use)
and rebased under the module's root of its kind with a "vibelin" step (/obj/item/weapon/sword/long/x ->
/obj/item/rogueweapon/sword/vibelin/long/x), so it keeps the behaviour of its kind (sheaths, sounds, the module's
weapon code) while every var the module's root sets is either written or reset. Intents are mapped to the module's
(Azure's) intents of the same path, an alias, or the nearest parent the module has. Sprites are copied under
items_vibelin/icons (or pointed at the identical file of the wardrobe); the held, belted and slung sprites of
getonmobprop() are queued for ai-skills bake_onmob_sheets.py in items_vibelin/onmob_bake.json and used once baked.

The numbers of an item (integrity, force, defense, strength) are not written into the type: they go to the section
`# >>> port_vibelin_items.py` of the staged items table (port.json "table") that the block's assembler merges into
the private config/redtard_private/mechanics/items.txt. Read-only on Vibelin and the other forks. No git.
"""

import argparse
import collections
import csv
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
FOLDER = os.path.join(REPO, 'modular_redtard', 'items_vibelin')
CONFIG = os.path.join(FOLDER, 'port.json')
SELECTION = os.path.join(FOLDER, 'selection.tsv')

for candidate in (os.environ.get('REDTARD_AI_SKILLS_SCRIPTS', ''), os.path.join(REPO, '..', 'ai-skills', 'scripts')):
    if candidate and os.path.isfile(os.path.join(candidate, 'dm_type_port.py')):
        sys.path.insert(0, candidate)
        break
import dm_type_port as engine  # noqa: E402

sys.path.insert(0, HERE)
import port_rockhill as rockhill  # noqa: E402  (its getonmobprop reader and bake queue)

TOKEN = re.compile(r'[A-Za-z_][A-Za-z0-9_]*')
FILE_REF = re.compile(r"^'([^']+)'$")
UNITS = {'SECONDS': '*10', 'SECOND': '*10', 'MINUTES': '*600', 'MINUTE': '*600', 'DECISECONDS': '*1', 'DECISECOND': '*1',
         'KILOGRAMS': '*1', 'GRAMS': '*0.001', 'TICKS': '*0.5'}
SAFE = re.compile(r'^[\d.\s+\-*/()%]*$')
ONMOB_HEAD = re.compile(r'^(/obj/item[A-Za-z0-9_/]*)/(?:proc/)?getonmobprop\(')


def under(path, prefix):
    return path == prefix or path.startswith(prefix + '/')


def norm(name):
    return re.sub(r'[^a-z0-9]+', ' ', (name or '').lower()).strip()


def rel(path):
    return os.path.join(REPO, path)


def read_tsv(path):
    with open(path, encoding='utf-8') as handle:
        return list(csv.DictReader(handle, delimiter='\t', quoting=csv.QUOTE_NONE))


def write_tsv(path, header, rows):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8', newline='\n') as handle:
        handle.write('\t'.join(header) + '\n')
        for row in rows:
            handle.write('\t'.join(str(row.get(h, '')) for h in header) + '\n')


# ---------------------------------------------------------------------------------------------------------------
# Selection: which Vibelin types are Vibelin's to port.


class Tree:
    """One parsed compile (a fork or the module): types, defines and where each type is declared."""

    def __init__(self, root, dme):
        files = engine.compiled_files(root, dme)
        types, defines, self.declared = engine.parse(files)
        self.src = engine.Source(types, defines)
        self.types = types

    def icon_state(self, path):
        raw = self.src.resolve(path, 'icon_state')
        value = self.src.expand(raw) if raw else ''
        return value.strip('"') if value and value.startswith('"') else ''


def module_tree():
    files = []
    for folder in ('modular_redtard/rockhill/ported', 'modular_redtard/wardrobe'):
        for dp, _dn, fn in os.walk(rel(folder)):
            files += [os.path.join(dp, f) for f in fn if f.endswith('.dm')]
    tree = Tree.__new__(Tree)
    types, defines, tree.declared = engine.parse(files)
    tree.src = engine.Source(types, defines)
    tree.types = types
    return tree


def same_item(cfg, vib, vpath, other, opath):
    """A K1v name pair (same name, same kind) holds unless the paths put the two types in different families of
    items (a mace and a scabbard, a club and a staff) and their sprites differ too."""
    generic = set(cfg['pair_generic_tokens'])
    vt = [t for t in vpath.split('/') if t and t not in generic]
    ot = [t for t in opath.split('/') if t and t not in generic]
    vs, os_ = vib.icon_state(vpath), other.icon_state(opath) if other else ''
    if vs and vs == os_:
        return 'sprite'
    if vt and ot and vt[-1] == ot[-1]:
        return 'last segment'
    families = cfg['pair_families']
    fam = lambda tokens: {f for f, words in families.items() for t in tokens if t in words}
    vf, of = fam(vt), fam(ot)
    if vf and of and not vf & of:
        return ''
    return 'name'


def refresh_selection(cfg):
    lists = rel(cfg['lists'])
    print('parsing Vibelin')
    vib = Tree(rel(cfg['source']), cfg.get('dme'))
    others = {}

    def other(name):
        if name not in others:
            root, dme = cfg['pair_sources'][name]
            print('parsing', name)
            others[name] = Tree(rel(root), dme) if os.path.isdir(rel(root)) else None
        return others[name]

    dups = collections.defaultdict(list)
    for row in read_tsv(os.path.join(lists, 'duplicates.tsv')):
        if row['name']:
            dups[(norm(row['name']), row['kind'])].append(row)
    rows = []
    missing = read_tsv(os.path.join(lists, 'missing_vibelin.tsv'))
    missing_paths = {r['type'] for r in missing}
    for row in missing:
        if not row['name'] or row['type'] not in vib.declared:
            continue
        out = {'kind': row['kind'], 'type': row['type'], 'name': row['name'], 'file': row['file']}
        candidates = dups.get((norm(row['name']), row['kind']), [])
        held = []
        for cand in candidates:
            source = next((s for s in cand['sources'].split(',') if s in cfg['pair_sources']), None)
            why = same_item(cfg, vib, row['type'], other(source) if source else None, cand['type'])
            if why:
                held.append((cand, why))
        if not candidates:
            out.update(pick='vibelin', verdict='unique', match='')
        elif not held:
            out.update(pick='vibelin', verdict='false_pair', match=','.join(c['type'] for c in candidates))
        else:
            picks = [c['pick'] for c, _ in held]
            pick = next((p for p in picks if p != 'vibelin'), 'vibelin')
            out.update(pick=pick, verdict='pair (' + held[0][1] + ')', match=','.join(c['type'] for c, _ in held))
        rows.append(out)
    # The Vibelin types K1v took for "in the module" by name: kept out unless the module's type of that name is
    # another item.
    print('parsing the module')
    mod = module_tree()
    mod_names = collections.defaultdict(list)
    for path in mod.declared:
        if under(path, '/obj/item'):
            raw = mod.src.resolve(path, 'name')
            if raw and raw.startswith('"'):
                mod_names[norm(raw.strip('"'))].append(path)
    false_module = 0
    for path in sorted(vib.declared):
        if not under(path, '/obj/item') or path in missing_paths:
            continue
        raw = vib.src.resolve(path, 'name')
        if not raw or not raw.startswith('"'):
            continue
        name = raw.strip('"')
        cands = mod_names.get(norm(name), [])
        if not cands or any(same_item(cfg, vib, path, mod, c) for c in cands):
            continue
        files = sorted(vib.declared[path])
        rows.append({'kind': kind_of(path), 'type': path, 'name': name, 'file': os.path.relpath(files[0], rel(cfg['source'])).replace('\\', '/'),
                     'pick': 'vibelin', 'verdict': 'false_module_pair', 'match': ','.join(cands)})
        false_module += 1
    rows.sort(key=lambda r: r['type'])
    write_tsv(SELECTION, ['kind', 'type', 'name', 'pick', 'verdict', 'match', 'file'], rows)
    stats = collections.Counter((r['kind'], r['pick'] if r['pick'] == 'vibelin' else 'other build', r['verdict'].split(' ')[0]) for r in rows)
    print(f'{SELECTION}: {len(rows)} rows ({false_module} false pairs with the module)')
    for key, count in sorted(stats.items()):
        print('  ', key, count)


def kind_of(path):
    """K1v's guess of the kind by the path (k1v_items.py kind())."""
    p = path.lower()
    if any(k in p for k in ('/food', 'snacks', '/grown', 'produce', '/drinks', '/meat', '/fruit')):
        return 'food'
    if '/rogueweapon/tool' in p or ('weapon' not in p and any(k in p for k in (
            '/tool', 'lockpick', 'tongs', '/needle', '/shovel', '/hoe', '/pickaxe', '/trowel', '/chisel',
            '/saw', '/key', '/crowbar', '/lantern', '/torch', '/flashlight', '/fishing', '/rope'))):
        return 'tool'
    if any(k in p for k in ('shield', 'armor', 'helmet', '/plate', '/mail', 'gorget', 'chainmail', '/coif', 'bracers', '/greaves')):
        return 'armor'
    if any(k in p for k in ('weapon', 'ammo', '/gun', '/bow', 'arrow', 'bolt', '/sword', '/dagger', '/spear', '/axe', '/mace',
                            '/whip', '/flail', 'throwing', '/knife', '/polearm', '/staff', '/quiver')):
        return 'weapon'
    if '/clothing' in p:
        return 'clothing'
    return 'other'


# ---------------------------------------------------------------------------------------------------------------
# The port.


class VibelinPorter(engine.Porter):
    def __init__(self, cfg):
        engine_cfg = dict(cfg)
        engine_cfg['rebase'] = [rule for group in cfg['groups'].values() for rule in group['rebase']]
        super().__init__(engine_cfg, REPO, rel(cfg['source']))
        self.onmob = {}
        for path in self.files:
            lines = open(path, encoding='utf-8', errors='ignore').read().split('\n')
            i = 0
            while i < len(lines):
                head = ONMOB_HEAD.match(lines[i])
                i += 1
                if head:
                    body = []
                    while i < len(lines) and (not lines[i].strip() or lines[i].startswith(('\t', ' '))):
                        body.append(lines[i].rstrip())
                        i += 1
                    self.onmob[head.group(1)] = engine.strip_comments('\n'.join(body)).split('\n')
        self.module_blocks = {}
        for item_file in cfg['target_items']:
            current = None
            for line in open(rel(item_file), encoding='utf-8'):
                line = line.rstrip('\n')
                if line.startswith('/'):
                    current = self.module_blocks.setdefault(line.strip(), set())
                elif line.startswith('\t') and current is not None and ' = ' in line:
                    current.add(line.strip().split(' = ', 1)[0])
                elif not line.strip():
                    current = None
        self.shared = {}
        for folder in cfg.get('shared_assets', []):
            self.shared[folder] = rel(folder)
        self.table = []
        self.skipped = []
        # A group's var table may come from another dm_type_port config (the wardrobe's), with changes.
        for group in cfg['groups'].values():
            spec = group.get('engine')
            if spec and spec.get('from'):
                base = json.load(open(rel(spec['from']), encoding='utf-8'))
                merged = {key: base.get(key, {} if key != 'vars' else []) for key in ('vars', 'rename', 'copies', 'kinds', 'maps', 'defaults', 'state_flags', 'icon_size_vars')}
                merged['vars'] = [v for v in merged['vars'] if v not in spec.get('drop_vars', [])] + spec.get('add_vars', [])
                for key in ('rename', 'kinds', 'defaults', 'copies'):
                    merged[key].update(spec.get(key, {}))
                for var, table in spec.get('maps', {}).items():
                    merged['maps'].setdefault(var, {}).update(table)
                merged['require'] = {}
                group['engine'] = merged
        # Vibelin's armor datums the groups' maps do not name take the tier of their nearest named parent.
        armor_datums = [p for p in self.src.types if under(p, '/datum/armor')]
        for group in cfg['groups'].values():
            table = group.get('engine', {}).get('maps', {}).get('rogue_armor')
            if table is None:
                continue
            vector = lambda p: tuple(self.number(self.src.resolve(p, k)) or 0 for k in ('blunt', 'slash', 'stab', 'piercing'))
            named = {key: vector(key) for key in list(table) if key.startswith('/datum/armor')}
            for datum in armor_datums:
                if datum in table:
                    continue
                step = datum
                while step and step not in named and step.count('/') > 2:
                    step = self.src.parent(step)
                if step in named:
                    table[datum] = table[step]
                    continue
                # No named parent: the named datum nearest in Vibelin's own percent values.
                mine = vector(datum)
                nearest = min(named, key=lambda key: sum((a - b) ** 2 for a, b in zip(mine, named[key])))
                table[datum] = table[nearest]
        self.dropped_intents = collections.Counter()
        self.notes = collections.Counter()
        self.baked_missing = 0
        self.baked_used = 0

    # -- helpers -------------------------------------------------------------------------------------------------

    def asset(self, ref):
        source = os.path.join(self.source_root, ref)
        if not os.path.isfile(source):
            return None
        for folder, absolute in self.shared.items():
            twin = os.path.join(absolute, ref)
            if os.path.isfile(twin) and open(twin, 'rb').read() == open(source, 'rb').read():
                target = f'{folder}/{ref}'
                self.sources[target] = source
                return target
        return super().asset(ref)

    def literal(self, value):
        """A define both builds know (WEIGHT_CLASS_BULKY, WLENGTH_LONG) stays a name; the engine expands it."""
        value = value.strip()
        if TOKEN.fullmatch(value) and value in self.known_defines and value not in ('TRUE', 'FALSE', 'null'):
            return value
        return super().literal(value)

    def number(self, raw, depth=0):
        if raw is None:
            return None
        text = raw.strip()
        if depth > 12:
            return None
        if text in ('TRUE',):
            return 1
        if text in ('FALSE', 'null'):
            return 0

        def sub(match):
            tok = match.group(0)
            if tok in UNITS:
                return UNITS[tok]
            if tok in self.src.defines:
                value = self.number(self.src.defines[tok], depth + 1)
                if value is None:
                    raise ValueError(tok)
                return f'({value!r})'
            raise ValueError(tok)

        try:
            expr = TOKEN.sub(sub, text)
        except ValueError:
            return None
        expr = re.sub(r'(\d)\s+\*', r'\1*', expr)
        if not SAFE.match(expr):
            return None
        try:
            value = eval(expr, {'__builtins__': {}}, {})
        except Exception:
            return None
        return value

    def fmt(self, value, step=None):
        if step:
            value = max(step, int(round(value / step)) * step)
        if isinstance(value, float):
            value = round(value, 3)
            if value.is_integer():
                value = int(value)
        return str(value)

    def chain_vars(self, target):
        """The vars the module's own blocks set on the target's ancestors (what the target would inherit)."""
        found = set()
        path = target
        while path.count('/') > 2:
            path = path.rsplit('/', 1)[0]
            found |= self.module_blocks.get(path, set())
        return found

    def mapped_path(self, raw, table, item_path):
        value = self.src.expand(raw.strip())
        if value in table:
            spec = table[value]
            best = max((p for p in spec if p and under(item_path, p)), key=len, default='')
            value = spec.get(best, spec.get(''))
        return value if value in self.target_types else None

    def intents(self, raw):
        if raw is None:
            return None
        text = raw.strip()
        if text == 'null':
            return []
        if not text.startswith('list('):
            text = f'list({text})'
        out = []
        aliases = sorted(self.cfg['intent_aliases'].items(), key=lambda kv: -len(kv[0]))
        for token in re.findall(r'[A-Za-z_/][A-Za-z0-9_/]*', text[5:-1]):
            path = self.src.expand(token)
            if path in ('null', ''):
                continue
            if not path.startswith('/datum/intent'):
                self.dropped_intents[token] += 1
                continue
            for prefix, to in aliases:
                if under(path, prefix):
                    path = to + path[len(prefix):]
                    break
            near = path
            while near.count('/') > 2 and near not in self.target_types:
                near = near.rsplit('/', 1)[0]
            if near not in self.target_types or path in self.cfg['intent_drop'] or any(under(path, d) for d in self.cfg['intent_drop_prefixes']) or near == '/datum/intent' and path != near:
                self.dropped_intents[path] += 1
                continue
            if near != path:
                self.notes[f'intent {path} -> {near}'] += 1
            if near not in out:
                out.append(near)
        return out

    def onmob_prop(self, path, tag):
        p = path
        while p and p.startswith('/obj/item'):
            body = self.onmob.get(p)
            if body is not None:
                found = rockhill.parse_onmob(body)
                if tag in found:
                    return None if found[tag] == 'null' else rockhill.onmob_numbers(found[tag])
                if not any('..()' in line for line in body):
                    return None
            p = self.src.parent(p)
        return None

    def truthy(self, path, var):
        raw = self.src.resolve(path, var)
        return bool(raw) and self.number(raw) not in (None, 0)

    def sheet_has(self, sheet, state):
        absolute = rel(sheet)
        if not os.path.isfile(absolute):
            return False
        return state in engine.dmi_meta(absolute)[2]

    # A slot of TG's default worn sheets (as TG's worn_icons unit test reads them, modular_redtard/tools/check_modular_content.py).
    TG_WORN_SHEETS = {
        'ITEM_SLOT_BACK': 'icons/mob/clothing/back.dmi', 'ITEM_SLOT_ID': 'icons/mob/clothing/id.dmi',
        'ITEM_SLOT_GLOVES': 'icons/mob/clothing/hands.dmi', 'ITEM_SLOT_EYES': 'icons/mob/clothing/eyes.dmi',
        'ITEM_SLOT_EARS': 'icons/mob/clothing/ears.dmi', 'ITEM_SLOT_NECK': 'icons/mob/clothing/neck.dmi',
        'ITEM_SLOT_MASK': 'icons/mob/clothing/mask.dmi', 'ITEM_SLOT_BELT': 'icons/mob/clothing/belt.dmi',
    }

    def blank_worn(self, written):
        """An item worn in a TG slot with no worn sheet of its own and no state in TG's default sheet of that slot (a
        Vibelin polearm on the back: its back sprite is the baked rogue_onmob_sheet) gets Rockhill's blank worn sheet
        and worn_icon_state = null, TG's way to say "no worn sprite", as the Ratwood porter does."""
        if (written.get('worn_icon') or 'null') != 'null':
            return
        slots = set(TOKEN.findall(written.get('slot_flags') or ''))
        looks = [(written.get(var) or '').strip('"') for var in ('worn_icon_state', 'icon_state')]
        look = next((state for state in looks if state and state != 'null'), None)
        if not look:
            return
        if any(slot in slots and not self.sheet_has(sheet, look) for slot, sheet in self.TG_WORN_SHEETS.items()):
            written['worn_icon'] = f"'{rockhill.BLANK_WORN}'"
            written['worn_icon_state'] = 'null'
            self.notes['worn in a TG slot without a worn sprite: blank worn sheet'] += 1

    # -- one type ------------------------------------------------------------------------------------------------

    def item_block(self, path, group_name, group, ported):
        target = self.rebased(path)
        cfg = self.cfg
        abstract = self.src.resolve(path, 'abstract_type')
        if (abstract and abstract.strip() == path) or path in group.get('abstract', []):
            return [target, f'\tabstract_type = {target}'], None
        if group.get('engine'):
            written = self.engine_vars(path, group, ported)
        else:
            written = self.weapon_vars(path, cfg)
        # Reset what the module's root of the kind sets and this type does not.
        resets = dict(cfg['resets'], **group.get('resets', {}))
        for var in sorted(self.chain_vars(target)):
            if var not in written and var in resets:
                written[var] = resets[var]
            elif var not in written and var not in cfg['keep_inherited']:
                self.notes[f'{group_name}: inherited from the module root: {var}'] += 1
        self.blank_worn(written)
        lines = [target] + [f'\t{name} = {value}' for name, value in written.items()]
        return lines, self.numbers(path, target, group_name)

    def engine_vars(self, path, group, ported):
        """Clothing: the engine's own block with the group's var table (the wardrobe's), then the slot's default worn
        sheet of Vibelin when the item names none."""
        saved = self.cfg
        self.cfg = dict(saved, **group['engine'])
        try:
            block = engine.Porter.block(self, path, ported) or [path]
        finally:
            self.cfg = saved
        written = collections.OrderedDict(line.strip().split(' = ', 1) for line in block[1:])
        if 'worn_icon' not in written and group.get('slot_worn_sheets'):
            own = (written.get('icon_state') or '').strip('"')
            held = self.src.expand(self.src.resolve(path, 'item_state') or 'null').strip('"')
            slots = set(TOKEN.findall(self.src.resolve(path, 'slot_flags') or ''))
            for slot, sheet in group.get('slot_worn_sheets', {}).items():
                source = os.path.join(self.source_root, sheet)
                if slot not in slots or not os.path.isfile(source):
                    continue
                sheet_states = engine.dmi_meta(source)[2]
                # Vibelin's build_worn_icon() draws the worn sprite by icon_state; item_state is for the hands.
                state = own if own in sheet_states else held if held in sheet_states else None
                if state:
                    written['worn_icon'] = f"'{self.asset(sheet)}'"
                    if state != (written.get('icon_state') or '').strip('"'):
                        written['worn_icon_state'] = f'"{state}"'
                    break
            else:
                self.notes['clothing without a worn sprite'] += 1
        material = (self.src.resolve(path, 'melting_material') or '').strip()
        smelt = (self.src.resolve(path, 'smeltresult') or '').strip()
        if smelt in self.target_types:
            written['smeltresult'] = smelt
        elif material in self.cfg['material_ingots'] and self.cfg['material_ingots'][material] in self.target_types:
            written['smeltresult'] = self.cfg['material_ingots'][material]
        for var in ('anvilrepair', 'sewrepair'):
            raw = self.src.resolve(path, var)
            if var == 'sewrepair':
                if raw and self.number(raw):
                    written['sewrepair'] = 'TRUE'
            elif raw and raw.strip() != 'null':
                value = self.mapped_path(raw, self.cfg['skill_map'], path)
                if value:
                    written[var] = value
        for ours, theirs in (('rogue_grid_width', 'grid_width'), ('rogue_grid_height', 'grid_height')):
            value = self.number(self.src.resolve(path, theirs))
            if value:
                written[ours] = self.fmt(value)
        if group.get('look'):
            self.look(path, written)
        return written

    def weapon_vars(self, path, cfg):
        written = collections.OrderedDict()
        resolve = lambda var: self.src.resolve(path, var)

        def put(var, raw, handler=None):
            if raw is None:
                return
            value = handler(raw) if handler else self.literal(raw)
            if value is None:
                self.dropped[f'{var} = {raw[:60]}'] += 1
                return
            written[var] = value

        put('name', resolve('name'))
        put('desc', resolve('desc'))
        put('icon', resolve('icon'))
        put('icon_state', resolve('icon_state'))
        put('w_class', resolve('w_class'))
        slots = resolve('slot_flags')
        if slots is not None:
            written['slot_flags'] = self.flags(slots, cfg['slot_flags'])
        for var in ('possible_item_intents', 'gripped_intents'):
            found = self.intents(resolve(var))
            written[var] = 'list(' + ', '.join(found) + ')' if found else 'null'
        for var in ('associated_skill', 'anvilrepair'):
            raw = resolve(var)
            if raw and raw.strip() != 'null':
                value = self.mapped_path(raw, cfg['skill_map'], path)
                if value:
                    written[var] = value
                else:
                    self.dropped[f'{var} = {raw[:60]}'] += 1
        put('can_parry', resolve('can_parry'))
        put('wlength', resolve('wlength'))
        # Vibelin's balance is a dodge scale from -2 to 2 (EASY_TO_DODGE ... VERY_HARD_TO_DODGE); the module's code
        # reads only its three steps (== WBALANCE_SWIFT, == WBALANCE_HEAVY).
        balance = self.number(resolve('wbalance'))
        if balance is not None:
            written['wbalance'] = 'WBALANCE_SWIFT' if balance > 0 else 'WBALANCE_HEAVY' if balance < 0 else 'WBALANCE_NORMAL'
        blade = self.number(resolve('max_blade_int'))
        if blade:
            written['max_blade_int'] = self.fmt(blade)
        special = resolve('weapon_special')
        if special and special.strip() != 'null':
            if special.strip() in self.target_types:
                written['special'] = special.strip()
            else:
                self.dropped[f'special = {special[:60]}'] += 1
        smelt = resolve('smeltresult')
        if smelt and smelt.strip() in self.target_types:
            written['smeltresult'] = smelt.strip()
        else:
            material = (resolve('melting_material') or '').strip()
            if material in cfg['material_ingots'] and cfg['material_ingots'][material] in self.target_types:
                written['smeltresult'] = cfg['material_ingots'][material]
        for ours, theirs in (('rogue_grid_width', 'grid_width'), ('rogue_grid_height', 'grid_height')):
            value = self.number(resolve(theirs))
            if value:
                written[ours] = self.fmt(value)
        coverage = self.number(resolve('coverage'))
        if coverage:
            written['coverage'] = self.fmt(coverage)
        self.look(path, written)
        return written

    def look(self, path, written):
        """World offset of a 64px sprite, held sprites (baked, or Vibelin's hand sheets) and worn sheets."""
        cfg = self.cfg
        icon = FILE_REF.match(written.get('icon') or '')
        state = (written.get('icon_state') or '').strip('"')
        width = height = 32
        states = set()
        if icon:
            width, height, states = engine.dmi_meta(self.asset_path(icon.group(1)))
        for var in ('pixel_x', 'pixel_y'):
            own = self.number(self.src.resolve(path, var))
            if own:
                written[var] = self.fmt(own)
            elif width == 64:
                written[var] = '-16'
        if not icon or not state or state not in states:
            if icon and state:
                self.notes['world sprite state missing in its icon'] += 1
            return
        sheets = f"{cfg['bake']['dir']}/{icon.group(1)[len(cfg['assets']) + 1:-len('.dmi')]}" if icon.group(1).startswith(cfg['assets'] + '/') \
            else f"{cfg['bake']['dir']}/{icon.group(1).split('/icons/', 1)[-1][:-len('.dmi')]}"
        hands = {}
        if self.truthy(path, 'experimental_inhand') and self.onmob_prop(path, 'gen'):
            hands[''] = self.onmob_prop(path, 'gen')
            wielded = self.onmob_prop(path, 'wielded')
            if wielded and written.get('gripped_intents', 'null') != 'null':
                hands['_wielded'] = wielded
        baked = False
        if hands:
            name = rockhill.bake_name((icon.group(1), 'hands'), state, json.dumps(hands, sort_keys=True))
            for suffix, prop in hands.items():
                sprite = state + suffix if suffix == '_wielded' and self.truthy(path, 'gripsprite') and state + suffix in states else state
                rockhill.bake_jobs(f'{sheets}_righthand.dmi', name + suffix, icon.group(1), sprite, prop, False)
                rockhill.bake_jobs(f'{sheets}_lefthand.dmi', name + suffix, icon.group(1), sprite, prop, True)
            left, right = f'{sheets}_lefthand.dmi', f'{sheets}_righthand.dmi'
            if self.sheet_has(left, name) and self.sheet_has(right, name):
                written['lefthand_file'] = f"'{left}'"
                written['righthand_file'] = f"'{right}'"
                written['inhand_icon_state'] = 'null' if name == state else f'"{name}"'
                written['inhand_x_dimension'] = '64'
                written['inhand_y_dimension'] = '64'
                written['rogue_baked_inhand'] = 'TRUE'
                baked = True
                self.baked_used += 1
            else:
                self.baked_missing += 1
        if not baked:
            hand_state = (self.src.expand(self.src.resolve(path, 'item_state') or 'null')).strip('"')
            hand_state = state if hand_state in ('null', '') else hand_state
            for var in ('lefthand_file', 'righthand_file'):
                ref = FILE_REF.match(self.src.expand(self.src.resolve(path, var) or ''))
                copied = None
                if ref and os.path.isfile(os.path.join(self.source_root, ref.group(1))):
                    frame_w, frame_h, hand_states = engine.dmi_meta(os.path.join(self.source_root, ref.group(1)))
                    if hand_state in hand_states:
                        copied = self.asset(ref.group(1))
                        written['inhand_x_dimension'] = str(frame_w)
                        written['inhand_y_dimension'] = str(frame_h)
                if copied:
                    written[var] = f"'{copied}'"
            if 'lefthand_file' in written:
                written['inhand_icon_state'] = 'null' if hand_state == state else f'"{hand_state}"'
        worn = {}
        if self.truthy(path, 'experimental_onback') and self.onmob_prop(path, 'onback'):
            worn['back'] = self.onmob_prop(path, 'onback')
        if self.truthy(path, 'experimental_onhip') and self.onmob_prop(path, 'onbelt'):
            worn['hip'] = self.onmob_prop(path, 'onbelt')
        if worn:
            name = rockhill.bake_name((icon.group(1), 'worn'), state, json.dumps(worn, sort_keys=True))
            out = f'{sheets}_onmob.dmi'
            first = None
            if 'back' in worn:
                rockhill.bake_jobs(out, f'back_{name}', icon.group(1), state, worn['back'], True)
                rockhill.bake_jobs(out, f'backr_{name}', icon.group(1), state, worn['back'], False)
                first = first or f'back_{name}'
            if 'hip' in worn:
                rockhill.bake_jobs(out, f'hipl_{name}', icon.group(1), state, worn['hip'], True)
                rockhill.bake_jobs(out, f'hipr_{name}', icon.group(1), state, worn['hip'], False)
                first = first or f'hipl_{name}'
            if self.sheet_has(out, first) or self.sheet_has(out, first + '_behind'):
                written['rogue_onmob_sheet'] = f"'{out}'"
                if name != state:
                    written['rogue_onmob_state'] = f'"{name}"'

    def numbers(self, path, target, group_name):
        entry = collections.OrderedDict()
        for field, spec in self.cfg['numbers'].items():
            value = self.number(self.src.resolve(path, spec['var']))
            if value is None:
                continue
            value *= spec.get('scale', {}).get(group_name, 1)
            if spec.get('skip_zero') and not value:
                continue
            entry[field] = self.fmt(value, spec.get('round') if spec.get('scale', {}).get(group_name) else None)
        return (target[len('/obj/item/'):], entry) if entry else None

    # -- the run -------------------------------------------------------------------------------------------------

    def classify(self, path, wanted):
        for name, group in self.cfg['groups'].items():
            for rule in group.get('skip', []):
                if under(path, rule['prefix']):
                    return name, None, rule['reason']
        best = None
        for name, group in self.cfg['groups'].items():
            for rule in group['rebase']:
                if under(path, rule['prefix']) and (best is None or len(rule['prefix']) > len(best[1]['prefix'])):
                    best = (name, rule)
        if not best:
            return None, None, self.cfg['no_rule_reason']
        return best[0], best[1], None

    def port(self, wanted, lists, dry_run):
        rows = [r for r in read_tsv(SELECTION) if r['pick'] == 'vibelin']
        chosen = collections.defaultdict(list)
        skipped = []
        # port.json "ported_elsewhere": exact Vibelin paths (not their subtypes) whose pair another build's porter brings
        # anyway, e.g. as a dependency of its outfits; the item would come twice.
        elsewhere = self.cfg.get('ported_elsewhere', {})
        for row in [r for r in rows if r['type'] in elsewhere]:
            skipped.append({'kind': row['kind'], 'type': row['type'], 'name': row['name'], 'group': '', 'reason': elsewhere[row['type']]})
        rows = [r for r in rows if r['type'] not in elsewhere]
        for row in rows:
            group, rule, reason = self.classify(row['type'], wanted)
            if reason:
                if group is None or group in wanted:
                    skipped.append({'kind': row['kind'], 'type': row['type'], 'name': row['name'], 'group': group or '', 'reason': reason})
                continue
            if group in wanted:
                chosen[group].append(row)
        ported_rows = []
        for group_name in wanted:
            group = self.cfg['groups'][group_name]
            if not group.get('file'):
                continue
            paths = sorted(r['type'] for r in chosen[group_name])
            ported = set(paths)
            blocks = {}
            for path in paths:
                block, entry = self.item_block(path, group_name, group, ported)
                blocks[block[0]] = block
                if entry:
                    self.table.append(entry)
                row = next(r for r in chosen[group_name] if r['type'] == path)
                ported_rows.append({'group': group_name, 'type': path, 'target': block[0], 'name': row['name'], 'verdict': row['verdict']})
            # Roots and in-between steps nobody ports are abstract: no empty item of them can be spawned.
            roots = {rule['to'] for rule in group['rebase']}
            for target in list(blocks):
                step = target
                while step.count('/') > 3:
                    step = step.rsplit('/', 1)[0]
                    if step in blocks:
                        continue
                    if any(under(step, r) for r in roots):
                        blocks[step] = [step, f'\tabstract_type = {step}']
            header = ['// Written by modular_redtard/tools/port_vibelin_items.py from modular_redtard/items_vibelin/port.json; do not edit by hand.',
                      '// ' + group['header'], '// Numbers (integrity, force, defense, strength) live in the private mechanics/items.txt.', '']
            text = '\n'.join(header) + '\n' + '\n'.join('\n'.join(blocks[p]) + '\n' for p in sorted(blocks))
            print(f"{group['file']}: {len(paths)} types, {len(blocks) - len(paths)} abstract steps")
            if not dry_run:
                with open(os.path.join(FOLDER, group['file']), 'w', encoding='utf-8', newline='\n') as handle:
                    handle.write(text)
        print(f'{len(self.copies)} files copied, {self.baked_used} held sprites baked, {self.baked_missing} waiting for the bake')
        for what, times in self.dropped.most_common():
            print(f'  dropped ({times}): {what}')
        for what, times in self.dropped_intents.most_common():
            print(f'  intent dropped ({times}): {what}')
        for what, times in self.notes.most_common():
            print(f'  note ({times}): {what}')
        if dry_run:
            return
        for source, target in self.copies.items():
            os.makedirs(os.path.dirname(target), exist_ok=True)
            if not os.path.isfile(target) or open(target, 'rb').read() != open(source, 'rb').read():
                with open(source, 'rb') as a, open(target, 'wb') as b:
                    b.write(a.read())
        self.write_table()
        bake = self.cfg['bake']
        rockhill.write_bake_manifest({'manifest': rel(bake['manifest']), 'mask32': bake['mask32'], 'mask64': bake['mask64']})
        if lists:
            write_tsv(os.path.join(lists, 'k3g_ported.tsv'), ['group', 'type', 'target', 'name', 'verdict'], ported_rows)
            write_tsv(os.path.join(lists, 'k3g_skipped.tsv'), ['kind', 'type', 'name', 'group', 'reason'], skipped)
            print(f'lists: {len(ported_rows)} ported, {len(skipped)} skipped -> {lists}')

    def write_table(self):
        spec = self.cfg['table']
        out = rel(spec['out'])
        section = spec['section']
        lines = [f"# >>> {section}: {spec['note']}", '']
        for item_id, entry in sorted(self.table):
            lines.append(f'[{item_id}]')
            lines += [f'{field} = {value}' for field, value in entry.items()]
            lines.append('')
        lines.append(f'# <<< {section}')
        old = open(out, encoding='utf-8').read() if os.path.isfile(out) else ''
        begin, end = f'# >>> {section}', f'# <<< {section}'
        if begin in old and end in old:
            head, rest = old.split(begin, 1)
            tail = rest.split(end, 1)[1]
            text = head + '\n'.join(lines) + tail
        else:
            text = (old.rstrip('\n') + '\n\n' if old.strip() else '') + '\n'.join(lines) + '\n'
        os.makedirs(os.path.dirname(out), exist_ok=True)
        with open(out, 'w', encoding='utf-8', newline='\n') as handle:
            handle.write(text)
        print(f'{spec["out"]}: {len(self.table)} entries')


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--refresh-selection', action='store_true', help='write items_vibelin/selection.tsv from the K1v lists first')
    parser.add_argument('--groups', help='comma-separated groups of port.json to write (default: all)')
    parser.add_argument('--lists', help='folder for the ported/skipped lists of the run')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    cfg = json.load(open(CONFIG, encoding='utf-8'))
    if args.refresh_selection:
        refresh_selection(cfg)
    wanted = args.groups.split(',') if args.groups else list(cfg['groups'])
    VibelinPorter(cfg).port(wanted, args.lists, args.dry_run)


if __name__ == '__main__':
    main()
