// Vibelin's Appearance page on TG's features: a tab per pickable feature with a thumbnail grid (TG's preferences
// spritesheet in place of Vibelin's chargen sheet), its colour beside it, the underwear together in one tab, and the
// rest (eyes, gradients, body type, height...) as a list of TG's own editors. Vibelin's taur body, intimacy features
// and preview backdrops have no counterpart here.
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import { features } from '../PreferencesMenu/preferences/features';
import { FeatureValueInput } from '../PreferencesMenu/preferences/features/base';
import { IconGrid, Panel } from './components';
import { FeatureList, featureName, type MainFeatureCatalog } from './features';
import type { SetupData } from './types';

const UNDERWEAR_TAB = '__underwear__';
const DETAILS_TAB = '__details__';
/** Shown on the Ancestry picker of the Identity page instead. */
const ANCESTRY_KEYS = ['skin_tone', 'feature_mcolor'];

type MainFeature = {
  key: string;
  value: string;
  catalog: MainFeatureCatalog & { icons: Record<string, string> };
};

function mainFeatures(
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

export function AppearancePage() {
  const { data } = useBackend<SetupData>();
  const prefs = data.character_preferences;
  const supplemental = prefs.supplemental_features ?? {};
  const clothing = mainFeatures(prefs.clothing ?? {}, data.features);
  const body = mainFeatures(prefs.features ?? {}, data.features);
  const [activeTab, setActiveTab] = useState<string>(UNDERWEAR_TAB);

  // Everything without a grid of its own goes to Details: the secondary features, the supplemental ones no shown
  // feature carries, and the features and clothing TG draws no icons for.
  const carried = new Set(
    [...clothing, ...body]
      .map((feature) => feature.catalog.supplemental_feature)
      .filter((key): key is string => !!key),
  );
  const details: Record<string, unknown> = {};
  for (const values of [
    prefs.secondary_features,
    prefs.features,
    prefs.clothing,
    supplemental,
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

  const tabs = [
    ...(clothing.length ? [{ key: UNDERWEAR_TAB, name: 'Underwear' }] : []),
    ...body.map((feature) => ({
      key: feature.key,
      name: featureName(feature.key, data.features),
    })),
    { key: DETAILS_TAB, name: 'Details' },
  ];
  const current = tabs.some((tab) => tab.key === activeTab)
    ? activeTab
    : tabs[0].key;

  let editor;
  if (current === UNDERWEAR_TAB) {
    editor = clothing.map((feature) => (
      <FeatureEditor
        key={feature.key}
        feature={feature}
        supplemental={supplemental}
      />
    ));
  } else if (current === DETAILS_TAB) {
    editor = <FeatureList values={details} />;
  } else {
    const feature = body.find((entry) => entry.key === current);
    editor = feature ? (
      <FeatureEditor feature={feature} supplemental={supplemental} />
    ) : null;
  }

  return (
    <Panel title="Appearance" icon="palette">
      <Box style={{ display: 'flex', flexWrap: 'wrap' }} mb={1}>
        {tabs.map((tab) => (
          <Button
            key={tab.key}
            mr={0.5}
            mb={0.5}
            selected={tab.key === current}
            onClick={() => setActiveTab(tab.key)}
          >
            {tab.name}
          </Button>
        ))}
      </Box>
      {editor}
    </Panel>
  );
}

type FeatureEditorProps = {
  feature: MainFeature;
  supplemental: Record<string, unknown>;
};

/** One pickable feature: its colour (the supplemental feature) and the grid of its styles. */
function FeatureEditor(props: FeatureEditorProps) {
  const { feature, supplemental } = props;
  const { data } = useBackend<SetupData>();
  const colorKey = feature.catalog.supplemental_feature;
  const colorFeature = colorKey ? features[colorKey] : undefined;

  return (
    <Section
      title={featureName(feature.key, data.features)}
      buttons={
        colorKey &&
        colorFeature &&
        colorKey in supplemental && (
          <Stack align="center">
            <Stack.Item>
              <Box color="label">{colorFeature.name}</Box>
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
      />
    </Section>
  );
}
