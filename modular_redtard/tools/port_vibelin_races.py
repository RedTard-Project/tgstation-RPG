"""Vibelin's playable races as TG species (heritage/ported/races.dm), run by port_vibelin.py.

Vanderlin's races and Vibelin's modular ones (modular_abel/races) are ported as /datum/species/vib_<id>, <id> being
Vibelin's species id, so the heritage data (a patron's allowed_races, a culture's species) names them as it is.
Vibelin's dark elf is not ported: Ratwood's (rogue_drow) stands for it. Every race gets:
  - its body: Vibelin's per-zone body sheets (limbs_icon_m/f) as TG dimorphic body parts, one sheet for all races
    (heritage/icons/vibelin_bodies.dmi, state <body>_<zone>_<m|f>, each leg with its "_above" part drawn over it),
    greyscale and coloured by the skin (TG's mutant colour);
  - its features: the default sprite of each ear, horn, snout, neck, tail and wing organ it has (the organ's
    accessory, or the first choice of its customizer) as a bodypart overlay of the head or the chest;
  - its customizers: every accessory its organ customizers offer, ported as a feature like the default ones (each
    colour key a state of its own, the uncoloured extra state, sprites of any size on a sheet of that size), and per
    slot the features to pick from, whether it may go without and whether the colours may change (rogue_customizers);
  - its origins: the named skin colours of get_skin_list() (Vibelin's "Ancestry", "Progenitor"...) and the hair
    colours of get_hairc_list();
  - its attribute sheets (statsheet_male/statsheet_female), traits this build has, head features (hair, beard, lips,
    eye colour), whose clothes it wears (swap_*_clothes), offsets of worn things (offset_features_m/f), description;
  - its languages (grant_language of on_species_gain and after_creation; Vibelin's this build lacks are ported), voice
    (voicepack sounds as the tongue's emote sounds), eyes (night vision as TG's lighting cutoff) and name lists.
The character menu picks the features (heritage/customizers.dm); the wagging tails and open wings are not ported.
"""

import collections
import filecmp
import json
import os
import re
import shutil

import dmi
import port_rockhill as porter

OUT_DM = 'modular_redtard/heritage/ported/races.dm'
BODIES_ICON = 'modular_redtard/heritage/icons/vibelin_bodies.dmi'
WIDE_ICON = 'modular_redtard/heritage/icons/vibelin_wide.dmi'
# Features of any other size, one sheet per size.
SIZED_ICON = 'modular_redtard/heritage/icons/vibelin_{0}x{1}.dmi'
FEATURE_PREFIX = '/datum/bodypart_overlay/simple/rogue_feature/'
LANGUAGE_ICON = 'modular_redtard/heritage/icons/languages.dmi'
SOUND_DIR = 'modular_redtard/heritage/sound'
ROCKHILL_SOUND_DIR = 'modular_redtard/rockhill/sound'
FLIGHT_SOUND = 'sound/mobs/wingflap.ogg'
# The buttons of the race mechanics TG has no icon for: our state -> Vibelin's icon and state (its first frame).
ACTIONS_ICON = 'modular_redtard/heritage/icons/actions.dmi'
ACTION_STATES = {'bioluminescence': ('icons/mob/actions/roguespells.dmi', 'shieldsparkles')}
NAMES_DIR = 'modular_redtard/heritage/strings/names'

RACES = [
    '/datum/species/human/northern',
    '/datum/species/elf/snow',
    '/datum/species/elf/zizo',
    '/datum/species/elf/sun',
    '/datum/species/dwarf/mountain',
    '/datum/species/dwarf/mountain/subterra',
    '/datum/species/dwarf/dworc',
    '/datum/species/halfling',
    '/datum/species/human/halfelf',
    '/datum/species/human/halfdrow',
    '/datum/species/human/halfzizo',
    '/datum/species/halforc',
    '/datum/species/tieberian',
    '/datum/species/aasimar',
    '/datum/species/triton',
    '/datum/species/kobold',
    '/datum/species/kobold/formikrag',
    '/datum/species/demihuman',
    '/datum/species/harpy',
    '/datum/species/medicator',
    '/datum/species/rakshari',
    '/datum/species/ooze',
    # Vibelin's beast races (modular_abel/races/furry, "alpha-test" there), without their body markings.
    '/datum/species/tabaxi',
    '/datum/species/vulpkanin',
    '/datum/species/lupian',
    '/datum/species/akula',
    '/datum/species/anthromorph',
    '/datum/species/lizardfolk',
    '/datum/species/moth',
    '/datum/species/aura',
]

