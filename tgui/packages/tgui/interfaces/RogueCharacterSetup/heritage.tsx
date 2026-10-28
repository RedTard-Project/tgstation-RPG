// Vibelin's faith picker (renderFaithPicker of PreferencesMenu.tsx) and a culture picker in its style, on the module's
// heritage preferences (modular_redtard/heritage): rogue_faith, rogue_patron and rogue_culture, whose values are type
// paths. The catalog comes translated from the server; what the character's race may not have is shown but disabled.
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Input, Section, Stack } from 'tgui-core/components';

import { display, FieldBlock, InfoRow, Panel } from './components';
import { useTr } from './strings';
import type { CultureEntry, FaithEntry, PatronEntry, SetupData } from './types';

/** Whether a race may have what lists these races (none is anyone). */
export function allowsRace(races: string[], race: string) {
  return !races.length || races.includes(race);
}

function faithAvailable(faith: FaithEntry, race: string) {
  return faith.patrons.some((patron) => allowsRace(patron.races, race));
}

/** The character's faith, patron and culture as the catalog names them. */
export function useHeritage() {
  const { data } = useBackend<SetupData>();
  const values = data.character_preferences.non_contextual ?? {};
  const faiths = data.heritage?.faiths ?? [];
  const faith = faiths.find((entry) => entry.id === values.rogue_faith);
  const patron = faiths
    .flatMap((entry) => entry.patrons)
    .find((entry) => entry.id === values.rogue_patron);
  const culture = data.heritage?.cultures.find(
    (entry) => entry.id === values.rogue_culture,
  );
  return {
    shown: 'rogue_faith' in values,
    faith,
    patron,
    culture,
  };
}

export function FaithPicker() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const race = data.heritage_species;
  const faiths = data.heritage?.faiths ?? [];
  const { faith: current, patron: currentPatron } = useHeritage();
  const [inspectedId, setInspectedId] = useState<string | null>(null);
  const inspected =
    faiths.find((faith) => faith.id === (inspectedId ?? current?.id)) ??
    faiths[0];

  return (
    <Panel title={tr('Choose Faith')} icon="asterisk">
      <Stack>
        <Stack.Item basis="210px">
          <Box style={{ maxHeight: '420px', overflowY: 'auto' }}>
            {faiths.length ? (
              faiths.map((faith) => (
                <Button
                  key={faith.id}
                  fluid
                  mb={0.5}
                  selected={faith.id === inspected?.id}
                  disabled={!faithAvailable(faith, race)}
                  onClick={() => setInspectedId(faith.id)}
                  style={{ minHeight: '40px', padding: '4px 6px' }}
                >
                  <Stack align="center">
                    <Stack.Item>
                      <Icon
                        name={
                          faith.id === current?.id ? 'check-circle' : 'asterisk'
                        }
                        color={faith.id === current?.id ? 'good' : undefined}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box bold textAlign="left">
                        {faith.name}
                      </Box>
                      <Box
                        color="label"
                        textAlign="left"
                        style={{ fontSize: '10px', lineHeight: '12px' }}
                      >
                        {tr('{0} patrons', faith.patrons.length)}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Button>
              ))
            ) : (
              <Box color="label">{tr('No faiths available.')}</Box>
            )}
          </Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          {inspected ? (
            <FaithDetails
              faith={inspected}
              current={inspected.id === current?.id}
              currentPatron={currentPatron}
              race={race}
              onUse={() => act('select_faith', { faith: inspected.id })}
            />
          ) : (
            <Box color="label">{tr('No faiths available.')}</Box>
          )}
        </Stack.Item>
      </Stack>
    </Panel>
  );
}

type FaithDetailsProps = {
  faith: FaithEntry;
  current: boolean;
  currentPatron?: PatronEntry;
  race: string;
  onUse: () => void;
};

