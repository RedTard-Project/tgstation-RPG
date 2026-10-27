// The character's name in Russian cases (modular_redtard/localization/declensions.dm, Vibelin's declensions): the
// chat translation declines names with them; a blank case keeps the name as it is.
import { type Feature, FeatureShortTextInput } from '../base';

type DeclensionFeature = Feature<string, string, { maximum_length: number }>;

function declension(name: string, description: string): DeclensionFeature {
  return { name, description, component: FeatureShortTextInput };
}

export const rogue_declension_genitive = declension(
  'Родительный падеж',
  'Кого? чего? Например: Ивана Петрова.',
);

export const rogue_declension_dative = declension(
  'Дательный падеж',
  'Кому? чему? Например: Ивану Петрову.',
);

export const rogue_declension_accusative = declension(
  'Винительный падеж',
  'Кого? что? Например: Ивана Петрова.',
);

export const rogue_declension_instrumental = declension(
  'Творительный падеж',
  'Кем? чем? Например: Иваном Петровым.',
);

export const rogue_declension_prepositional = declension(
  'Предложный падеж',
  'О ком? о чём? Например: Иване Петрове.',
);
