import argparse
import collections
import os
import re
import shutil
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dmi

MODULE = 'modular_redtard'
ROOTS = ('code', MODULE)
SKIP_DIRS = {'.git', '.cache', 'node_modules', '__pycache__'}
TYPE_RE = re.compile(r'^(/[\w/]+)\s*(?://.*)?$')
ASSIGN_RE = re.compile(r'^\t(?:var/(?:\w+/)*)?(\w+)\s*=\s*(.+?)\s*$')
DEFINE_RE = re.compile(r'^\s*#define\s+(\w+)(\(?)\s*(.*?)\s*$')
FILE_RE = re.compile(r"^'([^']+)'$")
STRING_RE = re.compile(r'^"((?:[^"\\\[]|\\.)*)"$')
PATH_RE = re.compile(r'^(/[\w/]+)$')
CONSTANT_RE = re.compile(r'\b[A-Z][A-Z0-9_]{2,}\b')
ROOT_PARENTS = {'/obj': '/atom/movable', '/mob': '/atom/movable', '/atom/movable': '/atom', '/turf': '/atom', '/area': '/atom', '/atom': '/datum'}
MISSING = object()
WORN_FILES = (
    ('ITEM_SLOT_BACK', 'icons/mob/clothing/back.dmi'),
    ('ITEM_SLOT_ID', 'icons/mob/clothing/id.dmi'),
    ('ITEM_SLOT_GLOVES', 'icons/mob/clothing/hands.dmi'),
    ('ITEM_SLOT_EYES', 'icons/mob/clothing/eyes.dmi'),
    ('ITEM_SLOT_EARS', 'icons/mob/clothing/ears.dmi'),
    ('ITEM_SLOT_NECK', 'icons/mob/clothing/neck.dmi'),
    ('ITEM_SLOT_MASK', 'icons/mob/clothing/mask.dmi'),
    ('ITEM_SLOT_BELT', 'icons/mob/clothing/belt.dmi'),
)
ARMOR_WEARS = (('/obj/item/clothing/gloves', 'HANDS'), ('/obj/item/clothing/shoes', 'FEET'))
ARMOR_PROTECTIONS = ('melee', 'bomb', 'energy', 'laser', 'bullet', 'wound')
MERGE_BLACKLIST = {'/obj/item/stack/sheet', '/obj/item/stack/sheet/mineral', '/obj/item/stack/ore', '/obj/item/stack/spacecash', '/obj/item/stack/license_plates', '/obj/item/stack/tile/mineral', '/obj/item/stack/tile'}
KINDS = ('icons', 'inhands', 'worn', 'turfs', 'closets', 'armor', 'stacks', 'reagents', 'constants', 'paths')
RESOURCE_RE = re.compile(r"'([^'\n]+\.(?:dmi|png|ogg|wav|mid|ttf|json|txt|html|css|js))'")


def byond_bin():
    candidates = [os.path.dirname(entry) for entry in os.environ.get('DM_EXE', '').split(',') if entry]
    candidates += [os.path.dirname(found) for found in (shutil.which('dm'), shutil.which('DreamMaker')) if found]
    if sys.platform == 'win32':
        import winreg
        for key in (r'SOFTWARE\WOW6432Node\Dantom\BYOND', r'Software\Dantom\BYOND'):
            try:
                with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, key) as handle:
                    candidates.append(os.path.join(winreg.QueryValueEx(handle, 'installpath')[0], 'bin'))
            except OSError:
                pass
    for directory in candidates:
        for name in ('byondcore.dll', 'libbyond.so'):
            if os.path.isfile(os.path.join(directory, name)):
                return os.path.join(directory, name)
    return None


def byond_constants():
    library = byond_bin()
    if not library:
        return None
    return {name.decode() for name in re.findall(rb'#define\s+([A-Za-z_]\w*)', open(library, 'rb').read())}


def walk_dm(root):
    for dirpath, dirnames, files in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for name in files:
            if name.endswith('.dm'):
                yield os.path.join(dirpath, name).replace('\\', '/')


def strip_comment(value):
    quote = None
    index = 0
    while index < len(value):
        char = value[index]
        if quote:
            if char == '\\':
                index += 1
            elif char == quote:
                quote = None
        elif char in '"\'':
            quote = char
        elif value.startswith('//', index):
            return value[:index].rstrip()
        index += 1
    return value


