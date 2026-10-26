import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Ware = {
  key: string;
  name: string;
  price: number;
  count: number;
};

type Data = {
  locked: BooleanLike;
  budget: number;
  profits: number;
  wares: Ware[];
};

/** PEDDLER: a keeper's stall (Ratwood vendor.dm, "THE PEDDLER, THIRD ITERATION"). */
export const RoguePeddler = () => {
  const { act, data } = useBackend<Data>();
  const wares = data.wares || [];
  const selling = !!data.locked;
  return (
    <Window title="THE PEDDLER, THIRD ITERATION" width={460} height={420}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              {selling ? (
                <Stack align="center">
                  <Stack.Item grow>Stored mammon: {data.budget}</Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="coins"
                      disabled={data.budget <= 0}
                      onClick={() => act('change')}
                    >
                      Change
                    </Button>
                  </Stack.Item>
                </Stack>
              ) : (
                <Stack align="center">
                  <Stack.Item grow>Stored profits: {data.profits}</Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="coins"
                      disabled={data.profits <= 0}
                      onClick={() => act('withdraw_profits')}
                    >
                      Withdraw
                    </Button>
                  </Stack.Item>
                </Stack>
              )}
              <Box mt={1} color="label">
                {selling
                  ? 'Insert coins, then buy.'
                  : 'Open with the stall key: put wares in, name and price them.'}
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title="Wares">
              {wares.length === 0 && <NoticeBox>Nothing for sale.</NoticeBox>}
              <Table>
                {wares.map((ware) => (
                  <Table.Row key={ware.key} className="candystripe">
                    <Table.Cell>
                      {selling ? (
                        ware.name
                      ) : (
                        <Button
                          compact
                          onClick={() => act('setname', { key: ware.key })}
                        >
                          {ware.name}
                        </Button>
                      )}
                    </Table.Cell>
                    <Table.Cell collapsing>x{ware.count}</Table.Cell>
                    <Table.Cell collapsing>
                      {selling ? (
                        `${ware.price}m`
                      ) : (
                        <Button
                          compact
                          onClick={() => act('setprice', { key: ware.key })}
                        >
                          {ware.price}m
                        </Button>
                      )}
                    </Table.Cell>
                    <Table.Cell collapsing>
                      {selling ? (
                        <Button
                          disabled={ware.price > data.budget}
                          onClick={() => act('buy', { key: ware.key })}
                        >
                          Buy
                        </Button>
                      ) : (
                        <Button onClick={() => act('retrieve', { key: ware.key })}>
                          Take
                        </Button>
                      )}
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
