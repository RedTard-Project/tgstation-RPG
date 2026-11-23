"""VA1g: Vibelin's (Vanderlin's) alchemy as data of the module: essences, essence mixes, precursors, cauldron recipes,
mortar recipes (Vibelin's and Azure Peak's on top of Ratwood's), infusions, distillations, chemical reactions, reagent
data, new ingredients and filled bottles.

    py -3 -I modular_redtard/tools/port_vibelin_alchemy.py [--out DIR] [--lists DIR] [--config FILE] [--dry-run]

--out is where the .dm files, path_map.json and alchemy_port.json go (default modular_redtard/alchemy/vibelin); --lists
gets the tables of what was ported, what was not and why, and the checks (default the VA1 block's work folder).
The config (alchemy_port.json) is read from --config, else from <out>/alchemy_port.json; when there is none the
built-in one below is written there, so the run can be repeated and tuned by editing that file.

The generator writes only values of vars of types; the bases (the types' vars and every proc) are declared by the
module's alchemy code, by the owners named in BASES below. Every base name and var name lives in BASES: when an owner
renames one, it is changed there and nowhere else. A path value is written only when the module (or TG, or this run)
has that type; otherwise the entry is dropped and listed.

Reagent paths are the module's (Ratwood's) where the module has the reagent, by an explicit pair, the same path or the
same name; a Vibelin reagent the module lacks keeps its Vibelin path. Vibelin's paths that TG has are TG's and are not
touched (on modern maps they stay TG). The map of every Vibelin path this run met to the module's path is
path_map.json. Balance numbers are not written (temp and thresholds of reagents, capacities and times of machines are
the owners' rogue_value() names); amounts in recipes are recipe data, as the food ports keep them.

Checks: reagent names unique (TG's reagent_names test, through inheritance over TG, the module and this run), no
reaction overlapping another (TG's reagent_recipe_collisions, chem_recipes_do_conflict()), no item claimed by two
precursors, no generated path clashing with a type the module declares for something else.
Read-only on Vibelin, Azure Peak and Ratwood. No git, no DM.
"""

import argparse
import collections
import csv
import difflib
import json
import os
import re
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))

for candidate in (os.environ.get('REDTARD_AI_SKILLS_SCRIPTS', ''), os.path.join(REPO, '..', 'ai-skills', 'scripts')):
    if candidate and os.path.isfile(os.path.join(candidate, 'dm_type_port.py')):
        sys.path.insert(0, candidate)
        break
import dm_type_port as engine  # noqa: E402

# ---------------------------------------------------------------------------------------------------------------
# BASES: the one place for the names of the module's alchemy bases (types and their vars), by the VA1 contract
# (TASKS.md "Блок ВА1", v0_alchemy.md section 5, contract A1). "owner" is the agent that declares the base; "vars" maps
# Vibelin's var name to the module's (None: not written). Change a name here when its owner changes it.
BASES = {
    'essence': {'owner': 'VA1b (alchemy/essence/)', 'root': '/datum/thaumaturgical_essence', 'vibelin_root': '/datum/thaumaturgical_essence',
                'vars': {'name': 'name', 'desc': 'desc', 'tier': 'tier', 'color': 'color', 'icon_state': 'icon_state',
                         'smells_like': 'smells_like', 'attunement': 'attunement'}},
    'combination': {'owner': 'VA1b (alchemy/essence/)', 'root': '/datum/essence_combination', 'vibelin_root': '/datum/essence_combination',
                    'vars': {'name': 'name', 'inputs': 'inputs', 'output_type': 'output_type', 'output_amount': 'output_amount',
                             'skill_required': 'skill_required', 'category': 'category'}},
    'precursor': {'owner': 'VA1b (alchemy/essence/)', 'root': '/datum/natural_precursor', 'vibelin_root': '/datum/natural_precursor',
                  'vars': {'name': 'name', 'essence_yields': 'essence_yields', 'init_types': 'init_types', 'category': 'category'}},
    'infusion': {'owner': 'VA1b (alchemy/essence/)', 'root': '/datum/infusion_recipe', 'vibelin_root': '/datum/infusion_recipe',
                 'vars': {'name': 'name', 'target_type': 'target_type', 'result_type': 'result_type',
                          'required_essences': 'required_essences', 'category': 'category', 'infusion_time': None}},
    'cauldron': {'owner': 'VA1v (alchemy/brewing.dm)', 'root': '/datum/alch_cauldron_recipe', 'vibelin_root': '/datum/alch_cauldron_recipe',
                 'vars': {'recipe_name': 'recipe_name', 'smells_like': 'smells_like', 'output_reagents': 'output_reagents',
                          'output_items': 'output_items', 'required_essences': 'required_essences', 'category': 'category',
                          'skill_required': 'skill_required'}},
    'grind': {'owner': 'VA1v (alchemy/brewing.dm)', 'root': '/datum/alch_grind_recipe', 'vibelin_root': '/datum/alch_grind_recipe',
              'vars': {'picky': 'picky', 'valid_input': 'valid_input', 'valid_outputs': 'valid_outputs',
                       'bonus_chance_outputs': 'bonus_chance_outputs', 'name': 'name'},
              # Steps of the generated mortar recipes under the root (Ratwood's own recipes stay at the root, written by
              # the Rockhill porter); each step is written abstract.
              'steps': {'vibelin': 'vibelin', 'azure': 'azure'}},
    'distillation': {'owner': 'VA1v (alchemy/distillation.dm)', 'root': '/datum/distillation_recipe', 'vibelin_root': '/datum/distillation_recipe',
                     'vars': {'name': 'name', 'id': 'id', 'distilled_reagent': 'distilled_reagent', 'required_reagents': 'required_reagents',
                              'consume_reagents': 'consume_reagents', 'results': 'results', 'required_temp': 'required_temp',
                              'distill_message': 'distill_message', 'distill_sound': 'distill_sound'}},
    # TG's own reaction vars; the root (instant, no heat) is the module's (alchemy/potions.dm, VA1a).
    'reaction': {'owner': 'VA1a (alchemy/potions.dm)', 'root': '/datum/chemical_reaction/rogue_alchemy', 'vibelin_root': '/datum/chemical_reaction',
                 'vars': {'required_reagents': 'required_reagents', 'results': 'results', 'required_catalysts': 'required_catalysts',
                          'required_temp': 'required_temp', 'is_cold_recipe': 'is_cold_recipe', 'mix_message': 'mix_message',
                          'mix_sound': 'mix_sound', 'required_container': 'required_container', 'mob_react': 'mob_react',
                          'name': None, 'id': None}},
    # Reagent data. scent_description is declared on /datum/reagent by VA1a; TG has no reagent_state nor boiling_point.
    'reagent': {'owner': 'VA1a (alchemy/_defines.dm, potions.dm …)', 'root': '/datum/reagent', 'vibelin_root': '/datum/reagent',
                'vars': {'name': 'name', 'description': 'description', 'color': 'color', 'taste_description': 'taste_description',
                         'taste_mult': 'taste_mult', 'scent_description': 'scent_description',
                         'reagent_state': None, 'boiling_point': None}},
    # Ingredients: the module's (Ratwood's) /obj/item/alch; Vibelin's herbs (/obj/item/alch/herb/x) are the module's /obj/item/alch/x.
    'ingredient': {'owner': 'Rockhill porter (alchemy/ported/alchemy.dm)', 'root': '/obj/item/alch', 'vibelin_root': '/obj/item/alch',
                   'vars': {'name': 'name', 'desc': 'desc', 'icon': 'icon', 'icon_state': 'icon_state', 'w_class': 'w_class', 'color': 'color'}},
    # Filled bottles: the module's Ratwood bottle; Vibelin's ones the module lacks go under the step.
    'bottle': {'owner': 'survival/vessels.dm', 'root': '/obj/item/reagent_containers/glass/bottle', 'vibelin_root': '/obj/item/reagent_containers/glass/bottle',
               'step': 'vibelin_alchemy',
               'vars': {'list_reagents': 'list_reagents', 'volume': 'volume', 'auto_label_name': 'name', 'auto_label_desc': 'desc'}},
}

# The module's ranks of a skill (crafting/_defines.dm) by the suffix of a source's rank define.
RANKS = {'NONE': 'ROGUE_RANK_NONE', 'NOVICE': 'ROGUE_RANK_NOVICE', 'APPRENTICE': 'ROGUE_RANK_APPRENTICE',
         'JOURNEYMAN': 'ROGUE_RANK_JOURNEYMAN', 'EXPERT': 'ROGUE_RANK_EXPERT', 'MASTER': 'ROGUE_RANK_MASTER',
         'LEGENDARY': 'ROGUE_RANK_LEGENDARY'}
RANK_NUMBERS = ['ROGUE_RANK_NONE', 'ROGUE_RANK_NOVICE', 'ROGUE_RANK_APPRENTICE', 'ROGUE_RANK_JOURNEYMAN', 'ROGUE_RANK_EXPERT',
                'ROGUE_RANK_MASTER', 'ROGUE_RANK_LEGENDARY']

