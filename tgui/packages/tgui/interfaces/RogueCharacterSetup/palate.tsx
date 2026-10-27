// Ratwood's culinary preferences window (preferences_culinary.dm: the favourite and hated food and drink, each picked
// from a list of every food by fare and every drink by quality, drawn with its sprite or its vessel), on the module's
// rogue_favourite_food, rogue_hated_food, rogue_favourite_drink and rogue_hated_drink preferences
// (modular_redtard/charsetup/culinary.dm). As in Ratwood, a favourite cannot also be the hated one.
import { memo, useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { sendAct } from 'tgui/events/act';
import { Box, Button, Input, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { FieldBlock, Panel } from './components';
import { type Translate, useTr } from './strings';
import type { CulinaryCatalog, CulinaryEntry, SetupData } from './types';

type Slot = {
  key: string;
  label: string;
  drink: boolean;
  /** The other preference of the pair: favourite and hated may not be the same. */
  opposite: string;
};

const SLOTS: Slot[] = [
  {
    key: 'rogue_favourite_food',
    label: 'Favourite Food',
    drink: false,
    opposite: 'rogue_hated_food',
  },
  {
    key: 'rogue_hated_food',
    label: 'Hated Food',
    drink: false,
    opposite: 'rogue_favourite_food',
  },
  {
    key: 'rogue_favourite_drink',
    label: 'Favourite Drink',
    drink: true,
    opposite: 'rogue_hated_drink',
  },
  {
    key: 'rogue_hated_drink',
    label: 'Hated Drink',
    drink: true,
    opposite: 'rogue_favourite_drink',
  },
];

/** Ratwood's fares (ROGUE_FARE_*) and drink qualities, worst first. */
const FARES = ['', 'Desperate fare', 'Poor fare', 'Decent fare', 'Fine fare', 'Lavish fare'];
const QUALITIES = ['Plain', 'Nice', 'Good', 'Very good', 'Fantastic'];

const EMPTY_CATALOG: CulinaryCatalog = { foods: [], drinks: [], none: 'none' };

function rankName(tr: Translate, drink: boolean, rank: number) {
  return tr((drink ? QUALITIES[rank] : FARES[rank]) ?? String(rank));
}

/** Whether this map has culinary preferences at all. */
export function usePalateShown() {
  const { data } = useBackend<SetupData>();
  return 'rogue_favourite_food' in (data.character_preferences.non_contextual ?? {});
}

export function CulinaryPicker() {
  const { data } = useBackend<SetupData>();
  const tr = useTr();
  const values = data.character_preferences.non_contextual ?? {};
  const catalog = data.culinary ?? EMPTY_CATALOG;
  const [slotKey, setSlotKey] = useState(SLOTS[0].key);
  const slot = SLOTS.find((entry) => entry.key === slotKey) ?? SLOTS[0];
  const entries = slot.drink ? catalog.drinks : catalog.foods;
  const byId = useMemo(() => {
    const found: Record<string, CulinaryEntry> = {};
    for (const entry of [...catalog.foods, ...catalog.drinks]) {
      found[entry.id] = entry;
    }
    return found;
  }, [catalog]);

  return (
    <Panel title={tr('Food & Drink')} icon="utensils">
      <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }} mb={1}>
        {SLOTS.map((entry) => {
          const value = String(values[entry.key] ?? '');
          const picked = byId[value];
          return (
            <Button
              key={entry.key}
              selected={entry.key === slot.key}
              onClick={() => setSlotKey(entry.key)}
              style={{ minWidth: '170px', padding: '4px 6px' }}
            >
              <Stack align="center">
                <Stack.Item>
                  <Thumbnail icon={picked?.icon} />
                </Stack.Item>
                <Stack.Item grow>
                  <Box color="label" textAlign="left" style={{ fontSize: '10px' }}>
                    {tr(entry.label)}
                  </Box>
                  <Box bold textAlign="left">
                    {picked ? picked.name : tr('None')}
                  </Box>
                </Stack.Item>
              </Stack>
            </Button>
          );
        })}
      </Box>
      <FieldBlock label={tr('Choose: {0}', tr(slot.label))}>
        <CulinaryGrid
          key={slot.key}
          featureKey={slot.key}
          entries={entries}
          drink={slot.drink}
          selected={String(values[slot.key] ?? '')}
          taken={String(values[slot.opposite] ?? '')}
          none={slot.key === 'rogue_hated_drink' ? catalog.none : null}
          lang={data.lang}
        />
      </FieldBlock>
    </Panel>
  );
}

