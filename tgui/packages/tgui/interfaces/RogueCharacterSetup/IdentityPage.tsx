// Vibelin's Identity page: name, body, age and standing, then the species or ancestry picker. Vibelin's faiths and
// patrons, pronouns, dominant hand, quirks and name declensions have no system here.
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
import {
  display,
  FieldBlock,
  InfoRow,
  Panel,
  StatChips,
  swatchColor,
} from './components';
import type { AgeBand, SetupData, SpeciesEntry } from './types';

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
  const prefs = data.character_preferences;
  const name = String(prefs.names?.real_name ?? '');
  const gender = String(prefs.misc?.gender ?? Gender.Male) as Gender;
  const speciesId = String(prefs.misc?.species ?? '');
  const species = data.species.find((entry) => entry.id === speciesId);
  const age = Number(prefs.non_contextual?.age ?? data.ages.min);
  const band = ageBand(data.ages.bands, age);
  const [mode, setMode] = useState<'species' | 'ancestry'>('species');

  const setName = (value: string) => {
    if (value.trim() && value !== name) {
      act('set_preference', { preference: 'real_name', value });
    }
  };

  return (
    <>
      <Stack>
        <Stack.Item grow basis={0}>
          <Panel title="Identity" icon="id-card">
            <FieldBlock label="Name">
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
                    tooltip="Random name"
                    onClick={() => act('randomize_name')}
                  />
                </Stack.Item>
              </Stack>
            </FieldBlock>
            {(!species || !!species.sexes) && (
              <FieldBlock label="Body Type">
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
            <FieldBlock label="Age">
              <Tooltip
                content={
                  band
                    ? `${band.name} from ${band.from}: ${
                        band.stats
                          .map(
                            (stat) =>
                              `${stat.label} ${stat.value > 0 ? '+' : ''}${stat.value}`,
                          )
                          .join(', ') || 'no stat modifiers'
                      }`
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
            <Box>
              <Button
                compact
                icon="users"
                selected={mode === 'species'}
                onClick={() => setMode('species')}
              >
                Species
              </Button>
              <Button
                compact
                icon="leaf"
                selected={mode === 'ancestry'}
                onClick={() => setMode('ancestry')}
              >
                Ancestry
              </Button>
            </Box>
          </Panel>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Panel title="Standing" icon="sun">
            <InfoRow
              icon="award"
              label="Player Quality"
              value={`${data.pq_rank} (${data.pq})`}
              valueColor={data.pq_color || undefined}
            />
            <InfoRow icon="trophy" label="Triumphs" value={data.triumphs} />
            {!!band && (
              <FieldBlock label={`Age: ${band.name}`}>
                <StatChips stats={band.stats} empty="No age modifiers." />
              </FieldBlock>
            )}
          </Panel>
        </Stack.Item>
      </Stack>
      {mode === 'species' ? (
        <SpeciesPicker currentId={speciesId} />
      ) : (
        <AncestryPicker species={species} />
      )}
    </>
  );
}

type SpeciesFilter = 'all' | 'medieval' | 'other';

/** Vibelin's species picker: a searchable list, and the inspected species with its stats, perks and lore. */
function SpeciesPicker(props: { currentId: string }) {
  const { currentId } = props;
  const { act, data } = useBackend<SetupData>();
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
    <Panel title="Choose Species" icon="users">
      <Stack>
        <Stack.Item basis="230px">
          <Input
            fluid
            placeholder="Search species..."
            value={search}
            onChange={setSearch}
          />
          <Box mt={0.5} mb={0.75}>
            <Button
              icon="list"
              selected={filter === 'all'}
              onClick={() => setFilter('all')}
            >
              All
            </Button>
            <Button
              icon="chess-rook"
              selected={filter === 'medieval'}
              tooltip="Ratwood's races"
              onClick={() => setFilter('medieval')}
            >
              Medieval
            </Button>
            <Button
              icon="globe"
              selected={filter === 'other'}
              onClick={() => setFilter('other')}
            >
              Other
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
                          .join(' / ') || (entry.medieval ? 'Medieval' : '')}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Button>
              ))
            ) : (
              <Box color="label" py={2} textAlign="center">
                No species match.
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
            <Box color="label">No species available.</Box>
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
  return (
    <Section
      fill
      title={
        <Stack align="center">
          <Stack.Item>{species.name}</Stack.Item>
          {current && (
            <Stack.Item>
              <Box color="good">Current</Box>
            </Stack.Item>
          )}
        </Stack>
      }
      buttons={
        <Button
          icon="check"
          color={current ? undefined : 'green'}
          disabled={current}
          onClick={onApply}
        >
          {current ? 'Current Species' : 'Apply Species'}
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
            {display(species.desc, 'No description.')}
          </Box>
        </Stack.Item>
      </Stack>
      <FieldBlock label="Stat modifiers">
        <StatChips stats={species.stats} />
      </FieldBlock>
      <FieldBlock label="Traits">
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
        <FieldBlock label="Lore">
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
 * Vibelin's ancestry picker on what TG has: the skin tones of a species that uses them, as swatches, and the body
 * colour of one with mutant colours.
 */
function AncestryPicker(props: { species?: SpeciesEntry }) {
  const { species } = props;
  const { act, data } = useBackend<SetupData>();
  const secondary = data.character_preferences.secondary_features ?? {};
  const tones = data.features.skin_tone as ToneCatalog | undefined;
  const hasTone = 'skin_tone' in secondary && !!tones;
  const hasColor = 'feature_mcolor' in secondary && !!features.feature_mcolor;

  return (
    <Panel title="Choose Ancestry" icon="leaf">
      {!hasTone && !hasColor && (
        <Box color="label">
          {species?.name ?? 'This species'} has no skin or colour to choose.
        </Box>
      )}
      {hasTone && (
        <FieldBlock label="Skin tone">
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
            {tones.choices.map((tone) => (
              <Button
                key={tone}
                selected={tone === secondary.skin_tone}
                tooltip={tones.display_names?.[tone] ?? tone}
                onClick={() =>
                  act('set_preference', {
                    preference: 'skin_tone',
                    value: tone,
                  })
                }
                style={{ minWidth: '126px', padding: '6px' }}
              >
                <Stack align="center">
                  <Stack.Item>
                    <Box
                      width="28px"
                      height="16px"
                      style={{ border: '1px solid rgba(0,0,0,0.65)' }}
                      backgroundColor={swatchColor(tones.to_hex?.[tone]?.value)}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box bold textAlign="left">
                      {tones.display_names?.[tone] ?? tone}
                    </Box>
                  </Stack.Item>
                </Stack>
              </Button>
            ))}
          </Box>
        </FieldBlock>
      )}
      {hasColor && (
        <FieldBlock label="Body colour">
          <FeatureValueInput
            feature={features.feature_mcolor}
            featureId="feature_mcolor"
            value={secondary.feature_mcolor}
          />
        </FieldBlock>
      )}
    </Panel>
  );
}