function FaithDetails(props: FaithDetailsProps) {
  const { faith, current, currentPatron, race, onUse } = props;
  const { act } = useBackend<SetupData>();
  const tr = useTr();
  const available = faithAvailable(faith, race);
  // The patron to read about: the character's, if it is of this faith, else the faith's godhead.
  const shownPatron =
    (current &&
      faith.patrons.find((patron) => patron.id === currentPatron?.id)) ||
    faith.patrons.find((patron) => patron.id === faith.godhead) ||
    faith.patrons[0];

  return (
    <Section
      fill
      title={
        // Inline, not a Stack: a block title takes the whole bar and pushes the buttons onto the line below.
        <>
          {faith.name}
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
          disabled={current || !available}
          tooltip={tr("Choose this faith's godhead")}
          onClick={onUse}
        >
          {current ? tr('Current Faith') : tr('Use Faith')}
        </Button>
      }
    >
      <Box
        mb={1}
        style={{ maxHeight: '90px', overflowY: 'auto', whiteSpace: 'pre-line' }}
      >
        {display(faith.desc, tr('No description.'))}
      </Box>
      <FieldBlock label={tr('Patrons')}>
        <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
          {faith.patrons.map((patron) => {
            const selected = current && patron.id === currentPatron?.id;
            const allowed = allowsRace(patron.races, race);
            return (
              <Button
                key={patron.id}
                selected={selected}
                disabled={!allowed}
                tooltip={
                  allowed
                    ? display(patron.domain, patron.name)
                    : tr('Not for this race')
                }
                onClick={() => act('select_patron', { patron: patron.id })}
                style={{ minWidth: '140px', padding: '4px 6px' }}
              >
                <Stack align="center">
                  <Stack.Item>
                    <Icon
                      name={selected ? 'check-circle' : 'sun'}
                      color={selected ? 'good' : undefined}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box bold textAlign="left">
                      {patron.name}
                    </Box>
                  </Stack.Item>
                </Stack>
              </Button>
            );
          })}
        </Box>
      </FieldBlock>
      {!!shownPatron && <PatronDetails patron={shownPatron} />}
    </Section>
  );
}

function PatronDetails(props: { patron: PatronEntry }) {
  const { patron } = props;
  const tr = useTr();
  return (
    <Box
      p={1}
      style={{
        border: '1px solid rgba(255,255,255,0.12)',
        borderRadius: '4px',
      }}
    >
      <Box bold fontSize="14px" mb={0.5}>
        {patron.name}
      </Box>
      <InfoRow
        icon="globe"
        label={tr('Domain')}
        value={display(patron.domain, tr('None'))}
      />
      <InfoRow
        icon="users"
        label={tr('Worshippers')}
        value={display(patron.worshippers, tr('None'))}
      />
      <Box my={0.5} style={{ whiteSpace: 'pre-line' }}>
        {display(patron.desc, tr('No description.'))}
      </Box>
      <FieldBlock label={tr('Boons')}>
        <Box color="good">{display(patron.boons, tr('None'))}</Box>
      </FieldBlock>
      <FieldBlock label={tr('Flaws')}>
        <Box>{display(patron.flaws, tr('None'))}</Box>
      </FieldBlock>
      <FieldBlock label={tr('Sins')}>
        <Box color="bad">{display(patron.sins, tr('None'))}</Box>
      </FieldBlock>
    </Box>
  );
}

/** The cultures the race may come from: its own first, then those anyone may have. */
export function CulturePicker() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const race = data.heritage_species;
  const { culture: current } = useHeritage();
  const [search, setSearch] = useState('');
  const needle = search.trim().toLowerCase();
  const matches = (culture: CultureEntry) =>
    !needle || culture.name.toLowerCase().includes(needle);
  const cultures = data.heritage?.cultures ?? [];
  const own = cultures.filter(
    (culture) => culture.races.includes(race) && matches(culture),
  );
  const common = cultures.filter(
    (culture) => !culture.races.length && matches(culture),
  );
  const select = (culture: CultureEntry) =>
    act('set_preference', { preference: 'rogue_culture', value: culture.id });

  return (
    <Panel title={tr('Culture')} icon="landmark">
      <Stack>
        <Stack.Item basis="230px">
          <Input
            fluid
            mb={0.5}
            placeholder={tr('Search cultures...')}
            value={search}
            onChange={setSearch}
          />
          <Box style={{ maxHeight: '400px', overflowY: 'auto' }}>
            {!own.length && !common.length && (
              <Box color="label" py={2} textAlign="center">
                {tr('No cultures match.')}
              </Box>
            )}
            {[...own, ...common].map((culture) => (
              <Button
                key={culture.id}
                fluid
                mb={0.5}
                selected={culture.id === current?.id}
                color={culture.races.length ? undefined : 'transparent'}
                onClick={() => select(culture)}
              >
                <Stack align="center">
                  <Stack.Item>
                    <Icon
                      name={
                        culture.id === current?.id
                          ? 'check-circle'
                          : culture.races.length
                            ? 'users'
                            : 'globe'
                      }
                      color={culture.id === current?.id ? 'good' : undefined}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box textAlign="left">{culture.name}</Box>
                  </Stack.Item>
                </Stack>
              </Button>
            ))}
          </Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          {current ? (
            <Section title={current.name}>
              <Box style={{ whiteSpace: 'pre-line' }}>
                {display(current.desc, tr('No description.'))}
              </Box>
              <Box color="label" mt={1}>
                {tr('Only those of the same culture know where you come from.')}
              </Box>
            </Section>
          ) : (
            <Box color="label">{tr('None')}</Box>
          )}
        </Stack.Item>
      </Stack>
    </Panel>
  );
}
