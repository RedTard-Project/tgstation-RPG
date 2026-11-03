// Vibelin's Identity page: name, pronouns and body, age, accent and standing, then the species, faith, ancestry, culture,
// homeland (Ratwood's origin) or food and drink picker. Pronouns are TG's gender and the body TG's body type (Vibelin
// keeps the body as its gender and the pronouns apart); Vibelin's dominant hand and quirks have no system here; the
// name declensions are on the profile page.
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  Input,
  NumberInput,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { features } from '../PreferencesMenu/preferences/features';
import { FeatureValueInput } from '../PreferencesMenu/preferences/features/base';
import { GENDERS, Gender } from '../PreferencesMenu/preferences/gender';
import { AccentField } from './accents';
import {
  display,
  FieldBlock,
  InfoRow,
  Panel,
  StatChips,
  swatchColor,
} from './components';
import { CulturePicker, FaithPicker, useHeritage } from './heritage';
import { HomelandPicker, useHomeland } from './homeland';
import { CulinaryPicker, usePalateShown } from './palate';
import { useTr } from './strings';
import type { AgeBand, SetupData, SpeciesEntry } from './types';

type PickerMode =
  | 'species'
  | 'faith'
  | 'ancestry'
  | 'culture'
  | 'homeland'
  | 'palate';

export function ageBand(bands: AgeBand[], age: number): AgeBand | undefined {
  let found: AgeBand | undefined;
  for (const band of bands) {
    if (age >= band.from) {
      found = band;
    }
  }
  return found;
}