function Thumbnail(props: { icon?: string | null }) {
  return (
    <Box
      width="32px"
      height="32px"
      className={props.icon ? classes(['rogue_culinary32x32', props.icon]) : undefined}
      style={{ imageRendering: 'pixelated' }}
    />
  );
}

type CulinaryGridProps = {
  featureKey: string;
  entries: CulinaryEntry[];
  drink: boolean;
  selected: string;
  /** The other slot's pick, which this one may not take. */
  taken: string;
  /** The value of "nothing", when this slot may have none. */
  none: string | null;
  /** The player's language: the grid reads its texts when it renders, so a change of language must re-render it. */
  lang: string;
};

/**
 * The foods or drinks of one slot, grouped by fare or quality, with a search. Memoised on its props (the catalog comes
 * from static data, so its reference holds between updates) and sending its action itself, so an update that touches
 * neither the slot nor its values skips the hundreds of buttons.
 */
const CulinaryGrid = memo(function CulinaryGrid(props: CulinaryGridProps) {
  const { featureKey, entries, drink, selected, taken, none } = props;
  const tr = useTr();
  const [search, setSearch] = useState('');
  const needle = search.trim().toLowerCase();
  const groups = useMemo(() => {
    const found = new Map<number, CulinaryEntry[]>();
    for (const entry of entries) {
      if (needle && !entry.name.toLowerCase().includes(needle)) {
        continue;
      }
      found.set(entry.rank, [...(found.get(entry.rank) ?? []), entry]);
    }
    return [...found.entries()];
  }, [entries, needle]);
  const pick = (value: string) =>
    sendAct('set_preference', { preference: featureKey, value });

  return (
    <Box>
      <Input
        fluid
        mb={0.5}
        placeholder={tr(drink ? 'Search drinks...' : 'Search foods...')}
        value={search}
        onChange={setSearch}
      />
      {!!none && (
        <Button
          mb={0.5}
          icon="ban"
          selected={selected === none}
          onClick={() => pick(none)}
        >
          {tr('None')}
        </Button>
      )}
      <Box style={{ maxHeight: '360px', overflowY: 'auto' }}>
        {!groups.length && (
          <Box color="label" py={2} textAlign="center">
            {tr('Nothing matches.')}
          </Box>
        )}
        {groups.map(([rank, group]) => (
          <Box key={rank} mb={1}>
            <Box color="label" mb={0.5} style={{ fontSize: '12px' }}>
              {rankName(tr, drink, rank)}
            </Box>
            <Box style={{ display: 'flex', flexWrap: 'wrap' }}>
              {group.map((entry) => {
                const isTaken = entry.id === taken;
                return (
                  <Button
                    key={entry.id}
                    mr={0.5}
                    mb={0.5}
                    selected={entry.id === selected}
                    disabled={isTaken}
                    tooltip={
                      isTaken
                        ? tr('Already picked for the other slot')
                        : entry.name
                    }
                    onClick={() => pick(entry.id)}
                    style={{ width: '82px', height: '62px', padding: '2px' }}
                  >
                    <Box
                      style={{
                        display: 'flex',
                        justifyContent: 'center',
                        height: '34px',
                      }}
                    >
                      <Thumbnail icon={entry.icon} />
                    </Box>
                    <Box
                      style={{
                        fontSize: '10px',
                        lineHeight: '1.15',
                        overflow: 'hidden',
                        whiteSpace: 'nowrap',
                        textOverflow: 'ellipsis',
                        textAlign: 'center',
                      }}
                    >
                      {entry.name}
                    </Box>
                  </Button>
                );
              })}
            </Box>
          </Box>
        ))}
      </Box>
    </Box>
  );
});
