"""VM1g: the spell basket of four forks as skeleton types of the module's magic (magic/, /datum/action/cooldown/spell/rogue).

    py -3 -I modular_redtard/tools/port_spells.py --dry-run [--lists DIR] [--agent AGENT ...] [--wave 1|2]
    py -3 -I modular_redtard/tools/port_spells.py --work DIR --key KEY [--agent AGENT ...] [--wave 1|2]

Input: the basket of block M2 (.cache/modular_redtard/agents/m1/lists/m2_b49*.tsv: one row a spell, its owner fork and
source type, the agent of the wave) and the primitive table of the V0 magic reconciliation
(.cache/modular_redtard/agents/v0/magic_primitives.tsv: data / light / code by the procs a type overrides). The source is
what each fork compiles (its .dme and the #include lines, recursively), read-only: Vibelin, Azure Peak, Ratwood 2.0 and
Twilight Axis.

For every spell of the basket the generator writes a skeleton type /datum/action/cooldown/spell/rogue/<primitive>/<path>:
its parent is the primitive of the V0 interface contract (rogue/projectile, rogue/aoe, rogue/touch...; a spell on the
bare base when the source has its own cast), and it carries the name, description, button icon, sound, invocation,
form, technique, skill, spell_forks, spell_source_type, the flags the source sets below its primitive, and `tunables`.
The numbers never go into the type: every number the type or its chain sets is a tunable, written as
spell_<type>_<tunable> to staged/<key>/magic_spells.txt of the block's work folder, read by tune(). The old system
(/obj/effect/proc_holder/spell) is translated by the rule of the basket (TASKS "B49a-B49g"): chargetime -> charge,
recharge_time -> cooldown, releasedrain -> cost, chargedrain -> charge_drain, charging_slowdown -> slowdown; Azure Peak's
hold (hold_drain, hold_grace_time, hold_max_time), cancel penalty, recovery and armour penalty go to the contract's
fields hold_drain, hold_grace, hold_max, cancel_penalty, recovery_time, armor_penalized. Energy and stamina of the
Roguetown forks become mana when the spell trains a magic skill; a spell of another skill keeps stamina
(ROGUE_SPELL_COST_STAMINA). The projectiles a spell fires are written beside it (/obj/projectile/magic/rogue/<name>);
statuses, summoned creatures and conjured items are listed with what the module already has.

--dry-run writes nothing into the module and nothing into staged/: the lists (data / light / code by the agents of the
waves, what the generator could not read) and a preview of the types and the numbers go to --lists (default: the
work folder of block VM1). Without --dry-run the types go to modular_redtard/magic/spells/ported/<agent>.dm and the
numbers to --work/staged/<key>/magic_spells.txt. No git, no DM, no copies of icons or sounds (they are listed).
"""

import argparse
import ast
import collections
import csv
import hashlib
import operator
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import dmi  # noqa: E402

REPO = os.path.normpath(os.path.join(HERE, "..", ".."))
MODULE = os.path.join(REPO, "modular_redtard")
AGENTS = os.path.join(REPO, ".cache", "modular_redtard", "agents")
BASKET_DIR = os.path.join(AGENTS, "m1", "lists")
PRIMITIVES_TSV = os.path.join(AGENTS, "v0", "magic_primitives.tsv")
DEFAULT_LISTS = os.path.join(AGENTS, "vm1")
PORTED_DIR = os.path.join(MODULE, "magic", "spells", "ported")
NUMBERS_FILE = "magic_spells.txt"

FORKS = {
    "Vibelin": ("C:/RedTardProject/Vibelin", "vanderlin.dme"),
    "Azure": ("C:/RedTardProject/Azure-Peak-Fork", "roguetown.dme"),
    "Ratwood": ("C:/RedTardProject/Ratwood-2.0-fork", "roguetown.dme"),
    "TA": ("C:/RedTardProject/Twilight-Axis-Fork", "roguetown.dme"),
}
# What spell_forks says (the module's two samples write "Vibelin").
FORK_TITLES = {"Vibelin": "Vibelin", "Azure": "Azure Peak", "Ratwood": "Ratwood", "TA": "Twilight Axis"}
FORK_FOLDERS = {"Vibelin": "vibelin", "Azure": "azure", "Ratwood": "ratwood", "TA": "twilight"}

ROGUE = "/datum/action/cooldown/spell/rogue"
NEW_BASE = "/datum/action/cooldown/spell"
OLD_BASE = "/obj/effect/proc_holder/spell"

# The basket without what is dead or not a spell of the basket (VM1 plan): Vibelin's talent tree is dead code.
DROP = {
    "open talent trees": "Vibelin's talent tree is dead code (VM1 plan: not ported)",
}
# The 17 spells of category "other": what they belong to instead of the arcyne basket. None is PvE or an antagonist's.
OTHER_SCOPE = {
    "grant residency": "system: residency (Vibelin dun_world residents)",
    "place schematic": "system: building blueprints (Vibelin crafting/blueprinting)",
    "place thatchwood hall": "system: building blueprints (Vibelin crafting/blueprinting)",
    "recruit retainer": "system: personal objectives (Vibelin, Astrata)",
    "recruit sundweller": "role: the Sunlord job (Vibelin austranderlin)",
    "sunlord s fireball": "role: the Sunlord job (Vibelin austranderlin)",
    "luxus pragmas charm": "alchemy: the lux reagent (Vibelin reagent_containers/lux.dm)",
    "choose your side": "faith: the schism event (Azure god_intervention)",
    "martial master ability": "combat: Twilight Axis martial combos",
    "switch stance": "combat: Twilight Axis martial combos",
    "shape body": "role: Twilight Axis mentor system (tat_system)",
    "training": "role: Twilight Axis mentor system (tat_system)",
    "architect s design": "system: Twilight Axis building planner",
    "materialize matrix": "system: Twilight Axis building planner",
    "harpy flight": "race: harpy wings",
    "harpy s song": "race: harpy vocal cords",
    "miracles": "faith: Azure/Ratwood church research (learn miracles)",
}
# Spells that systems already made wait for (VM3, wave 1), by basket key.
AWAITED = {"prestidigitation", "arcyne forge", "mending", "lesser mending", "greater mending", "arcyne affinity",
           "divine inspiration", "reforge"}
# Primitives of wave 1 for data and light spells (V0 magic, section 3).
WAVE1_PRIMITIVES = {"projectile", "aoe", "aoe/on_turf", "cone", "conjure", "conjure_summon", "conjure_item", "status",
                    "augment_buff", "enchantment", "touch"}
# The contract's primitives (V0 magic, section 4); rogue/projectile is in the module already.
CONTRACT = {"aoe", "aoe/on_turf", "cone", "beam", "touch", "status", "augment_buff", "conjure", "conjure_item",
            "conjure_summon", "telegraphed_strike", "telegraphed_strike/spellblade", "list_target", "jaunt", "teleport",
            "shapeshift", "enchantment", "minion_order", "projectile"}

# Source ancestor -> primitive of the contract. Checked from the type's parent upward; the first ancestor that matches
# wins. "" is the bare base (the spell has its own cast); "song" is outside the contract (the bards' agent declares it).
PRIMITIVE_PATHS = [
    (r"/spell/telegraphed_strike/spellblade$|/spellblade_strike$|/spell/spellblade$", "telegraphed_strike/spellblade"),
    (r"/spell/telegraphed_strike$", "telegraphed_strike"),
    (r"^/datum/action/cooldown/spell/projectile$|/spell/undirected/basic_projectile$|/proc_holder/spell/invoked/projectile$|/proc_holder/spell/targeted/projectile$|/proc_holder/spell/aimed$|/spell/aimed$", "projectile"),
    (r"/spell/cone/staggered$|/spell/cone$|/spell/undirected/cone$|/proc_holder/spell/aoe_turf/cone$|/proc_holder/spell/cone$", "cone"),
    (r"/spell/beam$", "beam"),
    (r"/spell/aoe/on_turf$|/spell/invoked_aoe$|/proc_holder/spell/invoked/invoked_aoe$", "aoe/on_turf"),
    (r"^/datum/action/cooldown/spell/aoe$|/proc_holder/spell/aoe_turf$|/spell/aoe_turf$", "aoe"),
    (r"/spell/undirected/touch$|^/datum/action/cooldown/spell/touch$|/proc_holder/spell/targeted/touch$|/proc_holder/spell/touch$", "touch"),
    (r"/spell/conjure_summon$|/proc_holder/spell/invoked/summon$", "conjure_summon"),
    (r"^/datum/action/cooldown/spell/conjure$|/proc_holder/spell/aoe_turf/conjure$|/proc_holder/spell/targeted/conjure$", "conjure"),
    (r"/spell/undirected/conjure_item$|^/datum/action/cooldown/spell/conjure_item$|/proc_holder/spell/targeted/conjure_item$|/proc_holder/spell/self/conjure_item$", "conjure_item"),
    (r"^/datum/action/cooldown/spell/status$", "status"),
    (r"^/datum/action/cooldown/spell/enchantment$", "enchantment"),
    (r"^/datum/action/cooldown/spell/augment_buff$", "augment_buff"),
    (r"/spell/undirected/jaunt$|/proc_holder/spell/targeted/ethereal_jaunt$|^/datum/action/cooldown/spell/jaunt$", "jaunt"),
    (r"/spell/undirected/teleport$|^/datum/action/cooldown/spell/teleport$|/proc_holder/spell/targeted/area_teleport$|/proc_holder/spell/targeted/turf_teleport$", "teleport"),
    (r"/spell/undirected/shapeshift$|/proc_holder/spell/targeted/shapeshift$|^/datum/action/cooldown/spell/shapeshift$|/proc_holder/spell/self/wildshape$|/spell/wildshape$", "shapeshift"),
    (r"/spell/undirected/list_target$|^/datum/action/cooldown/spell/list_target$", "list_target"),
    (r"/spell/undirected/song$|/spell/undirected/rhythm$|^/datum/action/cooldown/spell/song$|/proc_holder/spell/invoked/song$|/proc_holder/spell/self/song$|/proc_holder/spell/self/rhythm$", "song"),
    (r"/spell/minion_order$|/proc_holder/spell/invoked/order$|^/datum/action/cooldown/spell/order$", "minion_order"),
    (r"^/datum/action/cooldown/spell/pointed$|^/obj/effect/proc_holder/spell/invoked$|^/obj/effect/proc_holder/spell/targeted$", ""),
    (r"^/datum/action/cooldown/spell/undirected$|^/obj/effect/proc_holder/spell/self$", ""),
    (r"^/datum/action/cooldown/spell$|^/obj/effect/proc_holder/spell$", ""),
]
PRIMITIVE_PATHS = [(re.compile(p), name) for p, name in PRIMITIVE_PATHS]
PRIMITIVE_ROOTS = {f"{ROGUE}/{p}" for p in CONTRACT} | {f"{ROGUE}/song", ROGUE}
# The bare base is pointed (click to cast); these roots are not.
UNDIRECTED_ROOTS = re.compile(r"^/datum/action/cooldown/spell/undirected$|^/obj/effect/proc_holder/spell/self$")

