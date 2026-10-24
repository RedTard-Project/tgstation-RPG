import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type StatMeta = {
  key: string;
  name: string;
  shorthand: string;
  desc: string;
};

type SkillDefault = {
  name: string;
  value: number;
};

type SkillMeta = {
  key: string;
  name: string;
  desc: string;
  difficulty: string;
  governing: string | null;
  defaults: SkillDefault[];
};

type Category = {
  name: string;
  skills: SkillMeta[];
};

type StatValue = {
  base: number;
  value: number;
  level: string;
};

type SkillValue = {
  base: number | null;
  value: number | null;
  governing: number;
  defaulted: number;
  level: string;
  rank: number;
  trained: BooleanLike;
  xp: number;
  xp_floor: number;
  xp_next: number;
};

type Modifier = {
  id: string;
  changes: SkillDefault[];
};

type Data = {
  name: string;
  stats: Record<string, StatValue>;
  skills: Record<string, SkillValue>;
  modifiers: Modifier[];
  stat_meta: StatMeta[];
  categories: Category[];
};

const signed = (value: number) => (value > 0 ? `+${value}` : `${value}`);

const valueColor = (value: number | null, base: number | null) => {
  if (value === null || base === null || value === base) {
    return undefined;
  }
  return value > base ? 'good' : 'bad';
};

const StatsSection = (props: {
  meta: StatMeta[];
  values: Record<string, StatValue>;
}) => {
  const { meta, values } = props;
  return (
    <Section title="Stats">
      <Table>
        {meta.map((stat) => {
          const value = values[stat.key];
          if (!value) {
            return null;
          }
          return (
            <Table.Row key={stat.key} className="candystripe">
              <Table.Cell>
                <Tooltip content={stat.desc}>
                  <Box inline bold>
                    {stat.name} ({stat.shorthand})
                  </Box>
                </Tooltip>
              </Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Box bold color={valueColor(value.value, value.base)}>
                  {value.value}
                </Box>
              </Table.Cell>
              <Table.Cell collapsing color="label">
                {value.value !== value.base ? `base ${value.base}` : ''}
              </Table.Cell>
              <Table.Cell collapsing italic>
                {value.level}
              </Table.Cell>
            </Table.Row>
          );
        })}
      </Table>
    </Section>
  );
};

const skillTooltip = (skill: SkillMeta, value: SkillValue) => {
  const lines = [skill.desc, `Difficulty: ${skill.difficulty}`];
  if (skill.governing) {
    lines.push(`Governed by ${skill.governing}`);
  }
  if (skill.defaults.length) {
    lines.push(
      `Defaults: ${skill.defaults
        .map((entry) => `${entry.name} ${signed(entry.value)}`)
        .join(', ')}`,
    );
  }
  if (value.governing) {
    lines.push(`Governing bonus: ${signed(value.governing)}`);
  }
  if (value.defaulted) {
    lines.push(`Defaulted: ${signed(value.defaulted)}`);
  }
  return lines.join('\n');
};

const SkillRow = (props: { skill: SkillMeta; value: SkillValue }) => {
  const { skill, value } = props;
  const span = Math.max(1, value.xp_next - value.xp_floor);
  const progress = value.trained
    ? Math.min(1, Math.max(0, (value.xp - value.xp_floor) / span))
    : 0;
  return (
    <Table.Row className="candystripe">
      <Table.Cell>
        <Tooltip content={skillTooltip(skill, value)}>
          <Box inline bold={!!value.trained} color={value.trained ? undefined : 'label'}>
            {skill.name}
          </Box>
        </Tooltip>
      </Table.Cell>
      <Table.Cell collapsing italic>
        {value.level}
      </Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Box bold color={valueColor(value.value, value.base)}>
          {value.value ?? '—'}
        </Box>
      </Table.Cell>
      <Table.Cell width="30%">
        {value.trained ? (
          <ProgressBar value={progress} color="good">
            {value.xp} / {value.xp_next} xp
          </ProgressBar>
        ) : null}
      </Table.Cell>
    </Table.Row>
  );
};

const SkillsSection = (props: {
  categories: Category[];
  values: Record<string, SkillValue>;
}) => {
  const { categories, values } = props;
  const [showUntrained, setShowUntrained] = useState(false);
  const [search, setSearch] = useState('');
  const needle = search.trim().toLowerCase();
  const visible = categories
    .map((category) => ({
      name: category.name,
      skills: category.skills.filter((skill) => {
        const value = values[skill.key];
        if (!value) {
          return false;
        }
        if (needle && !skill.name.toLowerCase().includes(needle)) {
          return false;
        }
        return showUntrained || !!value.trained;
      }),
    }))
    .filter((category) => category.skills.length);
  return (
    <Section
      title="Skills"
      buttons={
        <Stack>
          <Stack.Item>
            <Input
              placeholder="Search..."
              value={search}
              onChange={setSearch}
            />
          </Stack.Item>
          <Stack.Item>
            <Button.Checkbox
              checked={showUntrained}
              onClick={() => setShowUntrained(!showUntrained)}
            >
              Untrained
            </Button.Checkbox>
          </Stack.Item>
        </Stack>
      }
    >
      {visible.length === 0 ? (
        <NoticeBox>I am genuinely, absolutely and completely useless.</NoticeBox>
      ) : (
        visible.map((category) => (
          <Section key={category.name} title={category.name}>
            <Table>
              {category.skills.map((skill) => (
                <SkillRow
                  key={skill.key}
                  skill={skill}
                  value={values[skill.key]}
                />
              ))}
            </Table>
          </Section>
        ))
      )}
    </Section>
  );
};

const ModifiersSection = (props: { modifiers: Modifier[] }) => {
  const { modifiers } = props;
  if (!modifiers.length) {
    return null;
  }
  return (
    <Section title="Modifiers">
      <Table>
        {modifiers.map((modifier) => (
          <Table.Row key={modifier.id} className="candystripe">
            <Table.Cell bold>{modifier.id}</Table.Cell>
            <Table.Cell>
              {modifier.changes
                .map((change) => `${change.name} ${signed(change.value)}`)
                .join(', ')}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const RogueAttributes = () => {
  const { data } = useBackend<Data>();
  const {
    name,
    stat_meta = [],
    categories = [],
    stats = {},
    skills = {},
    modifiers = [],
  } = data;
  return (
    <Window title={`Attributes of ${name}`} width={620} height={720}>
      <Window.Content scrollable>
        <StatsSection meta={stat_meta} values={stats} />
        <SkillsSection categories={categories} values={skills} />
        <ModifiersSection modifiers={modifiers} />
      </Window.Content>
    </Window>
  );
};