DEFAULT_CONFIG = {
    'vibelin': {'root': '../Vibelin', 'dme': 'vanderlin.dme'},
    'azure': {'root': '../Azure-Peak-Fork', 'dme': 'roguetown.dme'},
    # Ratwood's cauldron recipes, for the ranks (the porter's cache first, then the fork).
    'ratwood_recipes': [['.cache/ratwood', 'code/modules/roguetown/roguecrafting/alchemy/alch_cauldron_recipe_base.dm',
                         'code/modules/roguetown/roguecrafting/alchemy/alch_cauldron_recipes.dm'],
                        ['../Ratwood-2.0-fork', 'code/modules/roguetown/roguecrafting/alchemy/alch_cauldron_recipe_base.dm',
                         'code/modules/roguetown/roguecrafting/alchemy/alch_cauldron_recipes.dm']],
    'final_dir': 'modular_redtard/alchemy/vibelin',
    'module_scan': 'modular_redtard',
    'tg_dme': 'tgstation.dme',
    # Vibelin files whose reagents this run carries as data (alcohol, herbal teas and food are block VA2's).
    'reagent_files': ['code/modules/crafting/alchemy/reagents.dm',
                      'code/modules/reagents/chemistry/reagents/medicine_reagents.dm',
                      'code/modules/reagents/chemistry/reagents/toxin_reagents.dm',
                      'code/modules/reagents/chemistry/reagents/buff_reagents.dm',
                      'code/modules/reagents/chemistry/reagents/special_reagents.dm',
                      'code/modules/reagents/chemistry/reagents/other_reagents.dm'],
    'reagent_files_later': {'code/modules/reagents/chemistry/reagents/alcohol_reagents.dm': 'alcohol: block VA2 (drinks and brewing)',
                            'code/modules/crafting/alchemy/herbal_recipes.dm': 'herbal reagents: block VA2 (herbal pot)',
                            'code/modules/reagents/chemistry/reagents/drug_reagents.dm': "drugs: the module keeps Ratwood's (alchemy/drugs.dm, deeper)",
                            'code/modules/reagents/chemistry/reagents/drink_reagents.dm': 'drinks: block VA2',
                            'code/modules/reagents/chemistry/reagents/food_reagents.dm': 'food reagents: not alchemy',
                            'code/modules/cooking/NeuFood.dm': 'food reagents: not alchemy',
                            'code/modules/cooking/Teas_and_Brews.dm': 'teas: block VA2 (herbal pot)'},
    # Module files whose reagents take Vibelin's data (VA1a rewrites them with Vibelin's behaviour and leaves names,
    # colours, tastes and smells to this run). A module reagent declared elsewhere keeps its own data.
    'module_overwrite_files': ['modular_redtard/alchemy/potions.dm', 'modular_redtard/alchemy/poisons.dm', 'modular_redtard/alchemy/buffs.dm',
                               'modular_redtard/alchemy/medicines.dm', 'modular_redtard/alchemy/toxins.dm'],
    # Vibelin reagent -> the module's, where neither the path nor the name tells (v0_alchemy.md section 2).
    'reagent_pairs': {'/datum/reagent/poison/berry': '/datum/reagent/berrypoison',
                      '/datum/reagent/poison/stamina': '/datum/reagent/stampoison',
                      '/datum/reagent/poison/stamina_strong': '/datum/reagent/strongstampoison',
                      '/datum/reagent/poison/doom': '/datum/reagent/strongpoison',
                      '/datum/reagent/poison/organ': '/datum/reagent/organpoison',
                      '/datum/reagent/poison/killersice': '/datum/reagent/toxin/killersice',
                      # Vibelin's lamp oil ("oil") is TG's oil of the same name (flammable, a fuel).
                      '/datum/reagent/blood/fuel': '/datum/reagent/fuel/oil',
                      '/datum/reagent/water/salty': '/datum/reagent/water/salt',
                      '/datum/reagent/consumable/sodiumchloride': '/datum/reagent/consumable/salt'},
    # Vibelin reagents of other files carried as data too, because this run's recipes need them.
    'reagent_extra': ['/datum/reagent/consumable/nutriment/bone_marrow'],
    # Vibelin reagents left alone whatever the module has (the module's own stays).
    'reagent_skip': {'/datum/reagent/water/blessed': "the module's holy water (Azure's, faith/) stays; Vibelin's is not taken"},
    # Vibelin item -> the module's, where neither the path, the ports nor the name tells.
    'item_pairs': {'/obj/item/fertilizer/bone_meal': '/obj/item/alch/bonemeal',
                   '/obj/item/reagent_containers/glass/bottle/vial': '/obj/item/reagent_containers/glass/bottle/alchemical',
                   # The module's mana crystal is Ratwood's (TASKS "ВМ1", point 2); Vibelin's small one has no twin.
                   '/obj/item/mana_battery/mana_crystal/standard': '/obj/item/magic/manacrystal'},
    # Path rewrites of Vibelin items before the lookups (prefix -> prefix).
    'item_rewrites': {'/obj/item/alch/herb': '/obj/item/alch', '/obj/item/neuFarm/seed': ['/obj/item/herbseed', '/obj/item/seeds']},
    # Lists of earlier ports: Vibelin type -> the module's type (column type -> target).
    'ported_lists': ['.cache/modular_redtard/agents/h2/h2g_lists/food_ported.tsv', '.cache/modular_redtard/agents/k3/k3g_lists/k3g_ported.tsv'],
    # K1v pairs: a module type (type) and the Vibelin types of the same item (vibelin_match).
    'k1v_duplicates': '.cache/modular_redtard/agents/k1/k1v_lists/duplicates.tsv',
    # Vibelin bottles of the alchemy shelf.
    'bottle_files': ['code/modules/reagents/reagent_containers/bottles/alchemy.dm'],
    # A reaction whose reagents are all TG's would change TG chemistry on modern maps: left out.
    'reaction_skip_tg_only': True,
}

STRING = re.compile(r'^"(?:[^"\\]|\\.)*"$')
NUMBER = re.compile(r'^-?(?:\d+\.?\d*|\.\d+)$')
PATH_RX = re.compile(r'^/[A-Za-z0-9_/]+$')
FILE_REF = re.compile(r"^'([^']+)'$")
PROC_HEAD = re.compile(r'^(/[A-Za-z0-9_/]+?)/(?:proc/|verb/)?([A-Za-z_][A-Za-z0-9_]*)\(')
HEADER = re.compile(r'^(/[A-Za-z0-9_/]+?)/?\s*(?://.*)?$')


def rel(path):
    return os.path.normpath(os.path.join(REPO, path))


def under(path, prefix):
    return path == prefix or path.startswith(prefix + '/')


def norm(name):
    return re.sub(r'[^a-z0-9]+', ' ', (name or '').lower()).strip()


def write_tsv(path, header, rows):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8', newline='\n') as handle:
        handle.write('\t'.join(header) + '\n')
        for row in rows:
            handle.write('\t'.join(str(row.get(h, '')).replace('\t', ' ').replace('\n', ' ') for h in header) + '\n')


def read_tsv(path):
    if not os.path.isfile(path):
        return []
    with open(path, encoding='utf-8') as handle:
        return list(csv.DictReader(handle, delimiter='\t', quoting=csv.QUOTE_NONE))


def split_top(text):
    """Top-level comma-separated parts of a text, strings and brackets respected."""
    parts, depth, cur, quote = [], 0, [], None
    i = 0
    while i < len(text):
        c = text[i]
        if quote:
            cur.append(c)
            if c == '\\' and i + 1 < len(text):
                cur.append(text[i + 1])
                i += 2
                continue
            if c == quote:
                quote = None
        elif c in '"\'':
            quote = c
            cur.append(c)
        elif c in '([':
            depth += 1
            cur.append(c)
        elif c in ')]':
            depth -= 1
            cur.append(c)
        elif c == ',' and depth == 0:
            parts.append(''.join(cur).strip())
            cur = []
        else:
            cur.append(c)
        i += 1
    if ''.join(cur).strip():
        parts.append(''.join(cur).strip())
    return parts


def list_entries(raw):
    """(key, value) entries of a DM list(...); value None for a plain entry. [] for null or an empty list."""
    raw = (raw or '').strip()
    if not raw.startswith('list(') or not raw.endswith(')'):
        return []
    out = []
    for part in split_top(raw[5:-1]):
        depth, quote, cut = 0, None, -1
        for i, c in enumerate(part):
            if quote:
                if c == quote:
                    quote = None
                continue
            if c in '"\'':
                quote = c
            elif c in '([':
                depth += 1
            elif c in ')]':
                depth -= 1
            elif c == '=' and depth == 0 and part[i + 1:i + 2] != '=' and part[i - 1:i] not in '!<>=':
                cut = i
                break
        if cut >= 0:
            out.append((part[:cut].strip(), part[cut + 1:].strip()))
        else:
            out.append((part.strip(), None))
    return out