export function IdentityPage() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const heritage = useHeritage();
  const homeland = useHomeland();
  const palateShown = usePalateShown();
  const prefs = data.character_preferences;
  const name = String(prefs.names?.real_name ?? '');
  const gender = String(prefs.misc?.gender ?? Gender.Male) as Gender;
  const speciesId = String(prefs.misc?.species ?? '');
  const species = data.species.find((entry) => entry.id === speciesId);
  const age = Number(prefs.non_contextual?.age ?? data.ages.min);
  // Vibelin's immortal races (an aasimar's only age) are not weakened by the years.
  const band: AgeBand | undefined = species?.ageless
    ? { name: tr('Immortal'), from: data.ages.min, stats: [] }
    : ageBand(data.ages.bands, age);
  const [mode, setMode] = useState<PickerMode>('species');
  const modes: { id: PickerMode; label: string; icon: string }[] = [
    { id: 'species', label: tr('Species'), icon: 'users' },
    ...(heritage.shown
      ? [{ id: 'faith' as const, label: tr('Faith'), icon: 'asterisk' }]
      : []),
    { id: 'ancestry', label: tr('Ancestry'), icon: 'leaf' },
    ...(heritage.shown
      ? [{ id: 'culture' as const, label: tr('Culture'), icon: 'landmark' }]
      : []),
    ...(homeland.shown
      ? [
          {
            id: 'homeland' as const,
            label: tr('Homeland'),
            icon: 'map-marked-alt',
          },
        ]
      : []),
    ...(palateShown
      ? [{ id: 'palate' as const, label: tr('Food & Drink'), icon: 'utensils' }]
      : []),
  ];
  const shownMode = modes.some((entry) => entry.id === mode) ? mode : 'species';

  const setName = (value: string) => {
    if (value.trim() && value !== name) {
      act('set_preference', { preference: 'real_name', value });
    }
  };

  return (
    <>
      <Stack>
        <Stack.Item grow basis={0}>
          <Panel title={tr('Identity')} icon="id-card">
            <FieldBlock label={tr('Name')}>
              <Stack>
                <Stack.Item grow>
                  <Input
                    fluid
                    value={name}
                    onBlur={setName}
                    onEnter={setName}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="dice"
                    tooltip={tr('Random name')}
                    onClick={() => act('randomize_name')}
                  />
                </Stack.Item>
              </Stack>
            </FieldBlock>
            {(!species || !!species.sexes) && (
              <FieldBlock label={tr('Pronouns')}>
                {[Gender.Male, Gender.Female, Gender.Other, Gender.Other2].map(
                  (option) => (
                    <Button
                      key={option}
                      icon={GENDERS[option].icon}
                      selected={option === gender}
                      tooltip={GENDERS[option].text}
                      onClick={() =>
                        act('set_preference', {
                          preference: 'gender',
                          value: option,
                        })
                      }
                    >
                      {GENDERS[option].text}
                    </Button>
                  ),
                )}
              </FieldBlock>
            )}
            {'body_type' in (prefs.secondary_features ?? {}) &&
              !!features.body_type && (
                <FieldBlock label={tr('Body type')}>
                  <FeatureValueInput
                    feature={features.body_type}
                    featureId="body_type"
                    value={prefs.secondary_features?.body_type}
                  />
                </FieldBlock>
              )}
            <FieldBlock label={tr('Age')}>
              <Tooltip
                content={
                  band
                    ? tr(
                        '{0} from {1}: {2}',
                        band.name,
                        band.from,
                        band.stats
                          .map(
                            (stat) =>
                              `${stat.label} ${stat.value > 0 ? '+' : ''}${stat.value}`,
                          )
                          .join(', ') || tr('no stat modifiers'),
                      )
                    : ''
                }
                position="bottom"
              >
                <Stack align="center">
                  <Stack.Item>
                    <NumberInput
                      value={age}
                      minValue={data.ages.min}
                      maxValue={data.ages.max}
                      step={1}
                      width="60px"
                      onChange={(value) =>
                        act('set_preference', { preference: 'age', value })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Box color="label">{band?.name ?? ''}</Box>
                  </Stack.Item>
                </Stack>
              </Tooltip>
            </FieldBlock>
            <AccentField />
            <Box>
              {modes.map((entry) => (
                <Button
                  key={entry.id}
                  compact
                  icon={entry.icon}
                  selected={shownMode === entry.id}
                  onClick={() => setMode(entry.id)}
                >
                  {entry.label}
                </Button>
              ))}
            </Box>
          </Panel>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Panel title={tr('Standing')} icon="sun">
            <InfoRow
              icon="award"
              label={tr('Player Quality')}
              value={`${data.pq_rank} (${data.pq})`}
              valueColor={data.pq_color || undefined}
            />
            <InfoRow
              icon="trophy"
              label={tr('Triumphs')}
              value={data.triumphs}
            />
            {heritage.shown && (
              <>
                <InfoRow
                  icon="asterisk"
                  label={tr('Faith')}
                  value={display(heritage.faith?.name, tr('None'))}
                />
                <InfoRow
                  icon="sun"
                  label={tr('Patron')}
                  value={display(heritage.patron?.name, tr('None'))}
                />
                <InfoRow
                  icon="landmark"
                  label={tr('Culture')}
                  value={display(heritage.culture?.name, tr('None'))}
                />
              </>
            )}
            {homeland.shown && (
              <InfoRow
                icon="map-marked-alt"
                label={tr('Homeland')}
                value={display(homeland.homeland?.name, tr('None'))}
              />
            )}
            {!!band && (
              <FieldBlock label={tr('Age: {0}', band.name)}>
                <StatChips stats={band.stats} empty={tr('No age modifiers.')} />
              </FieldBlock>
            )}
          </Panel>
        </Stack.Item>
      </Stack>
      {shownMode === 'species' && <SpeciesPicker currentId={speciesId} />}
      {shownMode === 'faith' && <FaithPicker />}
      {shownMode === 'ancestry' && <AncestryPicker species={species} />}
      {shownMode === 'culture' && <CulturePicker />}
      {shownMode === 'homeland' && <HomelandPicker />}
      {shownMode === 'palate' && <CulinaryPicker />}
    </>
  );
}

type SpeciesFilter = 'all' | 'medieval' | 'other';

