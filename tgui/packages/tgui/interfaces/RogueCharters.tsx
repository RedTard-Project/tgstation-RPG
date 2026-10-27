import {
  Box,
  Button,
  Collapsible,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Charter = {
  id: string;
  name: string;
  category: string;
  mechanical: string;
  flavor: string;
  active: BooleanLike;
  suspended: BooleanLike;
  cooldown: number;
};

type Data = {
  charters: Charter[];
  ruler: BooleanLike;
  revoked_today: BooleanLike;
  restored_today: BooleanLike;
  concessions: number;
  sequestered: BooleanLike;
};

/** Charters of the Realm (Ratwood DecreeSetter): everyone may read them, only the ruler revises them. */
export const RogueCharters = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Window title="Charters of the Realm" width={560} height={640}>
      <Window.Content scrollable>
        {!!data.sequestered && (
          <NoticeBox danger>
            The realm is sequestered: every charter but the Golden Bull stands
            suspended until the Company is repaid.
          </NoticeBox>
        )}
        {data.concessions > 0 && (
          <NoticeBox info>
            By ancient prerogative, {data.concessions} suspended charter
            {data.concessions === 1 ? '' : 's'} may be restored at once.
          </NoticeBox>
        )}
        {!data.ruler && (
          <Box color="label" mb={1}>
            Only the Grand Duke revokes and restores charters: one of each a
            day.
          </Box>
        )}
        <Stack vertical>
          {(data.charters || []).map((charter) => (
            <Stack.Item key={charter.id}>
              <Section
                title={charter.name}
                buttons={
                  <CharterButtons charter={charter} data={data} act={act} />
                }
              >
                <Box color={charter.active ? 'good' : 'bad'} mb={1}>
                  {charter.active ? 'In force' : 'Suspended'}
                  {charter.category === 'ancient' ? ', ancient' : ', new'}
                  {!!charter.suspended && ', by sequestration'}
                </Box>
                <Box mb={1}>{charter.mechanical}</Box>
                <Collapsible title="Read the charter">
                  <Box preserveWhitespace italic>
                    {charter.flavor}
                  </Box>
                </Collapsible>
              </Section>
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};

type ButtonsProps = {
  charter: Charter;
  data: Data;
  act: (action: string, payload?: object) => void;
};

const CharterButtons = (props: ButtonsProps) => {
  const { charter, data, act } = props;
  if (!data.ruler) {
    return null;
  }
  if (charter.suspended && !charter.active && data.concessions > 0) {
    return (
      <Button icon="crown" onClick={() => act('concede', { id: charter.id })}>
        Restore by prerogative
      </Button>
    );
  }
  const usedToday = charter.active ? data.revoked_today : data.restored_today;
  let blocker: string | undefined;
  if (charter.suspended && data.sequestered) {
    blocker = 'Suspended by the sequestration.';
  } else if (charter.cooldown > 0) {
    blocker = `The seal is still warm: ${charter.cooldown}s.`;
  } else if (usedToday) {
    blocker = charter.active
      ? 'A charter has already been revoked today.'
      : 'A charter has already been restored today.';
  }
  return (
    <Button
      color={charter.active ? 'bad' : 'good'}
      disabled={!!blocker}
      tooltip={blocker}
      onClick={() => act('toggle', { id: charter.id })}
    >
      {charter.active ? 'Revoke' : 'Restore'}
    </Button>
  );
};