ZONES = ['head', 'chest', 'l_arm', 'r_arm', 'l_hand', 'r_hand', 'l_leg', 'r_leg']
MERGE = {'l_leg': 'l_leg_above', 'r_leg': 'r_leg_above'}
PARTS = [
    ('head', '/obj/item/bodypart/head', 'BODY_ZONE_HEAD'),
    ('chest', '/obj/item/bodypart/chest', 'BODY_ZONE_CHEST'),
    ('l_arm', '/obj/item/bodypart/arm/left', 'BODY_ZONE_L_ARM'),
    ('r_arm', '/obj/item/bodypart/arm/right', 'BODY_ZONE_R_ARM'),
    ('l_leg', '/obj/item/bodypart/leg/left', 'BODY_ZONE_L_LEG'),
    ('r_leg', '/obj/item/bodypart/leg/right', 'BODY_ZONE_R_LEG'),
]
LAYERS = {'BODY_BEHIND_LAYER': 'BEHIND', 'BODY_ADJ_LAYER': 'ADJ', 'BODY_FRONT_LAYER': 'FRONT'}
# Vibelin's organ slot: the part it is drawn on, the worn flags that hide it and the slot's name in rogue_customizers.
FEATURE_SLOTS = {
    'ORGAN_SLOT_EARS': ('head', 'HIDEEARS', 'ears'),
    'ORGAN_SLOT_HORNS': ('head', 'HIDEHAIR', 'horns'),
    'ORGAN_SLOT_SNOUT': ('head', 'HIDESNOUT', 'snout'),
    'ORGAN_SLOT_NECK_FEATURE': ('head', 'NONE', 'neck'),
    'ORGAN_SLOT_TAIL': ('chest', 'NONE', 'tail'),
    'ORGAN_SLOT_WINGS': ('chest', 'NONE', 'wings'),
}
# Vibelin's colour sources of a key (color_key_defaults) as what colours it here: the body ("skin", which is also the
# mutant colour of a race with mutant colours) or the hair; the second and third mutant colours have no counterpart and
# draw the sprite as it is (white).
KEY_SOURCES = {
    'KEY_SKIN_COLOR': 'skin', 'KEY_CHEST_COLOR': 'skin', 'KEY_MUT_COLOR_ONE': 'skin',
    'KEY_HAIR_COLOR': 'hair', 'KEY_FACE_HAIR_COLOR': 'hair',
}
# The source of a key without color_key_defaults (Vibelin's default_define_for_color_key()).
MUT_KEYS = ['KEY_MUT_COLOR_ONE', 'KEY_MUT_COLOR_TWO', 'KEY_MUT_COLOR_THREE']
CUSTOMIZER_SLOTS = {
    'ears': 'ORGAN_SLOT_EARS', 'horns': 'ORGAN_SLOT_HORNS', 'snout': 'ORGAN_SLOT_SNOUT',
    'neck_feature': 'ORGAN_SLOT_NECK_FEATURE', 'tail': 'ORGAN_SLOT_TAIL', 'wings': 'ORGAN_SLOT_WINGS',
}
HEAD_FLAGS = {'HAIR': 'HEAD_HAIR', 'FACEHAIR': 'HEAD_FACIAL_HAIR', 'LIPS': 'HEAD_LIPS', 'EYECOLOR': 'HEAD_EYECOLOR'}
HEAD_FLAGS_ALWAYS = ['HEAD_EYESPRITES', 'HEAD_EYEHOLES', 'HEAD_DEBRAIN']
# Vibelin's language: this build's, or the type and key it gets here (keys TG and the module leave free).
LANGUAGES = {
    '/datum/language/common': '/datum/language/common',
    '/datum/language/elvish': '/datum/language/rogue_elvish',
    '/datum/language/orcish': '/datum/language/rogue_orcish',
    '/datum/language/dwarvish': ('/datum/language/rogue_dwarvish', 'j'),
    '/datum/language/halfling': ('/datum/language/rogue_halfling', 'q'),
    '/datum/language/hellspeak': ('/datum/language/rogue_infernal', 'l'),
    '/datum/language/celestial': ('/datum/language/rogue_celestial', 'a'),
    '/datum/language/kobold': ('/datum/language/rogue_kobold', '2'),
    '/datum/language/deepspeak': ('/datum/language/rogue_deepspeak', '3'),
    '/datum/language/zalad': ('/datum/language/rogue_zalad', '5'),
    '/datum/language/beast': ('/datum/language/rogue_beast', '7'),
}
GENERIC_VOICES = {'/datum/voicepack/male', '/datum/voicepack/female'}
# Vibelin's accents (code/__DEFINES/accents.dm): word swaps from strings/accents, copied here.
ACCENTS_DEFINES = 'code/__DEFINES/accents.dm'
ACCENTS_DIR = 'modular_redtard/heritage/strings/accents'
ACCENT_NONE = 'No Accent'
# Vibelin's get_accent(): the accent of a race's native language (an elf's is the French one, a sun elf's the Russian).
NATIVE_ACCENTS = {
    'Old Psydonic': 'ACCENT_GRENZ', 'Psydonic': 'ACCENT_GRENZ', 'Zalad': 'ACCENT_ZALAD', 'Elfish': 'ACCENT_DELF',
    'Dwarfish': 'ACCENT_DWARF', 'Infernal': 'ACCENT_TIEFLING', 'Orcish': 'ACCENT_HORC', 'Halfling': 'ACCENT_HALFLING',
    'Utterances': 'ACCENT_KOBOLD', 'Rous': 'ACCENT_ROUSMAN', 'Deepspeak': 'ACCENT_TRITON', 'Pirate': 'ACCENT_PIRATE',
    'Osslandic': 'ACCENT_OSSLAND', 'Rockhill': 'ACCENT_ROCKHILL',
}
ACCENT_VARIANTS = {'/datum/species/elf/sun': 'ACCENT_ELF'}
# The languages of Vibelin's handle_speech() by name, as this build's types (with the halfling and kobold tongues,
# which Vibelin's list forgets): a race speaks its native one without its accent.
NATIVE_LANGUAGES = {
    'Imperial': '/datum/language/common', 'Elfish': '/datum/language/rogue_elvish',
    'Dwarfish': '/datum/language/rogue_dwarvish', 'Infernal': '/datum/language/rogue_infernal',
    'Orcish': '/datum/language/rogue_orcish', 'Celestial': '/datum/language/rogue_celestial',
    'Zalad': '/datum/language/rogue_zalad', 'Deepspeak': '/datum/language/rogue_deepspeak',
    'Halfling': '/datum/language/rogue_halfling', 'Utterances': '/datum/language/rogue_kobold',
}
OFFSET_EXTRA = {'OFFSET_RING': ['ROGUE_OFFSET_RING']}
CHANGESOURCE = 'MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT'
STAT_PAIR = re.compile(r'\b(STAT_[A-Z]+)\s*=\s*(-?\d+)')
COLOR_PAIR = re.compile(r'"([^"]+)"\s*=\s*("[#0-9A-Fa-f]{6,7}"|[A-Z][A-Z0-9_]+)')
SOUND_LITERAL = re.compile(r"'(sound/[^']+?\.(?:ogg|wav|mp3))'")
NAME_FILE = re.compile(r"file2list\(\s*'([^']+)'\s*\)")


class Procs:
    """Bodies of the procs the port reads (get_skin_list, get_hairc_list, names, on_species_gain, get_sound), read once
    from every file Vibelin compiles."""

    WANTED = {'get_skin_list', 'get_hairc_list', 'get_possible_names', 'get_possible_surnames', 'on_species_gain', 'after_creation', 'get_sound'}

    def __init__(self, files):
        self.bodies = {}
        header = re.compile(r'^(/[\w/]+?)/(?:proc/)?(\w+)\(')
        for path in files:
            if not os.path.exists(path):
                continue
            lines = porter.strip_comments(open(path, encoding='utf-8', errors='ignore').read()).split('\n')
            for i, line in enumerate(lines):
                found = header.match(line)
                if not found or found.group(2) not in self.WANTED:
                    continue
                body = []
                for following in lines[i + 1:]:
                    if following.strip() and not following.startswith(('\t', ' ')):
                        break
                    body.append(following)
                self.bodies[(found.group(1), found.group(2))] = body

    def find(self, base, path, name, stop='/datum/species'):
        """The body of the proc as path has it (its own or a parent's), and the type it is on."""
        p = path
        while p and p != stop:
            if (p, name) in self.bodies:
                return self.bodies[(p, name)], p
            p = base.parent(p)
        return None, None