class Tree:
    def __init__(self):
        self.vars = collections.defaultdict(dict)
        self.module = set()
        self.core = set()
        self.defines = {}
        for root in ROOTS:
            for path in walk_dm(root):
                self.read(path, root == MODULE)
        self.children = collections.defaultdict(set)
        for path in self.module | self.core:
            parent = self.parent(path)
            if parent:
                self.children[parent].add(path)

    def read(self, path, ours):
        lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
        current = None
        index = 0
        while index < len(lines):
            line = lines[index].rstrip('\r')
            index += 1
            define = DEFINE_RE.match(line)
            if define:
                if not define.group(2):
                    self.defines[define.group(1)] = strip_comment(define.group(3))
                continue
            if line[:1] == '/' and not line.startswith('//'):
                match = TYPE_RE.match(line)
                current = match.group(1).rstrip("/") if match else None
                if current:
                    (self.module if ours else self.core).add(current)
                continue
            if not current or not line.startswith('\t'):
                if line and not line.startswith(('\t', ' ', '#')):
                    current = None
                continue
            match = ASSIGN_RE.match(line)
            if not match:
                continue
            value = strip_comment(match.group(2))
            while value.count('(') > value.count(')') and index < len(lines):
                value += ' ' + strip_comment(lines[index].strip())
                index += 1
            self.vars[current][match.group(1)] = value

    def parent(self, path):
        own = self.vars.get(path, {}).get('parent_type')
        if own and PATH_RE.match(own):
            return own
        if path in ROOT_PARENTS:
            return ROOT_PARENTS[path]
        if path.count('/') <= 1:
            return None
        return path.rsplit('/', 1)[0]

    def ancestry(self, path):
        seen = []
        while path and path not in seen:
            seen.append(path)
            path = self.parent(path)
        return seen

    def raw(self, path, name):
        for step in self.ancestry(path):
            value = self.vars.get(step, {}).get(name)
            if value is not None:
                return value
        return MISSING

    def is_a(self, path, root):
        return root in self.ancestry(path)

    def file(self, path, name):
        value = self.raw(path, name)
        match = FILE_RE.match(value) if isinstance(value, str) else None
        if match:
            return match.group(1)
        return None if value in ('null', MISSING) else MISSING

    def text(self, path, name):
        value = self.raw(path, name)
        if value is MISSING or value == 'null':
            return None
        match = STRING_RE.match(value)
        return match.group(1).replace('\\"', '"') if match else MISSING

    def number(self, expression, depth=0):
        if expression is MISSING or expression is None or depth > 20:
            return None
        text = expression.strip()
        if text in ('null', ''):
            return 0
        resolved = re.sub(r'(?<![\w.])[A-Za-z_]\w*', lambda m: f'({self.define_value(m.group(0), depth)})', text)
        if 'None' in resolved or not re.fullmatch(r'[\d\s|&<>~()+\-*xXa-fA-F.]+', resolved):
            return None
        try:
            return int(eval(resolved, {'__builtins__': {}}))
        except Exception:
            return None

    def define_value(self, name, depth):
        if name not in self.defines:
            return 'None'
        value = self.number(self.defines[name], depth + 1)
        return 'None' if value is None else str(value)

    def flags(self, path, name):
        return self.number(self.raw(path, name))

    def abstract(self, path):
        return self.raw(path, 'abstract_type') == path

    def subtypes(self, root):
        found = []
        pending = [root]
        while pending:
            for child in self.children.get(pending.pop(), ()):
                found.append(child)
                pending.append(child)
        return found


def exact_path(path, listings):
    current = '.'
    for part in path.split('/'):
        if current not in listings:
            listings[current] = set(os.listdir(current)) if os.path.isdir(current) else set()
        if part not in listings[current]:
            return False
        current = os.path.join(current, part)
    return True


def list_entries(value):
    if not isinstance(value, str) or not value.startswith('list('):
        return []
    body = value[len('list('):value.rfind(')')]
    return [entry.strip() for entry in body.split(',') if entry.strip()]


