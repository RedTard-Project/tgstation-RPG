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
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Recipe = {
  ref: string;
  name: string;
  category: string;
  group: string;
  icon: string;
  bar: string | null;
  blade: string | null;
  materials: string[];
  count: number;
  skill: string | null;
  difficulty: string;
  desc: string | null;
};

type Data = {
  workpiece: string | null;
  current: string | null;
  recipes: Recipe[];
};

// What the work starts from: the bar, a cast blade, or either.
const startText = (recipe: Recipe) =>
  [recipe.bar, recipe.blade].filter(Boolean).join(' or ');

// Ratwood anvil window: recipes for the bar on the anvil, by tab and group.
export const RogueAnvil = () => {
  const { act, data } = useBackend<Data>();
  const recipes = data.recipes || [];
  const categories = Array.from(new Set(recipes.map((r) => r.category)));
  const [tab, setTab] = useState<string | null>(null);
  const [search, setSearch] = useState('');
  const shownTab = tab && categories.includes(tab) ? tab : categories[0];
  const needle = search.trim().toLowerCase();
  const shown = recipes.filter((recipe) =>
    needle
      ? recipe.name.toLowerCase().includes(needle)
      : recipe.category === shownTab,
  );
  const groups = Array.from(new Set(shown.map((r) => r.group)));
  return (
    <Window title="Anvil" width={620} height={600}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            {data.workpiece ? (
              <NoticeBox info>
                On the anvil: {data.workpiece}
                {data.current && ` (being worked into ${data.current})`}
              </NoticeBox>
            ) : (
              <NoticeBox>
                Nothing is on the anvil. These are all the recipes.
              </NoticeBox>
            )}
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <Tabs>
                  {categories.map((category) => (
                    <Tabs.Tab
                      key={category}
                      selected={!needle && category === shownTab}
                      onClick={() => {
                        setTab(category);
                        setSearch('');
                      }}
                    >
                      {category}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </Stack.Item>
              <Stack.Item>
                <Input
                  placeholder="Search..."
                  value={search}
                  onChange={setSearch}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              {shown.length === 0 && (
                <NoticeBox>Nothing can be made from this.</NoticeBox>
              )}
              {groups.map((group) => (
                <Section key={group} title={group}>
                  <Table>
                    {shown
                      .filter((recipe) => recipe.group === group)
                      .map((recipe) => (
                        <Table.Row key={recipe.ref} className="candystripe">
                          <Table.Cell collapsing>
                            <Box
                              className={classes([
                                'rogue_anvil32x32',
                                recipe.icon,
                              ])}
                            />
                          </Table.Cell>
                          <Table.Cell>
                            <Button
                              fluid
                              tooltip={recipe.desc || undefined}
                              disabled={!data.workpiece}
                              onClick={() =>
                                act('choose_recipe', { ref: recipe.ref })
                              }
                            >
                              {recipe.count > 1
                                ? `${recipe.name} (x${recipe.count})`
                                : recipe.name}
                            </Button>
                          </Table.Cell>
                          <Table.Cell collapsing color="label">
                            {startText(recipe)}
                            {recipe.materials.length > 0 &&
                              `, ${recipe.materials.join(', ')}`}
                          </Table.Cell>
                          <Table.Cell collapsing>
                            <Box color="label">
                              {recipe.skill}: {recipe.difficulty}
                            </Box>
                          </Table.Cell>
                        </Table.Row>
                      ))}
                  </Table>
                </Section>
              ))}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