def define_value(token):
    value = porter.expand_define(token)
    depth = 0
    while value and re.fullmatch(r'[A-Z][A-Z0-9_]+', value) and depth < 5:
        value = porter.expand_define(value)
        depth += 1
    return value


def hex_color(raw):
    value = define_value(raw).strip().strip('"').lstrip('#')
    return f'#{value.upper()}' if re.fullmatch(r'[0-9A-Fa-f]{6}', value) else None


def color_list(text):
    out = {}
    for name, raw in COLOR_PAIR.findall(text):
        color = hex_color(raw)
        if color:
            out[name] = color
    return out


def global_list(root, name):
    text = open(os.path.join(root, 'code/__HELPERS/mobs.dm'), encoding='utf-8', errors='ignore').read()
    found = re.search(rf'GLOBAL_LIST_INIT\({name},(.*?)\)\)\)', text, re.S)
    return color_list(porter.strip_comments(found.group(1))) if found else {}


def text_of(base, path, var):
    raw = base.resolve(path, var)
    if raw is None:
        return None
    value = define_value(raw.strip())
    return value if porter.STRING_LITERAL.match(value) else None


def dm_string(text):
    return json.dumps(text, ensure_ascii=False).replace('[', '\\[')


def description(raw):
    """Vibelin's desc as paragraphs (split on its blank lines, the escaped \\n\\n), without its markup."""
    text = re.sub(r'<br\s*/?>', lambda _: r'\n', raw[1:-1])
    text = re.sub(r'<[^>]+>', '', text)
    paragraphs = []
    for part in re.split(r'(?:\\n\s*){2,}', text):
        part = re.sub(r'\s+', ' ', part.replace(r'\n', ' ').replace(r'\"', '"')).strip()
        if part:
            paragraphs.append(part)
    return paragraphs


def leaf_of(accessory):
    return accessory[len('/datum/sprite_accessory/'):].replace('/', '_')


def accent_table(root):
    """Vibelin's accents: each ACCENT_* define's name, and by name the file and key of its word swaps."""
    text = porter.strip_comments(open(os.path.join(root, ACCENTS_DEFINES), encoding='utf-8', errors='ignore').read())
    names = dict(re.findall(r'^#define\s+(ACCENT_[A-Z_]+)\s+"([^"]+)"', text, re.M))
    files = {}
    for define, path, key in re.findall(r'(ACCENT_[A-Z_]+)\s*=\s*strings\(\s*"([^"]+)"\s*,\s*"([^"]+)"\s*\)', text):
        if define in names:
            files[names[define]] = (path, key)
    return names, files


def feature_id(path):
    """A feature's id in rogue_customizers and the rogue_features preference: its type path past rogue_feature/."""
    return path[len(FEATURE_PREFIX):]


def list_items(raw):
    """The items of a DM list(...) literal, as written."""
    found = re.search(r'list\((.*)\)', raw or '', re.S)
    return [item.strip() for item in found.group(1).split(',') if item.strip()] if found else []


