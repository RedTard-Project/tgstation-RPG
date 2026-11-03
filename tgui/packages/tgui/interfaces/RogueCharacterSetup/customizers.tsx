// Vibelin's customizers (modular_redtard/heritage/customizers.dm): the ears, horns, snout, neck, tail and wings of one
// of Vibelin's races, picked as TG's main features are (FeatureColumn.tsx): an icon button per slot beside the looking
// glass showing the pick, which opens the race's choices to the right, with "None" where the race may go without and,
// where Vibelin lets them change, the colour of each key in the title bar.
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Floating,
  Icon,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { swatchColor } from './components';
import { useTr } from './strings';
import type {
  CustomizerOption,
  CustomizerSlot,
  PickedFeatures,
  SetupData,
} from './types';

const CELL_SIZE = 48;
const NONE = 'none';
const SEARCH_FROM = 12;

/** The slots by name, as strings.ts translates them. */
const SLOT_NAMES: Record<string, string> = {
  ears: 'Ears',
  horns: 'Horns',
  snout: 'Snout',
  neck: 'Neck',
  tail: 'Tail',
  wings: 'Wings',
};

export type Customizers = {
  slots: CustomizerSlot[];
  picked: PickedFeatures;
};

/** The customizers of the character's race and what is picked, while the menu offers them (medieval maps). */
export function useCustomizers(): Customizers {
  const { data } = useBackend<SetupData>();
  const prefs = data.character_preferences;
  const values = prefs.non_contextual ?? {};
  if (!('rogue_features' in values)) {
    return { slots: [], picked: {} };
  }
  return {
    slots: data.customizers?.[String(prefs.misc?.species ?? '')] ?? [],
    picked: (values.rogue_features ?? {}) as PickedFeatures,
  };
}

/** What the slot shows: the pick if the race offers it, else the race's own, as the server puts it on the body. */
function currentPick(slot: CustomizerSlot, picked?: string) {
  if (picked === NONE) {
    return slot.none ? NONE : slot.default;
  }
  return slot.options.some((option) => option.id === picked)
    ? (picked as string)
    : slot.default;
}

/** A button per customizer slot of the character's race, for the stack of FeatureColumn. */
export function CustomizerButtons(props: Customizers) {
  const { slots, picked } = props;
  return (
    <>
      {slots.map((slot) => (
        <Stack.Item key={slot.slot}>
          <CustomizerButton slot={slot} picked={picked} />
        </Stack.Item>
      ))}
    </>
  );
}

type SlotProps = {
  slot: CustomizerSlot;
  picked: PickedFeatures;
};

function CustomizerButton(props: SlotProps) {
  const { slot, picked } = props;
  const tr = useTr();
  const current = currentPick(slot, picked[slot.slot]?.id);
  // As FeatureColumn's buttons: a plain div takes Floating's anchor ref, which a Button with a tooltip does not pass on.
  return (
    <Floating
      stopChildPropagation
      placement="right-start"
      content={<CustomizerChooser slot={slot} picked={picked} />}
    >
      <div>
        <Button
          tooltip={`${tr(SLOT_NAMES[slot.slot] ?? slot.slot)}: ${slot.name}`}
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
            <Thumbnail
              option={slot.options.find((option) => option.id === current)}
              fit={CELL_SIZE - 4}
            />
          </Box>
        </Button>
      </div>
    </Floating>
  );
}

