"""H2g: Vibelin's own food, drink and vessels as flat type blocks of the module's food (survival/, Ratwood's).

    py -3 modular_redtard/tools/port_vibelin_food.py [--lists DIR] [--private] [--dry-run]

Reads modular_redtard/items_vibelin/food_port.json beside items_vibelin/port.json (source, assets, defines, slot flags,
ingots and numbers are shared with tools/port_vibelin_items.py, whose porter class this one extends). The types are the
rows of items_vibelin/selection.tsv whose pick is "vibelin" and whose root one of the groups of food_port.json rebases;
a type whose name a food or vessel of the module already carries (Ratwood's, Azure Peak's) stays out as a duplicate,
and so does one whose K1v pair the module declares.

Vibelin (Vanderlin) food keeps its nutrition as numbers (nutrition, vitamin) and cooks by recipes of the oven, the pan
and the pot (/datum/container_craft) and of the table (/datum/repeatable_crafting_recipe/cooking,
/datum/orderless_slapcraft/food). The module's food is Ratwood's: reagents, bites, an eat effect, what an oven
(cooked_type) or a pan and a fire (fried_type) make of a food, its shelf life, slicing, and slapcraft recipes on a table
(/datum/rogue_food_recipe: a base and ordered ingredients). So:
  - nutrition becomes nutriment and vitamin reagents, as Vibelin's add_initial_reagents() makes them;
  - an oven or pan recipe of one food becomes that food's cooked_type or fried_type (cook time, smell);
  - a table recipe whose base is a food becomes a /datum/rogue_food_recipe/vibelin/* recipe;
  - what does not fit (several foods in the oven, pot recipes, tools, several results) goes to the lists.
Vessels (bottles, cups, bowls, teapots, powders, pills, platters) rebase under the module's vessel roots.

The numbers of an item (integrity, force, throw force) go to the section `# >>> port_vibelin_food.py` of the staged
items table; with --private the section is also put into config/redtard_private/mechanics/items.txt (after the
section of port_vibelin_items.py). Food data (reagents, times, bites) stay in the types, as the Ratwood and Azure Peak
food ports keep them. Read-only on Vibelin and the other forks. No git, no DM.
"""

import argparse
import collections
import csv
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import port_vibelin_items as pvi  # noqa: E402

engine = pvi.engine
rockhill = pvi.rockhill
under = pvi.under
norm = pvi.norm
rel = pvi.rel
FOOD_CONFIG = os.path.join(pvi.FOLDER, 'food_port.json')
HEADER = re.compile(r'^(/[A-Za-z0-9_/]+?)/?\s*$')
NAME_LINE = re.compile(r'^\tname\s*=\s*"(.*)"\s*$')
STATE_LINE = re.compile(r'^\ticon_state\s*=\s*"(.*)"\s*$')
STRING = re.compile(r'^"(?:[^"\\]|\\.)*"$')
PATH = re.compile(r'/[A-Za-z0-9_/]+')
FOOD_ROOT = '/obj/item/reagent_containers/food'


def load_config():
    cfg = json.load(open(pvi.CONFIG, encoding='utf-8'))
    food = json.load(open(FOOD_CONFIG, encoding='utf-8'))
    for key in ('groups', 'target_items', 'bake', 'table'):
        cfg[key] = food[key]
    cfg['food'] = food
    return cfg


def entries(raw):
    """(key, value) entries of a DM list(...); value None for plain entries."""
    return rockhill.food_entries(raw or '')


def list_paths(key):
    """A requirement key: one path, or the paths of a nested list(...)."""
    key = key.strip()
    if key.startswith('list('):
        return [p.rstrip('/') for p in PATH.findall(key[5:-1])]
    return [key.rstrip('/')] if key.startswith('/') else []