class Port:
    def __init__(self, base, root, procs, defines, attr_stats, offset_keys):
        self.base = base
        self.root = root
        self.procs = procs
        self.defines = defines
        self.attr_stats = attr_stats
        self.offset_keys = dict(offset_keys)
        self.offset_keys.update(OFFSET_EXTRA)
        self.sheets = {}
        self.body_states = []
        self.wide_states = []
        # Features of other sizes: (width, height) -> states.
        self.sized_states = {}
        self.features = {}
        self.blocks = []
        self.sounds = set()
        self.name_files = set()
        self.languages_used = set()
        self.eyes = {}
        self.warnings = []
        self.accent_names, self.accent_files = accent_table(root)

    def cells(self, rel):
        if rel not in self.sheets:
            self.sheets[rel] = dmi.read(os.path.join(self.root, rel))
        return self.sheets[rel]

    # Bodies.

    def body(self, species):
        icons = [(self.base.resolve(species, f'limbs_icon_{sex}') or '').strip().strip("'") for sex in ('m', 'f')]
        names = [os.path.splitext(os.path.basename(icon))[0] for icon in icons]
        key = 'vib_' + (names[0] if names[0] == names[1] else f'{names[0]}_{names[1]}')
        key = re.sub(r'[^a-z0-9_]', '_', key.lower())
        if not any(state.startswith(key + '_') for state, _, _ in self.body_states):
            empty = bytes(32 * 32 * 4)
            for sex, icon in zip(('m', 'f'), icons):
                source = self.cells(icon).state_cells()
                for zone in ZONES:
                    dirs, _, cells = source[zone] if zone in source else (1, 1, [empty])
                    cells = cells[:dirs]
                    above = MERGE.get(zone)
                    if above in source and source[above][0] == dirs:
                        cells = [porter.over(cell, top) for cell, top in zip(cells, source[above][2][:dirs])]
                    self.body_states.append((f'{key}_{zone}_{sex}', dirs, cells))
            for zone, part, _ in PARTS:
                block = [f'{part}/{key}', '\ticon = VIBELIN_BODIES_ICON', '\ticon_static = VIBELIN_BODIES_ICON',
                         '\ticon_greyscale = VIBELIN_BODIES_ICON', f'\ticon_state = "{key}_{zone}_m"', f'\tlimb_id = "{key}"',
                         '\tis_dimorphic = TRUE']
                if 'arm' in zone:
                    block.append('\trogue_sexed_hand = TRUE')
                self.blocks.append(block)
        return key

    # Features.

    def accessory_for(self, species, slot, organ):
        accessory = (self.base.resolve(organ, 'accessory_type') or '').strip() if organ else ''
        if accessory.startswith('/datum/sprite_accessory/'):
            return accessory
        kind = next((k for k, s in CUSTOMIZER_SLOTS.items() if s == slot), None)
        for customizer in re.findall(r'/datum/customizer/organ/[\w/]+', self.base.resolve(species, 'customizers') or ''):
            customizer = customizer.rstrip('/')
            if not customizer.startswith(f'/datum/customizer/organ/{kind}'):
                continue
            if (self.base.resolve(customizer, 'default_disabled') or '').strip() in ('TRUE', '1'):
                return None
            for choice in re.findall(r'/datum/customizer_choice/[\w/]+', self.base.resolve(customizer, 'customizer_choices') or ''):
                found = re.findall(r'/datum/sprite_accessory/[\w/]+', self.base.resolve(choice.rstrip('/'), 'sprite_accessories') or '')
                if found:
                    return found[0].rstrip('/')
        return None

    def sheet_for(self, size):
        """The icon a feature of this sprite size is drawn from, as DM writes it, and the states of its sheet."""
        if size == (32, 32):
            return 'VIBELIN_BODIES_ICON', self.body_states
        if size == (64, 32):
            return 'VIBELIN_WIDE_ICON', self.wide_states
        return f"'{SIZED_ICON.format(*size)}'", self.sized_states.setdefault(size, [])

    def color_defaults(self, accessory, keys):
        """What colours each of the accessory's colour keys by default, as Vibelin's get_default_colors(): its own colour
        (default_colors), else the source of color_key_defaults, else the key's mutant colour; None leaves it uncoloured."""
        if (self.base.resolve(accessory, 'use_static') or '').strip() in ('TRUE', '1'):
            return [None] * keys
        explicit = [None if item == 'null' else hex_color(item) for item in list_items(self.base.resolve(accessory, 'default_colors'))]
        sources = list_items(self.base.resolve(accessory, 'color_key_defaults'))
        out = []
        for index in range(keys):
            if index < len(explicit) and explicit[index]:
                out.append(explicit[index])
                continue
            source = sources[index] if index < len(sources) and sources[index] != 'null' else MUT_KEYS[min(index, 2)]
            out.append(KEY_SOURCES.get(source, '#FFFFFF'))
        return out

    def feature(self, accessory, hidden_by, slot):
        """The overlay type of a sprite accessory, its states added to the sheet of its size: a state per layer
        ("vib_<leaf>_<layer>"), past the first colour key one per key ("_2", "_3"), and the extra state drawn over them
        ("_extra")."""
        if accessory in self.features:
            return self.features[accessory]
        self.features[accessory] = None
        icon = (self.base.resolve(accessory, 'icon') or '').strip().strip("'")
        state = (text_of(self.base, accessory, 'icon_state') or '""').strip('"')
        if not icon or not state or not os.path.exists(os.path.join(self.root, icon)):
            self.warnings.append(f'{accessory}: no sprite ({icon} {state})')
            return None
        if (self.base.resolve(accessory, 'gendered_variants') or '').strip() in ('TRUE', '1'):
            self.warnings.append(f'{accessory}: gendered sprites are not ported')
            return None
        sheet = self.cells(icon)
        source = sheet.state_cells()
        icon_ref, target = self.sheet_for((sheet.frame_width, sheet.frame_height))
        keys = max(1, porter.number_value(self.base.resolve(accessory, 'color_keys')) or 1)
        extra = (self.base.resolve(accessory, 'extra_state') or '').strip() in ('TRUE', '1')
        leaf = leaf_of(accessory)
        layers = []
        extra_layers = []
        for token in re.findall(r'BODY_[A-Z]+_LAYER', self.base.resolve(accessory, 'relevant_layers') or ''):
            layer = LAYERS.get(token)
            if not layer or layer in layers:
                continue
            names = [f'{state}_{layer}'] if keys == 1 else [f'{state}_{layer}_{key}' for key in range(1, keys + 1)]
            if not all(name in source for name in names):
                continue
            for key, name in enumerate(names, 1):
                dirs, _, cells = source[name]
                target.append((f'vib_{leaf}_{layer}' + (f'_{key}' if key > 1 else ''), dirs, cells[:dirs]))
            if extra and f'{state}_{layer}_extra' in source:
                dirs, _, cells = source[f'{state}_{layer}_extra']
                target.append((f'vib_{leaf}_{layer}_extra', dirs, cells[:dirs]))
                extra_layers.append(layer)
            layers.append(layer)
        if not layers:
            self.warnings.append(f'{accessory}: none of its layers is in {icon}')
            return None
        path = f'{FEATURE_PREFIX}vib_{leaf}'
        block = [path, f'\ticon = {icon_ref}', f'\ticon_state = "vib_{leaf}"',
                 '\tlayers = list(' + ', '.join(f'"{layer}" = BODY_{layer}_LAYER' for layer in layers) + ')',
                 f'\thidden_by = {hidden_by}']
        pixel_x = porter.number_value(self.base.resolve(accessory, 'pixel_x')) or 0
        pixel_y = porter.number_value(self.base.resolve(accessory, 'pixel_y')) or 0
        if pixel_x:
            block.append(f'\trogue_pixel_x = {pixel_x}')
        defaults = self.color_defaults(accessory, keys)
        if defaults[0] == 'skin':
            block.append('\tskin_coloured = TRUE')
        elif defaults[0] == 'hair':
            block.append('\trogue_hair_coloured = TRUE')
        elif defaults[0]:
            block.append(f'\tdraw_color = "{defaults[0]}"')
        name = text_of(self.base, accessory, 'name')
        if name:
            block.append(f'\tname = {name}')
        block.append(f'\trogue_slot = "{slot}"')
        if pixel_y:
            block.append(f'\trogue_pixel_y = {pixel_y}')
        if keys > 1:
            names = re.findall(r'"(?:[^"\\]|\\.)*"', self.base.resolve(accessory, 'color_key_names') or '')
            block.append(f'\trogue_color_keys = {keys}')
            block.append('\trogue_color_defaults = list(' + ', '.join('null' if d is None else f'"{d}"' for d in defaults) + ')')
            if len(names) >= keys:
                block.append('\trogue_color_names = list(' + ', '.join(names[:keys]) + ')')
        if extra_layers:
            block.append('\trogue_extra = list(' + ', '.join(f'"{layer}"' for layer in extra_layers) + ')')
        self.blocks.append(block)
        self.features[accessory] = path
        return path

    def species_features(self, species):
        """The race's default features by the part they are drawn on, and by slot the one each slot has (None for a slot
        the race has bare)."""
        organs = dict(re.findall(r'(ORGAN_SLOT_[A-Z_]+)\s*=\s*(/obj/item/organ/[\w/]+)', self.base.resolve(species, 'organs') or ''))
        by_zone = collections.defaultdict(list)
        by_slot = {}
        for organ_slot, (zone, hidden_by, slot) in FEATURE_SLOTS.items():
            if organ_slot not in organs and organ_slot not in self.customized_slots(species):
                continue
            accessory = self.accessory_for(species, organ_slot, organs.get(organ_slot, '').rstrip('/'))
            path = self.feature(accessory, hidden_by, slot) if accessory else None
            by_slot[slot] = path
            if path:
                by_zone[zone].append(path)
        return by_zone, by_slot

    def customizers(self, species, defaults):
        """Vibelin's organ customizers of the race (rogue_customizers): per slot the choice's name, the feature a new
        character has (Vibelin's default entry: none if the customizer is off by default, else the default accessory of
        its default choice, else what the race's body has), whether it may go without, whether the colours may change,
        and the features to pick from (every accessory of its choices that ports, the body's own first if they lack it)."""
        lines = []
        seen = set()
        for customizer in re.findall(r'/datum/customizer/organ/[\w/]+', self.base.resolve(species, 'customizers') or ''):
            customizer = customizer.rstrip('/')
            organ_slot = CUSTOMIZER_SLOTS.get(customizer.split('/')[4])
            if not organ_slot:
                continue
            _, hidden_by, slot = FEATURE_SLOTS[organ_slot]
            if slot in seen:
                continue
            seen.add(slot)
            choices = []
            colors = False
            name = None
            picked = None
            choice_types = [c.rstrip('/') for c in re.findall(r'/datum/customizer_choice/[\w/]+', self.base.resolve(customizer, 'customizer_choices') or '')]
            default_choice = (self.base.resolve(customizer, 'default_choice') or '').strip().rstrip('/')
            if default_choice not in choice_types:
                default_choice = choice_types[0] if choice_types else None
            for choice in choice_types:
                name = name or text_of(self.base, choice, 'name')
                if (self.base.resolve(choice, 'allows_accessory_color_customization') or '').strip() not in ('FALSE', '0'):
                    colors = True
                accessories = [a.rstrip('/') for a in re.findall(r'/datum/sprite_accessory/[\w/]+', self.base.resolve(choice, 'sprite_accessories') or '')]
                for accessory in accessories:
                    path = self.feature(accessory, hidden_by, slot)
                    if path and path not in choices:
                        choices.append(path)
                if choice == default_choice and accessories:
                    first = (self.base.resolve(choice, 'default_accessory') or '').strip().rstrip('/')
                    picked = self.features.get(first if first in accessories else accessories[0])
            body = defaults.get(slot)
            if body and body not in choices:
                choices.insert(0, body)
            if not choices:
                continue
            disabling = (self.base.resolve(customizer, 'allows_disabling') or '').strip() in ('TRUE', '1')
            if disabling and (self.base.resolve(customizer, 'default_disabled') or '').strip() in ('TRUE', '1'):
                default = 'none'
            else:
                default = feature_id(picked or body or choices[0])
            entry = [
                f'"name" = {name or dm_string(slot.capitalize())}',
                f'"default" = "{default}"',
                f'"none" = {"TRUE" if disabling else "FALSE"}',
                f'"colors" = {"TRUE" if colors else "FALSE"}',
                '"choices" = list(' + ', '.join(f'"{feature_id(path)}"' for path in choices) + ')',
            ]
            lines.append(f'\t\t"{slot}" = list(' + ', '.join(entry) + '),')
        return ['\trogue_customizers = list('] + lines + ['\t\t)'] if lines else []

    def customized_slots(self, species):
        slots = set()
        for customizer in re.findall(r'/datum/customizer/organ/(\w+)', self.base.resolve(species, 'customizers') or ''):
            if customizer in CUSTOMIZER_SLOTS:
                slots.add(CUSTOMIZER_SLOTS[customizer])
        return slots

    # The rest of a species.

    def sheet(self, species, var, target):
        path = (self.base.resolve(species, var) or '').strip()
        if not path.startswith('/datum/attribute_holder'):
            return None
        bonus = collections.Counter()
        for token, amount in STAT_PAIR.findall(self.base.resolve(path, 'raw_attribute_list') or ''):
            stat = self.attr_stats.get(define_value(token).rsplit('/', 1)[-1])
            if stat:
                bonus[stat] += int(amount)
        if not any(bonus.values()):
            return None
        self.blocks.append([target, '\traw_attribute_list = list('] + [f'\t\t{stat} = {amount},' for stat, amount in sorted(bonus.items()) if amount] + ['\t\t)'])
        return target

    def offsets(self, species):
        lines = []
        for sex in ('m', 'f'):
            entries = []
            for name, x, y in re.findall(r'\b(OFFSET_[A-Z_]+)\s*=\s*list\(\s*(-?\d+)\s*,\s*(-?\d+)\s*\)', self.base.resolve(species, f'offset_features_{sex}') or ''):
                if int(x) or int(y):
                    entries += [f'{key} = list({x}, {y})' for key in self.offset_keys.get(name, [])]
            if entries:
                lines.append(f'\t\t"{sex}" = list(' + ', '.join(sorted(entries)) + '),')
        return ['\trogue_offsets = list('] + lines + ['\t\t)'] if lines else []

    def languages(self, species):
        found = []
        for proc in ('on_species_gain', 'after_creation'):
            p = species
            while p and p != '/datum/species':
                body, owner = self.procs.find(self.base, p, proc)
                if not body:
                    break
                found += re.findall(r'grant_language\(\s*(/datum/language/\w+)', '\n'.join(body))
                if not re.search(r'\.\.\(', '\n'.join(body)):
                    break
                p = self.base.parent(owner)
        out = []
        for language in dict.fromkeys(found):
            target = LANGUAGES.get(language)
            if not target:
                self.warnings.append(f'{species}: language {language} is not mapped')
                continue
            if isinstance(target, tuple):
                self.languages_used.add(language)
                target = target[0]
            out.append(target)
        return out

    def voices(self, species):
        voices = {}
        for sex in ('m', 'f'):
            pack = (self.base.resolve(species, f'soundpack_{sex}') or '').strip()
            if not pack.startswith('/datum/voicepack') or pack in GENERIC_VOICES:
                continue
            body, _ = self.procs.find(self.base, pack, 'get_sound', stop='/datum/voicepack')
            key = None
            for line in body or []:
                found = re.match(r'^\s*if\s*\(\s*"([^"]+)"\s*\)', line)
                if found:
                    key = {'deathgurgle': 'deathgasp'}.get(found.group(1), found.group(1))
                    continue
                files = SOUND_LITERAL.findall(line)
                if key and files:
                    voices.setdefault(key, {}).setdefault('MALE' if sex == 'm' else 'FEMALE', []).extend(dict.fromkeys(files))
        for by_sex in voices.values():
            for files in by_sex.values():
                self.sounds.update(files)
        return voices

    def sound_ref(self, rel):
        rockhill = os.path.join(ROCKHILL_SOUND_DIR, rel[len('sound/'):])
        if os.path.exists(rockhill) and filecmp.cmp(rockhill, os.path.join(self.root, rel), shallow=False):
            return f"'{rockhill}'"
        return f"'{SOUND_DIR}/{rel[len('sound/'):]}'"

    def eyes_for(self, species):
        """Eyes that see in the dark (Vibelin's lighting_alpha) as TG eyes with that lighting cutoff."""
        found = re.search(r'ORGAN_SLOT_EYES\s*=\s*(/obj/item/organ/eyes/[\w/]+)', self.base.resolve(species, 'organs') or '')
        eyes = found.group(1).rstrip('/') if found else None
        alpha = self.base.resolve(eyes, 'lighting_alpha') if eyes else None
        cutoff = porter.alpha_cutoff(alpha) if alpha else None
        if not cutoff:
            return None
        if eyes not in self.eyes:
            ours = f"/obj/item/organ/eyes/vib_{eyes[len('/obj/item/organ/eyes/'):].replace('/', '_')}"
            block = [ours]
            name = text_of(self.base, eyes, 'name')
            if name and name != '""':
                block.append(f'\tname = {name}')
            block.append(f'\tlighting_cutoff = {cutoff}')
            self.blocks.append(block)
            self.eyes[eyes] = ours
        return self.eyes[eyes]

    def names(self, species):
        out = {}
        for proc, keys in (('get_possible_names', ('m', 'f')), ('get_possible_surnames', ('last',))):
            body, _ = self.procs.find(self.base, species, proc)
            files = NAME_FILE.findall('\n'.join(body or []))
            if not files:
                continue
            if proc == 'get_possible_names':
                male = next((f for f in files if f.endswith('m.txt')), files[0])
                female = next((f for f in files if f.endswith('f.txt')), next((f for f in files if f != male), male))
                picked = {'m': male, 'f': female}
            else:
                picked = {'last': files[0]}
            for key, rel in picked.items():
                if os.path.exists(os.path.join(self.root, rel)):
                    self.name_files.add(rel)
                    out[key] = f'{NAMES_DIR}/{os.path.basename(os.path.dirname(rel))}_{os.path.basename(rel)}'
        return out

    def species(self, species):
        vid = define_value((self.base.resolve(species, 'id') or '').strip()).strip('"')
        if not vid:
            self.warnings.append(f'{species}: no id')
            return None
        path = f'/datum/species/vib_{vid}'
        name = text_of(self.base, species, 'name') or f'"{vid}"'
        body = self.body(species)
        features, slot_features = self.species_features(species)
        traits = re.findall(r'\b[A-Z][A-Z_]+\b', self.base.resolve(species, 'species_traits') or '')
        head_flags = HEAD_FLAGS_ALWAYS + [HEAD_FLAGS[t] for t in traits if t in HEAD_FLAGS]
        head = f'/obj/item/bodypart/head/{body}/{vid}'
        self.blocks.append([head, f"\thead_flags = {' | '.join(dict.fromkeys(head_flags))}"])
        if features.get('head'):
            self.blocks.append([f'{head}/Initialize(mapload)', '\t. = ..()'] + [f'\tadd_bodypart_overlay(new {f}, update = FALSE)' for f in features['head']])
        chest = f'/obj/item/bodypart/chest/{body}'
        if features.get('chest'):
            chest = f'{chest}/{vid}'
            self.blocks.append([chest])
            self.blocks.append([f'{chest}/Initialize(mapload)', '\t. = ..()'] + [f'\tadd_bodypart_overlay(new {f}, update = FALSE)' for f in features['chest']])

        inherent = ['TRAIT_MUTANT_COLORS']
        if 'NO_UNDERWEAR' in traits:
            inherent.append('TRAIT_NO_UNDERWEAR')
        block = [path, f'\tname = {name}', f'\tid = "vib_{vid}"', '\tinherent_traits = list(' + ', '.join(inherent) + ')',
                 f'\tchangesource_flags = {CHANGESOURCE}', '\trogue_playable = TRUE', f'\trogue_vibelin_type = "{species}"']
        parts = {zone: f'{part}/{body}' for zone, part, _ in PARTS}
        parts['head'] = head
        parts['chest'] = chest
        block.append('\tbodypart_overrides = list(')
        block += [f'\t\t{define} = {parts[zone]},' for zone, _, define in PARTS]
        block.append('\t\t)')

        skins, _ = self.procs.find(self.base, species, 'get_skin_list')
        origins = color_list('\n'.join(skins)) if skins and 'GLOB.skin_tones' not in '\n'.join(skins) else self.skin_tones
        if origins:
            block.append(f'\trogue_default_skin = "{next(iter(origins.values()))}"')
            block.append('\trogue_origins = list(' + ', '.join(f'{dm_string(k)} = "{v}"' for k, v in origins.items()) + ')')
        wording = text_of(self.base, species, 'skin_tone_wording')
        if wording:
            block.append(f'\trogue_origin_wording = {wording}')
        hairs, _ = self.procs.find(self.base, species, 'get_hairc_list')
        hair = color_list('\n'.join(hairs)) if hairs and 'GLOB.haircolor' not in '\n'.join(hairs) else self.hair_colors
        if hair and 'HAIR' in traits:
            block.append('\trogue_hair_colors = list(' + ', '.join(f'{dm_string(k)} = "{v}"' for k, v in hair.items()) + ')')

        block += self.offsets(species)
        block += self.customizers(species, slot_features)
        block += self.accents(species)
        block += self.mechanics(species)
        male = self.sheet(species, 'statsheet_male', f'/datum/attribute_holder/sheet/vibelin_race/{vid}')
        if male:
            block.append(f'\trogue_race_sheet = {male}')
        female_sheet = (self.base.resolve(species, 'statsheet_female') or '').strip()
        if female_sheet and female_sheet != (self.base.resolve(species, 'statsheet_male') or '').strip():
            female = self.sheet(species, 'statsheet_female', f'/datum/attribute_holder/sheet/vibelin_race/{vid}_female')
            if female:
                block.append(f'\trogue_race_sheet_female = {female}')
        race_traits = [t for t in dict.fromkeys(re.findall(r'TRAIT_[A-Z0-9_]+', self.base.resolve(species, 'inherent_traits') or '')) if t in self.defines]
        if race_traits:
            block.append(f"\trogue_race_traits = list({', '.join(race_traits)})")
        swap_m = (self.base.resolve(species, 'swap_male_clothes') or '').strip() in ('TRUE', '1')
        swap_f = (self.base.resolve(species, 'swap_female_clothes') or '').strip() in ('TRUE', '1')
        if swap_m != swap_f:
            block.append(f'\trogue_worn_sex = "{"f" if swap_m else "m"}"')
        raw = self.base.resolve(species, 'desc')
        if raw and porter.STRING_LITERAL.match(raw.strip()):
            paragraphs = description(raw.strip())
            if paragraphs:
                lore = paragraphs[1:] if len(paragraphs) > 1 else paragraphs
                block.append(f'\trogue_description = {dm_string(" ".join(lore))}')
                block += ['\trogue_lore = list('] + [f'\t\t{dm_string(p)},' for p in lore] + ['\t\t)']
        names = self.names(species)
        if names:
            block.append('\trogue_names = list(' + ', '.join(f'"{k}" = "{v}"' for k, v in names.items()) + ')')

        languages = self.languages(species)
        voices = self.voices(species)
        if languages:
            holder = f'/datum/language_holder/vib_{vid}'
            entries = ', '.join(f'{lang} = list(LANGUAGE_ATOM)' for lang in dict.fromkeys(['/datum/language/common'] + languages))
            self.blocks.append([holder, f'\tunderstood_languages = list({entries})', f'\tspoken_languages = list({entries})'])
            block.append(f'\tspecies_language_holder = {holder}')
        if languages or voices:
            tongue = f'/obj/item/organ/tongue/rogue_race/vib_{vid}'
            tongue_block = [tongue]
            extra = [lang for lang in languages if lang != '/datum/language/common']
            if extra:
                tongue_block.append(f"\trogue_languages = list({', '.join(dict.fromkeys(extra))})")
            if voices:
                tongue_block.append('\temote_sounds = list(')
                for key in sorted(voices):
                    by_sex = ', '.join(f"{sex} = list({', '.join(self.sound_ref(f) for f in files)})" for sex, files in sorted(voices[key].items()))
                    tongue_block.append(f'\t\t"{key}" = list({by_sex}),')
                tongue_block.append('\t\t)')
            self.blocks.append(tongue_block)
            block.append(f'\tmutanttongue = {tongue}')
        eyes = self.eyes_for(species)
        if eyes:
            block.append(f'\tmutanteyes = {eyes}')
        self.blocks.append(block)
        return path

    def accents(self, species):
        """The race's native language (as this build's type), the accent it speaks the other languages with, and the
        accents it may pick instead (Vibelin's multiple_accents), by Vibelin's accent names ("No Accent" for none)."""
        native = (text_of(self.base, species, 'native_language') or '"Imperial"').strip('"')
        lines = []
        if native in NATIVE_LANGUAGES:
            lines.append(f'\trogue_native_language = {NATIVE_LANGUAGES[native]}')
        own = self.accent_names.get(ACCENT_VARIANTS.get(species) or NATIVE_ACCENTS.get(native, ''))
        if own:
            lines.append(f'\trogue_accent = "{own}"')
        picks = []
        for value in re.findall(r'=\s*(ACCENT_[A-Z_]+|"[^"]*")', self.base.resolve(species, 'multiple_accents') or ''):
            # Vibelin names a language there now and then ("Humen Accent" = "Imperial"): its native accent.
            define = NATIVE_ACCENTS.get(value.strip('"'), 'ACCENT_NONE') if value.startswith('"') else value
            name = self.accent_names.get(define)
            if name and name not in picks:
                picks.append(name)
        if picks:
            lines.append('\trogue_accents = list(' + ', '.join(f'"{name}"' for name in picks) + ')')
        return lines

    def mechanics(self, species):
        """Vibelin's race mechanics this build has (heritage/race_mechanics.dm): flight on its wings (wings/flight, for the
        races its flight_for_species names: whether it rises a level as it takes off, how long it stays up), the triton's
        bioluminescence (granted in on_species_gain), and an ageless race (its only age is AGE_IMMORTAL)."""
        lines = []
        organs = dict(re.findall(r'(ORGAN_SLOT_[A-Z_]+)\s*=\s*(/obj/item/organ/[\w/]+)', self.base.resolve(species, 'organs') or ''))
        wings = organs.get('ORGAN_SLOT_WINGS', '').rstrip('/')
        if wings.startswith('/obj/item/organ/wings/flight'):
            fliers = [define_value(t).strip('"') for t in re.findall(r'SPEC_ID_[A-Z0-9_]+', self.base.resolve(wings, 'flight_for_species') or '')]
            vid = define_value((self.base.resolve(species, 'id') or '').strip()).strip('"')
            if not fliers or vid in fliers:
                lines.append('\trogue_flight = TRUE')
                if (self.base.resolve(wings, 'can_takeoff') or '').strip() in ('FALSE', '0'):
                    lines.append('\trogue_flight_takeoff = FALSE')
                time = re.match(r'\s*(\d+)\s*SECONDS', self.base.resolve(wings, 'flight_time') or '')
                if time:
                    lines.append(f'\trogue_flight_time = {int(time.group(1)) * 10}')
        body, _ = self.procs.find(self.base, species, 'on_species_gain')
        if body and 'bioluminescence' in '\n'.join(body):
            lines.append('\trogue_bioluminescence = TRUE')
        if re.findall(r'AGE_[A-Z]+', self.base.resolve(species, 'possible_ages') or '') == ['AGE_IMMORTAL']:
            lines.append('\trogue_ageless = TRUE')
        return lines

    def accent_block(self):
        """The accents by name: the file of their word swaps (under ACCENTS_DIR's parent) and its key."""
        entries = [f'\t"{name}" = list("{path}", "{key}"),' for name, (path, key) in sorted(self.accent_files.items())]
        return ['GLOBAL_LIST_INIT(rogue_accents, list('] + entries + ['))']

    def language_blocks(self):
        icons = []
        blocks = []
        for language in sorted(self.languages_used):
            ours, key = LANGUAGES[language]
            old_key = (text_of(self.base, language, 'key') or '""').strip('"')
            block = [ours]
            for var in ('name', 'desc'):
                value = text_of(self.base, language, var)
                if value:
                    if var == 'desc' and old_key:
                        value = value.replace(f',{old_key}', f',{key}')
                    block.append(f'\t{var} = {value}')
            block.append(f'\tkey = "{key}"')
            for var in ('space_chance', 'default_priority'):
                value = porter.number_value(self.base.resolve(language, var))
                if value is not None:
                    block.append(f'\t{var} = {value}')
            syllables = re.findall(r'"((?:[^"\\]|\\.)*)"', self.base.resolve(language, 'syllables') or '')
            if syllables:
                block.append('\tsyllables = list(' + ', '.join(json.dumps(s, ensure_ascii=False) for s in syllables) + ')')
            icon = (self.base.resolve(language, 'icon') or "'icons/misc/language.dmi'").strip().strip("'")
            state = (text_of(self.base, language, 'icon_state') or '""').strip('"')
            if state and os.path.exists(os.path.join(self.root, icon)):
                sheet = self.cells(icon)
                cells = sheet.state_cells()
                if state in cells and (not icons or size == (sheet.frame_width, sheet.frame_height)):
                    size = (sheet.frame_width, sheet.frame_height)
                    icons.append((ours.rsplit('/', 1)[-1], 1, cells[state][2][:1]))
                    block += [f"\ticon = '{LANGUAGE_ICON}'", f'\ticon_state = "{ours.rsplit("/", 1)[-1]}"']
            blocks.append(block)
        if icons:
            dmi.write_states(LANGUAGE_ICON, size[0], size[1], icons)
        return blocks


