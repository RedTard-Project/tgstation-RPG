import { Box, Button, NoticeBox, Section, Table } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type DreamSkill = {
  type: string;
  name: string;
  next: string;
  cost: number;
  affordable: boolean;
};

type Data = {
  cycle: number;
  points: number;
  asleep: boolean;
  skills: DreamSkill[];
};

// Ratwood/Azure Peak dreams (sleep_adv show_ui()): spend dream points on skills whose experience waited for sleep.
export const RogueDreams = () => {
  const { act, data } = useBackend<Data>();
  const skills = data.skills || [];
  return (
    <Window title="Dreams" width={360} height={460}>
      <Window.Content scrollable>
        <Section
          title={`Cycle ${data.cycle}`}
          buttons={
            <Button icon="moon" onClick={() => act('continue')}>
              Continue
            </Button>
          }
        >
          <Box textAlign="center" italic mb={1}>
            Dream, for those who dream may reach higher heights.
          </Box>
          <Box textAlign="center" bold mb={1}>
            Dream points: {data.points}
          </Box>
          {!data.asleep && <NoticeBox>I am awake.</NoticeBox>}
          {skills.length === 0 ? (
            <NoticeBox>Nothing is ripe for learning yet.</NoticeBox>
          ) : (
            <Table>
              {skills.map((skill) => (
                <Table.Row key={skill.type} className="candystripe">
                  <Table.Cell>
                    <Button
                      fluid
                      disabled={!skill.affordable || !data.asleep}
                      onClick={() => act('buy', { type: skill.type })}
                    >
                      {skill.name} ({skill.next})
                    </Button>
                  </Table.Cell>
                  <Table.Cell collapsing>{skill.cost}</Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
          <Box textAlign="center" color="label" mt={1}>
            Your points will be retained.
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