class Tree:
    """Parsed types of a compile: vars, declaring files, and the procs each type defines."""

    def __init__(self, files, label):
        self.label = label
        types, defines, self.declared = engine.parse(files)
        self.types = types
        self.src = engine.Source(types, defines)
        self.defines = defines
        self.all_paths = set()
        for path in types:
            parts = path.split('/')
            for k in range(2, len(parts) + 1):
                self.all_paths.add('/'.join(parts[:k]))

    def resolve(self, path, var):
        return self.src.resolve(path, var)

    def subtypes(self, root, strict=True):
        return sorted(p for p in self.all_paths if under(p, root) and (p != root or not strict))

    def abstract(self, path):
        return (self.resolve(path, 'abstract_type') or '').strip().rstrip('/') == path

    def name(self, path):
        raw = self.resolve(path, 'name')
        if raw is None:
            return ''
        value = self.src.expand(raw)
        return value[1:-1] if STRING.match(value) else ''


def scan_procs(files):
    """{type: set of procs} of the given files (a proc header at column 0)."""
    procs = collections.defaultdict(set)
    for path in files:
        for line in open(path, encoding='utf-8', errors='ignore'):
            head = PROC_HEAD.match(line)
            if head and not line.startswith(('\t', ' ')):
                procs[head.group(1).rstrip('/')].add(head.group(2))
    return procs