# Vars that say nothing the module keeps: bookkeeping, runtime state, what the module does its own way. Dropped silently.
IGNORED = {
    "abstract_type", "parent_type", "currently_charging", "charged", "charge_started_at", "charge_target_time",
    "charge_counter", "auto_cancel_timer", "charge_sound_instance", "mastery_source", "charge_item", "charge_overlay",
    "fully_charged", "fully_charged_at", "hold_instability", "hold_warned", "next_hold_shake", "charge_started_realtime",
    "last_process_time", "active", "action", "ranged_ability_user", "current_amount", "arc_mode", "panel",
    "base_action", "has_action", "action_background_icon_state", "background_icon_state", "base_background_icon_state",
    "active_background_icon_state", "overlay_icon_state", "active_overlay_icon_state", "base_icon_state", "button_icon",
    "action_icon", "overlay_icon", "still_recharging_msg", "ranged_mousepointer", "spell_glow_light", "mob_charge_effect",
    "weapon_penalty_active", "attached_hand", "item_refs", "conjured_mobs", "current_mode", "active", "displayed_damage",
    "player_lock", "centcom_cancast", "panel", "charge_type", "holder_var_type", "holder_var_amount", "cooldown_min",
    "warnie", "chargedloop", "charge_sound", "charge_message", "has_visual_effects", "hide_charge_effect",
    "spell_impact_intensity", "spell_impact_color", "overlay_alpha", "fluff_desc", "desc_detail", "npc_aborted",
    "npc_targets_allies", "npc_requires_bound_weapon", "npc_commits_aim", "experience_max_skill", "experience_sleep",
    "experience_sleep_threshold", "initial_charges", "uses_spellbook_charges", "cast_effect_x_offset",
    "cast_effect_y_offset", "sparks_spread", "overlay", "overlay_lifespan", "ranged_clickcd_override",
}
# Text and identity, written as the source has them.
TEXT_VARS = {"name", "desc", "active_msg", "deactive_msg", "spell_color", "choose_target_message", "summon_noun",
             "draw_message", "drop_message", "weapon_missing_message", "invocation_self_message"}
# Times and numbers of the module's base and its primitives, by the source var (new and old system) -> tunable.
CORE_NUMBERS = {
    "spell_cost": "cost", "primary_resource_cost": "cost", "releasedrain": "cost",
    "cooldown_time": "cooldown", "recharge_time": "cooldown",
    "charge_time": "charge", "chargetime": "charge",
    "charge_slowdown": "slowdown", "charging_slowdown": "slowdown",
    "charge_drain": "charge_drain", "chargedrain": "charge_drain",
}
HOLD_NUMBERS = {"hold_drain": "hold_drain", "hold_grace_time": "hold_grace", "hold_max_time": "hold_max",
                "cancel_penalty_mult": "cancel_penalty", "recovery_time": "recovery_time"}
FORM_DEFINES = {"FORM_ARCANE": "ROGUE_FORM_ARCANE", "FORM_FIRE": "ROGUE_FORM_FIRE", "FORM_WATER": "ROGUE_FORM_WATER",
                "FORM_ICE": "ROGUE_FORM_ICE", "FORM_EARTH": "ROGUE_FORM_EARTH", "FORM_AIR": "ROGUE_FORM_AIR",
                "FORM_LIGHTNING": "ROGUE_FORM_LIGHTNING", "FORM_LIFE": "ROGUE_FORM_LIFE",
                "FORM_DEATH": "ROGUE_FORM_DEATH", "FORM_BLOOD": "ROGUE_FORM_BLOOD"}
TECHNIQUE_DEFINES = {f"TECHNIQUE_{n}": f"ROGUE_TECHNIQUE_{n}" for n in
                     ("DESTRUCTION", "CREATION", "SUMMONING", "RESTORATION", "ALTERATION", "ILLUSION", "IMBUE")}
STAT_DEFINES = {"STAT_INTELLIGENCE": "ROGUE_STAT_INTELLIGENCE", "STATKEY_INT": "ROGUE_STAT_INTELLIGENCE",
                "STAT_STRENGTH": "ROGUE_STAT_STRENGTH", "STATKEY_STR": "ROGUE_STAT_STRENGTH",
                "STAT_PERCEPTION": "ROGUE_STAT_PERCEPTION", "STATKEY_PER": "ROGUE_STAT_PERCEPTION",
                "STAT_CONSTITUTION": "ROGUE_STAT_CONSTITUTION", "STATKEY_CON": "ROGUE_STAT_CONSTITUTION",
                "STAT_ENDURANCE": "ROGUE_STAT_WILLPOWER", "STATKEY_WIL": "ROGUE_STAT_WILLPOWER",
                "STAT_SPEED": "ROGUE_STAT_SPEED", "STATKEY_SPD": "ROGUE_STAT_SPEED",
                "STAT_FORTUNE": "ROGUE_STAT_FORTUNE", "STATKEY_LCK": "ROGUE_STAT_FORTUNE"}
OLD_INVOCATION = {'"shout"': "INVOCATION_SHOUT", '"whisper"': "INVOCATION_WHISPER", '"emote"': "INVOCATION_EMOTE",
                  '"none"': "INVOCATION_NONE"}
# Kinds of range of the module (cast_range_key, magic.txt magic_range_*), by the forks' SPELL_RANGE_* defines.
RANGE_KEYS = {"SPELL_RANGE_PROJECTILE": "magic_range_projectile", "SPELL_RANGE_GROUND": "magic_range_ground",
              "SPELL_RANGE_TWO_SCREENS": "magic_range_two_screens", "SPELL_RANGE_AURA": "magic_range_aura",
              "SPELL_RANGE_ADJACENT": "magic_range_adjacent"}
# The contract's primitives as Vibelin has them: what vars the primitive will declare until it is written (block VM2).
VIBELIN_PRIMITIVES = {
    "projectile": "/datum/action/cooldown/spell/projectile", "aoe": "/datum/action/cooldown/spell/aoe",
    "aoe/on_turf": "/datum/action/cooldown/spell/aoe/on_turf", "cone": "/datum/action/cooldown/spell/cone",
    "beam": "/datum/action/cooldown/spell/beam", "touch": "/datum/action/cooldown/spell/undirected/touch",
    "status": "/datum/action/cooldown/spell/status", "augment_buff": "/datum/action/cooldown/spell/augment_buff",
    "conjure": "/datum/action/cooldown/spell/conjure", "conjure_item": "/datum/action/cooldown/spell/undirected/conjure_item",
    "conjure_summon": "/datum/action/cooldown/spell/conjure_summon",
    "telegraphed_strike": "/datum/action/cooldown/spell/telegraphed_strike",
    "telegraphed_strike/spellblade": "/datum/action/cooldown/spell/telegraphed_strike/spellblade",
    "list_target": "/datum/action/cooldown/spell/undirected/list_target",
    "jaunt": "/datum/action/cooldown/spell/undirected/jaunt", "teleport": "/datum/action/cooldown/spell/undirected/teleport",
    "shapeshift": "/datum/action/cooldown/spell/undirected/shapeshift",
    "enchantment": "/datum/action/cooldown/spell/enchantment", "minion_order": "/datum/action/cooldown/spell/minion_order",
    "song": "/datum/action/cooldown/spell/undirected/song",
}
# Vars of the source bases the module has no use for, with why (listed apart from what the generator could not read).
KNOWN_DROPPED = {
    "clothes_req": "old system: no wizard garb", "human_req": "old system: the module's spells ask a human anyway",
    "nonabstract_req": "old system", "stat_allowed": "old system", "phase_allowed": "old system",
    "include_user": "old system targeting", "selection_type": "old system targeting", "max_targets": "old system targeting",
    "message": "old system", "invocation_emote_self": "old system", "charge_invocation": "old system",
    "no_early_release": "old system: a module spell is cast once charged", "xp_gain": "old system: every module cast teaches",
    "gesture_required": "old system: no hands check in the module", "miracle": "miracles are faith/",
    "devotion_cost": "miracles are faith/", "ignore_cockblock": "old system", "ignore_combat_tag": "Roguetown combat tag",
    "priest_excluded": "old system", "is_cdr_exempt": "old system", "skipcharge": "old system",
    "breaks_invisibility": "old system", "inhand_requirement": "old system", "req_items": "old system",
    "req_inhand": "old system", "glow_intensity": "old system glow", "cost": "old system: spellbook points, the module buys by form and technique",
    "point_cost": "Azure spellbook points, the module buys by form and technique", "spell_tier": "Azure/Ratwood tiers, the module goes by form rank",
    "zizo_spell": "heretical flag, no such learning rule in the module", "heretical_spell": "heretical flag, no such learning rule in the module",
    "source_aspect": "Azure aspects", "attunement_school": "Azure attunement schools", "utility_learned": "Azure learning",
    "requires_aspect_access": "Azure aspects", "refundable": "Azure learning", "expose_caster_on_deflect": "Azure deflect",
    "supports_fellowship_snap": "Azure fellowship", "fellowship_snap": "Azure fellowship", "allow_cross_z": "Azure",
    "charge_swingdelay_type": "Azure swing delay", "charge_swingdelay_duration": "Azure swing delay",
    "blocks_defense_while_channeling": "Azure", "blocked_by_antimagic": "Azure", "charge_then_click": "Azure",
    "freeze_cast": "Azure", "spare_allies": "Azure", "recovery_slowdown": "Azure recovery slowdown",
    "background_icon": "the module's own spell background", "cooldown_reduction_per_rank": "Vibelin, unused by the module's base",
    "essences": "Vibelin essences (alchemy)", "spell_magnitude_modifier": "Vibelin magnitude: the contract's magnitude is VM1b's",
    "sparks_amt": "TG effect", "smoke_type": "TG effect", "smoke_amt": "TG effect", "ignore_can_speak": "TG",
    "ignore_los": "old system line of sight", "ranged_clickcd_override": "old system",
    "spell_flags": "Vibelin spell_flags (SPELL_RITUOS...): no such flags on the module's base",
    "npc_max_range": "Azure NPC casting", "npc_min_range": "Azure NPC casting", "npc_cast_chance": "Azure NPC casting",
}
# Numbers of a projectile that are its look, not its balance: they stay on the type.
VISUAL_NUMBERS = {"light_range", "light_power", "alpha", "pixel_x", "pixel_y", "layer", "plane", "icon_scale"}
PROJECTILE_IGNORED = {"parent_type", "abstract_type", "firer", "fired_from", "original"}

