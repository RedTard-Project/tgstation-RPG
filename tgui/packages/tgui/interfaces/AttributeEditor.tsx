import { useState } from 'react';
import {
  Button,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Entry = {
  name: string;
  type: string;
  value: number | null;
  raw_value: number | null;
};

type Data = {
  parent: string;
  attribute_min: number;
  attribute_max: number;
  attribute_default: number;
  skill_min: number;
  skill_max: number;
  skill_default: number | null;
  attributes: Entry[];
  skills: Entry[];
};

const LIMITS: [string, keyof Data][] = [
  ['Attribute min', 'attribute_min'],
  ['Attribute max', 'attribute_max'],
  ['Attribute default', 'attribute_default'],
  ['Skill min', 'skill_min'],
  ['Skill max', 'skill_max'],
  ['Skill default', 'skill_default'],
];

const EntryTable = (props: { entries: Entry[]; min: number; max: number }) => {
  const { act } = useBackend<Data>();
  const { entries, min, max } = props;
  return (
    <Table>
      <Table.Row header>
        <Table.Cell>Name</Table.Cell>
        <Table.Cell collapsing>Value</Table.Cell>
        <Table.Cell collapsing>Bonus</Table.Cell>
        <Table.Cell collapsing />
        <Table.Cell collapsing>Raw</Table.Cell>
        <Table.Cell collapsing />
      </Table.Row>
      {entries.map((entry) => {
        const raw = entry.raw_value ?? 0;
        const bonus = (entry.value ?? 0) - raw;
        return (
          <Table.Row key={entry.type} className="candystripe">
            <Table.Cell>{entry.name}</Table.Cell>
            <Table.Cell>{entry.value ?? '-'}</Table.Cell>
            <Table.Cell>
              <NumberInput
                width="50px"
                value={bonus}
                minValue={-100}
                maxValue={100}
                step={1}
                onChange={(value) =>
                  act('change_attribute', {
                    attribute_type: entry.type,
                    new_value: value,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                compact
                tooltip="Remove the admin bonus"
                onClick={() =>
                  act('null_attribute', { attribute_type: entry.type })
                }
              >
                ×
              </Button>
            </Table.Cell>
            <Table.Cell>
              <NumberInput
                width="50px"
                value={raw}
                minValue={min}
                maxValue={max}
                step={1}
                onChange={(value) =>
                  act('change_raw_attribute', {
                    attribute_type: entry.type,
                    new_value: value,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                compact
                tooltip="Reset raw to the default (skills: unknown)"
                onClick={() =>
                  act('null_raw_attribute', { attribute_type: entry.type })
                }
              >
                ×
              </Button>
            </Table.Cell>
          </Table.Row>
        );
      })}
    </Table>
  );
};

export const AttributeEditor = () => {
  const { act, data } = useBackend<Data>();
  const [search, setSearch] = useState('');
  const attributes = data.attributes || [];
  const skills = (data.skills || []).filter(
    (skill) =>
      !search || skill.name.toLowerCase().includes(search.toLowerCase()),
  );
  return (
    <Window
      title={data.parent ? `${data.parent} - Attribute Editor` : 'Attribute Editor'}
      width={900}
      height={700}
    >
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Limits">
              <LabeledList>
                {LIMITS.map(([label, varName]) => (
                  <LabeledList.Item
                    key={varName}
                    label={label}
                    buttons={
                      <Button
                        compact
                        onClick={() => act('null_var', { var_name: varName })}
                      >
                        Default
                      </Button>
                    }
                  >
                    <NumberInput
                      width="60px"
                      value={Number(data[varName] ?? 0)}
                      minValue={-100}
                      maxValue={100}
                      step={1}
                      onChange={(value) =>
                        act('change_var', { var_name: varName, var_value: value })
                      }
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item grow basis={0}>
                <Section fill scrollable title={`Attributes (${attributes.length})`}>
                  <EntryTable
                    entries={attributes}
                    min={data.attribute_min}
                    max={data.attribute_max}
                  />
                </Section>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Section
                  fill
                  scrollable
                  title={`Skills (${skills.length})`}
                  buttons={
                    <Input
                      placeholder="Search..."
                      value={search}
                      onChange={setSearch}
                    />
                  }
                >
                  <EntryTable
                    entries={skills}
                    min={data.skill_min}
                    max={data.skill_max}
                  />
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
