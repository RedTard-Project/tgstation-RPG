import { useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Stat = {
  name: string;
  value: number;
};

type Skill = {
  name: string;
  level: string;
};

type ClassEntry = {
  type: string;
  name: string;
  desc: string | null;
  stats: Stat[];
  skills: Skill[];
  traits: string[];
  slots: number | null;
};

type Data = {
  job: string;
  classes: ClassEntry[];
  seconds_left: number;
};

export const RockhillClassSelect = () => {
  const { act, data } = useBackend<Data>();
  const classes = data.classes || [];
  const [selectedType, setSelectedType] = useState<string | null>(null);
  const selected =
    classes.find((entry) => entry.type === selectedType) || classes[0];
  return (
    <Window title={`${data.job}: choose your calling`} width={760} height={560}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="230px">
            <Section fill scrollable title="Callings">
              {classes.map((entry) => (
                <Button
                  key={entry.type}
                  fluid
                  selected={selected?.type === entry.type}
                  onClick={() => setSelectedType(entry.type)}
                >
                  {entry.name}
                  {entry.slots !== null && ` (${entry.slots} left)`}
                </Button>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            {selected ? (
              <Section
                fill
                scrollable
                title={selected.name}
                buttons={
                  <Button
                    icon="check"
                    color="good"
                    onClick={() => act('choose', { type: selected.type })}
                  >
                    Choose
                  </Button>
                }
              >
                <NoticeBox info>
                  Chosen automatically in {data.seconds_left} s.
                </NoticeBox>
                {selected.desc && <Box mb={1}>{selected.desc}</Box>}
                {selected.stats.length > 0 && (
                  <LabeledList>
                    {selected.stats.map((stat) => (
                      <LabeledList.Item key={stat.name} label={stat.name}>
                        <Box color={stat.value >= 0 ? 'good' : 'bad'}>
                          {stat.value >= 0 ? `+${stat.value}` : stat.value}
                        </Box>
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                )}
                {selected.skills.length > 0 && (
                  <Table mt={1}>
                    {selected.skills.map((skill) => (
                      <Table.Row key={skill.name} className="candystripe">
                        <Table.Cell>{skill.name}</Table.Cell>
                        <Table.Cell collapsing>{skill.level}</Table.Cell>
                      </Table.Row>
                    ))}
                  </Table>
                )}
                {selected.traits.length > 0 && (
                  <Box mt={1} color="label">
                    {selected.traits.join(', ')}
                  </Box>
                )}
              </Section>
            ) : (
              <NoticeBox>No calling is free.</NoticeBox>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