PATH = re.compile(r"/(?:datum|obj|mob|turf|area|atom)(?:/[A-Za-z0-9_]+)+")
IDENT = re.compile(r"\b[A-Za-z_][A-Za-z0-9_]*\b")
INCLUDE = re.compile(r'^\s*#include\s+"([^"]+)"', re.MULTILINE)
DEFINE = re.compile(r"^\s*#define\s+([A-Za-z_][A-Za-z0-9_]*)(?![A-Za-z0-9_(])\s*(.*)$")
FN_DEFINE = re.compile(r"^\s*#define\s+([A-Za-z_][A-Za-z0-9_]*)\(([^()]*)\)\s*(.*)$")
FN_CALL = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\(([^()]*)\)")
TIME_UNITS = {"SECONDS", "MINUTES", "DECISECONDS", "HOURS", "MILLISECONDS", "SECOND", "MINUTE", "DS"}
IMPLICIT_PARENTS = {"/obj": "/atom/movable", "/mob": "/atom/movable", "/atom/movable": "/atom", "/turf": "/atom",
                    "/area": "/atom", "/atom": "/datum"}
# Vars BYOND itself gives datums and atoms (no var/ line declares them).
BUILTIN_VARS = {"name", "desc", "icon", "icon_state", "color", "alpha", "layer", "plane", "pixel_x", "pixel_y", "pixel_w",
                "pixel_z", "density", "opacity", "dir", "invisibility", "mouse_opacity", "appearance_flags", "blend_mode",
                "transform", "luminosity", "maptext", "maptext_width", "maptext_height", "maptext_x", "maptext_y",
                "mouse_over_pointer", "mouse_drag_pointer", "mouse_drop_pointer", "tag", "gender", "suffix", "text",
                "filters", "render_source", "render_target", "vis_flags", "glide_size", "animate_movement", "step_size",
                "bound_x", "bound_y", "bound_width", "bound_height", "screen_loc", "verbs", "override"}
DM_WORDS = {"TRUE", "FALSE", "null", "list", "new", "src", "usr", "world", "global"}
TYPE_HEAD = re.compile(r"^(/[A-Za-z0-9_/]+?)/?\s*(?:\{\s*)?$")
PROC_HEAD = re.compile(r"^(/[A-Za-z0-9_/]+?)/(?:proc/|verb/)?([A-Za-z0-9_]+)\s*\(")
INDENT_PROC = re.compile(r"^\t(?:proc/|verb/)?([A-Za-z0-9_]+)\s*\(.*\)\s*$")
VAR_LINE = re.compile(r"^\t(?:var/)?(?:(?:tmp|static|global|const|list|[A-Za-z_][A-Za-z0-9_]*)/)*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$")
VAR_DECL = re.compile(r"^\tvar/(?:[A-Za-z_][A-Za-z0-9_]*/)*([A-Za-z_][A-Za-z0-9_]*)\s*$")
TEXT = re.compile(r'"(?:[^"\\]|\\.)*"')
BLOCK_COMMENT = re.compile(r"/\*.*?\*/", re.DOTALL)


# ---------------------------------------------------------------- reading DM

def strip_comment(line):
    """The line without a // comment outside strings and file references."""
    quote = None
    i = 0
    while i < len(line):
        c = line[i]
        if quote:
            if c == "\\":
                i += 2
                continue
            if c == quote:
                quote = None
        elif c in "\"'":
            quote = c
        elif c == "/" and line.startswith("//", i):
            return line[:i].rstrip()
        i += 1
    return line.rstrip()


def paren_balance(text):
    depth = 0
    quote = None
    i = 0
    while i < len(text):
        c = text[i]
        if quote:
            if c == "\\":
                i += 2
                continue
            if c == quote:
                quote = None
        elif c in "\"'":
            quote = c
        elif c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
        i += 1
    return depth


def compiled_files(root, dme):
    """Every .dm the fork compiles, in include order (BYOND resolves includes against the including file's folder)."""
    seen, order = set(), []

    def walk(path):
        norm = os.path.normcase(os.path.normpath(path))
        if norm in seen or not os.path.isfile(path):
            return
        seen.add(norm)
        order.append(path)
        text = open(path, encoding="utf-8", errors="replace").read()
        base = os.path.dirname(path)
        for inc in INCLUDE.findall(text):
            inc = inc.replace("\\", "/")
            if not inc.lower().endswith((".dm", ".dme")):
                continue
            candidate = os.path.join(base, inc)
            if not os.path.isfile(candidate):
                candidate = os.path.join(root, inc)
            walk(candidate)

    walk(os.path.join(root, dme))
    return [p for p in order if p.lower().endswith(".dm")]


class TypeInfo:
    __slots__ = ("path", "vars", "declared", "procs", "file", "line", "parent")

    def __init__(self, path):
        self.path = path
        self.vars = {}
        self.declared = set()
        self.procs = set()
        self.file = ""
        self.line = 0
        self.parent = None


