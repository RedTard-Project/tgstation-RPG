import { useState } from 'react';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type OrderLine = {
  name: string;
  needed: number;
  stocked: number;
};

type Order = {
  id: number;
  title: string;
  description: string;
  region: string;
  payout: number;
  days_left: number;
  lines: OrderLine[];
};

type Region = {
  name: string;
  subtitle: string;
  produces: string[];
  demands: string[];
};

type Data = {
  fiscal: BooleanLike;
  purse: number;
  orders: Order[];
  regions: Region[];
};

const Orders = () => {
  const { act, data } = useBackend<Data>();
  const orders = data.orders || [];
  if (!orders.length) {
    return <NoticeBox>No standing orders today.</NoticeBox>;
  }
  return (
    <>
      {orders.map((order) => {
        const ready = order.lines.every((line) => line.stocked >= line.needed);
        return (
          <Section
            key={order.id}
            title={order.title}
            buttons={
              !!data.fiscal && (
                <Button
                  icon="truck"
                  color={ready ? 'good' : undefined}
                  onClick={() => act('fulfill', { id: order.id })}
                >
                  Fulfill
                </Button>
              )
            }
          >
            <Box italic color="label">
              {order.description}
            </Box>
            <Table mt={1}>
              {order.lines.map((line) => (
                <Table.Row key={line.name} className="candystripe">
                  <Table.Cell>{line.name}</Table.Cell>
                  <Table.Cell
                    collapsing
                    color={line.stocked >= line.needed ? 'good' : 'average'}
                  >
                    {line.stocked}/{line.needed} in stock
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
            <Box mt={1}>
              Pays <b>{order.payout}</b> mammons to the Crown&apos;s Purse.
              Expires{' '}
              {order.days_left > 0
                ? `in ${order.days_left} dawn${order.days_left === 1 ? '' : 's'}`
                : 'at the next dawn'}
              .
            </Box>
          </Section>
        );
      })}
    </>
  );
};

const Regions = () => {
  const { data } = useBackend<Data>();
  return (
    <>
      {(data.regions || []).map((region) => (
        <Section key={region.name} title={region.name}>
          <Box italic color="label">
            {region.subtitle}
          </Box>
          <Box mt={1}>
            <b>Produces:</b> {region.produces.join(', ') || 'nothing'}
          </Box>
          <Box>
            <b>Demands:</b> {region.demands.join(', ') || 'nothing'}
          </Box>
        </Section>
      ))}
    </>
  );
};

/** Standing orders of the realm's regions (Ratwood's steward trade window, orders and regions only). */
export const RogueStandingOrders = () => {
  const { data } = useBackend<Data>();
  const [tab, setTab] = useState('orders');
  return (
    <Window width={560} height={620}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              Crown&apos;s Purse: <b>{data.purse}</b> mammons.
              {!data.fiscal &&
                " Only the Crown's officers may fill the orders."}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                selected={tab === 'orders'}
                onClick={() => setTab('orders')}
              >
                Standing orders ({(data.orders || []).length})
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'regions'}
                onClick={() => setTab('regions')}
              >
                Regions
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              {tab === 'orders' ? <Orders /> : <Regions />}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
