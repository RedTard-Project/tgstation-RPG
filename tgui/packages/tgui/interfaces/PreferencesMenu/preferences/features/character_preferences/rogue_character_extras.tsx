// The homeland, the favourite and hated food and drink and the combat music of a medieval character
// (modular_redtard/homelands, modular_redtard/charsetup: Ratwood's origins, culinary preferences and combat music). The
// medieval character menu has pickers of its own for them; here they are plain dropdowns for TG's own menu.
import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const rogue_homeland: FeatureChoiced = {
  name: 'Homeland',
  component: FeatureDropdownInput,
};

export const rogue_favourite_food: FeatureChoiced = {
  name: 'Favourite food',
  component: FeatureDropdownInput,
};

export const rogue_hated_food: FeatureChoiced = {
  name: 'Hated food',
  component: FeatureDropdownInput,
};

export const rogue_favourite_drink: FeatureChoiced = {
  name: 'Favourite drink',
  component: FeatureDropdownInput,
};

export const rogue_hated_drink: FeatureChoiced = {
  name: 'Hated drink',
  component: FeatureDropdownInput,
};

export const rogue_combat_music: FeatureChoiced = {
  name: 'Combat music',
  component: FeatureDropdownInput,
};