def generate(base, root, files, defines):
    cfg = json.load(open('modular_redtard/rockhill/config.json', encoding='utf-8'))
    os.makedirs(os.path.dirname(BODIES_ICON), exist_ok=True)
    port = Port(base, root, Procs(files), defines, cfg['attributes']['stats'], cfg['port']['bodies']['offset_keys'])
    port.skin_tones = global_list(root, 'skin_tones')
    port.hair_colors = global_list(root, 'haircolor')
    species = {}
    for path in RACES:
        if path not in base.types:
            port.warnings.append(f'{path}: not in Vibelin')
            continue
        ours = port.species(path)
        if ours:
            species[path] = ours
    port.blocks = port.language_blocks() + port.blocks
    port.blocks.append(['GLOBAL_LIST_INIT(rogue_vibelin_species, list('] + [f'\t"{k}" = {v},' for k, v in species.items()] + ['))'])
    port.blocks.append(port.accent_block())
    os.makedirs(ACCENTS_DIR, exist_ok=True)
    for path, _ in sorted(set(port.accent_files.values())):
        shutil.copyfile(os.path.join(root, 'strings', path), os.path.join(os.path.dirname(ACCENTS_DIR), path))
    # The beat of wings that take off and land (heritage/race_mechanics.dm).
    os.makedirs(SOUND_DIR, exist_ok=True)
    shutil.copyfile(os.path.join(root, FLIGHT_SOUND), os.path.join(SOUND_DIR, os.path.basename(FLIGHT_SOUND)))
    action_states = []
    for ours, (icon, state) in ACTION_STATES.items():
        sheet = port.cells(icon)
        cells = sheet.state_cells()
        if state in cells:
            dirs, _, frames = cells[state]
            action_states.append((ours, dirs, frames[:dirs]))
            action_size = (sheet.frame_width, sheet.frame_height)
    if action_states:
        dmi.write_states(ACTIONS_ICON, action_size[0], action_size[1], action_states)

    os.makedirs(os.path.dirname(BODIES_ICON), exist_ok=True)
    dmi.write_states(BODIES_ICON, 32, 32, port.body_states)
    if port.wide_states:
        dmi.write_states(WIDE_ICON, 64, 32, port.wide_states)
    for (width, height), states in sorted(port.sized_states.items()):
        dmi.write_states(SIZED_ICON.format(width, height), width, height, states)
    for rel in sorted(port.sounds):
        ref = port.sound_ref(rel).strip("'")
        if ref.startswith(SOUND_DIR) and os.path.exists(os.path.join(root, rel)):
            os.makedirs(os.path.dirname(ref), exist_ok=True)
            shutil.copyfile(os.path.join(root, rel), ref)
    os.makedirs(NAMES_DIR, exist_ok=True)
    for rel in sorted(port.name_files):
        shutil.copyfile(os.path.join(root, rel), f'{NAMES_DIR}/{os.path.basename(os.path.dirname(rel))}_{os.path.basename(rel)}')
    header = '// Generated by modular_redtard/tools/port_vibelin.py (port_vibelin_races.py) from Vibelin: do not edit by hand.\n\n'
    open(OUT_DM, 'w', encoding='utf-8', newline='\n').write(header + '\n\n'.join('\n'.join(b) for b in port.blocks) + '\n')
    print(f'{OUT_DM}: {len(species)} races, {len(port.features)} features, {len(port.languages_used)} languages, '
          f'{len(port.sounds)} voice sounds, {len(port.name_files)} name lists; {BODIES_ICON}: {len(port.body_states)} states, '
          f'{WIDE_ICON}: {len(port.wide_states)}' + ''.join(f', {SIZED_ICON.format(*size)}: {len(states)}' for size, states in sorted(port.sized_states.items())))
    for warning in port.warnings:
        print('  warning:', warning)
