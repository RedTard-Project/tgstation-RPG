// The language of the chat and the interface (modular_redtard/localization/language.dm, Vibelin's localization).
import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const rogue_ui_language: FeatureChoiced = {
  name: 'Language / Язык',
  category: 'UI',
  description:
    'Russian translates the chat and the game texts the server sends in English; English shows them as they are.',
  component: FeatureDropdownInput,
};
