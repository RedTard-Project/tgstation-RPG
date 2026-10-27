// Ratwood's origin picker (its map of pins, each with the land's description) as a list in the style of the faith
// picker, on the rogue_homeland preference (modular_redtard/homelands): the land, its traits and who resents its people.
// Ratwood's world map is not in the port, so there are no pins.
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Section, Stack } from 'tgui-core/components';

import { display, FieldBlock, Panel } from './components';
import { useTr } from './strings';
import type { HomelandEntry, SetupData } from './types';

/** The character's homeland as the catalog names it, and whether this map has homelands at all. */
export function useHomeland() {
  const { data } = useBackend<SetupData>();
  const values = data.character_preferences.non_contextual ?? {};
  return {
    shown: 'rogue_homeland' in values,
    homeland: data.homelands?.find((entry) => entry.id === values.rogue_homeland),
  };
}

export function HomelandPicker() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const homelands = data.homelands ?? [];
  const { homeland: current } = useHomeland();
  const [inspectedId, setInspectedId] = useState<string | null>(null);
  const inspected =
    homelands.find((entry) => entry.id === (inspectedId ?? current?.id)) ??
    homelands[0];

  return (
    <Panel title={tr('Choose Homeland')} icon="map-marked-alt">
      <Stack>
        <Stack.Item basis="210px">
          <Box style={{ maxHeight: '420px', overflowY: 'auto' }}>
            {homelands.map((entry) => (
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
                      name={entry.id === current?.id ? 'check-circle' : 'flag'}
                      color={entry.id === current?.id ? 'good' : undefined}
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
                      {entry.traits.map((trait) => trait.name).join(' / ')}
                    </Box>
                  </Stack.Item>
                </Stack>
              </Button>
            ))}
          </Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          {inspected ? (
            <HomelandDetails
              homeland={inspected}
              current={inspected.id === current?.id}
              onChoose={() =>
                act('set_preference', {
                  preference: 'rogue_homeland',
                  value: inspected.id,
                })
              }
            />
          ) : (
            <Box color="label">{tr('No homelands available.')}</Box>
          )}
        </Stack.Item>
      </Stack>
    </Panel>
  );
}

type HomelandDetailsProps = {
  homeland: HomelandEntry;
  current: boolean;
  onChoose: () => void;
};

function HomelandDetails(props: HomelandDetailsProps) {
  const { homeland, current, onChoose } = props;
  const tr = useTr();
  let prejudice = tr('No one resents its people.');
  if (homeland.prejudice) {
    prejudice = homeland.resented_by.length
      ? tr(
          'The people of {0} resent its people on sight.',
          homeland.resented_by.join(', '),
        )
      : tr('Everyone from elsewhere resents its people on sight.');
  }

  return (
    <Section
      fill
      title={
        // Inline, not a Stack: a block title takes the whole bar and pushes the buttons onto the line below.
        <>
          {homeland.name}
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
          onClick={onChoose}
        >
          {current ? tr('Current Homeland') : tr('Choose Homeland')}
        </Button>
      }
    >
      <Box
        mb={1}
        style={{ maxHeight: '140px', overflowY: 'auto', whiteSpace: 'pre-line' }}
      >
        {display(homeland.desc, tr('No description.'))}
      </Box>
      <FieldBlock label={tr('Traits')}>
        <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
          {homeland.traits.length ? (
            homeland.traits.map((trait) => (
              <Button
                key={trait.name}
                compact
                icon="star"
                tooltip={trait.desc || undefined}
              >
                {trait.name}
              </Button>
            ))
          ) : (
            <Box color="label">{tr('None')}</Box>
          )}
        </Box>
      </FieldBlock>
      <FieldBlock label={tr('Prejudice')}>
        <Box color={homeland.prejudice ? 'bad' : 'label'}>{prejudice}</Box>
      </FieldBlock>
      <Box color="label" mt={1}>
        {tr('Whoever sees your face learns your ancestry.')}
      </Box>
    </Section>
  );
}
