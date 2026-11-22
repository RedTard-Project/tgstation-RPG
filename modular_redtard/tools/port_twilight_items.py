#!/usr/bin/env python3
"""K3v: the items only Twilight Axis has, as flat type blocks of the module.

    py -3 modular_redtard/tools/port_twilight_items.py [--refresh-selection] [--dry-run] [--kinds weapon,armor,...]

Reads items_twilight/port.json. The types are the ones of items_twilight/selection.tsv (the unique Twilight Axis
types of the K1v lists, written by --refresh-selection); each is flattened through Twilight Axis's own inheritance
with the dm_type_port.py engine of ai-skills (read-only use), its vars are renamed to the module's, its sprites and
sounds copied under items_twilight/assets (or pointed at the identical file the module already has), and one block
written into the .dm file of its kind. The numbers of an item (integrity, force, defense, strength, ...) are not
written into the type: they go to the section `# >>> port_twilight_items.py` of the staged items table that
the block's assembler merges into the private config/redtard_private/mechanics/items.txt.

Read-only on the Twilight Axis source and on everything outside items_twilight/ and the staging folder. No git.
"""

import argparse
import collections
import csv
import hashlib
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
FOLDER = os.path.join(REPO, 'modular_redtard', 'items_twilight')
CONFIG = os.path.join(FOLDER, 'port.json')

# The generic engine lives in ai-skills; a copy beside the repository is found by its sibling folder or the variable.
for candidate in (os.environ.get('REDTARD_AI_SKILLS_SCRIPTS', ''), os.path.join(REPO, '..', 'ai-skills', 'scripts')):
    if candidate and os.path.isfile(os.path.join(candidate, 'dm_type_port.py')):
        sys.path.insert(0, candidate)
        break
import dm_type_port as engine  # noqa: E402

CYRILLIC = re.compile('[Ѐ-ӿ]')
FILE_REF = re.compile(r"'([^']+)'")
ARMOR_FIELDS = ('blunt', 'slash', 'stab', 'piercing', 'fire', 'acid', 'magic')
TYPE_PATH = re.compile(r'/[A-Za-z_][A-Za-z0-9_]*(?:/[A-Za-z_][A-Za-z0-9_]*)*')
# Rockhill's one-empty-state worn sheet and TG's default worn sheets per slot (TG's worn_icons unit test reads them).
BLANK_WORN = 'modular_redtard/rockhill/icons/blank_worn.dmi'
TG_WORN_SHEETS = {
    'ITEM_SLOT_BACK': 'icons/mob/clothing/back.dmi', 'ITEM_SLOT_ID': 'icons/mob/clothing/id.dmi',
    'ITEM_SLOT_GLOVES': 'icons/mob/clothing/hands.dmi', 'ITEM_SLOT_EYES': 'icons/mob/clothing/eyes.dmi',
    'ITEM_SLOT_EARS': 'icons/mob/clothing/ears.dmi', 'ITEM_SLOT_NECK': 'icons/mob/clothing/neck.dmi',
    'ITEM_SLOT_MASK': 'icons/mob/clothing/mask.dmi', 'ITEM_SLOT_BELT': 'icons/mob/clothing/belt.dmi',
}

