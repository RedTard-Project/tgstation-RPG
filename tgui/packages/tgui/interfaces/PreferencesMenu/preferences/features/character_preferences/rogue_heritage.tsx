// The character's faith, patron, culture and origin on medieval maps (modular_redtard/heritage, Vibelin's
// preferences). The medieval character menu draws them as cards and swatches; here they are plain dropdowns for TG's own
// menu (type paths; the origin's name, which only one of Vibelin's races uses).
import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const rogue_faith: FeatureChoiced = {
  name: 'Faith',
  component: FeatureDropdownInput,
};

export const rogue_patron: FeatureChoiced = {
  name: 'Patron',
  component: FeatureDropdownInput,
};

export const rogue_culture: FeatureChoiced = {
  name: 'Culture',
  component: FeatureDropdownInput,
};

export const rogue_origin: FeatureChoiced = {
  name: 'Origin',
  component: FeatureDropdownInput,
};