class AlchemyPorter:
    def __init__(self, cfg, out_dir):
        self.cfg = cfg
        self.out_dir = out_dir
        self.final_dir = cfg['final_dir'].replace('\\', '/').rstrip('/')
        self.notes = collections.Counter()
        self.rows = []          # not ported / ported rows: kind, source, path, target, status, reason
        self.path_map = collections.OrderedDict()   # Vibelin (or Azure) path -> {target, how}
        self.blocks = collections.defaultdict(list)  # file -> [(path, [lines])]
        self.generated = {}     # generated path -> {var: value} (written values)
        self.copies = {}
        vib = cfg['vibelin']
        print('parsing Vibelin')
        self.vib_files = engine.compiled_files(rel(vib['root']), vib.get('dme'))
        self.vib = Tree(self.vib_files, 'vibelin')
        self.vib_root = rel(vib['root'])
        az = cfg['azure']
        self.az = None
        if os.path.isdir(rel(az['root'])):
            print('parsing Azure Peak')
            self.az = Tree(engine.compiled_files(rel(az['root']), az.get('dme')), 'azure')
        print('parsing TG')
        tg_files = engine.compiled_files(REPO, cfg['tg_dme'])
        tg_files = [f for f in tg_files if not os.path.normpath(f).startswith(rel(cfg['module_scan']))]
        self.tg = Tree(tg_files, 'tg')
        print('parsing the module')
        skip = [os.path.join(os.path.normpath(p), '') for p in (os.path.abspath(out_dir), rel(self.final_dir))]
        mod_files = []
        for dp, _dn, fn in os.walk(rel(cfg['module_scan'])):
            if any(os.path.join(os.path.normpath(dp), '').startswith(s) for s in skip):
                continue
            mod_files += [os.path.join(dp, f) for f in fn if f.endswith('.dm')]
        self.mod = Tree(mod_files, 'module')
        self.mod_known = self.mod.all_paths
        self.tg_known = self.tg.all_paths
        self.mod_file_of = {p: sorted(os.path.relpath(f, REPO).replace('\\', '/') for f in fs) for p, fs in self.mod.declared.items()}
        self.vib_procs = scan_procs(self.vib_files)
        self.index_names()
        self.load_pairs()

    # -- indexes ---------------------------------------------------------------------------------------------------

    def index_names(self):
        self.mod_item_names = collections.defaultdict(list)
        self.mod_reagent_names = collections.defaultdict(list)
        for path in self.mod.types:
            if under(path, '/obj/item') and not self.mod.abstract(path):
                name = self.mod.name(path) or self.tg.name(path)
                if name:
                    self.mod_item_names[norm(name)].append(path)
            elif under(path, '/datum/reagent') and not self.mod.abstract(path):
                name = self.combined_name(path)
                if name:
                    self.mod_reagent_names[norm(name)].append(path)

    def combined_name(self, path):
        """The name a type has in the compiled game (the module over TG), through inheritance."""
        seen = set()
        while path and path not in seen:
            seen.add(path)
            for tree in (self.mod, self.tg):
                value = tree.types.get(path, {}).get('name')
                if value is not None:
                    value = tree.src.expand(value)
                    return value[1:-1] if STRING.match(value) else ''
            path = path.rsplit('/', 1)[0] if path.count('/') > 1 else None
        return ''

    def load_pairs(self):
        self.ported_pairs = {}
        for listing in self.cfg['ported_lists']:
            for row in read_tsv(rel(listing)):
                if row.get('target') and row['target'] in self.mod_known:
                    self.ported_pairs.setdefault(row['type'], row['target'])
        self.k1v_pairs = {}
        for row in read_tsv(rel(self.cfg['k1v_duplicates'])):
            if row.get('type') in self.mod_known:
                for match in (m for m in (row.get('vibelin_match') or '').split(',') if m):
                    self.k1v_pairs.setdefault(match, row['type'])

    def known(self, path):
        return path in self.mod_known or path in self.tg_known or path in self.generated

    # -- mapping ---------------------------------------------------------------------------------------------------

    def remember(self, source, path, target, how, kind):
        key = f'{source}:{path}' if source != 'vibelin' else path
        if key not in self.path_map:
            self.path_map[key] = {'kind': kind, 'target': target, 'how': how}

    def map_reagent(self, path, source='vibelin'):
        """The module's reagent for a source's reagent path; None if there is none (yet)."""
        path = path.strip().rstrip('/')
        if path in self.reagent_targets:
            return self.reagent_targets[path]
        tree = self.vib if source == 'vibelin' else self.az
        target, how = None, ''
        if path in self.cfg['reagent_pairs']:
            target, how = self.cfg['reagent_pairs'][path], 'pair'
        elif path in self.mod_known and path in self.mod.types:
            target, how = path, 'same path (module)'
        elif path in self.tg_known:
            target, how = path, 'same path (TG)'
        else:
            name = tree.name(path) if tree else ''
            found = sorted(self.mod_reagent_names.get(norm(name), [])) if name else []
            if found:
                target, how = found[0], 'same name' + (f' (of {len(found)})' if len(found) > 1 else '')
        if target and not self.known(target):
            target, how = None, ''
        if target:
            self.reagent_targets[path] = target
            self.remember(source, path, target, how, 'reagent')
        return target

    def map_item(self, path, source='vibelin', many=False):
        """The module's item (or items, with many) for a source's item path."""
        path = path.strip().rstrip('/')
        tree = self.vib if source == 'vibelin' else self.az
        hits = []
        how = ''
        options = [path]
        for prefix, to in self.cfg['item_rewrites'].items():
            if source == 'vibelin' and under(path, prefix):
                options = [t + path[len(prefix):] for t in ([to] if isinstance(to, str) else to)] + [path]
        rewritten = next((o for o in options if o in self.generated or o in self.mod.types), options[0])
        if source == 'vibelin' and path in self.cfg['item_pairs']:
            hits, how = [self.cfg['item_pairs'][path]], 'pair'
        elif path in self.generated:
            hits, how = [path], 'this run'
        elif rewritten in self.generated:
            hits, how = [rewritten], 'this run'
        elif rewritten in self.mod.types or (rewritten in self.tg_known and rewritten in self.tg.types and not under(rewritten, '/obj/item/reagent_containers/food')):
            hits, how = [rewritten], 'same path' if rewritten == path else 'path rewrite'
        elif source == 'vibelin' and path in self.ported_pairs:
            hits, how = [self.ported_pairs[path]], 'earlier port'
        elif source == 'vibelin' and path in self.k1v_pairs:
            hits, how = [self.k1v_pairs[path]], 'K1v pair'
        else:
            name = tree.name(path) if tree else ''
            found = sorted(self.mod_item_names.get(norm(name), [])) if name else []
            family = path.startswith('/obj/item/reagent_containers/food')
            found = [p for p in found if p.startswith('/obj/item/reagent_containers/food') == family]
            if len(found) > 1:
                # Several of that name (seeds, berries): the one whose last step is most like this one's; a generic
                # name with no close one is no match.
                tail = path.rsplit('/', 1)[-1]
                score = lambda p: difflib.SequenceMatcher(None, tail, p.rsplit('/', 1)[-1]).ratio()
                best = max(score(p) for p in found)
                if best < 0.6 and len(found) > 2:
                    found = []
                else:
                    found = sorted((p for p in found if score(p) == best), key=lambda p: (p.count('/'), p))
            if found:
                found.sort(key=lambda p: (p.count('/'), p))
                hits, how = (found if many else found[:1]), 'same name' + (f' (of {len(found)})' if len(found) > 1 else '')
        hits = [h for h in hits if self.known(h)]
        if hits:
            self.remember(source, path, hits if many and len(hits) > 1 else hits[0], how, 'item')
        return hits if many else (hits[0] if hits else None)

    # -- values ----------------------------------------------------------------------------------------------------

    def number(self, tree, raw):
        if raw is None:
            return None
        value = tree.src.expand(raw.strip())
        if NUMBER.match(value):
            return float(value)
        for _ in range(8):
            expanded = re.sub(r'[A-Za-z_][A-Za-z0-9_]*', lambda m: f'({tree.defines[m.group(0)]})' if m.group(0) in tree.defines else m.group(0), value)
            if expanded == value:
                break
            value = expanded
        if re.match(r'^[\d.\s+\-*/()]+$', value):
            try:
                return float(eval(value, {'__builtins__': {}}, {}))
            except (SyntaxError, ZeroDivisionError, TypeError):
                return None
        return None

    @staticmethod
    def fmt(number):
        number = round(number, 4)
        return str(int(number)) if float(number).is_integer() else f'{number:g}'

    def string(self, tree, raw):
        if raw is None:
            return None
        value = tree.src.expand(raw.strip())
        if STRING.match(value) and '[' not in value:
            return value
        if value.startswith('{"') and value.endswith('"}') and '[' not in value:
            return value
        return None

    def rank(self, raw):
        value = (raw or '').strip()
        for suffix, define in RANKS.items():
            if value.endswith('_' + suffix):
                return define
        if NUMBER.match(value) and 0 <= int(float(value)) < len(RANK_NUMBERS):
            return RANK_NUMBERS[int(float(value))]
        return None

    def reagent_list(self, tree, raw, source='vibelin'):
        """list(path = amount) of reagents mapped to the module; (text or None, missing paths)."""
        pairs, missing = collections.OrderedDict(), []
        for key, value in list_entries(raw):
            key = key.rstrip('/')
            if not key.startswith('/datum/reagent'):
                continue
            target = self.map_reagent(key, source)
            amount = self.number(tree, value) if value is not None else 1
            if not target:
                missing.append(key)
                continue
            if amount is None:
                missing.append(f'{key} (amount {value})')
                continue
            pairs[target] = pairs.get(target, 0) + amount
        return pairs, missing

    def item_list(self, tree, raw, source='vibelin'):
        pairs, missing = collections.OrderedDict(), []
        for key, value in list_entries(raw):
            key = key.rstrip('/')
            if not key.startswith('/obj/'):
                continue
            target = self.map_item(key, source)
            amount = self.number(tree, value) if value is not None else 1
            if not target or amount is None:
                missing.append(key)
                continue
            pairs[target] = pairs.get(target, 0) + amount
        return pairs, missing

    def essence_list(self, raw):
        pairs, missing = collections.OrderedDict(), []
        for key, value in list_entries(raw):
            key = key.rstrip('/')
            amount = self.number(self.vib, value) if value is not None else None
            if key not in self.essences or amount is None:
                missing.append(key)
                continue
            pairs[self.essences[key]] = pairs.get(self.essences[key], 0) + amount
        return pairs, missing

    def list_text(self, pairs):
        return 'list(' + ', '.join(f'{k} = {self.fmt(v)}' for k, v in pairs.items()) + ')' if pairs else 'list()'

    def put_block(self, file, path, values, comment=None):
        lines = []
        if comment:
            lines.append(f'// {comment}')
        lines.append(path)
        lines += [f'\t{k} = {v}' for k, v in values.items()]
        self.blocks[file].append((path, lines))
        self.generated[path] = dict(values)

    def row(self, kind, source, path, target, status, reason=''):
        self.rows.append({'kind': kind, 'source': source, 'path': path, 'target': target or '', 'status': status, 'reason': reason})

    def vib_types(self, root, files=None):
        """Vibelin's concrete types under a root (the root and abstract steps left out), declared in the given files."""
        out = []
        for path in self.vib.subtypes(root):
            if self.vib.abstract(path):
                continue
            if files is not None:
                where = {os.path.relpath(f, self.vib_root).replace('\\', '/') for f in self.vib.declared.get(path, ())}
                if not where & set(files):
                    continue
            out.append(path)
        return out

    def target_path(self, kind, vpath):
        base = BASES[kind]
        return base['root'] + vpath[len(base['vibelin_root']):]

    # -- essences and their kin ------------------------------------------------------------------------------------

    def port_essences(self):
        base = BASES['essence']
        self.essences = {}
        for path in self.vib_types(base['vibelin_root']):
            self.essences[path] = self.target_path('essence', path)
        for path, target in self.essences.items():
            values = collections.OrderedDict()
            for theirs, ours in base['vars'].items():
                if not ours or theirs not in self.vib.types.get(path, {}):
                    continue
                raw = self.vib.types[path][theirs]
                if theirs == 'tier':
                    number = self.number(self.vib, raw)
                    if number is not None:
                        values[ours] = self.fmt(number)
                elif theirs == 'attunement':
                    value = raw.strip().rstrip('/')
                    if value.startswith('/') and self.known(value):
                        values[ours] = value
                    else:
                        self.notes[f'essence attunement without a module type, left out: {value}'] += 1
                else:
                    text = self.string(self.vib, raw)
                    if text is not None:
                        values[ours] = text
            self.put_block('essences.dm', target, values)
            self.remember('vibelin', path, target, 'essence', 'essence')
            self.row('essence', 'vibelin', path, target, 'ported')

    def port_combinations(self):
        base = BASES['combination']
        for path in self.vib_types(base['vibelin_root']):
            r = self.vib.types[path]
            inputs, missing = self.essence_list(r.get('inputs'))
            output = (self.vib.resolve(path, 'output_type') or '').strip().rstrip('/')
            if missing or output not in self.essences:
                self.row('combination', 'vibelin', path, '', 'not ported', 'an essence unknown: ' + ', '.join(missing + ([output] if output not in self.essences else [])))
                continue
            values = collections.OrderedDict()
            name = self.string(self.vib, self.vib.resolve(path, 'name'))
            if name:
                values[base['vars']['name']] = name
            values[base['vars']['inputs']] = self.list_text(inputs)
            values[base['vars']['output_type']] = self.essences[output]
            amount = self.number(self.vib, self.vib.resolve(path, 'output_amount'))
            if amount is not None:
                values[base['vars']['output_amount']] = self.fmt(amount)
            if 'skill_required' in r:
                rank = self.rank(r['skill_required'])
                if rank:
                    values[base['vars']['skill_required']] = rank
            target = self.target_path('combination', path)
            self.put_block('essence_combinations.dm', target, values)
            self.remember('vibelin', path, target, 'combination', 'recipe')
            self.row('combination', 'vibelin', path, target, 'ported')

    def port_precursors(self):
        base = BASES['precursor']
        self.claimed = collections.defaultdict(list)
        for path in self.vib_types(base['vibelin_root']):
            yields, missing = self.essence_list(self.vib.resolve(path, 'essence_yields'))
            if missing or not yields:
                self.row('precursor', 'vibelin', path, '', 'not ported', 'an essence unknown: ' + ', '.join(missing))
                continue
            types, lost = [], []
            for key, _ in list_entries(self.vib.resolve(path, 'init_types')):
                key = key.rstrip('/')
                hits = self.map_item(key, many=True)
                if not hits:
                    lost.append(key)
                for hit in hits:
                    if hit not in types:
                        types.append(hit)
            for key in lost:
                self.row('precursor item', 'vibelin', key, '', 'not mapped', f'{path}: the module has no such item')
            if not types:
                self.row('precursor', 'vibelin', path, '', 'not ported', 'none of its items is in the module')
                continue
            target = self.target_path('precursor', path)
            for t in types:
                self.claimed[t].append(target)
            values = collections.OrderedDict()
            name = self.string(self.vib, self.vib.resolve(path, 'name'))
            if name:
                values[base['vars']['name']] = name
            values[base['vars']['essence_yields']] = self.list_text(yields)
            values[base['vars']['init_types']] = 'list(' + ', '.join(types) + ')'
            self.put_block('precursors.dm', target, values, f'not in the module: {", ".join(lost)}' if lost else None)
            self.remember('vibelin', path, target, 'precursor', 'recipe')
            self.row('precursor', 'vibelin', path, target, 'ported' if not lost else 'ported in part', f'{len(lost)} of its items not in the module' if lost else '')

    def port_infusions(self):
        base = BASES['infusion']
        for path in self.vib_types(base['vibelin_root']):
            needs, missing = self.essence_list(self.vib.resolve(path, 'required_essences'))
            raw_in = (self.vib.resolve(path, 'target_type') or '').strip().rstrip('/')
            raw_out = (self.vib.resolve(path, 'result_type') or '').strip().rstrip('/')
            what = self.map_item(raw_in) if raw_in.startswith('/') else None
            into = self.map_item(raw_out) if raw_out.startswith('/') else None
            why = []
            if missing:
                why.append('an essence unknown: ' + ', '.join(missing))
            if not what:
                why.append(f'its item {raw_in} is not in the module')
            if not into:
                why.append(f'its result {raw_out} is not in the module')
            if why:
                self.row('infusion', 'vibelin', path, '', 'not ported', '; '.join(why))
                continue
            values = collections.OrderedDict()
            name = self.string(self.vib, self.vib.resolve(path, 'name'))
            if name:
                values[base['vars']['name']] = name
            values[base['vars']['target_type']] = what
            values[base['vars']['result_type']] = into
            values[base['vars']['required_essences']] = self.list_text(needs)
            target = self.target_path('infusion', path)
            self.put_block('infusion_recipes.dm', target, values)
            self.remember('vibelin', path, target, 'infusion', 'recipe')
            self.row('infusion', 'vibelin', path, target, 'ported')

    # -- reagents --------------------------------------------------------------------------------------------------

    def plan_reagents(self):
        """Which Vibelin reagents this run writes data for, and under which path."""
        self.reagent_targets = {}
        self.reagent_new = {}      # Vibelin path -> generated path (a reagent the module lacks)
        self.reagent_overlay = {}  # Vibelin path -> module path taking Vibelin's data
        self.reagent_kept = {}     # Vibelin path -> module path keeping its own data
        self.reagent_implicit = set()
        overwrite = {f.replace('\\', '/') for f in self.cfg['module_overwrite_files']}
        files = set(self.cfg['reagent_files'])
        self.data_reagents = self.vib_types('/datum/reagent', files)
        self.data_reagents += [p for p in self.cfg.get('reagent_extra', []) if p in self.vib.types and p not in self.data_reagents]
        self.reagent_file = {}
        for path in self.vib.subtypes('/datum/reagent'):
            where = sorted(os.path.relpath(f, self.vib_root).replace('\\', '/') for f in self.vib.declared.get(path, ()))
            if where:
                self.reagent_file[path] = where[0]
        for path in self.data_reagents:
            if path in self.cfg['reagent_skip']:
                self.row('reagent', 'vibelin', path, '', 'skipped', self.cfg['reagent_skip'][path])
                continue
            target = self.map_reagent(path)
            if target and target in self.tg_known and target not in self.mod.types:
                self.row('reagent', 'vibelin', path, target, 'TG', "TG's reagent: left as TG's (modern maps)")
                continue
            if target:
                files_of = set(self.mod_file_of.get(target, []))
                if files_of & overwrite:
                    self.reagent_overlay[path] = target
                else:
                    self.reagent_kept[path] = target
                    self.row('reagent', 'vibelin', path, target, 'module keeps', 'the module has it in ' + ', '.join(sorted(files_of)) + ': its own data stays')
                continue
            self.reagent_new[path] = None
        # A new reagent goes under the module's type of its nearest Vibelin parent that the module has under another
        # path (Vibelin's poison/berry/shroom is the module's berrypoison/shroom), else it keeps its Vibelin path.
        for path in sorted(self.reagent_new, key=lambda p: (p.count('/'), p)):
            target, how = path, 'new (Vibelin path)'
            step = path.rsplit('/', 1)[0]
            while step.count('/') > 2:
                mapped = self.reagent_targets.get(step)
                if mapped and mapped != step:
                    target, how = mapped + path[len(step):], f'new, under the module\'s {mapped}'
                    break
                step = step.rsplit('/', 1)[0]
            self.reagent_new[path] = target
            self.reagent_targets[path] = target
            self.remember('vibelin', path, target, how, 'reagent')
        # A new reagent's steps the module lacks become types too: they must be the same as Vibelin's (abstract or not).
        for path in list(self.reagent_new):
            step = self.reagent_new[path].rsplit('/', 1)[0]
            while step.count('/') > 2 and not self.known(step) and step not in self.reagent_new.values():
                if step not in self.reagent_targets:
                    self.reagent_new[step] = step
                    self.reagent_targets[step] = step
                    if step not in self.vib.types:
                        # Declared by its subtypes only (Vibelin's poison/): written abstract, a step and no reagent.
                        self.reagent_implicit.add(step)
                    self.remember('vibelin', step, step, 'new step (Vibelin path)', 'reagent')
                step = step.rsplit('/', 1)[0]
        for path in self.vib.subtypes('/datum/reagent'):
            if path not in self.reagent_new and path not in self.reagent_overlay and path not in self.reagent_kept and path not in self.reagent_targets:
                f = self.reagent_file.get(path, '')
                if f in self.cfg['reagent_files_later'] and not self.vib.abstract(path):
                    self.map_reagent(path)  # still map it for recipes (the module may have it)

    def write_reagents(self):
        base = BASES['reagent']
        self.reagent_rows = []
        for path in sorted(set(self.reagent_new) | set(self.reagent_overlay), key=lambda p: (p.count('/'), p)):
            target = self.reagent_new.get(path) or self.reagent_overlay[path]
            values = collections.OrderedDict()
            own = self.vib.types.get(path, {})
            if path in self.reagent_new and (self.vib.abstract(path) or path in self.reagent_implicit):
                values['abstract_type'] = target
            for theirs, ours in base['vars'].items():
                # A new reagent inherits like Vibelin's only where its module parent is Vibelin's too; a pair
                # (overlay) takes every var Vibelin's chain gives it, short of Vibelin's /datum/reagent root.
                raw = own.get(theirs) if path in self.reagent_new and self.parent_is_generated(path) else self.chain(path, theirs)
                if raw is None:
                    continue
                if not ours:
                    self.notes[f'reagent var not in the module, left out: {theirs}'] += 1
                    continue
                if theirs == 'taste_mult':
                    number = self.number(self.vib, raw)
                    if number is not None:
                        values[ours] = self.fmt(number)
                    continue
                text = self.string(self.vib, raw)
                if text is None:
                    self.notes[f'reagent {theirs} not a plain string, left out'] += 1
                    continue
                if text == '""' and theirs != 'name':
                    continue
                values[ours] = text
            if not values and path in self.reagent_overlay:
                continue
            self.put_block('reagents.dm', target, values)
            procs = sorted(self.vib_procs.get(path, ()))
            parent = target.rsplit('/', 1)[0]
            tg_parent = parent if parent in self.tg_known and parent != '/datum/reagent' else ''
            extra = {k: self.vib.resolve(path, k) for k in ('metabolization_rate', 'overdose_threshold', 'boiling_point', 'price_per_unit', 'quality')}
            self.reagent_rows.append({'target': target, 'vibelin': path, 'how': 'new' if path in self.reagent_new else 'onto the module path',
                                      'file': self.reagent_file.get(path, ''), 'procs': ','.join(procs), 'tg_parent': tg_parent,
                                      'name': values.get('name', ''), **{k: (v or '') for k, v in extra.items()}})
            self.row('reagent', 'vibelin', path, target, 'ported', 'new' if path in self.reagent_new else 'data onto the module path')

    def chain(self, path, var):
        """A var of a Vibelin reagent through its parents, Vibelin's /datum/reagent root left out (its defaults are
        not the module's)."""
        while path and path != '/datum/reagent':
            value = self.vib.types.get(path, {}).get(var)
            if value is not None:
                return value.strip()
            path = path.rsplit('/', 1)[0]
        return None

    def parent_is_generated(self, path):
        parent = path.rsplit('/', 1)[0]
        return parent in self.reagent_new or parent in self.reagent_overlay or parent == '/datum/reagent'

    # -- recipes ---------------------------------------------------------------------------------------------------

    def ratwood_ranks(self):
        """Ratwood's ranks of its cauldron recipes by the reagent they make (module paths)."""
        ranks = {}
        for root, *files in self.cfg['ratwood_recipes']:
            paths = [os.path.join(rel(root), f) for f in files]
            if not all(os.path.isfile(p) for p in paths):
                continue
            tree = Tree(paths, 'ratwood')
            for path in tree.subtypes('/datum/alch_cauldron_recipe'):
                rank = self.rank(tree.resolve(path, 'skill_required'))
                for key, _ in list_entries(tree.resolve(path, 'output_reagents')):
                    key = key.rstrip('/')
                    if rank and key not in ranks:
                        ranks[key] = (rank, path)
            print(f'Ratwood ranks from {root}: {len(ranks)}')
            break
        else:
            print('Ratwood recipes not found: no ranks')
        return ranks

    def port_cauldron(self):
        base = BASES['cauldron']
        ranks = self.ratwood_ranks()
        used = set()
        for path in self.vib_types(base['vibelin_root']):
            r = lambda var: self.vib.resolve(path, var)
            needs, missing = self.essence_list(r('required_essences'))
            outs, lost = self.reagent_list(self.vib, r('output_reagents'))
            items, lost_items = self.item_list(self.vib, r('output_items'))
            why = []
            if missing:
                why.append('an essence unknown: ' + ', '.join(missing))
            if lost or lost_items:
                why.append('its result is not in the module: ' + ', '.join(lost + lost_items))
            if not needs:
                why.append('no essences: it would match an empty cauldron')
            if not outs and not items:
                why.append('nothing to make')
            if why:
                self.row('cauldron', 'vibelin', path, '', 'not ported', '; '.join(why))
                continue
            values = collections.OrderedDict()
            name = self.string(self.vib, r('recipe_name'))
            if name:
                values[base['vars']['recipe_name']] = name
            smell = self.string(self.vib, r('smells_like'))
            if smell:
                values[base['vars']['smells_like']] = smell
            values[base['vars']['output_reagents']] = self.list_text(outs)
            if items:
                values[base['vars']['output_items']] = self.list_text(items)
            values[base['vars']['required_essences']] = self.list_text(needs)
            if 'category' in self.vib.types.get(path, {}):
                cat = self.string(self.vib, self.vib.types[path]['category'])
                if cat:
                    values[base['vars']['category']] = cat
            rank = next((ranks[k] for k in outs if k in ranks), None)
            if rank:
                values[base['vars']['skill_required']] = rank[0]
                used.add(rank[1])
            target = self.target_path('cauldron', path)
            self.put_block('cauldron_recipes.dm', target, values, f"rank from Ratwood's {rank[1].rsplit('/', 1)[-1]}" if rank else None)
            self.remember('vibelin', path, target, 'cauldron recipe', 'recipe')
            self.row('cauldron', 'vibelin', path, target, 'ported', f'rank {rank[0]} (Ratwood)' if rank else 'rank: the base default')
        self.ratwood_left = sorted({p for _rk, p in ranks.values()} - used)
        for path in self.ratwood_left:
            self.row('cauldron', 'ratwood', path, '', 'not ported', 'no Vibelin recipe makes its reagent: content of block VA2 (essences picked by hand)')

    def module_grind_inputs(self):
        inputs = {}
        for path in self.mod.subtypes(BASES['grind']['root']):
            raw = (self.mod.resolve(path, 'valid_input') or '').strip().rstrip('/')
            if raw.startswith('/'):
                inputs.setdefault(raw, path)
        return inputs

    def port_grind(self):
        base = BASES['grind']
        taken = self.module_grind_inputs()
        root = base['root']
        for source, tree in (('vibelin', self.vib), ('azure', self.az)):
            if tree is None:
                continue
            step = f"{root}/{base['steps'][source]}"
            wrote = 0
            for path in tree.subtypes(base['vibelin_root']):
                if tree.abstract(path):
                    continue
                r = lambda var: tree.resolve(path, var)
                raw_in = (r('valid_input') or '').strip().rstrip('/')
                if not raw_in.startswith('/'):
                    continue
                what = self.map_item(raw_in, source)
                outs, lost = self.item_list(tree, r('valid_outputs'), source)
                bonus, lost_b = self.item_list(tree, r('bonus_chance_outputs'), source)
                why = []
                if not what:
                    why.append(f'its item {raw_in} is not in the module')
                elif what in taken:
                    why.append(f'the module grinds {what} already ({taken[what]})')
                if lost or not outs:
                    why.append('its result is not in the module: ' + ', '.join(lost or ['nothing']))
                if why:
                    self.row('grind', source, path, '', 'not ported', '; '.join(why))
                    continue
                if lost_b:
                    self.notes[f'{source} mortar: a bonus output not in the module, left out'] += len(lost_b)
                values = collections.OrderedDict()
                name = self.string(tree, r('name'))
                values[base['vars']['name']] = name or json.dumps(self.combined_name(what) or what.rsplit('/', 1)[-1])
                picky = (r('picky') or 'TRUE').strip()
                if picky in ('FALSE', '0'):
                    values[base['vars']['picky']] = 'FALSE'
                values[base['vars']['valid_input']] = what
                values[base['vars']['valid_outputs']] = self.list_text(outs)
                if bonus:
                    values[base['vars']['bonus_chance_outputs']] = self.list_text(bonus)
                target = step + path[len(base['vibelin_root']):]
                self.put_block('grind_recipes.dm', target, values)
                taken[what] = target
                self.remember(source, path, target, 'mortar recipe', 'recipe')
                self.row('grind', source, path, target, 'ported')
                wrote += 1
            if wrote:
                self.put_block('grind_recipes.dm', step, collections.OrderedDict(abstract_type=step))

    def port_distillation(self):
        base = BASES['distillation']
        for path in self.vib_types(base['vibelin_root']):
            r = lambda var: self.vib.resolve(path, var)
            raw = (r('distilled_reagent') or '').strip().rstrip('/')
            what = self.map_reagent(raw) if raw.startswith('/') else None
            needs, lost = self.reagent_list(self.vib, r('required_reagents'))
            outs, lost_o = self.reagent_list(self.vib, r('results'))
            why = []
            if not what:
                why.append(f'its reagent {raw} is not in the module')
            if lost or lost_o:
                why.append('a reagent not in the module: ' + ', '.join(lost + lost_o))
            if not outs:
                why.append('nothing to make')
            if why:
                self.row('distillation', 'vibelin', path, '', 'not ported', '; '.join(why))
                continue
            values = collections.OrderedDict()
            for var in ('name', 'id', 'distill_message', 'distill_sound'):
                # An id is the recipe's own (Vibelin's subtypes inherit their parent's, which would make them one).
                text = self.string(self.vib, self.vib.types.get(path, {}).get(var) if var == 'id' else r(var))
                if text and base['vars'].get(var):
                    values[base['vars'][var]] = text
            values[base['vars']['distilled_reagent']] = what
            if needs:
                values[base['vars']['required_reagents']] = self.list_text(needs)
            if (r('consume_reagents') or 'FALSE').strip() in ('TRUE', '1'):
                values[base['vars']['consume_reagents']] = 'TRUE'
            values[base['vars']['results']] = self.list_text(outs)
            temp = r('required_temp')
            if temp is not None:
                kelvin = self.number(self.vib, temp)
                if kelvin is None:
                    self.notes['distillation temperature not a number, left out'] += 1
                else:
                    values[base['vars']['required_temp']] = self.fmt(kelvin)
            target = self.target_path('distillation', path)
            self.put_block('distillation_recipes.dm', target, values)
            self.remember('vibelin', path, target, 'distillation recipe', 'recipe')
            self.row('distillation', 'vibelin', path, target, 'ported')

    def port_reactions(self):
        base = BASES['reaction']
        root = base['root']
        self.reactions = {}
        for path in self.vib_types(base['vibelin_root']):
            r = lambda var: self.vib.resolve(path, var)
            if any(v in self.vib.types.get(path, {}) for v in ('randomize_inputs', 'possible_reagents')):
                self.row('reaction', 'vibelin', path, '', 'not ported', "a randomized recipe: TG's own randomized reactions stand")
                continue
            needs, lost = self.reagent_list(self.vib, r('required_reagents'))
            outs, lost_o = self.reagent_list(self.vib, r('results'))
            cats, lost_c = self.reagent_list(self.vib, r('required_catalysts'))
            why = []
            if lost or lost_o or lost_c:
                why.append('a reagent not in the module: ' + ', '.join(lost + lost_o + lost_c))
            if not needs:
                why.append('no reagents')
            if not why and self.cfg['reaction_skip_tg_only'] and all(k in self.tg_known and k not in self.mod.types for k in list(needs) + list(cats)):
                why.append("all its reagents are TG's: it would change TG chemistry on modern maps")
            if why:
                self.row('reaction', 'vibelin', path, '', 'not ported', '; '.join(why))
                continue
            values = collections.OrderedDict()
            values[base['vars']['required_reagents']] = self.list_text(needs)
            values[base['vars']['results']] = self.list_text(outs)
            if cats:
                values[base['vars']['required_catalysts']] = self.list_text(cats)
            temp = r('required_temp')
            if temp is not None:
                kelvin = self.number(self.vib, temp)
                if kelvin:
                    values[base['vars']['required_temp']] = self.fmt(kelvin)
            if (r('is_cold_recipe') or 'FALSE').strip() in ('TRUE', '1'):
                values[base['vars']['is_cold_recipe']] = 'TRUE'
            msg = self.string(self.vib, r('mix_message'))
            if msg:
                values[base['vars']['mix_message']] = msg
            sound = (r('mix_sound') or '').strip()
            ref = FILE_REF.match(sound)
            if ref and os.path.isfile(rel(ref.group(1))):
                values[base['vars']['mix_sound']] = sound
            elif ref:
                self.notes['reaction sound not in the repository, the root\'s stays'] += 1
            container = (r('required_container') or '').strip().rstrip('/')
            if container.startswith('/'):
                hit = self.map_item(container)
                if not hit:
                    self.row('reaction', 'vibelin', path, '', 'not ported', f'its container {container} is not in the module')
                    continue
                values[base['vars']['required_container']] = hit
            if (r('mob_react') or 'TRUE').strip() in ('FALSE', '0'):
                values[base['vars']['mob_react']] = 'FALSE'
            tail = path[len(base['vibelin_root']) + 1:].replace('/', '_')
            target = f'{root}/{tail}'
            if target in self.mod_known:
                target = f'{root}/vibelin_{tail}'
            self.put_block('reactions.dm', target, values)
            self.reactions[target] = {'required_reagents': needs, 'required_catalysts': cats, 'required_temp': float(values.get('required_temp', 0)),
                                      'is_cold_recipe': 'is_cold_recipe' in values, 'required_container': values.get('required_container'), 'competitive': False}
            self.remember('vibelin', path, target, 'reaction', 'recipe')
            self.row('reaction', 'vibelin', path, target, 'ported')

    # -- items -----------------------------------------------------------------------------------------------------

    def asset(self, ref, state=None):
        """A Vibelin sprite sheet: the module's sheet of the same name if it is the same file or has the state, else
        Vibelin's copied beside the data."""
        source = os.path.join(self.vib_root, ref)
        for folder in ('modular_redtard/rockhill/icons', 'modular_redtard/items_vibelin/icons/icons', 'modular_redtard/items_vibelin/icons'):
            tail = ref[len('icons/'):] if ref.startswith('icons/') and folder.endswith('rockhill/icons') else ref
            candidate = os.path.join(rel(folder), tail)
            if not os.path.isfile(candidate) or not os.path.isfile(source):
                continue
            if open(candidate, 'rb').read() == open(source, 'rb').read() or (state and state in engine.dmi_meta(candidate)[2]):
                return os.path.relpath(candidate, REPO).replace('\\', '/')
        if not os.path.isfile(source):
            return None
        tail = ref[len('icons/'):] if ref.startswith('icons/') else ref
        self.copies[source] = os.path.join(self.out_dir, 'icons', tail)
        return f'{self.final_dir}/icons/{tail}'

    def port_ingredients(self):
        base = BASES['ingredient']
        for path in self.vib_types(base['vibelin_root']):
            hit = self.map_item(path)
            if hit:
                self.row('ingredient', 'vibelin', path, hit, 'in the module')
                continue
            target = path
            for prefix, to in self.cfg['item_rewrites'].items():
                if under(path, prefix):
                    target = (to if isinstance(to, str) else to[0]) + path[len(prefix):]
            values = collections.OrderedDict()
            for theirs, ours in base['vars'].items():
                raw = self.vib.resolve(path, theirs)
                if raw is None or not ours:
                    continue
                value = self.vib.src.expand(raw.strip())
                if theirs == 'icon':
                    ref = FILE_REF.match(value)
                    state = self.string(self.vib, self.vib.resolve(path, 'icon_state') or '')
                    copied = self.asset(ref.group(1), state.strip('"') if state else None) if ref else None
                    if copied:
                        values[ours] = f"'{copied}'"
                    continue
                if theirs == 'w_class':
                    if value in self.tg.defines or value.startswith('WEIGHT_CLASS_'):
                        values[ours] = value
                    continue
                text = self.string(self.vib, raw)
                if text is not None:
                    values[ours] = text
            if 'icon' not in values:
                self.row('ingredient', 'vibelin', path, '', 'not ported', 'its sprite sheet is missing')
                continue
            self.put_block('ingredients.dm', target, values)
            self.remember('vibelin', path, target, 'new ingredient', 'item')
            self.row('ingredient', 'vibelin', path, target, 'ported', 'new')

    def module_bottle_contents(self):
        contents = {}
        for path in self.mod.subtypes(BASES['bottle']['root'], strict=False):
            raw = self.mod.resolve(path, 'list_reagents')
            keys = frozenset(k.rstrip('/') for k, _ in list_entries(raw) if k.startswith('/datum/reagent'))
            if keys:
                contents.setdefault(keys, path)
        return contents

    def port_bottles(self):
        base = BASES['bottle']
        have = self.module_bottle_contents()
        files = set(self.cfg['bottle_files'])
        step = f"{base['root']}/{base['step']}"
        wrote = 0
        chosen = {}
        for path in self.vib_types(base['vibelin_root'], files):
            pairs, lost = self.reagent_list(self.vib, self.vib.resolve(path, 'list_reagents'))
            if lost:
                self.row('bottle', 'vibelin', path, '', 'not ported', 'it comes filled with what the module lacks: ' + ', '.join(lost))
                continue
            if not pairs:
                continue
            key = frozenset(pairs)
            if key in have:
                self.row('bottle', 'vibelin', path, have[key], 'in the module', 'a module bottle holds the same')
                self.remember('vibelin', path, have[key], 'same content', 'item')
                continue
            # A labelled subtype and its plain parent are one bottle: the label names it.
            prev = chosen.get(key)
            if prev and not under(path, prev[0]):
                self.row('bottle', 'vibelin', path, '', 'not ported', f'same content as {prev[0]}')
                continue
            label = self.string(self.vib, self.vib.resolve(path, 'auto_label_name'))
            desc = self.string(self.vib, self.vib.resolve(path, 'auto_label_desc'))
            chosen[key] = (prev[0] if prev else path, pairs, label or (prev[2] if prev else None), desc or (prev[3] if prev else None))
        steps = set()
        for key, (path, pairs, label, desc) in chosen.items():
            # Under the module's bottle of the nearest Vibelin parent the module has (Vibelin's vial is the module's
            # alchemical vial), else under the root.
            parent, home = path.rsplit('/', 1)[0], None
            while under(parent, base['vibelin_root']) and parent != base['vibelin_root']:
                home = self.map_item(parent)
                if home:
                    break
                parent = parent.rsplit('/', 1)[0]
            if home:
                target = f"{home}/{base['step']}{path[len(parent):]}"
                steps.add(f"{home}/{base['step']}")
            else:
                target = step + path[len(base['vibelin_root']):]
                steps.add(step)
            values = collections.OrderedDict()
            if label:
                values[base['vars']['auto_label_name']] = label
            if desc:
                values[base['vars']['auto_label_desc']] = desc
            values[base['vars']['list_reagents']] = self.list_text(pairs)
            volume = self.number(self.vib, self.vib.resolve(path, 'volume'))
            module_volume = self.number(self.mod, self.mod.resolve(home or base['root'], 'volume'))
            total = sum(pairs.values())
            if volume and volume != module_volume and total > (module_volume or 0):
                values[base['vars']['volume']] = self.fmt(max(volume, total))
            self.put_block('bottles.dm', target, values)
            self.remember('vibelin', path, target, 'new bottle', 'item')
            self.row('bottle', 'vibelin', path, target, 'ported')
            wrote += 1
        for abstract in sorted(steps):
            self.put_block('bottles.dm', abstract, collections.OrderedDict(abstract_type=abstract))

    # -- checks ----------------------------------------------------------------------------------------------------

    def check_names(self):
        """Every concrete reagent's name unique (TG's reagent_names): TG, the module, then this run on top."""
        values = collections.defaultdict(dict)
        for tree in (self.tg, self.mod):
            for path, vars_ in tree.types.items():
                if under(path, '/datum/reagent'):
                    for var in ('name', 'abstract_type'):
                        if var in vars_:
                            values[path][var] = tree.src.expand(vars_[var]).strip()
        for path, vars_ in self.generated.items():
            if under(path, '/datum/reagent'):
                values[path].update({k: v for k, v in vars_.items() if k in ('name', 'abstract_type')})
        paths = set()
        for path in values:
            parts = path.split('/')
            for k in range(3, len(parts) + 1):
                paths.add('/'.join(parts[:k]))

        def resolve(path, var):
            while path:
                if var in values.get(path, {}):
                    return values[path][var]
                path = path.rsplit('/', 1)[0] if path.count('/') > 2 else None
            return None

        used = collections.defaultdict(list)
        for path in sorted(paths):
            if path == '/datum/reagent' or (resolve(path, 'abstract_type') or '').rstrip('/') == path:
                continue
            name = resolve(path, 'name') or ''
            if not STRING.match(name) or name == '""':
                continue
            used[name[1:-1].lower()].append(path)
        clashes = []
        for name, holders in sorted(used.items()):
            if len(holders) > 1:
                ours = [h for h in holders if h in self.generated]
                clashes.append({'name': name, 'types': ', '.join(holders), 'this_run': ', '.join(ours) or '-'})
        return clashes

    def check_reactions(self):
        """chem_recipes_do_conflict() of TG between this run's reactions, and against TG's and the module's."""
        others = {}
        for tree in (self.tg, self.mod):
            for path in tree.subtypes('/datum/chemical_reaction'):
                if path in self.generated:
                    continue
                req = collections.OrderedDict((k.rstrip('/'), self.number(tree, v) or 1) for k, v in list_entries(tree.resolve(path, 'required_reagents')))
                if not req:
                    continue
                flags = tree.resolve(path, 'reaction_flags') or ''
                cats = collections.OrderedDict((k.rstrip('/'), self.number(tree, v) or 1) for k, v in list_entries(tree.resolve(path, 'required_catalysts')))
                temp = self.number(tree, tree.resolve(path, 'required_temp') or '100')
                others[path] = {'required_reagents': req, 'required_catalysts': cats, 'required_temp': temp if temp is not None else 100,
                                'is_cold_recipe': (tree.resolve(path, 'is_cold_recipe') or 'FALSE').strip() == 'TRUE',
                                'required_container': (tree.resolve(path, 'required_container') or '').strip() or None,
                                'competitive': 'REACTION_COMPETITIVE' in flags}
        rows = []
        mine = sorted(self.reactions.items())
        print(f'reaction check: {len(mine)} of this run against {len(others)} of TG and the module')
        for i, (a, ra) in enumerate(mine):
            for b, rb in mine[i + 1:] + sorted(others.items()):
                if conflict(ra, rb):
                    rows.append({'reaction': a, 'with': b, 'where': 'this run' if b in self.reactions else 'TG or the module'})
        # The other way round too: TG's test checks every ordered pair.
        for b, rb in sorted(others.items()):
            for a, ra in mine:
                if conflict(rb, ra) and not any(r['reaction'] == a and r['with'] == b for r in rows):
                    rows.append({'reaction': a, 'with': b, 'where': 'TG or the module'})
        return rows

    def check_paths(self):
        """A generated type the module (outside this run's folders) or TG declares already, unless that is the point."""
        rows = []
        overlay = set(self.reagent_overlay.values())
        for path in self.generated:
            if path in overlay:
                continue
            where = []
            if path in self.mod.types:
                where.append('module: ' + ', '.join(self.mod_file_of.get(path, [])))
            if path in self.tg.types:
                where.append('TG')
            if where:
                rows.append({'path': path, 'declared': '; '.join(where)})
        return rows

    # -- the run ---------------------------------------------------------------------------------------------------

    def run(self, lists, dry_run):
        self.port_essences()
        self.plan_reagents()
        self.write_reagents()
        self.port_ingredients()
        self.port_combinations()
        self.port_precursors()
        self.port_infusions()
        self.port_cauldron()
        self.port_grind()
        self.port_distillation()
        self.port_reactions()
        self.port_bottles()
        names = self.check_names()
        reactions = self.check_reactions()
        paths = self.check_paths()
        overlaps = [{'item': item, 'precursors': ', '.join(holders)} for item, holders in sorted(self.claimed.items()) if len(holders) > 1]
        counts = collections.Counter((r['kind'], r['status']) for r in self.rows)
        print('rows:', ', '.join(f'{k} {s} {n}' for (k, s), n in sorted(counts.items())))
        for file in sorted(self.blocks):
            print(f'  {file}: {len(self.blocks[file])} types')
        print(f'checks: {len(names)} reagent name clashes ({sum(1 for n in names if n["this_run"] != "-")} with this run), '
              f'{len(reactions)} reaction conflicts, {len(overlaps)} items claimed by two precursors, {len(paths)} generated paths declared elsewhere')
        for what, times in self.notes.most_common():
            print(f'  note ({times}): {what}')
        if dry_run:
            return
        os.makedirs(self.out_dir, exist_ok=True)
        header = ('// Written by modular_redtard/tools/port_vibelin_alchemy.py from Vibelin (Vanderlin){extra}; do not edit by hand.\n'
                  '// Values of vars only: the bases and every proc are the module\'s alchemy code (see BASES in the script).\n')
        about = {
            'essences.dm': 'Essences (Vibelin essences.dm).', 'essence_combinations.dm': 'Essence mixes of the combiner (Vibelin essence_combinations.dm).',
            'precursors.dm': 'What the splitter splits each item into (Vibelin precursors.dm), on the module\'s items.',
            'infusion_recipes.dm': 'Infusions (Vibelin infusion_recipes.dm).', 'cauldron_recipes.dm': 'Cauldron recipes on essences (Vibelin cauldron_recipes.dm); ranks from Ratwood\'s recipes of the same reagent.',
            'grind_recipes.dm': 'Mortar recipes of Vibelin and Azure Peak the module (Ratwood\'s, alchemy/ported/alchemy.dm) lacks.',
            'distillation_recipes.dm': 'Distillation in the still (Vibelin recipes/distillation/).', 'reactions.dm': 'Mixing reactions (Vibelin recipes/), on TG\'s reaction holder.',
            'reagents.dm': 'Reagent data (name, description, colour, taste, smell); behaviour, temp and thresholds are VA1a\'s.',
            'ingredients.dm': 'Vibelin ingredients the module lacks.', 'bottles.dm': 'Vibelin\'s filled bottles of the alchemy shelf the module lacks.',
        }
        for file, blocks in self.blocks.items():
            extra = ' and Azure Peak' if file == 'grind_recipes.dm' else ''
            text = header.format(extra=extra) + f'// {about.get(file, "")}\n\n'
            text += '\n'.join('\n'.join(lines) + '\n' for _p, lines in sorted(blocks, key=lambda b: b[0]))
            with open(os.path.join(self.out_dir, file), 'w', encoding='utf-8', newline='\n') as handle:
                handle.write(text)
        for source, target in self.copies.items():
            os.makedirs(os.path.dirname(target), exist_ok=True)
            shutil.copyfile(source, target)
        with open(os.path.join(self.out_dir, 'path_map.json'), 'w', encoding='utf-8', newline='\n') as handle:
            json.dump({'about': 'Vibelin path (azure:path for Azure Peak) -> the module path this alchemy port uses; written by port_vibelin_alchemy.py.',
                       'bases': {k: {'root': v['root'], 'owner': v['owner']} for k, v in BASES.items()},
                       'paths': self.path_map}, handle, indent=1, ensure_ascii=False)
            handle.write('\n')
        includes = [f'#include "{self.final_dir.replace("modular_redtard/", "").replace("/", chr(92))}{chr(92)}{f}"' for f in FILE_ORDER if f in self.blocks]
        with open(os.path.join(self.out_dir, 'includes.txt'), 'w', encoding='utf-8', newline='\n') as handle:
            handle.write('\n'.join(includes) + '\n')
        if lists:
            write_tsv(os.path.join(lists, 'va1g_rows.tsv'), ['kind', 'source', 'path', 'target', 'status', 'reason'], self.rows)
            write_tsv(os.path.join(lists, 'va1g_reagents.tsv'), ['target', 'vibelin', 'how', 'name', 'file', 'procs', 'tg_parent', 'metabolization_rate',
                                                                  'overdose_threshold', 'boiling_point', 'price_per_unit', 'quality'], self.reagent_rows)
            write_tsv(os.path.join(lists, 'va1g_name_clashes.tsv'), ['name', 'types', 'this_run'], names)
            write_tsv(os.path.join(lists, 'va1g_reaction_conflicts.tsv'), ['reaction', 'with', 'where'], reactions)
            write_tsv(os.path.join(lists, 'va1g_precursor_overlaps.tsv'), ['item', 'precursors'], overlaps)
            write_tsv(os.path.join(lists, 'va1g_path_clashes.tsv'), ['path', 'declared'], paths)
            print(f'lists -> {lists}')