# Ratwood/Twilight body part flags as the module's rogue_coverage, in the order written (as port_rockhill.py does).
EXACT_COVERAGE = collections.OrderedDict((
    ('HEAD', 'HEAD'), ('HAIR', 'ROGUE_COVER_HAIR'), ('EARS', 'ROGUE_COVER_EARS'),
    ('RIGHT_EYE', 'ROGUE_COVER_RIGHT_EYE'), ('LEFT_EYE', 'ROGUE_COVER_LEFT_EYE'),
    ('NOSE', 'ROGUE_COVER_NOSE'), ('MOUTH', 'ROGUE_COVER_MOUTH'), ('NECK', 'NECK'),
    ('CHEST', 'CHEST'), ('VITALS', 'ROGUE_COVER_VITALS'), ('GROIN', 'GROIN'),
    ('ARM_RIGHT', 'ARM_RIGHT'), ('ARM_LEFT', 'ARM_LEFT'), ('HAND_RIGHT', 'HAND_RIGHT'), ('HAND_LEFT', 'HAND_LEFT'),
    ('LEG_RIGHT', 'LEG_RIGHT'), ('LEG_LEFT', 'LEG_LEFT'), ('FOOT_RIGHT', 'FOOT_RIGHT'), ('FOOT_LEFT', 'FOOT_LEFT'),
))
EXACT_GROUPS = (
    ('ROGUE_COVER_HEAD_PARTS', ('HAIR', 'EARS', 'RIGHT_EYE', 'LEFT_EYE', 'NOSE', 'MOUTH')),
    ('ROGUE_COVER_FACE', ('EARS', 'RIGHT_EYE', 'LEFT_EYE', 'NOSE', 'MOUTH')),
    ('ROGUE_COVER_EYES', ('RIGHT_EYE', 'LEFT_EYE')),
    ('ARMS', ('ARM_RIGHT', 'ARM_LEFT')), ('HANDS', ('HAND_RIGHT', 'HAND_LEFT')),
    ('LEGS', ('LEG_RIGHT', 'LEG_LEFT')), ('FEET', ('FOOT_RIGHT', 'FOOT_LEFT')),
)
TG_COVERAGE = {
    'HEAD': 'HEAD', 'MOUTH': 'HEAD', 'NOSE': 'HEAD', 'EARS': 'HEAD', 'HAIR': 'HEAD', 'LEFT_EYE': 'HEAD', 'RIGHT_EYE': 'HEAD',
    'CHEST': 'CHEST', 'VITALS': 'CHEST', 'GROIN': 'GROIN', 'NECK': 'NECK',
    'LEG_LEFT': 'LEG_LEFT', 'LEG_RIGHT': 'LEG_RIGHT', 'FOOT_LEFT': 'FOOT_LEFT', 'FOOT_RIGHT': 'FOOT_RIGHT',
    'ARM_LEFT': 'ARM_LEFT', 'ARM_RIGHT': 'ARM_RIGHT', 'HAND_LEFT': 'HAND_LEFT', 'HAND_RIGHT': 'HAND_RIGHT',
}
SLOT_FLAG_MAP = {
    'ITEM_SLOT_PANTS': 'ITEM_SLOT_ICLOTHING', 'ITEM_SLOT_ICLOTHING': 'ITEM_SLOT_ICLOTHING',
    'ITEM_SLOT_SHIRT': 'ITEM_SLOT_ROGUE_SHIRT', 'ITEM_SLOT_ARMOR': 'ITEM_SLOT_OCLOTHING',
    'ITEM_SLOT_OCLOTHING': 'ITEM_SLOT_OCLOTHING', 'ITEM_SLOT_SHOES': 'ITEM_SLOT_FEET',
    'ITEM_SLOT_GLOVES': 'ITEM_SLOT_GLOVES', 'ITEM_SLOT_RING': 'ITEM_SLOT_ROGUE_RING',
    'ITEM_SLOT_MOUTH': 'ITEM_SLOT_ROGUE_MOUTH', 'ITEM_SLOT_MASK': 'ITEM_SLOT_MASK', 'ITEM_SLOT_HEAD': 'ITEM_SLOT_HEAD',
    'ITEM_SLOT_CLOAK': 'ITEM_SLOT_ROGUE_CLOAK', 'ITEM_SLOT_NECK': 'ITEM_SLOT_NECK', 'ITEM_SLOT_BELT': 'ITEM_SLOT_BELT',
    'ITEM_SLOT_BACK_R': 'ITEM_SLOT_BACK', 'ITEM_SLOT_BACK_L': 'ITEM_SLOT_BACK', 'ITEM_SLOT_BACK': 'ITEM_SLOT_BACK',
    'ITEM_SLOT_HIP': 'ITEM_SLOT_POCKETS', 'ITEM_SLOT_WRISTS': 'ITEM_SLOT_ROGUE_WRISTS', 'ITEM_SLOT_POCKETS': 'ITEM_SLOT_POCKETS',
}