/** Vibelin's species picker: a searchable list, and the inspected species with its stats, perks and lore. */
function SpeciesPicker(props: { currentId: string }) {
  const { currentId } = props;
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState<SpeciesFilter>('all');
  const [inspectedId, setInspectedId] = useState<string | null>(null);

  const needle = search.trim().toLowerCase();
  const shown = data.species
    .filter((entry) => {
      if (filter === 'medieval' && !entry.medieval) {
        return false;
      }
      if (filter === 'other' && entry.medieval) {
        return false;
      }
      return !needle || entry.name.toLowerCase().includes(needle);
    })
    .sort((left, right) => left.name.localeCompare(right.name));
  const inspected =
    data.species.find((entry) => entry.id === (inspectedId ?? currentId)) ??
    data.species[0];

  return (
    <Panel title={tr('Choose Species')} icon="users">
      <Stack>
        <Stack.Item basis="230px">
          <Input
            fluid
            placeholder={tr('Search species...')}
            value={search}
            onChange={setSearch}
          />
          <Box mt={0.5} mb={0.75}>
            <Button
              icon="list"
              selected={filter === 'all'}
              onClick={() => setFilter('all')}
            >
              {tr('All')}
            </Button>
            <Button
              icon="chess-rook"
              selected={filter === 'medieval'}
              tooltip={tr("Ratwood's races")}
              onClick={() => setFilter('medieval')}
            >
              {tr('Medieval')}
            </Button>
            <Button
              icon="globe"
              selected={filter === 'other'}
              onClick={() => setFilter('other')}
            >
              {tr('Other')}
            </Button>
          </Box>
          <Box style={{ maxHeight: '360px', overflowY: 'auto' }}>
            {shown.length ? (
              shown.map((entry) => (
                <Button
                  key={entry.id}
                  fluid
                  mb={0.5}
                  selected={entry.id === inspected?.id}
                  onClick={() => setInspectedId(entry.id)}
                  style={{ minHeight: '40px', padding: '4px 6px' }}
                >
                  <Stack align="center">
                    <Stack.Item>
                      <Icon
                        name={entry.id === currentId ? 'check-circle' : 'user'}
                        color={entry.id === currentId ? 'good' : undefined}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box bold textAlign="left">
                        {entry.name}
                      </Box>
                      <Box
                        color="label"
                        textAlign="left"
                        style={{ fontSize: '10px', lineHeight: '12px' }}
                      >
                        {entry.stats
                          .map(
                            (stat) =>
                              `${stat.label} ${stat.value > 0 ? '+' : ''}${stat.value}`,
                          )
                          .join(' / ') ||
                          (entry.medieval ? tr('Medieval') : '')}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Button>
              ))
            ) : (
              <Box color="label" py={2} textAlign="center">
                {tr('No species match.')}
              </Box>
            )}
          </Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          {inspected ? (
            <SpeciesDetails
              species={inspected}
              current={inspected.id === currentId}
              onApply={() =>
                act('set_preference', {
                  preference: 'species',
                  value: inspected.id,
                })
              }
            />
          ) : (
            <Box color="label">{tr('No species available.')}</Box>
          )}
        </Stack.Item>
      </Stack>
    </Panel>
  );
}

type SpeciesDetailsProps = {
  species: SpeciesEntry;
  current: boolean;
  onApply: () => void;
};

const PERK_COLORS = {
  positive: 'green',
  neutral: 'transparent',
  negative: 'bad',
} as const;

function SpeciesDetails(props: SpeciesDetailsProps) {
  const { species, current, onApply } = props;
  const tr = useTr();
  return (
    <Section
      fill
      title={
        // Inline, not a Stack: a block title takes the whole bar and pushes the buttons onto the line below.
        <>
          {species.name}
          {current && (
            <Box inline ml={1} color="good">
              {tr('Current')}
            </Box>
          )}
        </>
      }
      buttons={
        <Button
          icon="check"
          color={current ? undefined : 'green'}
          disabled={current}
          onClick={onApply}
        >
          {current ? tr('Current Species') : tr('Apply Species')}
        </Button>
      }
    >
      <Stack mb={1}>
        <Stack.Item>
          <Box
            className={classes(['species64x64', species.icon])}
            style={{ imageRendering: 'pixelated' }}
          />
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box
            style={{
              maxHeight: '110px',
              overflowY: 'auto',
              whiteSpace: 'pre-line',
            }}
          >
            {display(species.desc, tr('No description.'))}
          </Box>
        </Stack.Item>
      </Stack>
      <FieldBlock label={tr('Stat modifiers')}>
        <StatChips stats={species.stats} empty={tr('No stat modifiers.')} />
      </FieldBlock>
      <FieldBlock label={tr('Traits')}>
        <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
          {(['positive', 'neutral', 'negative'] as const).flatMap((kind) =>
            (species.perks[kind] ?? []).map((perk) => (
              <Button
                key={`${kind}-${perk.name}`}
                compact
                icon={perk.ui_icon}
                color={PERK_COLORS[kind]}
                tooltip={perk.description}
              >
                {perk.name}
              </Button>
            )),
          )}
        </Box>
      </FieldBlock>
      {!!species.lore?.length && (
        <FieldBlock label={tr('Lore')}>
          <Box style={{ maxHeight: '160px', overflowY: 'auto' }}>
            {species.lore.map((paragraph, index) => (
              <Box key={index} mb={0.5}>
                {paragraph}
              </Box>
            ))}
          </Box>
        </FieldBlock>
      )}
    </Section>
  );
}