FILE_ORDER = ['essences.dm', 'essence_combinations.dm', 'reagents.dm', 'ingredients.dm', 'precursors.dm', 'infusion_recipes.dm',
              'cauldron_recipes.dm', 'grind_recipes.dm', 'distillation_recipes.dm', 'reactions.dm', 'bottles.dm']


def conflict(r1, r2):
    """TG's chem_recipes_do_conflict() (code/__HELPERS/reagents.dm)."""
    if r1['competitive'] or r2['competitive']:
        return False
    if r1['is_cold_recipe'] != r2['is_cold_recipe']:
        cold, warm = (r1, r2) if r1['is_cold_recipe'] else (r2, r1)
        if cold['required_temp'] < warm['required_temp']:
            return False
    a, b = r1['required_reagents'], r2['required_reagents']
    if len(a) > len(b):
        long, short = r1, r2
    elif len(a) < len(b):
        long, short = r2, r1
    else:
        long, short = (r1, r2) if len(r1['required_catalysts']) > len(r2['required_catalysts']) else (r2, r1)
    if short['required_container'] and short['required_container'] != long['required_container']:
        return False
    if short['is_cold_recipe'] == long['is_cold_recipe']:
        if short['is_cold_recipe'] and short['required_temp'] < long['required_temp']:
            return False
        if not short['is_cold_recipe'] and short['required_temp'] > long['required_temp']:
            return False
    overlap = {k: v for k, v in long['required_reagents'].items() if k in short['required_reagents']}
    if len(overlap) != len(short['required_reagents']):
        return False
    cat = {k: v for k, v in long['required_catalysts'].items() if k in short['required_catalysts']}
    if len(cat) != len(short['required_catalysts']):
        return False
    if len(overlap) == len(long['required_reagents']) and len(cat) == len(long['required_catalysts']):
        return True
    if any(overlap[k] < short['required_reagents'][k] for k in overlap):
        return False
    if any(cat[k] < short['required_catalysts'][k] for k in cat):
        return False
    return True


