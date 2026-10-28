// Data of the character menu of medieval maps (modular_redtard/charsetup/): Vibelin's PreferencesMenu.types.ts cut
// down to what TG's preferences and the module have here.
import type { BooleanLike } from 'tgui-core/react';

export type StatChip = {
  name: string;
  label: string;
  value: number;
};

export type Perk = {
  ui_icon: string;
  name: string;
  description: string;
};

/** A named colour: one of a race's origins (skin) or hair colours (Vibelin's get_skin_list, get_hairc_list). */
export type NamedColor = {
  /** The origin's key, the value of the rogue_origin preference; for hair, its name. */
  name: string;
  /** The name in the player's language. */
  label?: string;
  color: string;
};

export type SpeciesEntry = {
  id: string;
  name: string;
  desc: string;
  lore: string[];
  /** Class of TG's species spritesheet (species64x64). */
  icon: string;
  sexes: BooleanLike;
  skin_tones: BooleanLike;
  mutant_colors: BooleanLike;
  /** One of Ratwood's races rather than a TG species. */
  medieval: BooleanLike;
  stats: StatChip[];
  perks: {
    positive: Perk[];
    negative: Perk[];
    neutral: Perk[];
  };
  /** Vibelin's races: the skin colours to pick from, in place of a free colour. */
  origins: NamedColor[];
  /** What the race calls its origin ("Ancestry", "Progenitor"...). */
  origin_wording: string | null;
  hair_colors: NamedColor[];
};

export type JobClass = {
  name: string;
  desc: string | null;
};

export type JobEntry = {
  title: string;
  description: string | null;
  slots: number;
  /** The subclasses a Rockhill role picks from when it spawns. */
  classes: JobClass[];
  /** Ratwood's least PQ to take the role; null for none. */
  min_pq: number | null;
};

export type Department = {
  name: string;
  color: string | null;
  order: number;
  jobs: JobEntry[];
};

export type AgeBand = {
  name: string;
  from: number;
  stats: StatChip[];
};

export type PatronEntry = {
  /** Type path, the value of the rogue_patron preference. */
  id: string;
  name: string;
  desc: string;
  domain: string | null;
  worshippers: string | null;
  flaws: string | null;
  sins: string | null;
  boons: string | null;
  /** Species ids that may worship it; empty is anyone. */
  races: string[];
};

export type FaithEntry = {
  /** Type path, the value of the rogue_faith preference. */
  id: string;
  name: string;
  desc: string;
  godhead: string;
  patrons: PatronEntry[];
};

export type CultureEntry = {
  /** Type path, the value of the rogue_culture preference. */
  id: string;
  name: string;
  desc: string;
  /** Species ids it belongs to; empty is a culture anyone may have. */
  races: string[];
};

/** Vibelin's faiths, patrons and cultures (modular_redtard/heritage), in the player's language. */
export type HeritageCatalog = {
  faiths: FaithEntry[];
  cultures: CultureEntry[];
};

export type HomelandTrait = {
  name: string;
  desc: string | null;
};

/** Ratwood's origins (modular_redtard/homelands), in the player's language. */
export type HomelandEntry = {
  /** Ratwood's name of the land, the value of the rogue_homeland preference. */
  id: string;
  name: string;
  desc: string;
  traits: HomelandTrait[];
  /** Whether people from elsewhere may resent it on sight. */
  prejudice: BooleanLike;
  /** Who resents it; empty with prejudice is everyone from elsewhere. */
  resented_by: string[];
};

/** A food or drink of Ratwood's culinary preferences (modular_redtard/charsetup/culinary.dm). */
export type CulinaryEntry = {
  /** Type path, the value of the culinary preferences. */
  id: string;
  name: string;
  /** Ratwood's fare of a food (1 desperate to 5 lavish) or quality of a drink (0 plain to 4 fantastic). */
  rank: number;
  /** Class of the rogue_culinary spritesheet, when the thing has a sprite. */
  icon: string | null;
};

export type CulinaryCatalog = {
  foods: CulinaryEntry[];
  drinks: CulinaryEntry[];
  /** The hated drink's "nothing". */
  none: string;
};

/** A track of the combat music (modular_redtard/combat/music.dm). */
export type CombatTrack = {
  name: string;
  desc: string | null;
  credits: string | null;
  /** Whether the server has the files, so it can be listened to. */
  playable: BooleanLike;
};

export type RoundPhase = 'pregame' | 'setting_up' | 'playing' | 'postgame';

export type RoundState = {
  phase: RoundPhase;
  /** Seconds to the start; -1 while the start is delayed. */
  seconds: number;
  ready: BooleanLike;
  ready_count: number;
  players: number;
  migrant: BooleanLike;
};

/** TG's character_preferences shape: category -> savefile key -> value. */
export type PreferenceValues = Partial<Record<string, Record<string, unknown>>>;

export enum JobPriority {
  Low = 1,
  Medium = 2,
  High = 3,
}

export type SetupData = {
  // Static: sent when the window opens.
  preview_view: string | null;
  species: SpeciesEntry[];
  /** TG's compile_constant_data of the shown preferences, by savefile key. */
  features: Record<string, unknown>;
  jobs: Department[];
  job_bans: string[];
  ages: {
    min: number;
    max: number;
    bands: AgeBand[];
  };
  max_slots: number;
  /** The medieval lobby's minimum lengths of the flavor text and OOC notes before readying up. */
  flavor_min: number;
  ooc_min: number;
  pq: number;
  pq_rank: string;
  pq_color: string | null;
  triumphs: number;
  heritage: HeritageCatalog;
  homelands: HomelandEntry[];
  culinary: CulinaryCatalog;
  combat_music: CombatTrack[];

  // Dynamic: sent after each change.
  /** The player's language (the rogue_ui_language preference). */
  lang: 'ru' | 'en';
  /** The character's species id as the heritage data knows it (a patron's or culture's races). */
  heritage_species: string;
  active_slot: number;
  profiles: (string | null)[];
  character_preferences: PreferenceValues;
  job_preferences: Partial<Record<string, JobPriority>>;
  job_clothes: BooleanLike;
  round: RoundState | null;
};
