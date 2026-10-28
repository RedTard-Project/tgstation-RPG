import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Recipe = {
  id: string;
  name: string;
  category: string;
  icon: string | null;
  desc: string | null;
  makes: string[];
  skill: string | null;
  level: string | null;
  needs: string[];
  tools: string[];
  liquids: string[];
  place: string[];
  price: number;
};

type Data = {
  title: string;
  recipes: Recipe[];
};

const ALL = 'All';

const byName = (a: Recipe, b: Recipe) => a.name.localeCompare(b.name);

const skillText = (recipe: Recipe) => {
  if (!recipe.skill) {
    return 'Anyone can make this.';
  }
  return recipe.level
    ? `${recipe.skill}: for those of ${recipe.level} skill.`
    : `${recipe.skill}: suitable for all skills.`;
};

const Lines = (props: { title: string; lines: string[] }) => {
  const { title, lines } = props;
  if (!lines.length) {
    return null;
  }
  return (
    <Box mt={1}>
      <Box bold>{title}</Box>
      {lines.map((line, index) => (
        <Box key={index} ml={1}>
          - {line}
        </Box>
      ))}
    </Box>
  );
};

const RecipeDetails = (props: { recipe: Recipe }) => {
  const { recipe } = props;
  return (
    <>
      <Stack align="center">
        {recipe.icon && (
          <Stack.Item>
            <Box width="64px" height="64px">
              <Box
                className={classes([recipe.icon])}
                style={{ transform: 'scale(2)', transformOrigin: 'top left' }}
              />
            </Box>
          </Stack.Item>
        )}
        <Stack.Item grow>
          {recipe.desc ? (
            <Box italic>{recipe.desc}</Box>
          ) : (
            <Box color="label">No description available.</Box>
          )}
        </Stack.Item>
      </Stack>
      <Box mt={1}>{skillText(recipe)}</Box>
      <Lines title="Makes" lines={recipe.makes} />
      <Lines title="Requirements" lines={recipe.needs} />
      <Lines title="Required tools" lines={recipe.tools} />
      <Lines title="Required liquids" lines={recipe.liquids} />
      <Lines title="Where" lines={recipe.place} />
      <Box mt={1} color="label">
        {recipe.price
          ? `You can sell this for ${recipe.price} mammons at a normal quality.`
          : 'This is worthless for export.'}
      </Box>
    </>
  );
};

// Ratwood's profession manual: sections, a search, and the chosen recipe.
export const RogueRecipeBook = () => {
  const { data } = useBackend<Data>();
  const recipes = data.recipes || [];
  const categories = [
    ALL,
    ...Array.from(new Set(recipes.map((recipe) => recipe.category))).sort(),
  ];
  const [category, setCategory] = useState(ALL);
  const [search, setSearch] = useState('');
  const [chosenId, setChosenId] = useState<string | null>(null);
  const needle = search.trim().toLowerCase();
  const shown = recipes
    .filter((recipe) =>
      needle
        ? recipe.name.toLowerCase().includes(needle)
        : category === ALL || recipe.category === category,
    )
    .sort(byName);
  const chosen = recipes.find((recipe) => recipe.id === chosenId);
  return (
    <Window title={data.title} width={760} height={600}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="40%">
            <Stack fill vertical>
              <Stack.Item>
                <Input
                  fluid
                  placeholder="Search recipes..."
                  value={search}
                  onChange={setSearch}
                />
              </Stack.Item>
              <Stack.Item>
                <Section>
                  {categories.map((name) => (
                    <Button
                      key={name}
                      selected={!needle && name === category}
                      onClick={() => {
                        setCategory(name);
                        setSearch('');
                      }}
                    >
                      {name}
                    </Button>
                  ))}
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section fill scrollable>
                  {shown.length === 0 && (
                    <NoticeBox>No matching recipes found.</NoticeBox>
                  )}
                  {shown.map((recipe) => (
                    <Button
                      key={recipe.id}
                      fluid
                      selected={recipe.id === chosenId}
                      onClick={() => setChosenId(recipe.id)}
                    >
                      {recipe.name}
                    </Button>
                  ))}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title={chosen ? chosen.name : 'Recipe'}>
              {chosen ? (
                <RecipeDetails recipe={chosen} />
              ) : (
                <Box color="label">
                  Select a recipe from the list to view details.
                </Box>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