def load_config(path, out_dir):
    if path and os.path.isfile(path):
        cfg = json.load(open(path, encoding='utf-8'))
        merged = dict(DEFAULT_CONFIG)
        merged.update(cfg)
        return merged, None
    return dict(DEFAULT_CONFIG), os.path.join(out_dir, 'alchemy_port.json')


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--out', default=rel(DEFAULT_CONFIG['final_dir']), help='folder for the .dm data, path_map.json and alchemy_port.json')
    parser.add_argument('--lists', default=rel('.cache/modular_redtard/agents/va1/va1g_lists'), help='folder for the run\'s tables and checks')
    parser.add_argument('--config', help='alchemy_port.json to use (default <out>/alchemy_port.json)')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    out_dir = os.path.abspath(args.out)
    cfg, write_to = load_config(args.config or os.path.join(out_dir, 'alchemy_port.json'), out_dir)
    porter = AlchemyPorter(cfg, out_dir)
    porter.run(os.path.abspath(args.lists) if args.lists else None, args.dry_run)
    if write_to and not args.dry_run:
        with open(write_to, 'w', encoding='utf-8', newline='\n') as handle:
            json.dump(cfg, handle, indent=1, ensure_ascii=False)
            handle.write('\n')
        print(f'config written: {write_to}')


if __name__ == '__main__':
    main()
