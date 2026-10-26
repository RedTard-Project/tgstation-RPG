import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Pack = {
  ref: string;
  name: string;
  category: string;
  qty: number;
  cost: number;
  base: number;
};

type Data = {
  motto: string;
  categories: string[];
  is_public: BooleanLike;
  packs: Pack[];
  budget: number;
  tariff_rate: number;
  dodging: BooleanLike;
  proprietor: BooleanLike;
  tariff_paid: number;
  tariff_dodged: number;
};

/** GOLDFACE: the merchant's import catalog (Ratwood Goldface.tsx, without the harbor and catalogs). */
export const RogueGoldface = () => {
  const { act, data } = useBackend<Data>();
  const categories = data.categories || [];
  const [picked, setCategory] = useState('');
  const [search, setSearch] = useState('');
  const category = categories.includes(picked) ? picked : categories[0];
  const needle = search.trim().toLowerCase();
  const shown = (data.packs || [])
    .filter((pack) =>
      needle
        ? pack.name.toLowerCase().includes(needle) ||
          pack.category.toLowerCase().includes(needle)
        : pack.category === category,
    )
    .sort((a, b) => a.name.localeCompare(b.name));
  const tariff = (pack: Pack) => Math.floor(data.tariff_rate * pack.cost);
  return (
    <Window width={720} height={600}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section
              title={data.motto}
              buttons={
                <Button
                  icon="coins"
                  disabled={data.budget <= 0}
                  onClick={() => act('change')}
                >
                  Change
                </Button>
              }
            >
              <Stack align="center">
                <Stack.Item grow>
                  Budget: <b>{data.budget}</b> mammons. Crown import tariff:{' '}
                  {Math.round(data.tariff_rate * 100)}%.
                </Stack.Item>
                {!!data.proprietor && (
                  <Stack.Item>
                    <Button.Checkbox
                      checked={!!data.dodging}
                      onClick={() => act('toggle_tariff')}
                    >
                      Stop paying taxes
                    </Button.Checkbox>
                  </Stack.Item>
                )}
              </Stack>
              {!!data.proprietor && (
                <Box mt={1} color="label">
                  Tariff paid here: {data.tariff_paid}m, dodged:{' '}
                  {data.tariff_dodged}m.
                </Box>
              )}
              <Input
                mt={1}
                fluid
                placeholder="Search the catalog..."
                value={search}
                onChange={setSearch}
              />
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              {!needle && (
                <Stack.Item width="190px">
                  <Section fill scrollable>
                    <Tabs vertical>
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
                  </Section>
                </Stack.Item>
              )}
              <Stack.Item grow>
                <Section fill scrollable title={needle ? 'Search' : category}>
                  {shown.length === 0 && (
                    <NoticeBox>Nothing to import here.</NoticeBox>
                  )}
                  <Table>
                    {shown.map((pack) => {
                      const price = pack.base + tariff(pack);
                      return (
                        <Table.Row key={pack.ref} className="candystripe">
                          <Table.Cell>
                            {pack.name}
                            {pack.qty > 1 && ` x${pack.qty}`}
                          </Table.Cell>
                          <Table.Cell collapsing>
                            {price}m
                            {tariff(pack) > 0 && (
                              <Box inline color="label">
                                &nbsp;(+{tariff(pack)} tariff)
                              </Box>
                            )}
                          </Table.Cell>
                          <Table.Cell collapsing>
                            <Button
                              disabled={price > data.budget}
                              onClick={() => act('buy', { ref: pack.ref })}
                            >
                              Buy
                            </Button>
                          </Table.Cell>
                        </Table.Row>
                      );
                    })}
                  </Table>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
