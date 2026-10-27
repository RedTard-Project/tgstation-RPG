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

export type SettingsGroup = {
  title: string;
  keys: string[];
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
  settings: SettingsGroup[];
  max_slots: number;
  /** The medieval lobby's minimum lengths of the flavor text and OOC notes before readying up. */
  flavor_min: number;
  ooc_min: number;
  pq: number;
  pq_rank: string;
  pq_color: string | null;
  triumphs: number;

  // Dynamic: sent after each change.
  active_slot: number;
  profiles: (string | null)[];
  character_preferences: PreferenceValues;
  job_preferences: Partial<Record<string, JobPriority>>;
  job_clothes: BooleanLike;
  round: RoundState | null;
};