class Codebase:
    """Types (vars, own procs, parent_type) and plain defines of what a codebase compiles."""

    def __init__(self, root, files, keep_types=None):
        self.root = root
        self.types = {}
        self.defines = {}
        self.fn_defines = {}
        for path in files:
            self.read(path, keep_types)

    def info(self, path):
        info = self.types.get(path)
        if info is None:
            info = self.types[path] = TypeInfo(path)
        return info

    def read(self, path, keep_types):
        try:
            text = open(path, encoding="utf-8", errors="replace").read()
        except OSError:
            return
        text = BLOCK_COMMENT.sub("", text)
        rel = os.path.relpath(path, self.root).replace("\\", "/")
        lines = text.split("\n")
        current = None
        i = 0
        while i < len(lines):
            raw = lines[i].rstrip("\r")
            i += 1
            if raw.lstrip().startswith("#"):
                m = DEFINE.match(strip_comment(raw))
                if m:
                    value = m.group(2).strip()
                    while value.endswith("\\") and i < len(lines):
                        value = value[:-1] + " " + strip_comment(lines[i].rstrip("\r")).strip()
                        i += 1
                    self.defines[m.group(1)] = value.strip()
                else:
                    m = FN_DEFINE.match(strip_comment(raw))
                    if m:
                        self.fn_defines[m.group(1)] = ([a.strip() for a in m.group(2).split(",")], m.group(3).strip())
                current = None
                continue
            line = strip_comment(raw)
            if not line.strip():
                continue
            if not line[0].isspace():
                m = PROC_HEAD.match(line)
                if m:
                    if keep_types is None or keep_types(m.group(1)):
                        self.info(m.group(1)).procs.add(m.group(2))
                    current = None
                    continue
                m = TYPE_HEAD.match(line)
                if m and (keep_types is None or keep_types(m.group(1))):
                    current = self.info(m.group(1))
                    if not current.file:
                        current.file, current.line = rel, i
                    continue
                current = None
                continue
            if current is None:
                continue
            m = INDENT_PROC.match(line)
            if m and not line.startswith("\t\t") and "=" not in line.split("(", 1)[0]:
                current.procs.add(m.group(1))
                continue
            if line.startswith("\t\t"):
                continue
            m = VAR_LINE.match(line)
            if m:
                value = m.group(2).strip()
                while (paren_balance(value) > 0 or value.endswith("\\")) and i < len(lines):
                    value = value.rstrip("\\") + " " + strip_comment(lines[i].rstrip("\r")).strip()
                    i += 1
                value = re.sub(r"\s+", " ", value).strip()
                if m.group(1) == "parent_type":
                    current.parent = value
                current.vars[m.group(1)] = value
                if line.startswith("\tvar/"):
                    current.declared.add(m.group(1))
                continue
            m = VAR_DECL.match(line)
            if m:
                current.vars.setdefault(m.group(1), "null")
                current.declared.add(m.group(1))

    def parent_of(self, path):
        info = self.types.get(path)
        if info and info.parent and info.parent.startswith("/"):
            return info.parent
        if path in IMPLICIT_PARENTS:
            return IMPLICIT_PARENTS[path]
        if path.count("/") <= 1:
            return None
        return path.rsplit("/", 1)[0]

    def chain(self, path):
        out, seen = [], set()
        while path and path not in seen:
            seen.add(path)
            out.append(path)
            path = self.parent_of(path)
        return out

    def resolve(self, path, var, stop=None):
        """(raw value, defining type) of a var as the type sees it, walking its chain (up to, not into, stop)."""
        for step in self.chain(path):
            if stop and step == stop:
                return None, None
            info = self.types.get(step)
            if info and var in info.vars:
                return info.vars[var], step
        return None, None

    def own_procs(self, path, stop):
        """Procs the type and its chain override below stop (the primitive or a ported parent)."""
        out = set()
        for step in self.chain(path):
            if step == stop:
                break
            info = self.types.get(step)
            if info:
                out |= info.procs
        return out

    def declared_vars(self, path, stop=None):
        """Vars the type and its chain declare (var/), up to, not into, stop."""
        out = set()
        for step in self.chain(path):
            if stop and step == stop:
                break
            info = self.types.get(step)
            if info:
                out |= info.declared
        return out

    def expand(self, raw, depth=0):
        if depth > 12:
            return raw
        changed = False

        def fn(m):
            nonlocal changed
            args, body = self.fn_defines[m.group(1)]
            given = [a.strip() for a in m.group(2).split(",")]
            if len(given) != len(args):
                return m.group(0)
            changed = True
            for name, value in zip(args, given):
                body = re.sub(rf"\b{re.escape(name)}\b", f"({value})", body)
            return f"({body})"

        if self.fn_defines:
            raw = FN_CALL.sub(lambda m: fn(m) if m.group(1) in self.fn_defines else m.group(0), raw)

        def sub(m):
            nonlocal changed
            name = m.group(0)
            if name in self.defines:
                changed = True
                return " " + self.defines[name] + " "
            return name

        out = IDENT.sub(sub, raw)
        return self.expand(out, depth + 1) if changed else out

    def number(self, raw):
        """The value as a number, defines expanded (N SECONDS), or None."""
        if raw is None:
            return None
        raw = raw.strip()
        if raw.startswith(("'", '"', "/", "list(", "new")):
            return None
        return safe_eval(self.expand(raw))


OPS = {ast.Add: operator.add, ast.Sub: operator.sub, ast.Mult: operator.mul, ast.Div: operator.truediv,
       ast.Mod: operator.mod, ast.Pow: operator.pow, ast.LShift: operator.lshift, ast.RShift: operator.rshift,
       ast.BitOr: operator.or_, ast.BitAnd: operator.and_, ast.BitXor: operator.xor}


def safe_eval(text):
    text = text.strip()
    if not text or re.search(r"[A-Za-z_\"']", text.replace("e-", "").replace("e+", "")):
        return None
    try:
        node = ast.parse(text, mode="eval").body
    except SyntaxError:
        return None

    def ev(n):
        if isinstance(n, ast.Constant) and isinstance(n.value, (int, float)):
            return n.value
        if isinstance(n, ast.UnaryOp) and isinstance(n.op, (ast.USub, ast.UAdd)):
            v = ev(n.operand)
            return -v if isinstance(n.op, ast.USub) else v
        if isinstance(n, ast.BinOp) and type(n.op) in OPS:
            a, b = ev(n.left), ev(n.right)
            if isinstance(n.op, (ast.LShift, ast.RShift, ast.BitOr, ast.BitAnd, ast.BitXor)):
                a, b = int(a), int(b)
            return OPS[type(n.op)](a, b)
        raise ValueError(ast.dump(n))

    try:
        return ev(node)
    except (ValueError, ZeroDivisionError, TypeError, OverflowError):
        return None


def fmt_number(value):
    if isinstance(value, float):
        value = round(value, 4)
        if value == int(value):
            return str(int(value))
        return repr(value)
    return str(value)


# ---------------------------------------------------------------- the module

class Module:
    """What the module and TG already declare: types, defines, icon and sound files."""

    def __init__(self):
        files = []
        for root in (os.path.join(REPO, "code"), MODULE):
            for dirpath, dirnames, filenames in os.walk(root):
                dirnames[:] = [d for d in dirnames if d not in (".git", "node_modules", "tools", "build")]
                files += [os.path.join(dirpath, f) for f in sorted(filenames) if f.endswith(".dm")]
        self.code = Codebase(REPO, files)
        self.types = set(self.code.types)
        self.defines = set(self.code.defines) | set(self.code.fn_defines)
        self.files = collections.defaultdict(list)
        for root in (MODULE, os.path.join(REPO, "icons"), os.path.join(REPO, "sound")):
            for dirpath, dirnames, filenames in os.walk(root):
                dirnames[:] = [d for d in dirnames if d not in (".git", "node_modules")]
                for f in filenames:
                    if f.endswith((".dmi", ".ogg", ".wav")):
                        self.files[f.lower()].append(os.path.join(dirpath, f))
        self.hashes = {}
        self.states = {}

    def has_type(self, path):
        return path in self.types

    def digest(self, path):
        if path not in self.hashes:
            try:
                self.hashes[path] = hashlib.md5(open(path, "rb").read()).hexdigest()
            except OSError:
                self.hashes[path] = None
        return self.hashes[path]

    def icon_states(self, path):
        if path not in self.states:
            try:
                self.states[path] = set(dmi.state_names(path))
            except Exception:  # noqa: BLE001 - a broken or odd DMI only means the state is not known
                self.states[path] = None
        return self.states[path]

    def find_file(self, source_file, want_state=None):
        """('same', module path) for a byte-equal file, ('state', path) for a module file of that name holding the
        state, or (None, None)."""
        candidates = self.files.get(os.path.basename(source_file).lower(), [])
        digest = self.digest(source_file)
        for cand in candidates:
            if digest and self.digest(cand) == digest:
                return "same", cand
        if want_state:
            for cand in candidates:
                states = self.icon_states(cand)
                if states and want_state in states:
                    return "state", cand
        elif candidates and source_file.lower().endswith((".ogg", ".wav")):
            # A sound of the same name the module has (another fork's copy, re-encoded): the module's is used.
            mine = [c for c in candidates if os.path.normcase(c).startswith(os.path.normcase(MODULE))]
            return "name", (mine or candidates)[0]
        return None, None


def dm_rel(path):
    return os.path.relpath(path, REPO).replace("\\", "/")


# ---------------------------------------------------------------- the porter