/** The grid of one slot's choices, the colours of the shown feature in the title bar. */
function CustomizerChooser(props: SlotProps) {
  const { slot, picked } = props;
  const { act } = useBackend<SetupData>();
  const tr = useTr();
  const [search, setSearch] = useState('');
  const entry = picked[slot.slot];
  const current = currentPick(slot, entry?.id);
  const option = slot.options.find((choice) => choice.id === current);
  const colors = useFeatureColors(option, entry?.colors);
  const needle = search.trim().toLowerCase();
  const shown = needle
    ? slot.options.filter((choice) =>
        choice.name.toLowerCase().includes(needle),
      )
    : slot.options;
  const pick = (id: string) => act('set_customizer', { slot: slot.slot, id });

  return (
    <Box
      className="ChoicedSelection"
      style={{ width: '480px', height: '440px' }}
    >
      <Section
        fill
        scrollable
        title={`${tr(SLOT_NAMES[slot.slot] ?? slot.slot)}: ${slot.name}`}
        buttons={
          !!slot.colors &&
          !!option && (
            <Stack align="center">
              {option.keys.map((key, index) => (
                <Stack.Item key={index}>
                  <Button
                    tooltip={key.name ?? tr('Colour')}
                    onClick={() =>
                      act('set_customizer_color', {
                        slot: slot.slot,
                        index: index + 1,
                      })
                    }
                    style={{
                      width: '22px',
                      height: '22px',
                      padding: 0,
                      backgroundColor: swatchColor(colors[index]),
                    }}
                  />
                </Stack.Item>
              ))}
              {!!entry?.colors?.length && (
                <Stack.Item>
                  <Button
                    icon="undo"
                    tooltip={tr('Reset colours')}
                    onClick={() =>
                      act('reset_customizer_colors', { slot: slot.slot })
                    }
                  />
                </Stack.Item>
              )}
            </Stack>
          )
        }
      >
        {slot.options.length > SEARCH_FROM && (
          <Input
            fluid
            mb={0.5}
            placeholder={tr('Search...')}
            value={search}
            onChange={setSearch}
          />
        )}
        <Box style={{ display: 'flex', flexWrap: 'wrap' }}>
          {!!slot.none && (
            <Tile
              name={tr('None')}
              selected={current === NONE}
              onClick={() => pick(NONE)}
            />
          )}
          {shown.map((choice) => (
            <Tile
              key={choice.id}
              option={choice}
              name={choice.name}
              selected={choice.id === current}
              onClick={() => pick(choice.id)}
            />
          ))}
        </Box>
      </Section>
    </Box>
  );
}

/** The colours the feature is drawn in now: the picked ones, the rest by their defaults, as the server resolves them. */
function useFeatureColors(option?: CustomizerOption, stored?: string[]) {
  const { data } = useBackend<SetupData>();
  const prefs = data.character_preferences;
  if (!option) {
    return [];
  }
  const species = data.species.find(
    (entry) => entry.id === prefs.misc?.species,
  );
  const origin = species?.origins.find(
    (entry) => entry.name === prefs.non_contextual?.rogue_origin,
  );
  const skin =
    origin?.color ?? String(prefs.secondary_features?.feature_mcolor ?? '');
  const hair = String(prefs.supplemental_features?.hair_color ?? '');
  return option.keys.map((key, index) => {
    if (stored?.[index]) {
      return stored[index];
    }
    if (key.default === 'skin') {
      return skin;
    }
    if (key.default === 'hair') {
      return hair;
    }
    return key.default ?? '#FFFFFF';
  });
}

type TileProps = {
  option?: CustomizerOption;
  name: string;
  selected: boolean;
  onClick: () => void;
};

/** One choice of the grid, as IconGrid draws TG's: the thumbnail and the name. */
function Tile(props: TileProps) {
  const { option, name, selected, onClick } = props;
  return (
    <Button
      mr={0.5}
      mb={0.5}
      tooltip={name}
      selected={selected}
      onClick={onClick}
      style={{ width: '66px', height: '80px', padding: '2px' }}
    >
      <Box
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          height: '50px',
        }}
      >
        <Thumbnail option={option} fit={48} />
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
        {name}
      </Box>
    </Button>
  );
}

/** A feature's thumbnail from the rogue_customizers spritesheet, scaled to fit; a crossed circle for none. */
function Thumbnail(props: { option?: CustomizerOption; fit: number }) {
  const { option, fit } = props;
  if (!option) {
    return <Icon name="ban" size={1.5} color="label" />;
  }
  const [width, height] = option.size.split('x').map(Number);
  const scale = Math.min(fit / (width || 32), fit / (height || 32), 1.4);
  return (
    <Box
      className={classes([`rogue_customizers${option.size}`, option.id])}
      style={{ transform: `scale(${scale})`, imageRendering: 'pixelated' }}
    />
  );
}