def under(path, prefixes):
    return any(path == p or path.startswith(p + '/') for p in prefixes)


def digest(path):
    with open(path, 'rb') as handle:
        return hashlib.sha1(handle.read()).hexdigest()


def declared_types(roots, skip_dirs):
    """Every type path the module (and the core) declares, outside the folders this porter writes."""
    declared = set()
    skip = [os.path.normcase(os.path.abspath(s)) for s in skip_dirs]
    for root in roots:
        for dp, dn, fn in os.walk(root):
            if any(os.path.normcase(os.path.abspath(dp)).startswith(s) for s in skip):
                dn[:] = []
                continue
            for f in fn:
                if not f.endswith('.dm'):
                    continue
                for line in open(os.path.join(dp, f), encoding='utf-8', errors='ignore'):
                    m = re.match(r'^(/[A-Za-z0-9_/]+)', line)
                    if not m:
                        continue
                    parts = m.group(1).rstrip('/').split('/')
                    for k in range(2, len(parts) + 1):
                        if parts[k - 1] in ('proc', 'verb', 'var'):
                            break
                        declared.add('/'.join(parts[:k]))
    return declared


def refresh_selection(cfg):
    lists = os.path.join(REPO, cfg['selection_lists'])
    missing = list(csv.DictReader(open(os.path.join(lists, 'missing_twilight.tsv'), encoding='utf-8'), delimiter='\t'))
    dups = {r['type']: r for r in csv.DictReader(open(os.path.join(lists, 'duplicates.tsv'), encoding='utf-8'), delimiter='\t')}
    rows = []
    for r in missing:
        dup = dups.get(r['type'])
        if dup is None or dup['pick'] == 'twilight':
            rows.append((r['kind'], r['type'], r['name'], 'twilight' if dup else 'unique'))
    rows.sort(key=lambda r: (r[0], r[1]))
    with open(os.path.join(REPO, cfg['selection']), 'w', encoding='utf-8', newline='\n') as out:
        out.write('kind\ttype\tname\tpick\n')
        for r in rows:
            out.write('\t'.join(r) + '\n')
    print(f'selection: {len(rows)} types from {lists}')