class SpellPorter:
    def __init__(self):
        self.module = Module()
        print(f"module: {len(self.module.types)} types, {len(self.module.defines)} defines", file=sys.stderr)
        self.forks = {}
        for fork, (root, dme) in FORKS.items():
            files = compiled_files(root, dme)
            self.forks[fork] = Codebase(root, files)
            print(f"{fork}: {len(files)} files, {len(self.forks[fork].types)} types", file=sys.stderr)
        self.rows = []
        for fn in sorted(os.listdir(BASKET_DIR)):
            if fn.startswith("m2_b49") and fn.endswith(".tsv"):
                self.rows += list(csv.DictReader(open(os.path.join(BASKET_DIR, fn), encoding="utf-8"), delimiter="\t"))
        self.prim_rows = {r["type"] + "@" + r["owner"]: r for r in
                          csv.DictReader(open(PRIMITIVES_TSV, encoding="utf-8"), delimiter="\t")}
        self.targets = {}        # (fork, source type) -> target
        self.target_owner = {}   # target -> (fork, source type)
        self.unparsed = collections.Counter()   # (fork, var) -> types
        self.unparsed_example = {}
        self.assets = {}         # (kind, fork, source file) -> row
        self.linked = {}         # (fork, path) -> row
        self.projectiles = {}    # (fork, source) -> target
        self.projectile_blocks = {}
        self.notes = collections.Counter()
        self.parent_cache = {}
        self.dropped_vars = collections.Counter()
        self.dropped_example = {}

    # ---- primitive and path

    def primitive_of(self, fork, path):
        code = self.forks[fork]
        chain = code.chain(path)
        for anc in chain[1:]:
            for rx, name in PRIMITIVE_PATHS:
                if rx.search(anc):
                    return name, anc
        return None, None

    def target_path(self, fork, path, prim, prim_anc):
        if path.startswith(prim_anc + "/"):
            rest = path[len(prim_anc) + 1:]
        else:
            rest = path.rsplit("/", 1)[1]
        if prim == "":
            # Spells of the bare base: no pointed/ or undirected/ step (the base is pointed, undirected ones say so).
            for lead in ("pointed/", "undirected/", "invoked/", "targeted/", "self/"):
                if rest.startswith(lead):
                    rest = rest[len(lead):]
            return f"{ROGUE}/{rest}"
        return f"{ROGUE}/{prim}/{rest}"

    def assign_targets(self, rows):
        for row in rows:
            fork, path = row["owner"], row["owner_type"]
            prim, anc = self.primitive_of(fork, path)
            row["_prim"], row["_prim_anc"] = prim, anc
            if prim is None:
                row["_target"] = ""
                continue
            if prim == "conjure" and fork != "Vibelin":
                # The old conjure summons whatever summon_type lists: creatures are conjure_summon.
                raw, _ = self.forks[fork].resolve(path, "summon_type")
                if raw and "/mob/" in raw:
                    prim = row["_prim"] = "conjure_summon"
            target = self.target_path(fork, path, prim, anc)
            if self.module_source(target) == path:
                row["_in_module"] = True
            elif target in self.target_owner or target in self.module.types or target in PRIMITIVE_ROOTS:
                target = f"{target}_{FORK_FOLDERS[fork]}"
                self.notes["path collision: a fork suffix added"] += 1
                row.setdefault("_notes", []).append("path collision: fork suffix")
            self.targets[(fork, path)] = target
            self.target_owner[target] = (fork, path)
            row["_target"] = target

    def module_source(self, target):
        """The source type a spell of the module says it came from (spell_source_type), or None."""
        info = self.module.code.types.get(target)
        if not info or "spell_source_type" not in info.vars:
            return None
        return info.vars["spell_source_type"].strip('"')

    # ---- vars

    def note_unparsed(self, fork, var, value, path):
        self.unparsed[(fork, var)] += 1
        self.unparsed_example.setdefault((fork, var), (value, path))

    def asset(self, kind, fork, raw, state, origin_file):
        """A module path for a source icon or sound, or None (then it is listed to copy)."""
        code = self.forks[fork]
        rel = raw.strip("'")
        source = os.path.join(code.root, rel)
        if not os.path.isfile(source):
            source = os.path.join(code.root, os.path.dirname(origin_file), rel)
        key = (kind, fork, rel, state or "")
        if key in self.assets:
            self.assets[key]["uses"] += 1
            return self.assets[key]["module"] or None
        found, module_path = (None, None)
        if os.path.isfile(source):
            found, module_path = self.module.find_file(source, state if kind == "icon" else None)
        row = {"kind": kind, "fork": fork, "source": rel, "state": state or "", "exists": os.path.isfile(source),
               "match": found or "", "module": dm_rel(module_path) if module_path else "",
               "copy_to": "" if module_path else f"modular_redtard/magic/{'icons' if kind == 'icon' else 'sound'}/{FORK_FOLDERS[fork]}/{os.path.basename(rel)}",
               "uses": 1}
        self.assets[key] = row
        return row["module"] or None

    def asset_ref(self, kind, fork, raw, state, origin_file):
        module_path = self.asset(kind, fork, raw, state, origin_file)
        if module_path:
            return f"'{module_path}'"
        return f"'{self.assets[(kind, fork, raw.strip(chr(39)), state or '')]['copy_to']}'"

    def link(self, fork, path, spell_target, wants):
        """A type a spell points at (status, creature, item, effect): the module's when it has one, else listed."""
        key = (fork, path)
        if key not in self.linked:
            code = self.forks[fork]
            info = code.types.get(path)
            kind = path.split("/")[1] + "/" + (path.split("/")[2] if path.count("/") > 1 else "")
            own = sorted(code.own_procs(path, "/datum/status_effect" if path.startswith("/datum/status_effect") else None)) if info else []
            self.linked[key] = {"fork": fork, "path": path, "kind": kind, "in_module": self.module.has_type(path),
                                "in_source": info is not None, "own_procs": len(own), "spells": set(), "wants": wants}
        self.linked[key]["spells"].add(spell_target)
        return path

    def map_path_value(self, fork, raw, spell_target, var):
        """A value holding type paths: spells of the basket are renamed to their targets, projectiles to the ported
        ones, other types linked as they are."""
        def sub(m):
            p = m.group(0)
            if (fork, p) in self.targets:
                return self.targets[(fork, p)]
            if p.startswith("/obj/projectile"):
                return self.port_projectile(fork, p, spell_target)
            if p.startswith(("/datum/status_effect", "/mob", "/obj")):
                self.link(fork, p, spell_target, var)
            return p
        return PATH.sub(sub, raw)

    def port_projectile(self, fork, path, spell_target):
        key = (fork, path)
        if key in self.projectiles:
            return self.projectiles[key]
        if self.module.has_type(path) and path.startswith("/obj/projectile/magic/rogue"):
            self.projectiles[key] = path
            return path
        leaf = path.split("/obj/projectile/", 1)[1]
        for lead in ("magic/", "energy/", "bullet/"):
            if leaf.startswith(lead):
                leaf = leaf[len(lead):]
        target = "/obj/projectile/magic/rogue/" + leaf
        if target in self.projectile_blocks or self.module.has_type(target):
            if self.module.has_type(target):
                self.projectiles[key] = target
                return target
            target += "_" + FORK_FOLDERS[fork]
        self.projectiles[key] = target
        code = self.forks[fork]
        stop = None
        for step in code.chain(path)[1:]:
            if step in ("/obj/projectile/magic", "/obj/projectile", "/obj/projectile/energy", "/obj/projectile/bullet"):
                stop = step
                break
        lines, numbers, unknown = [], {}, []
        known = self.module.code.declared_vars("/obj/projectile/magic/rogue")
        seen = set()
        for step in code.chain(path):
            if step == stop:
                break
            info = code.types.get(step)
            if not info:
                continue
            for var, value in info.vars.items():
                if var in seen or var in PROJECTILE_IGNORED:
                    continue
                seen.add(var)
                kind, value = self.classify(code, value)
                if var in ("damage", "speed"):
                    numbers[var] = code.number(value)
                elif var not in known and var not in BUILTIN_VARS:
                    unknown.append(var)
                    self.note_unparsed(fork, "projectile:" + var, value, path)
                elif var == "icon" and kind == "file":
                    state, _ = code.resolve(path, "icon_state")
                    lines.append(("icon", self.asset_ref("icon", fork, value, (state or "").strip('"'), info.file)))
                elif kind == "file":
                    lines.append((var, self.asset_ref("sound", fork, value, None, info.file)))
                elif kind == "number":
                    if var in VISUAL_NUMBERS:
                        lines.append((var, value))
                    else:
                        numbers[var] = code.number(value)
                elif kind in ("bool", "null", "text", "define"):
                    lines.append((var, value))
                elif kind in ("path", "list"):
                    lines.append((var, self.map_path_value(fork, value, target, var)))
                else:
                    unknown.append(var)
                    self.note_unparsed(fork, "projectile:" + var, value, path)
        own = sorted(code.own_procs(path, stop))
        if "damage" not in numbers:
            numbers["damage"] = code.number(code.resolve(path, "damage")[0])
        if "speed" not in numbers:
            numbers["speed"] = code.number(code.resolve(path, "speed")[0])
        self.projectile_blocks[target] = {"fork": fork, "source": path, "lines": lines, "numbers": numbers,
                                          "own_procs": own, "unknown": unknown, "spells": {spell_target}}
        return target

    def port_spell(self, row):
        fork, path = row["owner"], row["owner_type"]
        code = self.forks[fork]
        target = row["_target"]
        prim, prim_anc = row["_prim"], row["_prim_anc"]
        system = "old" if path.startswith(OLD_BASE) else "new"
        # Vars written on the type: those its chain sets below the primitive or the nearest ported parent.
        stop = prim_anc
        for step in code.chain(path)[1:]:
            if step == prim_anc:
                break
            if (fork, step) in self.targets and target.startswith(self.targets[(fork, step)] + "/"):
                stop = step
                break
        parent_ported = stop != prim_anc
        row["_ported_parent"] = self.targets[(fork, stop)] if parent_ported else ""
        own_vars = {}
        for step in code.chain(path):
            if step == stop:
                break
            info = code.types.get(step)
            if info:
                for var, value in info.vars.items():
                    own_vars.setdefault(var, (value, step))
        lines = []
        tunables = collections.OrderedDict()
        notes = row.setdefault("_notes", [])

        def full(var):
            return code.resolve(path, var)[0]

        def put(var, value):
            lines.append((var, value))

        # The base's four numbers and the old system's drains, from the whole chain (the module's base has 0).
        for var, tun in CORE_NUMBERS.items():
            raw = full(var)
            if raw is None:
                continue
            if system == "old" and var in ("spell_cost", "cooldown_time", "charge_time", "charge_slowdown", "charge_drain", "primary_resource_cost"):
                continue
            if system == "new" and var in ("releasedrain", "recharge_time", "chargetime", "charging_slowdown", "chargedrain"):
                continue
            value = code.number(raw)
            if value is None:
                notes.append(f"{var} = {raw}: not a number")
                self.note_unparsed(fork, var, raw, path)
                continue
            if tun not in tunables or tunables[tun] == 0:
                tunables[tun] = value
        if (full("charge_required") or "").strip() == "FALSE":
            tunables["charge"] = 0
        for base in ("cost", "cooldown", "charge", "slowdown"):
            tunables.setdefault(base, 0)
        if tunables.get("charge_drain") == 0:
            del tunables["charge_drain"]
        # Azure Peak's hold, cancel penalty and recovery (the fork's base declares them), only on charged spells.
        if full("hold_drain") is not None:
            if tunables.get("charge", 0) > 0:
                for var, tun in HOLD_NUMBERS.items():
                    value = code.number(full(var))
                    if value:
                        tunables[tun] = value
            else:
                value = code.number(full("recovery_time"))
                if value:
                    tunables["recovery_time"] = value
        if full("ignore_armor_penalty") is not None and (full("ignore_armor_penalty") or "").strip() != "TRUE":
            put("armor_penalized", "TRUE")
        # The price: mana, or stamina for a spell that trains no magic skill (Vibelin SPELL_STAMINA).
        skill_raw = full("associated_skill") or ""
        magic_skill = "/magic/" in skill_raw or not skill_raw
        spell_type = (full("spell_type") or "").strip()
        resource = (full("primary_resource_type") or "").strip()
        if spell_type == "SPELL_STAMINA" or (resource in ("SPELL_COST_STAMINA", "SPELL_COST_ENERGY") and not magic_skill) \
                or (system == "old" and not magic_skill):
            put("cost_type", "ROGUE_SPELL_COST_STAMINA")
        elif resource in ("SPELL_COST_NONE",) or spell_type in ("SPELL_MIRACLE",):
            notes.append(f"price kind {resource or spell_type}: kept as mana")
        elif resource in ("SPELL_COST_BLOOD", "SPELL_COST_VITAE", "SPELL_COST_DEVOTION"):
            notes.append(f"price kind {resource}: no such price in the module (mana)")
        sec = (full("secondary_resource_type") or "SPELL_COST_NONE").strip()
        if sec != "SPELL_COST_NONE":
            notes.append(f"second price {sec} {full('secondary_resource_cost')}: not ported")
        # Identity.
        for var in ("name", "desc"):
            raw = own_vars.get(var, (None,))[0] if parent_ported else full(var)
            if raw is not None:
                put(var, raw)
        state_raw = None
        icon_raw = None
        if system == "new":
            state_raw = full("button_icon_state")
            icon_raw, icon_from = code.resolve(path, "button_icon")
        else:
            state_raw = full("overlay_state") or full("action_icon_state")
            icon_raw, icon_from = code.resolve(path, "action_icon")
        state = (state_raw or "").strip('"')
        if icon_raw and icon_raw.startswith("'"):
            origin = code.types[icon_from].file if icon_from in code.types else ""
            ref = self.asset_ref("icon", fork, icon_raw, state, origin)
            if ref != "'modular_redtard/magic/icons/roguespells.dmi'":
                put("button_icon", ref)
        if state_raw is not None:
            put("button_icon_state", state_raw)
        sound_raw, sound_from = code.resolve(path, "sound")
        if sound_raw and sound_raw.startswith("'"):
            ref = self.asset_ref("sound", fork, sound_raw, None, code.types[sound_from].file if sound_from in code.types else "")
            if ref != "'modular_redtard/combat/sound/magic/whiteflame.ogg'":  # the base's ROGUE_SPELL_CAST_SOUND
                put("sound", ref)
        elif sound_raw in ("null",):
            put("sound", "null")
        # Invocation: the first line of the old and of Azure's list.
        inv = full("invocation")
        if inv is None:
            invs = full("invocations")
            if invs and invs.startswith("list("):
                first = re.match(r'list\(\s*("(?:[^"\\]|\\.)*")', invs)
                if first:
                    inv = first.group(1)
                    if invs.count('"') > 2:
                        notes.append("several invocations: the first kept")
        inv_type = (full("invocation_type") or "").strip()
        inv_type = OLD_INVOCATION.get(inv_type, inv_type)
        if inv and inv not in ('""', "null"):
            put("invocation", inv)
            if inv_type and inv_type != "INVOCATION_NONE":
                put("invocation_type", inv_type)
        # Form, technique, skill, characteristic.
        form = (full("required_form") or "").strip()
        tech = (full("required_technique") or "").strip()
        if form and form != "null":
            if form in FORM_DEFINES:
                put("required_form", FORM_DEFINES[form])
            else:
                notes.append(f"form {form}: unknown")
        if tech and tech != "null":
            if tech in TECHNIQUE_DEFINES:
                put("required_technique", TECHNIQUE_DEFINES[tech])
            else:
                notes.append(f"technique {tech}: unknown")
        if skill_raw and skill_raw.strip() != "null":
            skill = skill_raw.strip().replace("/datum/skill/", "/datum/attribute/skill/")
            if self.module.has_type(skill):
                if skill != "/datum/attribute/skill/magic/arcane":
                    put("associated_skill", skill)
            else:
                notes.append(f"skill {skill_raw}: not in the module, Arcyne kept")
        stat = (full("associated_stat") or "").strip()
        if stat and stat not in ("STAT_INTELLIGENCE", "STATKEY_INT", "null"):
            if stat in STAT_DEFINES:
                put("associated_stat", STAT_DEFINES[stat])
            else:
                notes.append(f"characteristic {stat}: unknown")
        # Range: the kind (SPELL_RANGE_*) or a number of its own.
        raw = own_vars.get("cast_range", (None,))[0] or (own_vars.get("range", (None,))[0] if system == "old" else None)
        if raw:
            key = raw.strip()
            if key in RANGE_KEYS:
                put("cast_range_key", f'"{RANGE_KEYS[key]}"')
            else:
                value = code.number(raw)
                if value is None:
                    notes.append(f"range {raw}: not a number")
                elif system == "old" and prim in ("aoe", "aoe/on_turf"):
                    tunables["aoe_radius"] = value
                elif system == "old" and prim == "cone":
                    tunables["cone_levels"] = value
                else:
                    tunables["range"] = value
        # Projectiles: what it fires, its damage and speed as the spell's numbers.
        if prim == "projectile":
            proj_raw = full("projectile_type")
            if proj_raw and proj_raw.startswith("/"):
                proj_target = self.port_projectile(fork, proj_raw.strip(), target)
                self.projectile_blocks.get(proj_target, {}).get("spells", set()).add(target)
                put("projectile_type", proj_target)
                block = self.projectile_blocks.get(proj_target)
                if block:
                    if block["numbers"].get("damage"):
                        tunables["damage"] = block["numbers"]["damage"]
                    if block["numbers"].get("speed"):
                        tunables["tile_time"] = block["numbers"]["speed"]
        # Experience modifier of its own.
        raw = own_vars.get("experience_modifier", (None,))[0]
        if raw is not None:
            value = code.number(raw)
            if value is not None:
                put("experience_modifier_key", f'"{rogue_key(target)}_experience_modifier"')
                row["_extra_numbers"] = {f"{rogue_key(target)}_experience_modifier": value}
        # Requirements.
        req = own_vars.get("spell_requirements", (None,))[0]
        if req is not None:
            flags = [f.strip() for f in self.flag_names(code, req)]
            tg = [f for f in flags if f in self.module.defines and f.startswith("SPELL_")]
            rogue_flags = []
            for f in flags:
                if f in ("SPELL_REQUIRES_NO_MOVE",):
                    rogue_flags.append("ROGUE_SPELL_REQUIRES_NO_MOVE")
                elif f in ("SPELL_CASTABLE_WHILE_MOUNTED",):
                    rogue_flags.append("ROGUE_SPELL_CASTABLE_WHILE_MOUNTED")
                elif f == "SPELL_REQUIRES_SAME_Z":
                    continue  # Azure Peak's: the module's spells reach no further than the screen anyway
                elif f not in tg and f not in ("NONE", "0"):
                    notes.append(f"requirement {f}: no such flag in TG")
            put("spell_requirements", "|".join(tg) if tg else "NONE")
            if rogue_flags:
                put("rogue_requirements", "|".join(rogue_flags))
        if system == "old":
            if (full("movement_interrupt") or "").strip() == "TRUE":
                put("rogue_requirements", "ROGUE_SPELL_REQUIRES_NO_MOVE")
            if (full("antimagic_allowed") or "").strip() == "TRUE":
                put("spell_requirements", "SPELL_REQUIRES_HUMAN")
        anti = own_vars.get("antimagic_flags", (None,))[0]
        if anti is not None:
            flags = self.flag_names(code, anti)
            flags = [f for f in flags if f not in ("NONE", "0")]
            ok = [f for f in flags if f in self.module.defines]
            if len(ok) != len(flags):
                notes.append(f"antimagic {anti}: partly unknown")
            put("antimagic_flags", "|".join(ok) if ok else "NONE")
        # Undirected spells on the bare base cast at once.
        if prim == "" and any(UNDIRECTED_ROOTS.search(a) for a in code.chain(path)):
            put("click_to_activate", "FALSE")
        elif prim == "" and system == "new" and full("click_to_activate") is None:
            put("click_to_activate", "FALSE")
        # Everything else the chain sets below the primitive.
        handled = set(CORE_NUMBERS) | set(HOLD_NUMBERS) | {
            "name", "desc", "button_icon_state", "overlay_state", "action_icon_state", "sound", "invocation",
            "invocations", "invocation_type", "required_form", "required_technique", "associated_skill",
            "associated_stat", "cast_range", "range", "projectile_type", "experience_modifier", "spell_requirements",
            "antimagic_flags", "spell_type", "primary_resource_type", "secondary_resource_type",
            "secondary_resource_cost", "charge_required", "ignore_armor_penalty", "movement_interrupt",
            "antimagic_allowed", "click_to_activate"}
        done = {v for v, _ in lines}
        parent_vars = self.parent_vars(prim) | BUILTIN_VARS
        if parent_ported:
            parent_vars = parent_vars | code.declared_vars(stop, prim_anc)
        own_declared = code.declared_vars(path, stop)
        for var, (value, step) in own_vars.items():
            if var in handled or var in IGNORED or var in done:
                continue
            if var in KNOWN_DROPPED:
                self.dropped_vars[(fork, var)] += 1
                self.dropped_example.setdefault((fork, var), (value, path))
                continue
            if var in ("glow_color", "spell_color"):
                kind, text = self.classify(code, value)
                if kind in ("text", "define"):
                    put("spell_color", text)
                else:
                    self.dropped_vars[(fork, var)] += 1
                    self.dropped_example.setdefault((fork, var), (value, path))
                continue
            declared_here = var in own_declared and var not in parent_vars
            if not declared_here and var not in parent_vars:
                self.note_unparsed(fork, var, value, path)
                notes.append(f"{var}: not a var of the module's parent")
                continue
            name = f"var/{var}" if declared_here else var
            kind, value = self.classify(code, value)
            if var == "required_level":
                # The spellbook reads it with initial(): it stays on the type (a rank, not a balance number).
                put(name, fmt_number(code.number(value) or 0))
            elif kind == "number":
                tunables[var] = code.number(value)
                if declared_here:
                    put(name, None)
            elif kind in ("bool", "null", "text", "define"):
                put(name, value)
            elif kind == "file":
                put(name, self.asset_ref("sound" if "sound" in var or value.lower().endswith((".ogg", ".wav'")) else "icon",
                                         fork, value, None, code.types[step].file))
            elif kind in ("path", "list"):
                if kind == "list" and re.search(r"(?<![\w\"/])\d", re.sub(r'"(?:[^"\\]|\\.)*"', '""', value)):
                    notes.append(f"{var}: numbers inside a list (by hand)")
                missing = [i for i in self.idents(value) if i not in self.module.defines]
                if missing:
                    notes.append(f"{var}: {', '.join(missing[:4])} not in TG or the module")
                    self.note_unparsed(fork, var, value, path)
                    continue
                put(name, self.map_path_value(fork, value, target, var))
            else:
                self.note_unparsed(fork, var, value, path)
                notes.append(f"{var} = {value[:40]}: not read")
        put("tunables", "list(" + ", ".join(f'"{t}"' for t in tunables) + ")")
        put("spell_forks", '"' + ", ".join(FORK_TITLES[f] for f in row["forks"].split(",") if f in FORK_TITLES) + '"')
        put("spell_source_type", f'"{path}"')
        row["_lines"] = lines
        row["_tunables"] = tunables
        row["_system"] = system
        row["_own_procs"] = sorted(code.own_procs(path, stop))

    def flag_names(self, code, raw):
        return [p.strip() for p in re.split(r"[|()]", raw) if p.strip()]

    def idents(self, raw):
        """Names in a value outside strings, file references and type paths (defines it needs)."""
        bare = re.sub(r'"(?:[^"\\]|\\.)*"|\'[^\']*\'', '""', raw)
        bare = PATH.sub("", bare)
        return [i for i in IDENT.findall(bare) if i not in DM_WORDS and not i[0].isdigit()]

    def classify(self, code, raw):
        """What a source value is: bool, null, text, file, path, list, number (a balance number: digits and times, or
        defines the module lacks that come out a plain number), define (names the module has), unknown."""
        raw = raw.strip()
        if raw in ("TRUE", "FALSE"):
            return "bool", raw
        if raw == "null":
            return "null", raw
        if raw.startswith('"'):
            return ("text" if TEXT.fullmatch(raw) else "unknown"), raw
        if raw.startswith("'"):
            return "file", raw
        if PATH.fullmatch(raw):
            return "path", raw
        if raw.startswith("list("):
            return "list", raw
        names = [i for i in self.idents(raw) if i not in TIME_UNITS]
        missing = [i for i in names if i not in self.module.defines]
        if names and not missing:
            return "define", raw
        expanded = code.expand(raw).strip()
        while expanded.startswith("(") and expanded.endswith(")") and paren_balance(expanded[1:-1]) == 0:
            expanded = expanded[1:-1].strip()
        # A define the module lacks that stands for a text (GLOW_COLOR_ARCANE): the text itself.
        if TEXT.fullmatch(expanded):
            return "text", expanded
        if re.search(r"<<|\||&", expanded):
            return "unknown", raw
        return ("number" if code.number(raw) is not None else "unknown"), raw

    def parent_vars(self, prim):
        """Vars the module's parent will have: the base (module and TG), the primitive (the module's, or Vibelin's when
        the primitive is not written yet: the contract copies Vibelin's)."""
        if prim in self.parent_cache:
            return self.parent_cache[prim]
        mod = self.module.code
        out = mod.declared_vars(ROGUE)
        if prim:
            here = f"{ROGUE}/{prim}"
            if here in mod.types:
                out = out | mod.declared_vars(here, stop=ROGUE)
            elif prim in VIBELIN_PRIMITIVES:
                out = out | self.forks["Vibelin"].declared_vars(VIBELIN_PRIMITIVES[prim], stop=NEW_BASE)
        self.parent_cache[prim] = out
        return out

    # ---- the run

    def run(self, lists, dry_run, work, key, agents, wave):
        rows = []
        dropped, scoped = [], []
        for row in self.rows:
            if row["key"] in DROP:
                dropped.append({"agent": row["agent"], "key": row["key"], "name": row["name"], "type": row["owner_type"],
                                "why": DROP[row["key"]]})
                continue
            if any(rx.search(row["owner_type"]) for rx, _ in PRIMITIVE_PATHS):
                dropped.append({"agent": row["agent"], "key": row["key"], "name": row["name"], "type": row["owner_type"],
                                "why": "the base of a primitive, not a spell (its children are the spells)"})
                continue
            row["_scope"] = OTHER_SCOPE.get(row["key"], "")
            if row["category"] == "other" and not row["_scope"]:
                row["_scope"] = "other: to be sorted"
            rows.append(row)
        self.assign_targets(rows)
        for row in rows:
            fork, path = row["owner"], row["owner_type"]
            sv = self.prim_rows.get(path + "@" + fork, {})
            row["_kind"] = sv.get("kind", "")
            row["_v0_prim"] = sv.get("primitive", "")
            if not row["_target"]:
                row.setdefault("_notes", []).append("no primitive found in the source chain")
                continue
            if path not in self.forks[fork].types:
                row.setdefault("_notes", []).append("source type not found in what the fork compiles")
                row["_target"] = ""
                continue
            if row.get("_in_module"):
                row.setdefault("_notes", []).append("already in the module")
            self.port_spell(row)
            n = len(row["_own_procs"])
            row["_kind"] = row["_kind"] or ("data" if n == 0 else ("light" if n <= 2 else "code"))
            if row["_prim"] == "song" or (row["_prim"] and row["_prim"] not in CONTRACT):
                row["_notes"].append(f"parent rogue/{row['_prim']} is outside the V0 contract")
            row["_wave"] = 1 if (row["key"] in AWAITED or (row["_kind"] in ("data", "light") and row["_prim"] in WAVE1_PRIMITIVES)) else 2
        # A spell of wave 1 needs its ported parent in wave 1 too (the child carries only what differs from it).
        by_target = {r["_target"]: r for r in rows if r.get("_wave")}
        changed = True
        while changed:
            changed = False
            for row in by_target.values():
                parent = by_target.get(row.get("_ported_parent", ""))
                if parent and parent["_wave"] > row["_wave"]:
                    parent["_wave"] = row["_wave"]
                    parent.setdefault("_notes", []).append("wave 1: a spell of wave 1 is under it")
                    changed = True
        self.assign_steps([r for r in rows if not r.get("_in_module") and r.get("_wave")])
        picked = [r for r in rows if (not agents or r["agent"] in agents) and (not wave or r.get("_wave") == wave)]
        self.report(rows, picked, dropped, lists or DEFAULT_LISTS, dry_run)
        if not dry_run:
            self.write(picked, work, key)

    # ---- output

    def type_block(self, row):
        out = [row["_target"]]
        for var, value in row["_lines"]:
            out.append(f"\t{var}" if value is None else f"\t{var} = {value}")
        return "\n".join(out)

    def abstract_steps(self, targets):
        steps = set()
        roots = {ROGUE} | {f"{ROGUE}/{p}" for p in CONTRACT} | {f"{ROGUE}/song"}
        for t in targets:
            step = t
            while True:
                step = step.rsplit("/", 1)[0]
                if step in roots or not step.startswith(ROGUE + "/") or step in targets or self.module.has_type(step):
                    break
                steps.add(step)
        return steps

    def assign_steps(self, rows):
        """Path steps between a primitive and the ported spells that no spell fills: abstract families, each written
        once, in the file of the first agent and wave (by name) with a spell under it."""
        targets = {r["_target"] for r in rows if r.get("_target")}
        self.step_owner = {}
        for step in sorted(self.abstract_steps(targets)):
            units = sorted({unit(r) for r in rows if r.get("_target", "").startswith(step + "/")})
            self.step_owner[step] = units[0]

    def dm_text(self, rows, title):
        targets = {r["_target"] for r in rows}
        blocks = []
        for step, agent in sorted(self.step_owner.items()):
            if agent == title:
                blocks.append(f"{step}\n\tabstract_spell_type = {step}")
        for row in sorted(rows, key=lambda r: r["_target"]):
            if row.get("_own_procs"):
                blocks.append(f"// {row['name']}: by hand: {' '.join(row['_own_procs'])}")
            blocks.append(self.type_block(row))
        # A bolt several files' spells fire is written once, by the first of them (by name).
        unit_of = {r["_target"]: unit(r) for r in self.rows if r.get("_target") and r.get("_wave")}
        projs = sorted(t for t, b in self.projectile_blocks.items()
                       if b["spells"] & targets and min(unit_of.get(s, "~") for s in b["spells"]) == title)
        for t in projs:
            b = self.projectile_blocks[t]
            head = [f"// {b['source']} ({FORK_TITLES[b['fork']]})" + (f"; by hand: {' '.join(b['own_procs'])}" if b["own_procs"] else "")]
            body = [t] + [f"\t{var} = {value}" for var, value in b["lines"]]
            blocks.append("\n".join(head + body))
        header = [f"// Written by modular_redtard/tools/port_spells.py ({title}); do not edit by hand.",
                  "// Numbers live in the private mechanics/values/magic_spells.txt (spell_<type>_<tunable>, read by tune()).", ""]
        return "\n".join(header) + "\n" + "\n\n".join(blocks) + "\n"

    def numbers_text(self, rows):
        out = ["# Spells of the basket (magic/spells/, blocks VM3 and VM4): spell_<type>_<tunable>, written by tools/port_spells.py.", ""]
        for row in sorted(rows, key=lambda r: r["_target"]):
            src = f"{FORK_TITLES[row['owner']]} {row['owner_type']}"
            for tun, value in row["_tunables"].items():
                out.append(f"# {row['name']}: {describe(tun)} ({src}).")
                out.append(f"{rogue_key(row['_target'])}_{tun} = {fmt_number(value)}")
                out.append("")
            for name, value in row.get("_extra_numbers", {}).items():
                out.append(f"# {row['name']}: experience modifier of its own ({src}).")
                out.append(f"{name} = {fmt_number(value)}")
                out.append("")
        return "\n".join(out)

    def report(self, rows, picked, dropped, lists, dry_run):
        os.makedirs(lists, exist_ok=True)
        cols = ["agent", "wave", "kind", "key", "name", "owner", "system", "category", "scope", "primitive", "v0_primitive",
                "target", "source_type", "own_procs", "tunables", "notes"]
        all_rows = []
        for r in rows:
            all_rows.append({
                "agent": r["agent"], "wave": r.get("_wave", ""), "kind": r.get("_kind", ""), "key": r["key"],
                "name": r["name"], "owner": r["owner"], "system": r.get("_system", r["owner_system"]),
                "category": r["category"], "scope": r.get("_scope", ""),
                "primitive": "" if r.get("_prim") is None else ("rogue" if r["_prim"] == "" else "rogue/" + r["_prim"]),
                "v0_primitive": r.get("_v0_prim", ""), "target": r.get("_target", ""), "source_type": r["owner_type"],
                "own_procs": " ".join(r.get("_own_procs", [])), "tunables": len(r.get("_tunables", {})),
                "notes": "; ".join(r.get("_notes", []))})
        write_tsv(os.path.join(lists, "vm1g_spells.tsv"), cols, all_rows)
        by_agent = collections.defaultdict(list)
        for r in all_rows:
            by_agent[r["agent"]].append(r)
        for agent, items in by_agent.items():
            write_tsv(os.path.join(lists, f"vm1g_{agent}.tsv"), cols,
                      sorted(items, key=lambda r: (str(r["wave"]), r["kind"], r["primitive"], r["key"])))
        write_tsv(os.path.join(lists, "vm1g_dropped.tsv"), ["agent", "key", "name", "type", "why"], dropped)
        unparsed = [{"fork": f, "var": v, "types": n, "example": self.unparsed_example[(f, v)][0][:120],
                     "example_type": self.unparsed_example[(f, v)][1]} for (f, v), n in self.unparsed.most_common()]
        write_tsv(os.path.join(lists, "vm1g_unparsed_vars.tsv"), ["fork", "var", "types", "example", "example_type"], unparsed)
        known = [{"fork": f, "var": v, "types": n, "why": KNOWN_DROPPED.get(v, "a colour the module cannot read"),
                  "example": self.dropped_example[(f, v)][0][:120], "example_type": self.dropped_example[(f, v)][1]}
                 for (f, v), n in self.dropped_vars.most_common()]
        write_tsv(os.path.join(lists, "vm1g_dropped_vars.tsv"), ["fork", "var", "types", "why", "example", "example_type"], known)
        summary = collections.Counter((r["agent"], r["wave"], r["kind"]) for r in all_rows if r["target"])
        write_tsv(os.path.join(lists, "vm1g_summary.tsv"), ["agent", "wave", "data", "light", "code", "total"],
                  [{"agent": a, "wave": w, "data": summary[(a, w, "data")], "light": summary[(a, w, "light")],
                    "code": summary[(a, w, "code")], "total": sum(summary[(a, w, k)] for k in ("data", "light", "code"))}
                   for a in sorted(by_agent) for w in (1, 2)])
        assets = sorted(self.assets.values(), key=lambda a: (a["kind"], a["module"] != "", a["fork"], a["source"]))
        write_tsv(os.path.join(lists, "vm1g_assets.tsv"), ["kind", "fork", "source", "state", "exists", "match", "module", "copy_to", "uses"], assets)
        linked = [dict(v, spells=len(v["spells"])) for v in sorted(self.linked.values(), key=lambda v: (v["in_module"], v["kind"], v["path"]))]
        write_tsv(os.path.join(lists, "vm1g_linked_types.tsv"), ["fork", "path", "kind", "wants", "in_module", "in_source", "own_procs", "spells"], linked)
        projs = [{"target": t, "fork": b["fork"], "source": b["source"], "own_procs": " ".join(b["own_procs"]),
                  "unknown_vars": " ".join(b["unknown"]), "damage": b["numbers"].get("damage"), "speed": b["numbers"].get("speed"),
                  "spells": len(b["spells"])} for t, b in sorted(self.projectile_blocks.items())]
        write_tsv(os.path.join(lists, "vm1g_projectiles.tsv"), ["target", "fork", "source", "own_procs", "unknown_vars", "damage", "speed", "spells"], projs)
        ok = [r for r in picked if r.get("_target") and not r.get("_in_module")]
        preview = os.path.join(lists, "preview")
        os.makedirs(preview, exist_ok=True)
        for name in sorted({unit(r) for r in ok}):
            mine = [r for r in ok if unit(r) == name]
            with open(os.path.join(preview, f"{name}.dm"), "w", encoding="utf-8", newline="\n") as handle:
                handle.write(self.dm_text(mine, name))
        with open(os.path.join(preview, NUMBERS_FILE), "w", encoding="utf-8", newline="\n") as handle:
            handle.write(self.numbers_text(ok))
        # Summary.
        table = collections.Counter((r["agent"], r["wave"], r["kind"]) for r in all_rows if r["target"])
        print("agent\twave\tdata\tlight\tcode\ttotal")
        for agent in sorted(by_agent):
            for w in (1, 2):
                d, l, c = (table[(agent, w, k)] for k in ("data", "light", "code"))
                print(f"{agent}\t{w}\t{d}\t{l}\t{c}\t{d + l + c}")
        prim = collections.Counter(r["primitive"] for r in all_rows)
        print("primitives:", dict(prim.most_common()))
        print(f"spells {len(rows)} (+{len(dropped)} dropped), no target {sum(1 for r in all_rows if not r['target'])}, "
              f"in module {sum(1 for r in rows if r.get('_in_module'))}, projectiles {len(self.projectile_blocks)}, "
              f"linked types {len(self.linked)} ({sum(1 for v in self.linked.values() if not v['in_module'])} missing), "
              f"assets {len(self.assets)} ({sum(1 for a in self.assets.values() if not a['module'])} to copy), "
              f"unparsed vars {len(self.unparsed)}, numbers {sum(len(r['_tunables']) for r in ok)}")
        for what, times in self.notes.most_common():
            print(f"  note ({times}): {what}")
        print(f"lists -> {lists}{' (dry run: nothing written into the module or staged/)' if dry_run else ''}")

    def write(self, picked, work, key):
        if not work or not key:
            sys.exit("a real run needs --work (the block's folder) and --key (the task's key)")
        ok = [r for r in picked if r.get("_target") and not r.get("_in_module")]
        os.makedirs(PORTED_DIR, exist_ok=True)
        for name in sorted({unit(r) for r in ok}):
            mine = [r for r in ok if unit(r) == name]
            with open(os.path.join(PORTED_DIR, f"{name}.dm"), "w", encoding="utf-8", newline="\n") as handle:
                handle.write(self.dm_text(mine, name))
        staged = os.path.join(work, "staged", key)
        os.makedirs(staged, exist_ok=True)
        with open(os.path.join(staged, NUMBERS_FILE), "w", encoding="utf-8", newline="\n") as handle:
            handle.write(self.numbers_text(ok))
        print(f"written: {PORTED_DIR}, {staged}")


