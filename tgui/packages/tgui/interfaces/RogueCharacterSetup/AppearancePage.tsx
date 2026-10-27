// Vibelin's Appearance and Character Profile pages in one, laid out the way TG's menu shows a character: the pickable
// features (underwear, hair, ears...) are icon buttons beside the looking glass (FeatureColumn.tsx), each opening its
// grid, so this page keeps the rest of the look (eyes, gradients, body type, height...) as a list of TG's own editors,
// followed by the profile. Vibelin's taur body, intimacy features and preview backdrops have no counterpart here.
import { useBackend } from 'tgui/backend';
import { Box } from 'tgui-core/components';

import { Panel } from './components';
import { useMainFeatures } from './FeatureColumn';
import { FeatureList, type MainFeatureCatalog } from './features';
import { ProfilePage } from './ProfilePage';
import { useTr } from './strings';
import type { SetupData } from './types';

/** Shown on the Ancestry picker of the Identity page instead. */
const ANCESTRY_KEYS = ['skin_tone', 'feature_mcolor'];

export function AppearancePage() {
  const { data } = useBackend<SetupData>();
  const tr = useTr();
  const prefs = data.character_preferences;
  const shown = useMainFeatures();

  // Everything without a button of its own goes here: the secondary features, the supplemental ones no button
  // carries, and the features and clothing TG draws no icons for.
  const carried = new Set(
    shown
      .map((feature) => feature.catalog.supplemental_feature)
      .filter((key): key is string => !!key),
  );
  const details: Record<string, unknown> = {};
  for (const values of [
    prefs.secondary_features,
    prefs.features,
    prefs.clothing,
    prefs.supplemental_features,
  ]) {
    for (const [key, value] of Object.entries(values ?? {})) {
      const isMain = !!(data.features[key] as MainFeatureCatalog | undefined)
        ?.icons;
      if (isMain || carried.has(key) || ANCESTRY_KEYS.includes(key)) {
        continue;
      }
      details[key] = value;
    }
  }

  return (
    <>
      <Panel title={tr('Appearance')} icon="palette">
        {shown.length > 0 && (
          <Box color="label" mb={0.5}>
            {tr(
              'Hair, underwear and the rest of the look are on the buttons beside the looking glass.',
            )}
          </Box>
        )}
        <FeatureList values={details} />
      </Panel>
      <ProfilePage />
    </>
  );
}