class FoodPorter(pvi.VibelinPorter):
    def __init__(self, cfg):
        super().__init__(cfg)
        self.food = cfg['food']
        self.module_declared = set()
        self.module_names = collections.defaultdict(list)
        self.module_states = {}
        self.scan_module()
        self.module_keys = collections.defaultdict(list)
        self.module_tails = collections.defaultdict(list)
        for path in self.module_declared:
            if under(path, '/obj/item/reagent_containers') or under(path, '/obj/item/cooking'):
                self.module_keys[self.path_key(path)].append(path)
                self.module_tails[path.rsplit('/', 1)[-1]].append(path)
        self.dup_pairs = {}
        lists = rel(cfg['lists'])
        dups = os.path.join(lists, 'duplicates.tsv')
        if os.path.isfile(dups):
            for row in pvi.read_tsv(dups):
                for match in (m for m in (row.get('vibelin_match') or '').split(',') if m):
                    if row['type'] in self.module_declared:
                        self.dup_pairs.setdefault(match, row['type'])
        self.module_recipes = set()
        self.scan_module_recipes()
        self.ported = {}
        self.dup_skipped = {}
        self.heat = {}
        self.recipe_rows = []
        self.recipe_blocks = []

    # -- the module ----------------------------------------------------------------------------------------------

    def scan_module(self):
        skip = [os.path.join(os.path.normpath(rel(p)), '') for p in self.food['module_scan_skip']]
        for dp, _dn, fn in os.walk(os.path.normpath(rel(self.food['module_scan']))):
            if any(os.path.join(os.path.normpath(dp), '').startswith(s) for s in skip):
                continue
            for name in fn:
                if not name.endswith('.dm'):
                    continue
                current = None
                with open(os.path.join(dp, name), encoding='utf-8', errors='replace') as handle:
                    for line in handle:
                        line = line.rstrip('\n')
                        head = HEADER.match(line)
                        if head and not line.startswith(('\t', ' ')):
                            current = head.group(1)
                            if '/proc/' in current or '/verb/' in current:
                                current = None
                                continue
                            self.module_declared.add(current)
                            continue
                        if current and under(current, '/obj/item'):
                            found = NAME_LINE.match(line)
                            if found:
                                self.module_names[norm(found.group(1))].append(current)
                            state = STATE_LINE.match(line)
                            if state:
                                self.module_states.setdefault(current, state.group(1))
                        if line and not line.startswith(('\t', ' ', '/')):
                            current = None

    def scan_module_recipes(self):
        files = [rel(p) for p in self.food['recipes']['module_recipe_files'] if os.path.isfile(rel(p))]
        types, defines, _ = engine.parse(files)
        src = engine.Source(types, defines)
        for path in types:
            if not under(path, '/datum/rogue_food_recipe'):
                continue
            base = (src.resolve(path, 'base_item') or '').strip().rstrip('/')
            first = PATH.findall(src.resolve(path, 'ingredients') or '')
            if base.startswith('/') and first:
                self.module_recipes.add((base, first[0].rstrip('/')))

    def family(self, path):
        return 'food' if under(path, FOOD_ROOT) else 'vessel'

    def module_named(self, vpath, name):
        """The module's food or vessel of this Vibelin type's name, of the same family; None if there is none."""
        fam = self.family(vpath)
        found = sorted(p for p in self.module_names.get(norm(name), []) if (under(p, '/obj/item/reagent_containers') or under(p, '/obj/item/plate')) and self.family(p) == fam)
        return found[0] if found else None

    def path_key(self, path):
        """A path with the steps builds add for themselves (rogue, carved) left out, after the root aliases of
        food_port.json (Vibelin's /obj/item/plate is the module's /obj/item/cooking/platter)."""
        for prefix, to in self.food.get('path_aliases', {}).items():
            if under(path, prefix):
                path = to + path[len(prefix):]
                break
        generic = set(self.food.get('path_generic', []))
        return '/'.join(t for t in path.split('/') if t not in generic)

    def path_twin(self, vpath):
        """The module's food or vessel at this Vibelin type's path, with or without the generic steps (rogue/toast and
        toast, carved/amber and amber), or one of the same last step and the same sprite; None if there is none."""
        if any(under(vpath, p) for p in self.food.get('twin_skip', [])):
            return None
        fam = self.family(vpath)
        if vpath in self.module_declared and self.family(vpath) == fam:
            return vpath
        found = sorted(p for p in self.module_keys.get(self.path_key(vpath), []) if self.family(p) == fam)
        if found:
            return found[0]
        raw = self.src.resolve(vpath, 'icon_state')
        state = self.src.expand(raw).strip('"') if raw else ''
        if state:
            found = sorted(p for p in self.module_tails.get(vpath.rsplit('/', 1)[-1], []) if self.family(p) == fam and self.module_states.get(p) == state)
            if found:
                return found[0]
        return None

    def to_module(self, vpath):
        """The module's type for a Vibelin path: ported here, a duplicate left out, a K1v pair, the same path, or the
        item of the same name. None if the module has nothing for it."""
        vpath = vpath.strip().rstrip('/')
        if vpath in self.ported:
            return self.ported[vpath]
        if vpath in self.dup_skipped:
            return self.dup_skipped[vpath]
        if vpath in self.dup_pairs:
            return self.dup_pairs[vpath]
        if vpath.startswith('/datum/'):
            return vpath if vpath in self.target_types else None
        if vpath in self.module_declared:
            return vpath
        raw = self.src.resolve(vpath, 'name')
        if raw and raw.startswith('"') and under(vpath, '/obj/item'):
            fam = self.family(vpath)
            found = sorted(p for p in self.module_names.get(norm(raw.strip('"')), []) if self.family(p) == fam)
            if found:
                return found[0]
        return None

    # -- values --------------------------------------------------------------------------------------------------

    def fmtn(self, value):
        return self.fmt(round(value, 3) if isinstance(value, float) else value)

    def reagents(self, raw):
        """Reagent pairs of a Vibelin list(...) the module knows, and the unknown ones."""
        pairs, unknown = collections.OrderedDict(), []
        for key, value in entries(raw):
            key = key.rstrip('/')
            number = self.number(value) if value is not None else None
            if not key.startswith('/datum/reagent'):
                continue
            if key not in self.target_types:
                unknown.append(key)
                continue
            if number:
                pairs[key] = pairs.get(key, 0) + number
        return pairs, unknown

    def list_text(self, pairs):
        return 'list(' + ', '.join(f'{k} = {self.fmtn(v)}' for k, v in pairs.items()) + ')' if pairs else 'null'

    def food_values(self, path):
        r = lambda var: self.src.resolve(path, var)
        food = self.food
        values = collections.OrderedDict()
        pairs = collections.OrderedDict()
        nutrition = self.number(r('nutrition')) or 0
        vitamin = self.number(r('vitamin'))
        vitamin = 0.25 if vitamin is None else vitamin
        if nutrition:
            if vitamin:
                pairs[food['nutriment_reagent']] = nutrition * (1 - vitamin)
                pairs[food['vitamin_reagent']] = nutrition * vitamin
            else:
                pairs[food['nutriment_reagent']] = nutrition
        extra, unknown = self.reagents(r('list_reagents'))
        for key in unknown:
            self.notes[f'food reagent not in the module, left out: {key}'] += 1
        for key, value in extra.items():
            pairs[key] = pairs.get(key, 0) + value
        # Nothing left (no nutrition, reagents the module lacks): the module root's one nutriment, as a Ratwood food
        # without reagents gets; TG's edible wants something to bite.
        values['food_reagents'] = 'list(' + ', '.join(f'{k} = {self.fmtn(v)}' for k, v in pairs.items()) + ')' if pairs else food['module_defaults']['food_reagents']
        raw = r('foodtype')
        values['foodtypes'] = self.flags(raw, {}) if raw else 'NONE'
        tastes = [f'{key} = {self.fmtn(self.number(value) or 1)}' for key, value in entries(r('tastes')) if STRING.match(key.strip())]
        values['tastes'] = 'list(' + ', '.join(tastes) + ')' if tastes else 'null'
        effect = (r('eat_effect') or 'null').strip()
        if effect not in ('null', '') and effect not in food['eat_effects']:
            self.notes[f'eat effect without a module twin, left out: {effect}'] += 1
        values['eat_effect'] = food['eat_effects'].get(effect, 'null')
        heat = self.heat.get(path, {})
        values['cooked_type'] = heat.get('oven', (None,))[0] or 'null'
        values['fried_type'] = heat.get('pan', (None,))[0] or 'null'
        times = [heat[kind][1] for kind in ('oven', 'pan') if kind in heat and heat[kind][1]]
        values['cooktime'] = self.fmtn(min(times)) if times else '0'
        burn = self.number(r('burntime'))
        values['burntime'] = self.fmtn(burn if burn is not None else 3000)
        values['bitesize'] = self.fmtn(self.number(r('bitesize')) or 3)
        rot = self.number(r('rotprocess')) or 0
        values['rotprocess'] = self.fmtn(rot)
        warming = self.number(r('warming'))
        values['warming'] = self.fmtn(warming) if warming is not None and (r('warming') or '').strip() not in ('', 'null') else food['module_defaults']['warming']
        # Only a rotten form ported here: the module's own food has none (it goes bad in place), and a twin of a
        # Vibelin rotten form would be a fresh food.
        rotten = self.ported.get((r('become_rot_type') or '').strip().rstrip('/'))
        values['become_rot_type'] = rotten if rotten and rot else 'null'
        slice_raw = (r('slice_path') or 'null').strip()
        slice_path = self.to_module(slice_raw) if slice_raw != 'null' else None
        slices = self.number(r('slices_num')) or 0
        if slice_raw != 'null' and not slice_path:
            self.notes[f'slice path not in the module, no slicing: {slice_raw}'] += 1
        if not slice_path or slices <= 0:
            slice_path, slices = None, 0
        values['slice_path'] = slice_path or 'null'
        values['slices_num'] = self.fmtn(slices)
        bclass = (r('slice_bclass') or 'BCLASS_CUT').strip()
        values['slice_bclass'] = bclass if bclass in self.known_defines else 'BCLASS_CUT'
        values['slice_batch'] = 'FALSE' if (r('slice_batch') or 'TRUE').strip() in ('FALSE', '0') else 'TRUE'
        fare = self.number(r('faretype'))
        values['rogue_faretype'] = food['fare'].get(str(int(fare)) if fare is not None else '', food['module_defaults']['rogue_faretype'])
        values['rogue_portable'] = 'FALSE' if (r('portable') or 'TRUE').strip() in ('FALSE', '0') else 'TRUE'
        values['rogue_cooked_smell'] = heat.get('smell') or self.scent(r('cooked_smell')) or 'null'
        price = self.number(r('sellprice'))
        values['sellprice'] = self.fmtn(int(price)) if price else '0'
        return values

    def scent(self, raw):
        pollutant = (raw or '').strip().rstrip('/')
        if not pollutant.startswith('/datum/pollutant'):
            return None
        value = self.src.resolve(pollutant, 'scent')
        return value if value and STRING.match(value) and value != '""' else None

    def base_vars(self, path, group_name, group):
        """Name, look, grid, slots, smelting and repair of a food or a vessel."""
        written = collections.OrderedDict()
        resolve = lambda var: self.src.resolve(path, var)

        def put(var, raw):
            if raw is None:
                return
            value = self.literal(raw)
            if value is None:
                self.dropped[f'{var} = {raw[:60]}'] += 1
                return
            written[var] = value

        for var in ('name', 'desc', 'icon', 'icon_state', 'w_class'):
            put(var, resolve(var))
        # Vibelin's own slips: a state drawn on another of its food sheets (cured ollie: "ollie" is on produce.dmi).
        icon = pvi.FILE_REF.match(written.get('icon') or '')
        state = (written.get('icon_state') or '').strip('"')
        if icon and state and state not in engine.dmi_meta(self.asset_path(icon.group(1)))[2]:
            for ref in self.food.get('icon_fallbacks', []):
                source = os.path.join(self.source_root, ref)
                if os.path.isfile(source) and state in engine.dmi_meta(source)[2]:
                    written['icon'] = f"'{self.asset(ref)}'"
                    self.notes[f'world sprite state found on {ref}'] += 1
                    break
        color = resolve('color')
        if color and STRING.match(self.src.expand(color)):
            written['color'] = self.src.expand(color)
        slots = resolve('slot_flags')
        if group_name == 'vessels' and slots is not None:
            written['slot_flags'] = self.flags(slots, self.cfg['slot_flags'])
        for ours, theirs in (('rogue_grid_width', 'grid_width'), ('rogue_grid_height', 'grid_height')):
            value = self.number(resolve(theirs))
            if value:
                written[ours] = self.fmt(value)
        if group_name == 'vessels':
            smelt = (resolve('smeltresult') or '').strip()
            material = (resolve('melting_material') or '').strip()
            if smelt in self.target_types:
                written['smeltresult'] = smelt
            elif material in self.cfg['material_ingots'] and self.cfg['material_ingots'][material] in self.target_types:
                written['smeltresult'] = self.cfg['material_ingots'][material]
            raw = resolve('anvilrepair')
            if raw and raw.strip() != 'null':
                value = self.mapped_path(raw, self.cfg['skill_map'], path)
                if value:
                    written['anvilrepair'] = value
        self.look(path, written)
        return written

    def vessel_vars(self, path, written):
        """Volumes and transfers, prefilled reagents and a platter's room; None when a reagent is not the module's."""
        resolve = lambda var: self.src.resolve(path, var)
        for var in self.food['vessel_vars']:
            raw = resolve(var)
            if raw is None:
                continue
            if raw.strip().startswith('list('):
                numbers = [self.number(v) for v in re.split(r',', raw.strip()[5:-1]) if v.strip()]
                if all(n is not None for n in numbers):
                    written[var] = 'list(' + ', '.join(self.fmtn(n) for n in numbers) + ')'
                continue
            if var == 'spillable':
                written[var] = 'TRUE' if self.number(raw) else 'FALSE'
                continue
            number = self.number(raw)
            if number is not None:
                written[var] = self.fmtn(number)
        pairs, unknown = self.reagents(resolve('list_reagents'))
        if unknown:
            return None, unknown
        if under(path, '/obj/item/reagent_containers'):
            written['list_reagents'] = self.list_text(pairs)
        if under(path, '/obj/item/plate'):
            for var in self.food['plate_vars']:
                number = self.number(resolve(var))
                if number is not None:
                    written[var] = self.fmtn(number)
            tail = path.rsplit('/', 1)[-1]
            if tail not in self.food['plate_fragile']:
                written['fragile'] = 'FALSE'
        price = self.number(resolve('sellprice'))
        if price:
            written['sellprice'] = self.fmtn(int(price))
        return written, []

    # -- recipes -------------------------------------------------------------------------------------------------

    def recipe_types(self, root):
        for path in sorted(p for p in self.src.types if under(p, root) and p != root):
            abstract = (self.src.resolve(path, 'abstract_type') or '').strip()
            if abstract == path:
                continue
            yield path

    def recipe_row(self, status, kind, path, detail):
        name = (self.src.resolve(path, 'name') or '').strip('"')
        self.recipe_rows.append({'status': status, 'kind': kind, 'recipe': path, 'name': name, 'detail': detail})

    def collect_heat(self, selected):
        """Oven and pan recipes of one food: what the food bakes or fries into (Vibelin path), the time and smell."""
        rec = self.food['recipes']
        found = {}
        for kind in ('oven', 'pan'):
            for path in self.recipe_types(rec[kind]):
                r = lambda var: self.src.resolve(path, var)
                out = (r('output') or '').strip().rstrip('/')
                items = [(k.rstrip('/'), self.number(v) if v else 1, True) for k, v in entries(r('requirements'))]
                items += [(k.rstrip('/'), self.number(v) if v else 1, False) for k, v in entries(r('wildcard_requirements'))]
                reagents = entries(r('reagent_requirements'))
                if not out:
                    continue
                if len(items) != 1 or items[0][1] != 1 or reagents or not items[0][0].startswith('/obj/'):
                    involved = any(under(i[0], p) or under(p, i[0]) for i in items for p in selected) or out in selected
                    if involved:
                        self.recipe_row('not ported', kind, path, f'several ingredients or a reagent in the {kind}: the module makes one food of one food by heat (cooked_type, fried_type)')
                    continue
                time = self.number(r('crafting_time')) or 250
                smell = self.scent(r('cooked_smell'))
                amount = self.number(r('output_amount')) or 1
                found.setdefault(kind, []).append((items[0][0], items[0][2], out, time, smell, amount, path))
        for path in selected:
            heat = {}
            for kind, recipes in found.items():
                exact = [x for x in recipes if x[1] and x[0] == path]
                chain = []
                step = path
                while step and step.count('/') > 2:
                    chain.append(step)
                    step = self.src.parent(step)
                wild = sorted((x for x in recipes if not x[1] and x[0] in chain), key=lambda x: chain.index(x[0]))
                pick = (exact or wild or [None])[0]
                if not pick:
                    continue
                heat[kind] = pick
            self.heat[path] = heat
        return found

    def resolve_heat(self, found):
        """Vibelin outputs to module types, once every food is ported or known; rows for the recipes."""
        used = set()
        for path, heat in list(self.heat.items()):
            out = {}
            for kind, (_inp, _exact, result, time, smell, amount, recipe) in heat.items():
                target = self.to_module(result)
                if not target or target == self.ported.get(path):
                    self.recipe_row('not ported', kind, recipe, f'{path}: its result {result} is not in the module')
                    continue
                out[kind] = (target, time)
                if smell:
                    out['smell'] = smell
                if recipe not in used:
                    used.add(recipe)
                    self.recipe_row('ported', kind, recipe, f'{"cooked_type" if kind == "oven" else "fried_type"} of {self.ported[path]} -> {target}' + (f' (Vibelin makes {amount:g}, the module one)' if amount != 1 else ''))
            self.heat[path] = out
        for kind, recipes in found.items():
            for (inp, _exact, result, *_rest, recipe) in recipes:
                if recipe in used or any(r['recipe'] == recipe for r in self.recipe_rows):
                    continue
                if inp in self.ported or result in self.ported:
                    self.recipe_row('not ported', kind, recipe, f'its food {inp} is not Vibelin\'s own food here (the module\'s food cooks by its own data)')

    def table_recipes(self):
        """Vibelin's table recipes (repeatable cooking, orderless slapcraft) as recipes of the module."""
        rec = self.food['recipes']
        ours = set(self.ported.values())
        seen = {}
        for kind in ('table', 'orderless'):
            for path in self.recipe_types(rec[kind]):
                r = lambda var: self.src.resolve(path, var)
                if kind == 'table':
                    base_raw = (r('attacked_atom') or '').strip().rstrip('/')
                    start = (r('starting_atom') or '').strip().rstrip('/')
                    result_raw = (r('output') or '').strip().rstrip('/')
                    amount = self.number(r('output_amount')) or 1
                    tools = entries(r('tool_usage'))
                    needs = [(k.strip(), self.number(v) if v else 1) for k, v in entries(r('requirements'))]
                    time = self.number(r('craft_time'))
                    # The base lies on the table; the rest, the held item first, is added.
                    order = sorted(needs, key=lambda kv: kv[0].rstrip('/') != start)
                    steps = []
                    for key, count in order:
                        count = int(count or 1) - (1 if key.rstrip('/') == base_raw else 0)
                        steps += [key] * max(0, count)
                    finish = None
                else:
                    base_raw = (r('starting_item') or '').strip().rstrip('/')
                    result_raw = (r('output_item') or '').strip().rstrip('/')
                    amount = 1
                    tools = []
                    needs = [(k.strip(), self.number(v) if v else 1) for k, v in entries(r('requirements'))]
                    time = self.number(r('action_time'))
                    steps = []
                    for key, count in needs:
                        steps += [key] * int(count or 1)
                    finish = (r('finishing_item') or '').strip().rstrip('/')
                    if finish and finish != 'null':
                        steps.append(finish)
                if not result_raw or not base_raw or base_raw == 'null':
                    continue
                involved = base_raw in self.ported or result_raw in self.ported or any(p in self.ported for k in steps for p in list_paths(k))
                if not involved:
                    continue
                base = self.to_module(base_raw)
                result = self.to_module(result_raw)
                why = None
                if tools:
                    why = 'it takes a tool (' + ', '.join(k for k, _ in tools) + '): the module\'s recipes take ingredients only'
                elif amount != 1:
                    why = f'it makes {amount:g} at once: a recipe of the module makes one'
                elif not base or not under(base, FOOD_ROOT):
                    why = f'its base {base_raw} is ' + ('not in the module' if not base else 'not a food') + ': the module\'s recipe starts with a food on a table'
                elif not result:
                    why = f'its result {result_raw} is not in the module'
                elif base not in ours and result not in ours:
                    why = 'neither its base nor its result is Vibelin\'s own food here'
                ingredients = []
                if not why:
                    for key in steps:
                        options = [self.to_module(p) for p in list_paths(key)]
                        options = [o for o in options if o]
                        if not options:
                            why = f'an ingredient is not in the module: {key[:80]}'
                            break
                        ingredients.append(options[0] if len(options) == 1 else 'list(' + ', '.join(dict.fromkeys(options)) + ')')
                if not why:
                    for key, value in entries(r('reagent_requirements')):
                        key = key.rstrip('/')
                        target = self.to_module(key)
                        number = self.number(value) if value else None
                        if not target or not number:
                            why = f'a reagent is not in the module: {key}'
                            break
                        ingredients.append(f'{target} = {self.fmtn(number)}')
                if not why and not ingredients:
                    why = 'nothing to add to its base'
                if not why:
                    first = PATH.findall(ingredients[0])[0]
                    if (base, first) in self.module_recipes:
                        why = f'the module already has a recipe of {base} that starts with {first}'
                    elif (base, first) in seen:
                        why = f'same start as {seen[(base, first)]}'
                if why:
                    self.recipe_row('not ported', kind, path, why)
                    continue
                seen[(base, first)] = path
                tail = path[len(rec[kind]) + 1:].replace('/', '_')
                block = [f"{rec['target']}/{kind}_{tail}"]
                name = r('name')
                if name and STRING.match(name.strip()):
                    block.append(f'\tname = {name.strip()}')
                block += [f'\tbase_item = {base}', '\tingredients = list(' + ', '.join(ingredients) + ')', f'\tresult_type = {result}']
                if time and time != rec['default_step']:
                    block.append(f'\ttime_per_step = {self.fmtn(time)}')
                self.recipe_blocks.append(block)
                self.recipe_row('ported', kind, path, f'{block[0]}: {base} -> {result}')
        for kind in ('pot',):
            for path in self.recipe_types(rec[kind]):
                out = (self.src.resolve(path, 'output') or '').strip().rstrip('/')
                items = [p for k, _ in entries(self.src.resolve(path, 'requirements')) + entries(self.src.resolve(path, 'wildcard_requirements')) for p in list_paths(k)]
                if out in self.ported or any(p in self.ported for p in items):
                    self.recipe_row('not ported', kind, path, 'a pot recipe: the module\'s pot cooks Ratwood\'s soups and stews (survival/soups.dm, stews.dm)')

    # -- the run -------------------------------------------------------------------------------------------------

    def run_food(self, lists, write_private, dry_run):
        rows = [r for r in pvi.read_tsv(pvi.SELECTION) if r['pick'] == 'vibelin']
        skipped = []
        elsewhere = dict(self.in_module_pairs(rows))
        elsewhere.update(self.cfg.get('ported_elsewhere', {}))
        chosen = collections.defaultdict(list)
        for row in rows:
            path = row['type']
            rule = next((s for s in self.food['skip'] if under(path, s['prefix'])), None)
            group = None
            best = None
            for name, spec in self.cfg['groups'].items():
                for reb in spec['rebase']:
                    if under(path, reb['prefix']) and (best is None or len(reb['prefix']) > len(best)):
                        best, group = reb['prefix'], name
            if rule:
                skipped.append({'kind': row['kind'], 'type': path, 'name': row['name'], 'group': group or '', 'reason': rule['reason']})
                continue
            if not group:
                continue
            if path in elsewhere:
                skipped.append({'kind': row['kind'], 'type': path, 'name': row['name'], 'group': group, 'reason': elsewhere[path]})
                continue
            abstract = path in self.cfg['groups'][group].get('abstract', [])
            twin = self.module_named(path, row['name']) if not abstract else None
            why = 'of the same name'
            if not twin and not abstract:
                twin, why = self.path_twin(path), 'at the same path or of the same sprite'
            if twin:
                self.dup_skipped[path] = twin
                skipped.append({'kind': row['kind'], 'type': path, 'name': row['name'], 'group': group, 'reason': f'a duplicate: the module has {twin} {why}'})
                continue
            chosen[group].append(row)
        for group, picked in chosen.items():
            for row in picked:
                self.ported[row['type']] = self.rebased(row['type'])
        food_paths = sorted(r['type'] for r in chosen.get('food', []))
        found = self.collect_heat(food_paths)
        self.resolve_heat(found)
        ported_rows = []
        outputs = {}
        for group_name, group in self.cfg['groups'].items():
            paths = sorted(r['type'] for r in chosen.get(group_name, []))
            blocks = {}
            effective = {}
            resets = dict(self.cfg['resets'], **group.get('resets', {}))
            keep = set(self.cfg['keep_inherited']) | set(group.get('keep', []))
            for path in sorted(paths, key=lambda p: (self.ported[p].count('/'), self.ported[p])):
                target = self.ported[path]
                row = next(r for r in chosen[group_name] if r['type'] == path)
                abstract = (self.src.resolve(path, 'abstract_type') or '').strip()
                if abstract == path or path in group.get('abstract', []):
                    blocks[target] = [target, f'\tabstract_type = {target}']
                    effective[target] = dict(self.food['module_defaults'])
                    ported_rows.append({'group': group_name, 'type': path, 'target': target, 'name': row['name'], 'verdict': 'abstract'})
                    continue
                written = self.base_vars(path, group_name, group)
                handled = set()
                if group_name == 'food':
                    values = self.food_values(path)
                    parent = target.rsplit('/', 1)[0]
                    inherited = None
                    while parent.count('/') > 3:
                        if parent in effective:
                            inherited = effective[parent]
                            break
                        parent = parent.rsplit('/', 1)[0]
                    inherited = inherited or self.food['module_defaults']
                    for var, value in values.items():
                        if value != inherited.get(var):
                            written[var] = value
                    effective[target] = dict(inherited, **values)
                    # Food data equal to what the module's root (or a ported parent) has is inherited on purpose.
                    handled = set(values)
                else:
                    written, unknown = self.vessel_vars(path, written)
                    if written is None:
                        skipped.append({'kind': row['kind'], 'type': path, 'name': row['name'], 'group': group_name, 'reason': 'it comes filled with what the module lacks: ' + ', '.join(unknown)})
                        del self.ported[path]
                        continue
                for var in sorted(self.chain_vars(target)):
                    if var in written or var in keep or var in handled:
                        continue
                    if var in resets:
                        written[var] = resets[var]
                    else:
                        self.notes[f'{group_name}: inherited from the module root: {var}'] += 1
                self.blank_worn(written)
                blocks[target] = [target] + [f'\t{name} = {value}' for name, value in written.items()]
                entry = self.numbers(path, target, group_name)
                if entry:
                    self.table.append(entry)
                ported_rows.append({'group': group_name, 'type': path, 'target': target, 'name': row['name'], 'verdict': row['verdict']})
            roots = {reb['to'] for reb in group['rebase']}
            for target in list(blocks):
                step = target
                while step.count('/') > 3:
                    step = step.rsplit('/', 1)[0]
                    if step in blocks:
                        continue
                    if any(under(step, root) for root in roots):
                        blocks[step] = [step, f'\tabstract_type = {step}']
            for root in roots:
                if any(under(t, root) for t in blocks) and root not in blocks:
                    blocks[root] = [root, f'\tabstract_type = {root}']
            header = ['// Written by modular_redtard/tools/port_vibelin_food.py from modular_redtard/items_vibelin/food_port.json; do not edit by hand.',
                      '// ' + group['header'], '// Numbers (integrity, force, throw force) live in the private mechanics/items.txt.', '']
            outputs[group['file']] = '\n'.join(header) + '\n' + '\n'.join('\n'.join(blocks[p]) + '\n' for p in sorted(blocks))
            print(f"{group['file']}: {len([p for p in paths if p in self.ported])} types, {len(blocks) - len([p for p in paths if p in self.ported])} abstract steps")
        self.table_recipes()
        rec = self.food['recipes']
        recipe_text = ['// Written by modular_redtard/tools/port_vibelin_food.py from modular_redtard/items_vibelin/food_port.json; do not edit by hand.',
                       '// Vibelin\'s table recipes (repeatable cooking, orderless slapcraft) of its own food, as slapcraft recipes of the module (survival/recipes.dm).', '',
                       rec['target'], '']
        recipe_text += ['\n'.join(b) + '\n' for b in sorted(self.recipe_blocks)]
        outputs[rec['file']] = '\n'.join(recipe_text)
        counts = collections.Counter((r['kind'], r['status']) for r in self.recipe_rows)
        print('recipes:', ', '.join(f'{k} {s} {n}' for (k, s), n in sorted(counts.items())))
        print(f'{len(self.copies)} files copied, {self.baked_used} held sprites baked, {self.baked_missing} waiting for the bake')
        print(f'{len(skipped)} skipped:', dict(collections.Counter(s['reason'].split(':')[0] for s in skipped)))
        for what, times in self.dropped.most_common():
            print(f'  dropped ({times}): {what}')
        for what, times in self.notes.most_common():
            print(f'  note ({times}): {what}')
        if dry_run:
            return
        for name, text in outputs.items():
            with open(os.path.join(pvi.FOLDER, name), 'w', encoding='utf-8', newline='\n') as handle:
                handle.write(text)
        for source, target in self.copies.items():
            os.makedirs(os.path.dirname(target), exist_ok=True)
            if not os.path.isfile(target) or open(target, 'rb').read() != open(source, 'rb').read():
                with open(source, 'rb') as a, open(target, 'wb') as b:
                    b.write(a.read())
        self.write_table()
        if write_private:
            self.write_private()
        bake = self.cfg['bake']
        rockhill.write_bake_manifest({'manifest': rel(bake['manifest']), 'mask32': bake['mask32'], 'mask64': bake['mask64']})
        if lists:
            pvi.write_tsv(os.path.join(lists, 'food_ported.tsv'), ['group', 'type', 'target', 'name', 'verdict'], ported_rows)
            pvi.write_tsv(os.path.join(lists, 'food_skipped.tsv'), ['kind', 'type', 'name', 'group', 'reason'], skipped)
            pvi.write_tsv(os.path.join(lists, 'food_recipes.tsv'), ['status', 'kind', 'recipe', 'name', 'detail'], sorted(self.recipe_rows, key=lambda r: (r['status'], r['kind'], r['recipe'])))
            print(f'lists: {len(ported_rows)} ported, {len(skipped)} skipped, {len(self.recipe_rows)} recipe rows -> {lists}')

    def write_private(self):
        """The staged section into the private items table: replaced in place, or put after the section of
        port_vibelin_items.py (its ids are other types, so the order does not matter)."""
        spec = self.cfg['table']
        target = rel(spec['private'])
        if not os.path.isfile(target):
            print(f'{spec["private"]}: missing, the section stays staged')
            return
        staged = open(rel(spec['out']), encoding='utf-8').read()
        begin, end = f"# >>> {spec['section']}", f"# <<< {spec['section']}"
        section = staged[staged.index(begin):staged.index(end) + len(end)]
        old = open(target, encoding='utf-8').read()
        if begin in old and end in old:
            head, rest = old.split(begin, 1)
            text = head + section + rest.split(end, 1)[1]
        elif spec['private_after'] in old:
            head, tail = old.split(spec['private_after'], 1)
            text = head + spec['private_after'] + '\n\n' + section + '\n' + tail
        else:
            text = old.rstrip('\n') + '\n\n' + section + '\n'
        with open(target, 'w', encoding='utf-8', newline='\n') as handle:
            handle.write(text)
        print(f"{spec['private']}: section {spec['section']} with {len(self.table)} entries")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--lists', help='folder for the ported, skipped and recipe lists of the run')
    parser.add_argument('--private', action='store_true', help='also put the numbers section into the private items table')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    FoodPorter(load_config()).run_food(args.lists, args.private, args.dry_run)


if __name__ == '__main__':
    main()
