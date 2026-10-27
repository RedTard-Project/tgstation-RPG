"""Vibelin's playable races as TG species (heritage/ported/races.dm), run by port_vibelin.py.

Vanderlin's races and Vibelin's modular ones (modular_abel/races) are ported as /datum/species/vib_<id>, <id> being
Vibelin's species id, so the heritage data (a patron's allowed_races, a culture's species) names them as it is.
Vibelin's dark elf is not ported: Ratwood's (rogue_drow) stands for it. Every race gets:
  - its body: Vibelin's per-zone body sheets (limbs_icon_m/f) as TG dimorphic body parts, one sheet for all races
    (heritage/icons/vibelin_bodies.dmi, state <body>_<zone>_<m|f>, each leg with its "_above" part drawn over it),
    greyscale and coloured by the skin (TG's mutant colour);
  - its features: the default sprite of each ear, horn, snout, neck, tail and wing organ it has (the organ's
    accessory, or the first choice of its customizer) as a bodypart overlay of the head or the chest;
  - its origins: the named skin colours of get_skin_list() (Vibelin's "Ancestry", "Progenitor"...) and the hair
    colours of get_hairc_list();
  - its attribute sheets (statsheet_male/statsheet_female), traits this build has, head features (hair, beard, lips,
    eye colour), whose clothes it wears (swap_*_clothes), offsets of worn things (offset_features_m/f), description;
  - its languages (grant_language of on_species_gain and after_creation; Vibelin's this build lacks are ported), voice
    (voicepack sounds as the tongue's emote sounds), eyes (night vision as TG's lighting cutoff) and name lists.
The customization of the features (Vibelin's customizer choices) is not ported.
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
LANGUAGE_ICON = 'modular_redtard/heritage/icons/languages.dmi'
SOUND_DIR = 'modular_redtard/heritage/sound'
ROCKHILL_SOUND_DIR = 'modular_redtard/rockhill/sound'
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
# Vibelin's organ slot: the part it is drawn on and the worn flags that hide it.
FEATURE_SLOTS = {
    'ORGAN_SLOT_EARS': ('head', 'HIDEEARS'),
    'ORGAN_SLOT_HORNS': ('head', 'HIDEHAIR'),
    'ORGAN_SLOT_SNOUT': ('head', 'HIDESNOUT'),
    'ORGAN_SLOT_NECK_FEATURE': ('head', 'NONE'),
    'ORGAN_SLOT_TAIL': ('chest', 'NONE'),
    'ORGAN_SLOT_WINGS': ('chest', 'NONE'),
}
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
        self.features = {}
        self.blocks = []
        self.sounds = set()
        self.name_files = set()
        self.languages_used = set()
        self.eyes = {}
        self.warnings = []

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

    def feature(self, accessory, hidden_by):
        """The overlay type of a sprite accessory, its states added to the sheet that fits its size."""
        if accessory in self.features:
            return self.features[accessory]
        self.features[accessory] = None
        icon = (self.base.resolve(accessory, 'icon') or '').strip().strip("'")
        state = (text_of(self.base, accessory, 'icon_state') or '""').strip('"')
        if not icon or not state or not os.path.exists(os.path.join(self.root, icon)):
            self.warnings.append(f'{accessory}: no sprite ({icon} {state})')
            return None
        sheet = self.cells(icon)
        source = sheet.state_cells()
        size = (sheet.frame_width, sheet.frame_height)
        if size not in ((32, 32), (64, 32)):
            self.warnings.append(f'{accessory}: {size[0]}x{size[1]} sprites are not ported')
            return None
        target = self.body_states if size == (32, 32) else self.wide_states
        leaf = leaf_of(accessory)
        layers = []
        for token in re.findall(r'BODY_[A-Z]+_LAYER', self.base.resolve(accessory, 'relevant_layers') or ''):
            layer = LAYERS.get(token)
            name = f'{state}_{layer}'
            if layer and name in source and layer not in layers:
                dirs, _, cells = source[name]
                target.append((f'vib_{leaf}_{layer}', dirs, cells[:dirs]))
                layers.append(layer)
        if not layers:
            self.warnings.append(f'{accessory}: none of its layers is in {icon}')
            return None
        path = f'/datum/bodypart_overlay/simple/rogue_feature/vib_{leaf}'
        block = [path, f"\ticon = {'VIBELIN_BODIES_ICON' if size == (32, 32) else 'VIBELIN_WIDE_ICON'}", f'\ticon_state = "vib_{leaf}"',
                 '\tlayers = list(' + ', '.join(f'"{layer}" = BODY_{layer}_LAYER' for layer in layers) + ')',
                 f'\thidden_by = {hidden_by}']
        if size == (64, 32):
            block.append('\trogue_pixel_x = -16')
        keys = self.base.resolve(accessory, 'color_key_defaults') or ''
        if (self.base.resolve(accessory, 'use_static') or '').strip() in ('TRUE', '1'):
            pass
        elif 'KEY_SKIN_COLOR' in keys:
            block.append('\tskin_coloured = TRUE')
        elif 'KEY_HAIR_COLOR' in keys:
            block.append('\trogue_hair_coloured = TRUE')
        else:
            colors = re.findall(r'"(#[0-9A-Fa-f]{6})"', self.base.resolve(accessory, 'default_colors') or '')
            if colors:
                block.append(f'\tdraw_color = "{colors[0].upper()}"')
        self.blocks.append(block)
        self.features[accessory] = path
        return path

    def species_features(self, species):
        organs = dict(re.findall(r'(ORGAN_SLOT_[A-Z_]+)\s*=\s*(/obj/item/organ/[\w/]+)', self.base.resolve(species, 'organs') or ''))
        out = collections.defaultdict(list)
        for slot, (zone, hidden_by) in FEATURE_SLOTS.items():
            if slot not in organs and slot not in self.customized_slots(species):
                continue
            accessory = self.accessory_for(species, slot, organs.get(slot, '').rstrip('/'))
            path = self.feature(accessory, hidden_by) if accessory else None
            if path:
                out[zone].append(path)
        return out

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
        features = self.species_features(species)
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

    os.makedirs(os.path.dirname(BODIES_ICON), exist_ok=True)
    dmi.write_states(BODIES_ICON, 32, 32, port.body_states)
    if port.wide_states:
        dmi.write_states(WIDE_ICON, 64, 32, port.wide_states)
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
          f'{len(port.sounds)} voice sounds, {len(port.name_files)} name lists; {BODIES_ICON}: {len(port.body_states)} states')
    for warning in port.warnings:
        print('  warning:', warning)
