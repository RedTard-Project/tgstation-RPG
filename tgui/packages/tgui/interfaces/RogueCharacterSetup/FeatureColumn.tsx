// TG's column of main features beside the character (PreferencesMenu/CharacterPreferences/MainPage.tsx: MainFeature and
// ChoicedSelection): one icon button per pickable feature (underwear, hair, ears...) showing its current choice, which
// opens a floating grid to the right with the feature's colour, as on TG. TG's components are private to its page, so
// this is the menu's own, on its IconGrid.
import { useBackend } from 'tgui/backend';
import { Box, Button, Floating, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { features } from '../PreferencesMenu/preferences/features';
import { FeatureValueInput } from '../PreferencesMenu/preferences/features/base';
import { IconGrid } from './components';
import { featureName, type MainFeatureCatalog } from './features';
import { useTr } from './strings';
import type { SetupData } from './types';

const CELL_SIZE = 48;

export type MainFeature = {
  key: string;
  value: string;
  catalog: MainFeatureCatalog & { icons: Record<string, string> };
};

/** The preferences of a group that TG draws icons for, in their order. */
export function mainFeatures(
  values: Record<string, unknown>,
  catalog: Record<string, unknown>,
): MainFeature[] {
  const result: MainFeature[] = [];
  for (const [key, value] of Object.entries(values)) {
    const entry = catalog[key] as MainFeatureCatalog | undefined;
    if (entry?.icons) {
      result.push({
        key,
        value: String(value),
        catalog: entry as MainFeature['catalog'],
      });
    }
  }
  return result;
}

/** Underwear first, then the body features, as TG's column lists them. */
export function useMainFeatures(): MainFeature[] {
  const { data } = useBackend<SetupData>();
  const prefs = data.character_preferences;
  return [
    ...mainFeatures(prefs.clothing ?? {}, data.features),
    ...mainFeatures(prefs.features ?? {}, data.features),
  ];
}

export function FeatureColumn() {
  const { data } = useBackend<SetupData>();
  const shown = useMainFeatures();
  if (!shown.length) {
    return null;
  }
  const supplemental = data.character_preferences.supplemental_features ?? {};
  return (
    <Section fill>
      <Stack vertical wrap fill>
        {shown.map((feature) => (
          <Stack.Item key={feature.key}>
            <FeatureButton feature={feature} supplemental={supplemental} />
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
}

type FeatureProps = {
  feature: MainFeature;
  supplemental: Record<string, unknown>;
};

function FeatureButton(props: FeatureProps) {
  const { feature, supplemental } = props;
  const { data } = useBackend<SetupData>();
  const tr = useTr();
  return (
    <Floating
      stopChildPropagation
      placement="right-start"
      content={<FeatureChooser feature={feature} supplemental={supplemental} />}
    >
      <Button
        tooltip={featureName(feature.key, data.features, tr)}
        tooltipPosition="bottom"
        style={{
          width: `${CELL_SIZE}px`,
          height: `${CELL_SIZE}px`,
          padding: 0,
        }}
      >
        <Box
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            height: `${CELL_SIZE}px`,
          }}
        >
          <Box
            className={classes([
              'preferences32x32',
              feature.catalog.icons[feature.value],
            ])}
            style={{ transform: 'scale(1.3)', imageRendering: 'pixelated' }}
          />
        </Box>
      </Button>
    </Floating>
  );
}

/** The floating grid of one feature, its colour in the title bar (TG's ChoicedSelection). */
function FeatureChooser(props: FeatureProps) {
  const { feature, supplemental } = props;
  const { data } = useBackend<SetupData>();
  const tr = useTr();
  const colorKey = feature.catalog.supplemental_feature;
  const colorFeature = colorKey ? features[colorKey] : undefined;

  return (
    <Box
      className="ChoicedSelection"
      style={{ width: '480px', height: '440px' }}
    >
      <Section
        fill
        scrollable
        title={featureName(feature.key, data.features, tr)}
        buttons={
          colorKey &&
          colorFeature &&
          colorKey in supplemental && (
            <Stack align="center">
              <Stack.Item>
                <Box color="label">{tr(colorFeature.name)}</Box>
              </Stack.Item>
              <Stack.Item>
                <FeatureValueInput
                  shrink
                  feature={colorFeature}
                  featureId={colorKey}
                  value={supplemental[colorKey]}
                />
              </Stack.Item>
            </Stack>
          )
        }
      >
        <IconGrid
          featureKey={feature.key}
          icons={feature.catalog.icons}
          names={feature.catalog.display_names}
          selected={feature.value}
          searchText={tr('Search...')}
        />
      </Section>
    </Box>
  );
}