type ToneCatalog = {
  choices: string[];
  display_names?: Record<string, string>;
  to_hex?: Record<string, { value: string; lightness: number }>;
};

/**
 * Vibelin's ancestry picker: the origins of one of Vibelin's races (its named skin colours, rogue_origin) and its hair
 * colours; for the other races what TG has, the skin tones of a species that uses them and the body colour of one with
 * mutant colours.
 */
function AncestryPicker(props: { species?: SpeciesEntry }) {
  const { species } = props;
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const prefs = data.character_preferences;
  const secondary = prefs.secondary_features ?? {};
  const tones = data.features.skin_tone as ToneCatalog | undefined;
  const origins = species?.origins ?? [];
  const hasOrigins =
    origins.length > 0 && 'rogue_origin' in (prefs.non_contextual ?? {});
  const origin = origins.some(
    (entry) => entry.name === prefs.non_contextual?.rogue_origin,
  )
    ? prefs.non_contextual?.rogue_origin
    : origins[0]?.name;
  const hasTone = 'skin_tone' in secondary && !!tones;
  const hasColor =
    !hasOrigins && 'feature_mcolor' in secondary && !!features.feature_mcolor;
  const hairColors = species?.hair_colors ?? [];
  const hair = String(prefs.supplemental_features?.hair_color ?? '');
  const hasHair =
    hairColors.length > 0 &&
    'hair_color' in (prefs.supplemental_features ?? {});

  return (
    <Panel title={tr('Choose Ancestry')} icon="leaf">
      {!hasOrigins && !hasTone && !hasColor && (
        <Box color="label">
          {tr(
            '{0} has no skin or colour to choose.',
            species?.name ?? tr('This species'),
          )}
        </Box>
      )}
      {hasOrigins && (
        <FieldBlock label={species?.origin_wording || tr('Ancestry')}>
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
            {origins.map((entry) => (
              <Swatch
                key={entry.name}
                label={entry.label || entry.name}
                color={entry.color}
                selected={entry.name === origin}
                onClick={() =>
                  act('set_preference', {
                    preference: 'rogue_origin',
                    value: entry.name,
                  })
                }
              />
            ))}
          </Box>
        </FieldBlock>
      )}
      {hasTone && (
        <FieldBlock label={tr('Skin tone')}>
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
            {tones.choices.map((tone) => (
              <Swatch
                key={tone}
                label={tones.display_names?.[tone] ?? tone}
                color={tones.to_hex?.[tone]?.value}
                selected={tone === secondary.skin_tone}
                onClick={() =>
                  act('set_preference', {
                    preference: 'skin_tone',
                    value: tone,
                  })
                }
              />
            ))}
          </Box>
        </FieldBlock>
      )}
      {hasColor && (
        <FieldBlock label={tr('Body colour')}>
          <FeatureValueInput
            feature={features.feature_mcolor}
            featureId="feature_mcolor"
            value={secondary.feature_mcolor}
          />
        </FieldBlock>
      )}
      {hasHair && (
        <FieldBlock label={tr('Hair color')}>
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
            {hairColors.map((entry) => (
              <Swatch
                key={entry.name}
                label={entry.name}
                color={entry.color}
                selected={
                  swatchColor(hair).toLowerCase() === entry.color.toLowerCase()
                }
                onClick={() =>
                  act('set_preference', {
                    preference: 'hair_color',
                    value: entry.color,
                  })
                }
              />
            ))}
          </Box>
        </FieldBlock>
      )}
    </Panel>
  );
}

type SwatchProps = {
  label: string;
  color: unknown;
  selected: boolean;
  onClick: () => void;
};

/** A colour to pick, with its name. */
function Swatch(props: SwatchProps) {
  const { label, color, selected, onClick } = props;
  return (
    <Button
      selected={selected}
      tooltip={label}
      onClick={onClick}
      style={{ minWidth: '126px', padding: '6px' }}
    >
      <Stack align="center">
        <Stack.Item>
          <Box
            width="28px"
            height="16px"
            style={{ border: '1px solid rgba(0,0,0,0.65)' }}
            backgroundColor={swatchColor(color)}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Box bold textAlign="left">
            {label}
          </Box>
        </Stack.Item>
      </Stack>
    </Button>
  );
}