class TwilightPorter(engine.Porter):
    def __init__(self, cfg, source):
        # the engine reads Twilight Axis through its compile (roguetown.dme); the module's own scan comes below.
        self.cfg = cfg
        self.repo = REPO
        self.source_root = source
        self.files = engine.compiled_files(source, cfg.get('dme'))
        types, defines, self.declared_in = engine.parse(self.files)
        self.src = engine.Source(types, defines)
        scan_roots = [os.path.join(REPO, d) for d in cfg['module_dirs']]
        self.known_defines = engine.scan_defines([os.path.join(REPO, d) for d in cfg['target_defines']]) | engine.BUILTIN
        self.module_types = declared_types(scan_roots, [FOLDER])
        self.dropped = collections.Counter()
        self.skipped = collections.OrderedDict()
        self.copies = {}
        self.sources = {}
        self.reuse = {}
        self.table = collections.OrderedDict()
        self.datums = {}
        self.notes = collections.Counter()
        self.untranslated = []
        self.unknown_intents = collections.Counter()
        self.unknown_paths = collections.Counter()
        self.index = None
        self.worn_missing = []

    # ---- files -------------------------------------------------------------------------------------------------

    def module_index(self):
        """Files of the module's icon and sound folders by (basename, size), to find the identical file already there."""
        if self.index is None:
            self.index = collections.defaultdict(list)
            for root in self.cfg['reuse_dirs']:
                for dp, _dn, fn in os.walk(os.path.join(REPO, root)):
                    for f in fn:
                        if f.lower().endswith(('.dmi', '.ogg', '.wav', '.mp3')):
                            full = os.path.join(dp, f)
                            self.index[(f.lower(), os.path.getsize(full))].append(full)
        return self.index

    def asset(self, ref):
        source = os.path.join(self.source_root, ref)
        if not os.path.isfile(source):
            self.notes['file missing in the source: ' + ref.split('/')[0]] += 1
            return None
        if source in self.reuse:
            return self.reuse[source]
        wanted = None
        for found in self.module_index().get((os.path.basename(source).lower(), os.path.getsize(source)), ()):
            wanted = wanted or digest(source)
            if digest(found) == wanted:
                relative = os.path.relpath(found, REPO).replace('\\', '/')
                self.reuse[source] = relative
                self.notes['files reused from the module'] += 1
                return relative
        target = '/'.join([self.cfg['assets'].rstrip('/'), ref.replace('\\', '/')])
        self.copies[source] = os.path.join(REPO, target)
        self.sources[target] = source
        self.reuse[source] = target
        return target

    def states_of(self, ref_path):
        cache = self.__dict__.setdefault('_states', {})
        if ref_path not in cache:
            cache[ref_path] = engine.dmi_meta(self.sources.get(ref_path) or os.path.join(REPO, ref_path))
        return cache[ref_path]

    # ---- values ------------------------------------------------------------------------------------------------

    def literal(self, value):
        """The engine's literal, except that a define the module knows stays a define (WEIGHT_CLASS_BULKY)."""
        text = value.strip()
        if engine.TOKEN.fullmatch(text) and text in self.known_defines and text not in engine.BUILTIN:
            return text
        return super().literal(value)

    def number(self, raw):
        value = self.literal(raw)
        if value is None or not engine.NUMBER.match(value):
            return None
        return value

    def expand_text(self, raw, stop=()):
        """The text with every define of the source worked into it, except the names in stop."""
        text = raw
        for _ in range(8):
            changed = engine.TOKEN.sub(lambda m: f'({self.src.defines[m.group(0)]})' if m.group(0) in self.src.defines and m.group(0) not in stop else m.group(0), text)
            if changed == text:
                break
            text = changed
        return text

    def slot_flags(self, raw):
        if raw.strip() in ('0', 'null', 'NONE'):
            return 'NONE'
        text = self.expand_text(raw, SLOT_FLAG_MAP)
        tokens = [SLOT_FLAG_MAP[t] for t in re.findall(r'ITEM_SLOT_[A-Z_]+', text) if t in SLOT_FLAG_MAP]
        tokens = list(dict.fromkeys(tokens))
        return ' | '.join(tokens) if tokens else None

    def coverage(self, raw):
        """(body_parts_covered, rogue_coverage) of a Ratwood-style body part flag list."""
        names = set(engine.TOKEN.findall(self.expand_text(raw, EXACT_COVERAGE)))
        if raw.strip() in ('0', 'null', 'NONE'):
            return 'NONE', 'NONE'
        tg = [name for name in dict.fromkeys(TG_COVERAGE[n] for n in EXACT_COVERAGE if n in names and n in TG_COVERAGE)]
        exact = [n for n in EXACT_COVERAGE if n in names]
        written = []
        left = set(exact)
        for group, members in EXACT_GROUPS:
            if left >= set(members):
                written.append(group)
                left -= set(members)
        written += [EXACT_COVERAGE[n] for n in EXACT_COVERAGE if n in left]
        return (' | '.join(tg) or 'NONE'), (' | '.join(written) or 'NONE')

    def type_list(self, raw, prefix, known):
        """The type paths of a list or a define that the module declares, in order; the others are counted."""
        out = []
        for path in TYPE_PATH.findall(self.expand_text(raw)):
            path = path.rstrip('/')
            if not path.startswith(prefix):
                continue
            if path in known:
                if path not in out:
                    out.append(path)
            else:
                self.unknown_paths[path] += 1
        return out

    def intent_list(self, raw):
        out = []
        for path in TYPE_PATH.findall(self.expand_text(raw)):
            if not path.startswith('/datum/intent'):
                continue
            if path in self.module_types:
                if path not in out:
                    out.append(path)
            else:
                self.unknown_intents[path] += 1
        return out

    def sound_list(self, raw):
        refs = FILE_REF.findall(self.expand_text(raw))
        out = []
        for ref in refs:
            copied = self.asset(ref)
            if copied:
                out.append(f"'{copied}'")
        return out

    def skill(self, raw):
        path = raw.strip()
        for old, new in self.cfg['skill_paths'].items():
            if path.startswith(old):
                path = new + path[len(old):]
        return path if path in self.module_types else None

    def armor(self, raw):
        """rogue_armor: the datum of a tier define (ARMOR_PLATE -> /datum/rogue_armor/plate) or of a literal rating list.
        A datum the module lacks is declared here and its ratings go to the staged armor table."""
        name = raw.strip()
        text = self.expand_text(name)
        numbers = {}
        for key, token in re.findall(r'"(\w+)"\s*=\s*([^,)]+)', text):
            number = self.arithmetic(token.strip())
            if number is not None:
                numbers[key] = int(float(number))
        fields = collections.OrderedDict((k, max(0, numbers.get(k, 0))) for k in ARMOR_FIELDS)
        if not any(fields.values()):
            return None
        if re.match(r'^ARMOR_[A-Z0-9_]+$', name):
            leaf = name[len('ARMOR_'):].lower()
        elif name.startswith('list('):
            leaf = 'b{blunt}_s{slash}_t{stab}_p{piercing}_f{fire}_a{acid}'.format(**fields)
        else:
            return None
        path = '/datum/rogue_armor/' + leaf
        if path not in self.module_types:
            self.datums[path] = fields
        return path

    # ---- one type ----------------------------------------------------------------------------------------------

    def resolve(self, path, var):
        return self.src.resolve(path, var)

    def block(self, path):
        cfg = self.cfg
        lines = [path]
        written = collections.OrderedDict()
        table = collections.OrderedDict()
        is_clothing = under(path, ['/obj/item/clothing'])
        text_var = lambda var: self.resolve(path, var)

        name = text_var('name')
        if name and CYRILLIC.search(name):
            return None, 'name not in English'
        for var in cfg['vars']:
            if var in cfg['clothing_only'] and not is_clothing:
                continue
            source_var = cfg['rename'].get(var, var)
            raw = self.resolve(path, source_var)
            if raw is None:
                continue
            raw = raw.strip()
            kind = cfg['var_kinds'].get(var)
            value = None
            if var in cfg['table_fields']:
                number = self.number(raw)
                if number is None:
                    self.dropped[f'{var} = {raw[:50]}'] += 1
                elif not (is_clothing and cfg['table_fields'][var] in cfg['clothing_skip_zero'] and float(number) == 0):
                    table[cfg['table_fields'][var]] = number
                continue
            if var in ('name', 'desc'):
                if CYRILLIC.search(raw):
                    if var == 'desc':
                        self.untranslated.append((path, raw))
                    continue
                value = raw if engine.STRING.match(raw) or raw.startswith('{"') else None
            elif var == 'slot_flags':
                value = self.slot_flags(raw)
            elif var == 'body_parts_covered':
                tg, exact = self.coverage(raw)
                written['body_parts_covered'] = tg
                if is_clothing:
                    written['rogue_coverage'] = exact
                continue
            elif var == 'worn_icon':
                value = self.icon_value(raw)
            elif var in ('icon', 'lefthand_file', 'righthand_file'):
                if var != 'icon':
                    continue
                value = self.icon_value(raw)
            elif kind == 'icon':
                value = 'null' if raw == 'null' else self.icon_value(raw)
            elif kind == 'flags':
                value = self.flags(raw, cfg['maps'].get(var, {}))
            elif kind == 'mapped':
                key = raw.strip('()').strip()
                value = cfg['maps'].get(var, {}).get(key)
            elif kind == 'intents':
                items = self.intent_list(raw)
                value = 'list(' + ', '.join(items) + ')' if items else None
                if value is None and raw in ('null', 'list()'):
                    value = raw
            elif kind == 'typelist':
                items = self.type_list(raw, cfg['typelist_prefix'][var], self.module_types)
                value = 'list(' + ', '.join(items) + ')' if items else ('null' if raw == 'null' else None)
            elif kind == 'path':
                found = TYPE_PATH.fullmatch(raw)
                if raw == 'null':
                    value = 'null'
                elif found and raw in self.module_types:
                    value = raw
                elif found:
                    self.unknown_paths[raw] += 1
            elif kind == 'skill':
                value = self.skill(raw)
            elif kind == 'sounds':
                items = self.sound_list(raw)
                value = 'list(' + ', '.join(items) + ')' if items else None
            elif kind == 'armor':
                value = self.armor(raw)
            elif kind == 'string':
                expanded = self.src.expand(raw)
                value = expanded if engine.STRING.match(expanded) or expanded == 'null' else None
            else:
                value = self.literal(raw)
            if value is None:
                self.dropped[f'{var} = {raw[:50]}'] += 1
                continue
            if cfg['defaults'].get(var) == value or (var in cfg['skip_zero'] and value in ('0', '0.0', 'FALSE')):
                continue
            written[var] = value

        for rule in cfg['state_flags']:
            icon = written.get(rule['icon_var'])
            ref = engine.FILE_REF.match(icon or '')
            state = (written.get(rule.get('state_var', '')) or '').strip('"') or (written.get('icon_state') or '').strip('"')
            if ref and state and f"{state}{rule['suffix']}" in self.states_of(ref.group(1))[2]:
                written[rule['var']] = 'TRUE'
        for rule in cfg['icon_size_vars']:
            ref = engine.FILE_REF.match(written.get(rule['icon_var']) or '')
            if ref:
                width, height, _ = self.states_of(ref.group(1))
                if width != 32:
                    written[rule['x']] = str(width)
                if height != 32:
                    written[rule['y']] = str(height)

        worn = engine.FILE_REF.match(written.get('worn_icon') or '')
        worn_state = (written.get('worn_icon_state') or '').strip('"')
        if worn and worn_state not in ('', 'null') and worn_state not in self.states_of(worn.group(1))[2]:
            fallback = (written.get('icon_state') or '').strip('"')
            if fallback and fallback in self.states_of(worn.group(1))[2]:
                written['worn_icon_state'] = 'null'
                self.notes['worn state fell back to the icon state'] += 1
            else:
                # No worn sprite: Rockhill's blank sheet and worn_icon_state = null, TG's way to say so (its worn_icons
                # unit test fails on a state the sheet lacks), as the Ratwood porter does.
                written['worn_icon'] = f"'{BLANK_WORN}'"
                written['worn_icon_state'] = 'null'
                self.notes['worn sprite state missing in its file (item invisible when worn)'] += 1
                self.worn_missing.append(path)
        elif not worn and worn_state not in ('', 'null') and path.startswith('/obj/item/rogueweapon/'):
            # A weapon whose worn state TA's own mob sheets held, under a module weapon without a worn sheet (its back
            # sprite, if any, is a baked rogue_onmob_sheet): no worn sprite, as above.
            slots = set(re.findall(r'ITEM_SLOT_[A-Z_]+', written.get('slot_flags') or ''))
            if slots & set(TG_WORN_SHEETS) and not any(slot in slots and worn_state in self.states_of(sheet)[2] for slot, sheet in TG_WORN_SHEETS.items() if os.path.isfile(os.path.join(REPO, sheet))):
                written['worn_icon'] = f"'{BLANK_WORN}'"
                written['worn_icon_state'] = 'null'
                self.notes['weapon worn state of TA mob sheets: blank worn sheet'] += 1
        icon = engine.FILE_REF.match(written.get('icon') or '')
        state = (written.get('icon_state') or '').strip('"')
        if not icon:
            return None, 'no sprite file'
        if state and state not in self.states_of(icon.group(1))[2]:
            return None, 'sprite state missing in its file'
        lines += [f'\t{var} = {value}' for var, value in written.items()]
        self.table[path] = table
        return lines, None

    def icon_value(self, raw):
        ref = engine.FILE_REF.match(raw.strip())
        if not ref:
            return None
        copied = self.asset(ref.group(1))
        return f"'{copied}'" if copied else None

    # ---- run ---------------------------------------------------------------------------------------------------

    def selection(self, kinds):
        rows = list(csv.DictReader(open(os.path.join(REPO, self.cfg['selection']), encoding='utf-8'), delimiter='\t'))
        return [r for r in rows if r['kind'] in kinds]

    def eligible(self, path):
        cfg = self.cfg
        if path not in self.src.types:
            return 'path not a real type (broken K1v row)'
        if path in self.module_types:
            return 'the module already declares it'
        if under(path, cfg['exclude']):
            return 'excluded family: ' + next(p for p in cfg['exclude'] if path == p or path.startswith(p + '/'))
        ancestor = path.rsplit('/', 1)[0]
        while ancestor.count('/') > 1 and ancestor not in self.module_types:
            ancestor = ancestor.rsplit('/', 1)[0]
        if ancestor in ('/obj/item', '/obj'):
            return 'no module ancestor below /obj/item'
        if ancestor in cfg['bad_ancestors']:
            return 'module ancestor is a core base: ' + ancestor
        return None

    def run(self, kinds, dry_run):
        rows = self.selection(kinds)
        per_kind = collections.defaultdict(list)
        reasons = collections.OrderedDict()
        done = collections.Counter()
        for r in rows:
            path = r['type']
            why = self.eligible(path)
            if why:
                reasons[path] = (r['kind'], why)
                continue
            lines, why = self.block(path)
            if lines is None:
                reasons[path] = (r['kind'], why)
                continue
            per_kind[r['kind']].append(lines)
            done[r['kind']] += 1
        self.reasons = reasons
        self.per_kind = per_kind
        self.done = done
        if dry_run:
            return
        os.makedirs(FOLDER, exist_ok=True)
        for source, target in self.copies.items():
            os.makedirs(os.path.dirname(target), exist_ok=True)
            with open(source, 'rb') as a, open(target, 'wb') as b:
                b.write(a.read())
        for kind in kinds:
            spec = self.cfg['out'][kind]
            header = [f'// {line}' for line in self.cfg['header']] + [f'// {spec["note"]}', '']
            body = ['\n'.join(block) + '\n' for block in per_kind.get(kind, [])]
            out = os.path.join(REPO, spec['file'])
            if not body:
                if os.path.exists(out):
                    os.remove(out)
                continue
            with open(out, 'w', encoding='utf-8', newline='\n') as handle:
                handle.write('\n'.join(header) + '\n' + '\n'.join(body))
        self.write_table()
        self.write_armor()
        self.write_notes(kinds)

    def write_table(self):
        staged = os.path.join(REPO, self.cfg['staged'])
        os.makedirs(os.path.dirname(staged), exist_ok=True)
        begin = '# >>> port_twilight_items.py'
        end = '# <<< port_twilight_items.py'
        lines = [f"{begin}: {self.cfg['table_note']}", '']
        for path in sorted(self.table):
            fields = self.table[path]
            if not fields:
                continue
            lines.append('[' + path[len('/obj/item/'):] + ']')
            lines += [f'{field} = {value}' for field, value in fields.items()]
            lines.append('')
        lines.append(end)
        with open(staged, 'w', encoding='utf-8', newline='\n') as handle:
            handle.write('\n'.join(lines) + '\n')

    def write_armor(self):
        out = os.path.join(REPO, self.cfg['armor_dm'])
        staged = os.path.join(REPO, self.cfg['armor_staged'])
        begin = '# >>> port_twilight_items.py'
        end = '# <<< port_twilight_items.py'
        lines = [f"{begin}: {self.cfg['armor_note']}", '']
        text = ['// ' + line for line in self.cfg['header']]
        text += ['// Armor rating datums the Twilight Axis items need and the module lacks (their ratings are in the private armor.txt).', '']
        for path in sorted(self.datums):
            text += [path, '']
            lines.append('[' + path[len('/datum/rogue_armor/'):] + ']')
            lines += [f'{k} = {v}' for k, v in self.datums[path].items() if v]
            lines.append('')
        lines.append(end)
        with open(out, 'w', encoding='utf-8', newline='\n') as handle:
            handle.write('\n'.join(text).rstrip('\n') + '\n')
        with open(staged, 'w', encoding='utf-8', newline='\n') as handle:
            handle.write('\n'.join(lines) + '\n')

    def write_notes(self, kinds):
        folder = os.path.join(REPO, self.cfg['work'])
        os.makedirs(folder, exist_ok=True)
        with open(os.path.join(folder, 'k3v_skipped.tsv'), 'w', encoding='utf-8', newline='\n') as out:
            out.write('kind\ttype\treason\n')
            for path, (kind, why) in self.reasons.items():
                out.write(f'{kind}\t{path}\t{why}\n')
        with open(os.path.join(folder, 'k3v_untranslated.tsv'), 'w', encoding='utf-8', newline='\n') as out:
            out.write('type\tdesc\n')
            for path, desc in self.untranslated:
                out.write(f'{path}\t{desc}\n')
        with open(os.path.join(folder, 'k3v_dropped.txt'), 'w', encoding='utf-8', newline='\n') as out:
            for what, times in self.dropped.most_common():
                out.write(f'{times}\t{what}\n')
            out.write('\n# worn sprite state missing in its file\n')
            for path in self.worn_missing:
                out.write(path + '\n')
            out.write('\n# types the module lacks\n')
            for what, times in self.unknown_paths.most_common():
                out.write(f'{times}\t{what}\n')
            out.write('\n# intents the module lacks\n')
            for what, times in self.unknown_intents.most_common():
                out.write(f'{times}\t{what}\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    parser.add_argument('--refresh-selection', action='store_true')
    parser.add_argument('--dry-run', action='store_true')
    parser.add_argument('--kinds', help='comma list; default: every kind of port.json "kinds"')
    args = parser.parse_args()
    cfg = json.load(open(CONFIG, encoding='utf-8'))
    if args.refresh_selection:
        refresh_selection(cfg)
        return 0
    source = os.environ.get(cfg.get('source_env', ''), '') or os.path.normpath(os.path.join(REPO, cfg['source']))
    if not os.path.isdir(source):
        raise SystemExit(f'Twilight Axis source not found: {source}')
    kinds = args.kinds.split(',') if args.kinds else cfg['kinds']
    porter = TwilightPorter(cfg, source)
    porter.run(kinds, args.dry_run)
    for kind in kinds:
        print(f'{kind}: {porter.done[kind]} types')
    print(f'skipped: {len(porter.reasons)}  files copied: {len(porter.copies)}  reused: {porter.notes["files reused from the module"]}')
    for why, times in collections.Counter(w for _k, w in porter.reasons.values()).most_common():
        print(f'  skipped ({times}): {why}')
    for what, times in porter.notes.items():
        print(f'  {what}: {times}')
    print(f'untranslated descriptions dropped: {len(porter.untranslated)}')
    print(f'dropped values: {sum(porter.dropped.values())}; unknown paths: {len(porter.unknown_paths)}; unknown intents: {len(porter.unknown_intents)}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
