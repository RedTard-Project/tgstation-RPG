import { useState } from 'react';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export type RogueStock = {
  ref: string;
  name: string;
  desc: string;
  category: string;
  amount: number;
  limit: number;
  withdraw_price: number;
  payout_price: number;
  export_price: number;
  import_price: number;
  import_region?: string;
  withdraw_disabled: BooleanLike;
  accept_enabled: BooleanLike;
  autoexport_disabled: BooleanLike;
};

type Data = {
  buys: BooleanLike;
  budget: number;
  fiscal: BooleanLike;
  has_account: BooleanLike;
  below_floor: BooleanLike;
  stocks: RogueStock[];
};

/** The Crown's stockpile and vomitorium (Ratwood Stockpile.tsx, without market regions and events). */
export const RogueStockpile = () => {
  const { act, data } = useBackend<Data>();
  const stocks = data.stocks || [];
  const categories = Array.from(new Set(stocks.map((stock) => stock.category)));
  const [picked, setCategory] = useState('');
  const category = categories.includes(picked) ? picked : categories[0];
  const shown = stocks.filter((stock) => stock.category === category);
  return (
    <Window width={640} height={560}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section
              title={`Coinpouch: ${data.budget} mammons`}
              buttons={
                <Button
                  icon="coins"
                  disabled={data.budget <= 0}
                  onClick={() => act('refund')}
                >
                  Return change
                </Button>
              }
            >
              <Box color="label">
                Insert mammons to buy from the stockpile.
                {!!data.buys &&
                  ' Use a good on the machine to sell it to the Crown; the payout goes to your NERVELOCK account.'}
              </Box>
              {!!data.buys && !data.has_account && (
                <NoticeBox mt={1}>
                  No account: submit your fingers to a NERVELOCK before
                  selling.
                </NoticeBox>
              )}
              {!!data.buys && !!data.below_floor && (
                <NoticeBox mt={1} danger>
                  The Crown&apos;s ledger is thin. No purchases today.
                </NoticeBox>
              )}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Tabs fluid>
              {categories.map((name) => (
                <Tabs.Tab
                  key={name}
                  selected={name === category}
                  onClick={() => setCategory(name)}
                >
                  {name}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              <Table>
                <Table.Row header>
                  <Table.Cell>Good</Table.Cell>
                  <Table.Cell collapsing>Stock</Table.Cell>
                  {!!data.buys && <Table.Cell collapsing>Pays</Table.Cell>}
                  <Table.Cell collapsing>Price</Table.Cell>
                  <Table.Cell collapsing />
                </Table.Row>
                {shown.map((stock) => (
                  <Table.Row key={stock.ref} className="candystripe">
                    <Table.Cell>
                      <Tooltip content={stock.desc}>
                        <Box inline>{stock.name}</Box>
                      </Tooltip>
                    </Table.Cell>
                    <Table.Cell collapsing>
                      {stock.amount}/{stock.limit}
                    </Table.Cell>
                    {!!data.buys && (
                      <Table.Cell
                        collapsing
                        color={stock.accept_enabled ? undefined : 'label'}
                      >
                        {stock.accept_enabled ? stock.payout_price : '-'}
                      </Table.Cell>
                    )}
                    <Table.Cell collapsing>
                      {stock.amount > 0
                        ? stock.withdraw_price
                        : stock.import_price || '-'}
                    </Table.Cell>
                    <Table.Cell collapsing>
                      {stock.amount > 0 ? (
                        <Button
                          disabled={
                            (!!stock.withdraw_disabled && !data.fiscal) ||
                            stock.withdraw_price > data.budget
                          }
                          onClick={() => act('withdraw', { ref: stock.ref })}
                        >
                          Buy
                        </Button>
                      ) : (
                        <Button
                          tooltip={
                            stock.import_price
                              ? `None in stock: import one from ${stock.import_region} at the carriers' price.`
                              : 'No region supplies it today.'
                          }
                          disabled={
                            (!!stock.withdraw_disabled && !data.fiscal) ||
                            !stock.import_price ||
                            stock.import_price > data.budget
                          }
                          onClick={() => act('import', { ref: stock.ref })}
                        >
                          Import
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