def main():
    parser = argparse.ArgumentParser(description='Static pre-flight of modular_redtard content against the TG unit tests that walk every type.')
    parser.add_argument('-v', '--verbose', action='store_true')
    args = parser.parse_args()
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, 'reconfigure'):
            stream.reconfigure(encoding='utf-8', errors='replace')

    tree = Tree()
    ours = sorted(tree.module - tree.core)
    states = {}
    problems = collections.defaultdict(list)

    def has_state(icon, state):
        if icon not in states:
            states[icon] = dmi.state_names(icon) if os.path.exists(icon) else None
        if states[icon] is None:
            return None
        return state in states[icon]

    def bit(name):
        return tree.number(name) or 0

    abstract_flag = bit('ABSTRACT')
    pockets = bit('ITEM_SLOT_LPOCKET') | bit('ITEM_SLOT_RPOCKET')
    warned_worn = set()

    for path in ours:
        if not tree.is_a(path, '/obj') or tree.abstract(path):
            continue
        item = tree.is_a(path, '/obj/item')
        if item and (tree.flags(path, 'item_flags') or 0) & abstract_flag:
            continue
        gags = tree.raw(path, 'greyscale_colors') not in ('null', MISSING)

        icon = tree.file(path, 'icon')
        state = tree.text(path, 'icon_state')
        if not (gags and tree.raw(path, 'greyscale_config') not in ('null', MISSING)) and isinstance(icon, str) and isinstance(state, str):
            found = has_state(icon, state)
            if not found:
                problems['icons'].append(f'{path}: {icon} has no "{state}"' if found is False else f'{path}: icon {icon} does not exist')

        if not item or tree.is_a(path, '/obj/item/mod'):
            continue

        held = tree.text(path, 'inhand_icon_state')
        skip_left = gags and tree.raw(path, 'greyscale_config_inhand_left') not in ('null', MISSING)
        skip_right = gags and tree.raw(path, 'greyscale_config_inhand_right') not in ('null', MISSING)
        if isinstance(held, str) and held and not (skip_left and skip_right):
            sides = (('left', tree.file(path, 'lefthand_file'), skip_left), ('right', tree.file(path, 'righthand_file'), skip_right))
            if not any(side[1] for side in sides) and not (skip_left or skip_right):
                problems['inhands'].append(f'{path}: inhand_icon_state "{held}" but no lefthand_file/righthand_file')
            else:
                for side, sheet, skip in sides:
                    if skip or sheet is MISSING:
                        continue
                    if not sheet:
                        problems['inhands'].append(f'{path}: no {side}hand file for inhand_icon_state "{held}"')
                    elif not has_state(sheet, held):
                        problems['inhands'].append(f'{path}: {sheet} has no "{held}"')

        slots = tree.flags(path, 'slot_flags')
        if not slots or slots & pockets:
            continue
        if gags and tree.raw(path, 'greyscale_config_worn') not in ('null', MISSING):
            continue
        worn_icon = tree.file(path, 'worn_icon')
        worn_state = tree.text(path, 'worn_icon_state')
        if worn_icon is MISSING or worn_state is MISSING:
            continue
        look = worn_state or state
        if not isinstance(look, str) or look in warned_worn:
            continue
        if worn_icon:
            if worn_state is not None and not has_state(worn_icon, look):
                problems['worn'].append(f'{path}: worn_icon {worn_icon} has no "{look}"')
            continue
        for flag, sheet in WORN_FILES:
            if slots & bit(flag) and not has_state(sheet, look):
                warned_worn.add(look)
                problems['worn'].append(f'{path}: {flag} without worn_icon, and {sheet} has no "{look}"')

    for path in ours:
        if not tree.is_a(path, '/turf'):
            continue
        icon = tree.file(path, 'icon')
        state = tree.text(path, 'icon_state')
        if not isinstance(icon, str) or not isinstance(state, str):
            continue
        mineral = tree.is_a(path, '/turf/closed/mineral')
        if not mineral and tree.is_a(path, '/turf/closed/indestructible/rock'):
            continue
        if has_state(icon, state) or (mineral and has_state('icons/turf/mining.dmi', state)):
            continue
        problems['turfs'].append(f'{path}: {icon} has no "{state}"')

    for path in ours:
        if not tree.is_a(path, '/obj/structure/closet'):
            continue
        capacity = tree.number(tree.raw(path, 'storage_capacity'))
        contents = len(list_entries(tree.raw(path, 'rockhill_contents'))) + (1 if list_entries(tree.raw(path, 'rockhill_loot')) else 0)
        if capacity is not None and contents > capacity:
            problems['closets'].append(f'{path}: fills {contents} item(s), storage_capacity is {capacity}')

    for path in ours:
        armor = tree.raw(path, 'armor_type')
        armor = armor if isinstance(armor, str) and PATH_RE.match(armor) else None
        if tree.is_a(path, '/obj/item/clothing/under') and not (armor and tree.is_a(armor, '/datum/armor/clothing_under')):
            problems['armor'].append(f'{path}: jumpsuit armor_type {armor} is not a /datum/armor/clothing_under subtype (clothing_under_armor_subtype_check)')
        for root, cover in ARMOR_WEARS:
            if not armor or not tree.is_a(path, root) or path == root:
                continue
            if tree.flags(path, 'body_parts_covered') != tree.number(cover):
                continue
            protecting = [name for name in ARMOR_PROTECTIONS if tree.number(tree.raw(armor, name))]
            if protecting:
                problems['armor'].append(f'{path}: covers only {cover} but {armor} has {", ".join(protecting)} (gloves_and_shoes_armor)')

    for path in ours:
        if not tree.is_a(path, '/obj/item/stack'):
            continue
        if not tree.abstract(path) and not tree.text(path, 'singular_name'):
            problems['stacks'].append(f'{path}: no singular_name (stack_singular_name)')
        if path not in MERGE_BLACKLIST and tree.raw(path, 'merge_type') in ('null', MISSING):
            problems['stacks'].append(f'{path}: no merge_type (merge_type)')

    for path in ours:
        if not tree.is_a(path, '/obj/item/reagent_containers'):
            continue
        volume = tree.number(tree.raw(path, 'volume'))
        loaded = sum(tree.number(entry.split('=', 1)[1]) or 0 for entry in list_entries(tree.raw(path, 'list_reagents')) if '=' in entry)
        if volume is not None and loaded > volume:
            problems['reagents'].append(f'{path}: {loaded} units of list_reagents, volume {volume} (reagent_container_sanity)')
        if tree.number(tree.raw(path, 'has_variable_transfer_amount')):
            amount = tree.number(tree.raw(path, 'amount_per_transfer_from_this'))
            allowed = [tree.number(entry) for entry in list_entries(tree.raw(path, 'possible_transfer_amounts'))]
            if amount is not None and allowed and amount not in allowed:
                problems['reagents'].append(f'{path}: amount_per_transfer_from_this {amount} not in possible_transfer_amounts (reagent_container_defaults)')

    builtins = byond_constants()
    if builtins is None:
        print('  BYOND not found (DM_EXE, PATH, registry): the constants check is skipped')
    for path in ours if builtins is not None else ():
        for name, value in tree.vars.get(path, {}).items():
            bare = re.sub(r'"(?:[^"\\]|\\.)*"|\'[^\']*\'', '', value)
            for token in CONSTANT_RE.findall(bare):
                if token not in tree.defines and token not in builtins:
                    problems['constants'].append(f'{path}: {name} = {value}, but {token} is not #defined')

    listings = {}
    for source in walk_dm(MODULE):
        for number, line in enumerate(open(source, encoding='utf-8', errors='replace'), 1):
            for resource in RESOURCE_RE.findall(line):
                if not exact_path(resource, listings):
                    problems['paths'].append(f'{source}:{number}: {resource} does not exist with this exact case (Windows forgives it, a Linux build does not)')

    total = sum(len(found) for found in problems.values())
    print(f'checked {len(ours)} {MODULE} types against the TG content tests')
    for kind in KINDS:
        found = problems[kind]
        print(f'  {kind:<10} {"clean" if not found else f"{len(found)} problem(s)"}')
        for line in found if args.verbose or len(found) <= 12 else found[:12]:
            print(f'      - {line}')
        if not args.verbose and len(found) > 12:
            print(f'      ... {len(found) - 12} more (-v for all)')
    return 1 if total else 0


if __name__ == '__main__':
    sys.exit(main())
