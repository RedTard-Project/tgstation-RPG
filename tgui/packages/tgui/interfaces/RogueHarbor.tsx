import { useState } from 'react';
import {
  Box,
  Button,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type CargoLine = {
  good: string;
  name: string;
  target: number;
  done: number;
  price: number;
};

type Ship = {
  id: number;
  name: string;
  captain: string;
  ship_type: string;
  tonnage: number;
  realm: string;
  port: string;
  docked: BooleanLike;
  minutes_left: number;
  traded: number;
  expected: number;
  demands: CargoLine[];
  supplies: CargoLine[];
};

type Data = {
  budget: number;
  manager: BooleanLike;
  has_account: BooleanLike;
  duty_dodged: BooleanLike;
  duty_rate: number;
  tariff_rate: number;
  middleman_cut: number;
  duty_collected: number;
  duty_evaded: number;
  hails_left: number;
  dock_spots: number;
  docked: Ship[];
  offshore: Ship[];
};

const Cargo = (props: {
  title: string;
  lines: CargoLine[];
  buying?: { ship: Ship; budget: number };
}) => {
  const { act } = useBackend<Data>();
  const { title, lines, buying } = props;
  const [amounts, setAmounts] = useState<Record<string, number>>({});
  if (!lines.length) {
    return null;
  }
  return (
    <Box mt={1}>
      <Box bold color="label">
        {title}
      </Box>
      <Table>
        {lines.map((line) => {
          const left = line.target - line.done;
          const amount = Math.min(amounts[line.good] || 1, Math.max(left, 1));
          return (
            <Table.Row key={line.good} className="candystripe">
              <Table.Cell>{line.name}</Table.Cell>
              <Table.Cell collapsing>
                {line.done}/{line.target}
              </Table.Cell>
              <Table.Cell collapsing>{line.price}m each</Table.Cell>
              {!!buying && (
                <>
                  <Table.Cell collapsing>
                    <NumberInput
                      value={amount}
                      minValue={1}
                      maxValue={Math.max(left, 1)}
                      step={1}
                      width="40px"
                      onChange={(value) =>
                        setAmounts((current) => ({
                          ...current,
                          [line.good]: value,
                        }))
                      }
                    />
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      disabled={
                        left <= 0 || line.price * amount > buying.budget
                      }
                      onClick={() =>
                        act('buy', {
                          id: buying.ship.id,
                          good: line.good,
                          qty: amount,
                        })
                      }
                    >
                      Buy
                    </Button>
                  </Table.Cell>
                </>
              )}
            </Table.Row>
          );
        })}
      </Table>
    </Box>
  );
};

const ShipSection = (props: { ship: Ship; data: Data }) => {
  const { act } = useBackend<Data>();
  const { ship, data } = props;
  return (
    <Section
      title={`${ship.ship_type} ${ship.name}`}
      buttons={
        !!data.manager &&
        (ship.docked ? (
          <Button
            icon="anchor"
            onClick={() => act('send_away', { id: ship.id })}
          >
            Send away
          </Button>
        ) : (
          <Button
            icon="bullhorn"
            disabled={
              data.hails_left <= 0 || data.docked.length >= data.dock_spots
            }
            onClick={() => act('hail', { id: ship.id })}
          >
            Hail
          </Button>
        ))
      }
    >
      <Box color="label">
        {ship.realm}
        {ship.port && ` (${ship.port})`}, captain {ship.captain}, {ship.tonnage}{' '}
        tons.
        {!!ship.docked &&
          ` At the pier for ${ship.minutes_left} more minutes. Traded ${ship.traded} of the ${ship.expected}m the captain hopes for.`}
      </Box>
      <Cargo title="Buys" lines={ship.demands} />
      <Cargo
        title="Sells"
        lines={ship.supplies}
        buying={
          data.manager && ship.docked
            ? { ship, budget: data.budget }
            : undefined
        }
      />
    </Section>
  );
};

/** The harbor: ships at the pier and offshore (Ratwood ShipFulfillment.tsx and the GOLDFACE harbor tab). */
export const RogueHarbor = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState('docked');
  const shown = tab === 'offshore' ? data.offshore : data.docked;
  return (
    <Window width={620} height={640}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section
              title="Harbor ledger"
              buttons={
                <Button
                  icon="coins"
                  disabled={data.budget <= 0}
                  onClick={() => act('change')}
                >
                  Change ({data.budget}m)
                </Button>
              }
            >
              <Box color="label">
                Use goods the ships buy on the crate; the payout goes to your
                NERVELOCK account, less the Crown&apos;s export duty (
                {data.duty_rate}%) and the merchant&apos;s cut (
                {data.middleman_cut}%).
              </Box>
              {!data.has_account && (
                <NoticeBox mt={1}>
                  No account: submit your fingers to a NERVELOCK before selling.
                </NoticeBox>
              )}
              {!!data.manager && (
                <Stack mt={1} align="center">
                  <Stack.Item grow>
                    Hails left today: {data.hails_left}. Piers:{' '}
                    {data.docked.length}/{data.dock_spots}. Import tariff:{' '}
                    {data.tariff_rate}%.
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="percent" onClick={() => act('set_cut')}>
                      Set cut
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Checkbox
                      checked={!!data.duty_dodged}
                      onClick={() => act('toggle_duty')}
                    >
                      Stop paying duties
                    </Button.Checkbox>
                  </Stack.Item>
                </Stack>
              )}
              {!!data.manager && (
                <Box mt={1} color="label">
                  Duties paid here: {data.duty_collected}m, dodged:{' '}
                  {data.duty_evaded}m.
                </Box>
              )}
            </Section>
          </Stack.Item>
          {!!data.manager && (
            <Stack.Item>
              <Tabs fluid>
                <Tabs.Tab
                  selected={tab === 'docked'}
                  onClick={() => setTab('docked')}
                >
                  At the pier ({data.docked.length})
                </Tabs.Tab>
                <Tabs.Tab
                  selected={tab === 'offshore'}
                  onClick={() => setTab('offshore')}
                >
                  Offshore ({data.offshore.length})
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Section fill scrollable>
              {shown.length === 0 && (
                <NoticeBox>
                  {tab === 'offshore'
                    ? 'No sails on the horizon.'
                    : 'No vessels at the pier.'}
                </NoticeBox>
              )}
              {shown.map((ship) => (
                <ShipSection key={ship.id} ship={ship} data={data} />
              ))}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