DESCRIPTIONS = {
    "cost": "price in mana (or stamina)", "cooldown": "cooldown", "charge": "charge time", "slowdown": "slowdown while charging",
    "range": "reach in tiles", "damage": "damage of its bolt", "tile_time": "deciseconds a tile of its bolt",
    "charge_drain": "mana a second while charging", "hold_drain": "mana a second while held charged",
    "hold_grace": "hold without drain", "hold_max": "hold before it tears", "cancel_penalty": "cancel penalty multiplier",
    "recovery_time": "time exposed after the cast", "required_level": "form rank the spellbook asks",
}


def unit(row):
    """The file a spell goes to: its agent and wave (b49a_vibelin_w1), so a later wave never rewrites an earlier one."""
    return f"{row['agent']}_w{row['_wave']}"


def describe(tunable):
    return DESCRIPTIONS.get(tunable, tunable.replace("_", " "))


def rogue_key(target):
    return "spell_" + target[len(ROGUE) + 1:].replace("/", "_")


def write_tsv(path, cols, rows):
    with open(path, "w", encoding="utf-8", newline="") as handle:
        w = csv.DictWriter(handle, fieldnames=cols, delimiter="\t", lineterminator="\n", extrasaction="ignore")
        w.writeheader()
        for r in rows:
            w.writerow({k: ("" if r.get(k) is None else r.get(k)) for k in cols})


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--dry-run", action="store_true", help="lists and preview only: nothing into the module or staged/")
    parser.add_argument("--lists", help="folder for the lists and the preview (default: the work folder of block VM1)")
    parser.add_argument("--work", help="the block's work folder (a real run writes staged/<key>/magic_spells.txt there)")
    parser.add_argument("--key", help="the task's key for staged/")
    parser.add_argument("--agent", action="append", help="only this agent's list (b49a_vibelin, b49b_azure, b49v_ratwood, b49g_ta)")
    parser.add_argument("--wave", type=int, choices=(1, 2), help="only this wave")
    args = parser.parse_args()
    SpellPorter().run(args.lists, args.dry_run, args.work, args.key, set(args.agent or []), args.wave)


if __name__ == "__main__":
    main()
