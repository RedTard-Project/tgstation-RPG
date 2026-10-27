// Vibelin's chat translation (tgui-panel/localization/types.ts): the dictionary the server builds from
// modular_redtard/localization/strings (dictionary.dm) and the cases of character names.
export type Lang = 'ru' | 'en';

export type Cases = {
  nom?: string;
  gen?: string;
  dat?: string;
  acc?: string;
  ins?: string;
  pre?: string;
};

export type CaseKey = keyof Cases;

export type RawPattern = {
  re: string;
  ru: string;
};

export type Dictionary = {
  version: number;
  nouns: Record<string, Cases>;
  /** Titles glued onto a name ("Lady Herald Ivan"): the only words a captured name may be split on. */
  honorifics?: Record<string, Cases>;
  fragments: Record<string, string>;
  patterns: RawPattern[];
};

export type CompiledPattern = {
  re: RegExp;
  ru: string;
};
