// TG's preference editors inside the character menu. TG's feature components (PreferencesMenu/preferences/features,
// the module's rogue_character_notes.tsx among them) read their catalog from the ServerPrefs context, which TG's menu
// fills by fetching preferences.json. This menu fills it from its static data instead, so the same components work
// with no HTTP request, whatever the asset transport.
import { useBackend } from 'tgui/backend';
import { Box, Dropdown, LabeledList } from 'tgui-core/components';

import { features } from '../PreferencesMenu/preferences/features';
import {
  type FeatureChoicedServerData,
  FeatureValueInput,
} from '../PreferencesMenu/preferences/features/base';
import type { ServerData } from '../PreferencesMenu/types';
import { type Translate, useTr } from './strings';
import type { SetupData } from './types';

/** What TG's menu keeps in ServerPrefs besides the feature catalogs; nothing here reads it. */
const EMPTY_SERVER_DATA = {
  jobs: { departments: {}, jobs: {}, jobs_sorted: [] },
  names: { types: {} },
  quirks: {
    max_positive_quirks: -1,
    quirk_info: {},
    quirk_blacklist: [],
    points_enabled: false,
  },
  personality: { personalities: [], personality_incompatibilities: {} },
  random: { randomizable: [] },
  loadout: { loadout_tabs: [] },
  species: {},
};

/** The ServerPrefs value from the menu's static catalogs. */
export function buildServerData(catalog: Record<string, unknown>): ServerData {
  return { ...EMPTY_SERVER_DATA, ...catalog } as ServerData;
}

export type MainFeatureCatalog = FeatureChoicedServerData & {
  name?: string;
  supplemental_feature?: string;
};

/** The display name of a preference: TG's feature name, the catalog's, or its key, in the player's language. */
export function featureName(
  key: string,
  catalog: Record<string, unknown>,
  tr: Translate,
) {
  const entry = catalog[key] as MainFeatureCatalog | undefined;
  return tr(features[key]?.name ?? entry?.name ?? key);
}

type FeatureRowProps = {
  featureKey: string;
  value: unknown;
};

/** One preference as a labelled row, edited by TG's own component for it. */
export function FeatureRow(props: FeatureRowProps) {
  const { featureKey, value } = props;
  const { data } = useBackend<SetupData>();
  const tr = useTr();
  const feature = features[featureKey];
  return (
    <LabeledList.Item
      label={featureName(featureKey, data.features, tr)}
      tooltip={feature?.description}
      verticalAlign="middle"
    >
      {feature ? (
        <FeatureValueInput
          feature={feature}
          featureId={featureKey}
          value={value}
        />
      ) : (
        <FallbackInput featureKey={featureKey} value={value} />
      )}
    </LabeledList.Item>
  );
}

/** A preference TG has no component for: a dropdown of its choices, or its value. */
function FallbackInput(props: FeatureRowProps) {
  const { featureKey, value } = props;
  const { act, data } = useBackend<SetupData>();
  const entry = data.features[featureKey] as MainFeatureCatalog | undefined;
  if (!entry?.choices) {
    return <Box>{String(value ?? '')}</Box>;
  }
  return (
    <Dropdown
      width="100%"
      selected={String(value ?? '')}
      options={entry.choices.map((choice) => ({
        displayText: entry.display_names?.[choice] ?? choice,
        value: choice,
      }))}
      onSelected={(choice) =>
        act('set_preference', { preference: featureKey, value: choice })
      }
    />
  );
}

type FeatureListProps = {
  values: Record<string, unknown>;
  keys?: string[];
};

/** Several preferences as rows, sorted by name. */
export function FeatureList(props: FeatureListProps) {
  const { values } = props;
  const { data } = useBackend<SetupData>();
  const tr = useTr();
  const keys = (props.keys ?? Object.keys(values))
    .filter((key) => key in values)
    .sort((left, right) =>
      featureName(left, data.features, tr).localeCompare(
        featureName(right, data.features, tr),
      ),
    );
  if (!keys.length) {
    return <Box color="label">{tr('Nothing to set here.')}</Box>;
  }
  return (
    <LabeledList>
      {keys.map((key) => (
        <FeatureRow key={key} featureKey={key} value={values[key]} />
      ))}
    </LabeledList>
  );
}
