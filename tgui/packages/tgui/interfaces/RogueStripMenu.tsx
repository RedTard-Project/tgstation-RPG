import { range } from 'es-toolkit';
import type { CSSProperties } from 'react';
import { Box, Button, Icon, Image, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

const ROWS = 5;
const COLUMNS = 6;

const BUTTON_DIMENSIONS = '64px';
const QUARTER_DIMENSIONS = '32px';

type GridSpotKey = string;

const getGridSpotKey = (spot: [number, number]): GridSpotKey => {
  return `${spot[0]}/${spot[1]}`;
};

const CornerText = (props: {
  align: 'left' | 'right';
  children: string;
}): React.JSX.Element => {
  const { align, children } = props;

  return (
    <Box
      style={{
        position: 'relative',
        left: align === 'left' ? '2px' : '-2px',
        textAlign: align,
        textShadow: '1px 1px 1px #555',
      }}
    >
      {children}
    </Box>
  );
};

type AlternateAction = {
  icon: string;
  text: string;
};

const ALTERNATE_ACTIONS: Record<string, AlternateAction> = {
  knot: {
    icon: 'shoe-prints',
    text: 'Knot',
  },

  untie: {
    icon: 'shoe-prints',
    text: 'Untie',
  },

  unknot: {
    icon: 'shoe-prints',
    text: 'Unknot',
  },

  remove_item_cuffs: {
    icon: 'handcuffs',
    text: 'Remove Handcuffs',
  },

  enable_internals: {
    icon: 'tg-air-tank',
    text: 'Enable internals',
  },

  disable_internals: {
    icon: 'tg-air-tank-slash',
    text: 'Disable internals',
  },

  adjust_jumpsuit: {
    icon: 'tshirt',
    text: 'Adjust jumpsuit',
  },

  adjust_sensor: {
    icon: 'microchip',
    text: 'Adjust sensors',
  },

  strip_accessory: {
    icon: 'ribbon',
    text: 'Strip accessory',
  },

  deploy: {
    icon: 'plus',
    text: 'Deploy MOD',
  },

  undeploy: {
    icon: 'minus',
    text: 'Undeploy MOD',
  },

  activate_mod: {
    icon: 'power-off',
    text: 'Activate MOD',
  },
  deactivate_mod: {
    icon: 'power-off',
    text: 'Deactivate MOD',
  },

  access_storage: {
    icon: 'box-open',
    text: 'Open',
  },
};

const SLOTS: Record<
  string,
  {
    displayName: string;
    gridSpot: GridSpotKey;
    quarter?: number;
    image?: string;
    additionalComponent?: React.JSX.Element;
  }
> = {
  eyes: {
    displayName: 'eyewear',
    gridSpot: getGridSpotKey([0, 1]),
    image: 'inventory-glasses.png',
  },

  head: {
    displayName: 'headwear',
    gridSpot: getGridSpotKey([0, 2]),
    image: 'inventory-head.png',
  },

  neck: {
    displayName: 'neckwear',
    gridSpot: getGridSpotKey([1, 1]),
    image: 'inventory-neck.png',
  },

  mask: {
    displayName: 'mask',
    gridSpot: getGridSpotKey([1, 2]),
    image: 'inventory-mask.png',
  },

  pet_collar: {
    displayName: 'collar',
    gridSpot: getGridSpotKey([1, 2]),
    image: 'inventory-collar.png',
  },

  ears: {
    displayName: 'earwear',
    gridSpot: getGridSpotKey([1, 3]),
    image: 'inventory-ears.png',
  },

  parrot_headset: {
    displayName: 'headset',
    gridSpot: getGridSpotKey([1, 3]),
    image: 'inventory-ears.png',
  },

  handcuffs: {
    displayName: 'handcuffs',
    gridSpot: getGridSpotKey([1, 4]),
  },

  legcuffs: {
    displayName: 'legcuffs',
    gridSpot: getGridSpotKey([1, 5]),
  },

  jumpsuit: {
    displayName: 'uniform',
    gridSpot: getGridSpotKey([2, 1]),
    image: 'inventory-uniform.png',
  },

  suit: {
    displayName: 'suit',
    gridSpot: getGridSpotKey([2, 2]),
    image: 'inventory-suit.png',
  },

  gloves: {
    displayName: 'gloves',
    gridSpot: getGridSpotKey([2, 3]),
    image: 'inventory-gloves.png',
  },

  right_hand: {
    displayName: 'right hand',
    gridSpot: getGridSpotKey([2, 4]),
    image: 'inventory-hand_r.png',
    additionalComponent: <CornerText align="left">R</CornerText>,
  },

  left_hand: {
    displayName: 'left hand',
    gridSpot: getGridSpotKey([2, 5]),
    image: 'inventory-hand_l.png',
    additionalComponent: <CornerText align="right">L</CornerText>,
  },

  shoes: {
    displayName: 'shoes',
    gridSpot: getGridSpotKey([3, 2]),
    image: 'inventory-shoes.png',
  },

  suit_storage: {
    displayName: 'suit storage item',
    gridSpot: getGridSpotKey([4, 0]),
    image: 'inventory-suit_storage.png',
  },

  id: {
    displayName: 'ID',
    gridSpot: getGridSpotKey([4, 1]),
    image: 'inventory-id.png',
  },

  belt: {
    displayName: 'belt',
    gridSpot: getGridSpotKey([4, 2]),
    image: 'inventory-belt.png',
  },

  back: {
    displayName: 'back (left)',
    gridSpot: getGridSpotKey([4, 3]),
    image: 'inventory-back.png',
  },

  left_pocket: {
    displayName: 'left pocket',
    gridSpot: getGridSpotKey([4, 4]),
    image: 'inventory-pocket.png',
  },

  right_pocket: {
    displayName: 'right pocket',
    gridSpot: getGridSpotKey([4, 5]),
    image: 'inventory-pocket.png',
  },

  cloak: {
    displayName: 'cloak',
    gridSpot: getGridSpotKey([1, 0]),
    image: 'inventory-suit.png',
  },

  shirt: {
    displayName: 'shirt',
    gridSpot: getGridSpotKey([2, 0]),
    image: 'inventory-uniform.png',
  },

  backr: {
    displayName: 'back (right)',
    gridSpot: getGridSpotKey([3, 5]),
    image: 'inventory-back.png',
  },

  mouth: {
    displayName: 'mouth',
    gridSpot: getGridSpotKey([0, 3]),
    image: 'inventory-mask.png',
  },

  wrists: {
    displayName: 'wrists',
    gridSpot: getGridSpotKey([3, 3]),
    image: 'inventory-gloves.png',
  },

  ring1: {
    displayName: 'ring 1',
    gridSpot: getGridSpotKey([3, 4]),
    quarter: 0,
  },

  ring2: {
    displayName: 'ring 2',
    gridSpot: getGridSpotKey([3, 4]),
    quarter: 1,
  },

  ring3: {
    displayName: 'ring 3',
    gridSpot: getGridSpotKey([3, 4]),
    quarter: 2,
  },

  ring4: {
    displayName: 'ring 4',
    gridSpot: getGridSpotKey([3, 4]),
    quarter: 3,
  },
};

enum ObscuringLevel {
  Completely = 1,
  Hidden = 2,
  Inaccessible = 3,
}

type Interactable = {
  interacting: BooleanLike;
};

type AlternateActions = {
  alternate?: string[];
  alternate_icons?: Record<string, string> | null;
};

/**
 * Some possible options:
 *
 * null - No interactions, no item, but is an available slot
 * { interacting: 1 } - No item, but we're interacting with it
 * { icon: icon, name: name } - An item with no alternate actions
 *   that we're not interacting with.
 * { icon, name, interacting: 1 } - An item with no alternate actions
 *   that we're interacting with.
 */
type StripMenuItem =
  | null
  | Interactable
  | ((
      | ({
          icon: string;
          name: string;
          obscured: ObscuringLevel;
        } & AlternateActions)
      | ({
          obscured: ObscuringLevel;
        } & AlternateActions)
    ) &
      Partial<Interactable>);

type StripMenuData = {
  items: Record<keyof typeof SLOTS, StripMenuItem>;
  name: string;
};

const QuarterSlots = (props: {
  keys: string[];
  items: StripMenuData['items'];
}): React.JSX.Element => {
  const { act } = useBackend<StripMenuData>();
  const { keys, items } = props;

  return (
    <Box
      style={{
        display: 'flex',
        flexWrap: 'wrap',
        width: BUTTON_DIMENSIONS,
        height: BUTTON_DIMENSIONS,
      }}
    >
      {range(0, 4).map((quarter) => {
        const slotKey = keys[quarter];
        const style: CSSProperties = {
          width: QUARTER_DIMENSIONS,
          height: QUARTER_DIMENSIONS,
          margin: '0',
          padding: '0',
        };

        if (!slotKey) {
          return <Box key={quarter} style={style} />;
        }

        const item = items[slotKey];
        const slot = SLOTS[slotKey];
        const obscured =
          item &&
          'obscured' in item &&
          (item.obscured === ObscuringLevel.Hidden ||
            item.obscured === ObscuringLevel.Completely)
            ? item.obscured
            : undefined;

        let content: React.JSX.Element | undefined;
        let tooltip = slot.displayName;

        if (item && 'name' in item) {
          content = (
            <Image
              src={`data:image/jpeg;base64,${item.icon}`}
              width={QUARTER_DIMENSIONS}
              height={QUARTER_DIMENSIONS}
            />
          );
          tooltip = item.name;
        } else if (obscured) {
          content = (
            <Icon
              name={
                obscured === ObscuringLevel.Completely ? 'ban' : 'eye-slash'
              }
              mt={0.7}
            />
          );
          tooltip = `obscured ${slot.displayName}`;
        }

        return (
          <Button
            key={slotKey}
            onClick={() => {
              act('use', {
                key: slotKey,
              });
            }}
            tooltip={tooltip}
            style={{
              ...style,
              background: item?.interacting ? 'hsl(39, 73%, 30%)' : undefined,
              textAlign: 'center',
            }}
          >
            {content}
          </Button>
        );
      })}
    </Box>
  );
};

export const RogueStripMenu = (props) => {
  const { act, data } = useBackend<StripMenuData>();

  const gridSpots = new Map<GridSpotKey, string>();
  const quarterSpots = new Map<GridSpotKey, string[]>();
  for (const key of Object.keys(data.items)) {
    const slot = SLOTS[key];
    if (!slot) {
      continue;
    }
    if (slot.quarter === undefined) {
      gridSpots.set(slot.gridSpot, key);
      continue;
    }
    const quarters = quarterSpots.get(slot.gridSpot) ?? [];
    quarters[slot.quarter] = key;
    quarterSpots.set(slot.gridSpot, quarters);
  }

  return (
    // (64 + 6) * 6 + 6 = 426
    // (64 + 6) * 5 + 6 + 31 (from title) =
    <Window title={`Stripping ${data.name}`} width={426} height={387}>
      <Window.Content>
        <Stack fill vertical>
          {range(0, ROWS).map((row) => (
            <Stack.Item key={row}>
              <Stack fill>
                {range(0, COLUMNS).map((column) => {
                  const key = getGridSpotKey([row, column]);
                  const keyAtSpot = gridSpots.get(key);
                  const quarterKeys = quarterSpots.get(key);

                  if (quarterKeys) {
                    return (
                      <Stack.Item
                        key={key}
                        style={{
                          width: BUTTON_DIMENSIONS,
                          height: BUTTON_DIMENSIONS,
                        }}
                      >
                        <QuarterSlots keys={quarterKeys} items={data.items} />
                      </Stack.Item>
                    );
                  }

                  if (!keyAtSpot) {
                    return (
                      <Stack.Item
                        key={key}
                        style={{
                          width: BUTTON_DIMENSIONS,
                          height: BUTTON_DIMENSIONS,
                        }}
                      />
                    );
                  }

                  const item = data.items[keyAtSpot];
                  const slot = SLOTS[keyAtSpot];

                  let content: React.JSX.Element | undefined;
                  let alternateActions: React.JSX.Element[] | undefined;
                  let tooltip: string | undefined;

                  if (item === null) {
                    tooltip = slot.displayName;
                  } else if ('name' in item) {
                    content = (
                      <Image
                        src={`data:image/jpeg;base64,${item.icon}`}
                        width="64px"
                        height="64px"
                        style={{
                          verticalAlign: 'middle',
                        }}
                      />
                    );

                    tooltip = item.name;
                  } else if (
                    'obscured' in item &&
                    (item.obscured === ObscuringLevel.Hidden ||
                      item.obscured === ObscuringLevel.Completely)
                  ) {
                    content = (
                      <Icon
                        name={
                          item.obscured === ObscuringLevel.Completely
                            ? 'ban'
                            : 'eye-slash'
                        }
                        size={3}
                        ml={0}
                        mt={2.5}
                        style={{
                          textAlign: 'center',
                          verticalAlign: 'middle',
                          height: '100%',
                          width: '100%',
                        }}
                      />
                    );

                    tooltip = `obscured ${slot.displayName}`;
                  }

                  if (item && 'alternate' in item && item.alternate?.length) {
                    alternateActions = item.alternate
                      .filter((alternateKey) => ALTERNATE_ACTIONS[alternateKey])
                      .map((alternateKey, idx) => {
                        const alternateAction = ALTERNATE_ACTIONS[alternateKey];
                        const alternateIcon =
                          item.alternate_icons?.[alternateKey];

                        const alternateActionStyle: CSSProperties = {
                          background: 'rgba(0, 0, 0, 0.6)',
                          position: 'absolute',
                          overflow: 'hidden',
                          margin: '0',
                          width: '20px',
                          height: '20px',
                          zIndex: '2',
                          left: idx === 0 ? '0' : undefined,
                          right: idx === 1 ? '0' : undefined,
                          top: idx === 2 ? '0' : undefined,
                          bottom: '0',
                          padding: '0',
                          textAlign: 'center',
                        };
                        return (
                          <Button
                            key={alternateAction.text}
                            onClick={() => {
                              act('alt', {
                                key: keyAtSpot,
                                alternate_action: alternateKey,
                              });
                            }}
                            tooltip={alternateAction.text}
                            style={alternateActionStyle}
                            disabled={
                              item.obscured === ObscuringLevel.Inaccessible
                            }
                            opacity={
                              item.obscured === ObscuringLevel.Inaccessible
                                ? 0.7
                                : 1
                            }
                          >
                            {alternateIcon ? (
                              <Image
                                src={`data:image/jpeg;base64,${alternateIcon}`}
                                width="20px"
                                height="20px"
                              />
                            ) : (
                              <Icon name={alternateAction.icon} />
                            )}
                          </Button>
                        );
                      });
                  }

                  return (
                    <Stack.Item
                      key={key}
                      style={{
                        width: BUTTON_DIMENSIONS,
                        height: BUTTON_DIMENSIONS,
                      }}
                    >
                      <Box
                        style={{
                          position: 'relative',
                          width: '100%',
                          height: '100%',
                        }}
                      >
                        <Button
                          onClick={() => {
                            act('use', {
                              key: keyAtSpot,
                            });
                          }}
                          fluid
                          tooltip={tooltip}
                          style={{
                            background: item?.interacting
                              ? 'hsl(39, 73%, 30%)'
                              : undefined,
                            position: 'relative',
                            width: '100%',
                            height: '100%',
                            padding: '0',
                          }}
                        >
                          {slot.image && !(item && 'name' in item) && (
                            <Image
                              className="centered-image"
                              src={resolveAsset(slot.image)}
                              opacity={0.7}
                              width="64px"
                              height="64px"
                            />
                          )}

                          <Box style={{ position: 'relative' }}>{content}</Box>

                          {slot.additionalComponent}
                        </Button>
                        {alternateActions}
                      </Box>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};
