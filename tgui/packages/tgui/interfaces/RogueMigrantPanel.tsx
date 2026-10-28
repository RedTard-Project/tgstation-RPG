// The migrant panel of medieval maps (modular_redtard/migrants/migrants.dm): Ratwood's and Azure Peak's MigrantPanel.
// The waves forming now take a queue for a role; the waves that may roll are listed with their chance, and triumphs
// pledged to a wave make it likelier.
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Role = {
  ref: string;
  name: string;
  amount: number;
  kind: 'required' | 'optional';
  stars: number;
  queued: BooleanLike;
  can_be: BooleanLike;
  desc: string | null;
  classes: string[];
};

type FormingWave = {
  track: string;
  ref: string;
  name: string;
  arrival_at: number;
  queued: BooleanLike;
  min_optional_fills: number;
  roles: Role[];
};

type Wave = {
  ref: string;
  name: string;
  track: string;
  roll_chance: number;
  maxed: BooleanLike;
  locked_until: number;
  min_optional_fills: number;
  roles: Role[];
  triumph_total: number;
  triumph_threshold: number;
  my_contribution: number;
};

type Data = {
  server_time: number;
  wave_number: number;
  active_migrants: number;
  player_triumph: number;
  queued_wave: string | null;
  queued_role: string | null;
  next_regular_at: number | null;
  next_special_at: number | null;
  forming: FormingWave[];
  waves: Wave[];
};

const clock = (deciseconds: number) => {
  const total = Math.max(0, Math.round(deciseconds / 10));
  return `${Math.floor(total / 60)}:${(total % 60).toString().padStart(2, '0')}`;
};

const roleTooltip = (role: Role) =>
  [
    role.desc,
    role.classes.length ? `Classes: ${role.classes.join(', ')}` : null,
    role.can_be ? null : 'Your character cannot be this role.',
  ]
    .filter(Boolean)
    .join('\n');

export const RogueMigrantPanel = () => {
  const { act, data } = useBackend<Data>();
  const { forming, waves, server_time, queued_wave } = data;

  return (
    <Window title="Migration" width={520} height={620}>
      <Window.Content scrollable>
        <Section
          title={`Wave ${data.wave_number}`}
          buttons={
            !!queued_wave && (
              <Button icon="xmark" onClick={() => act('clear_queue')}>
                Leave the queue
              </Button>
            )
          }
        >
          <Stack vertical>
            <Stack.Item>Migrants queued: {data.active_migrants}</Stack.Item>
            <Stack.Item>My triumphs: {data.player_triumph}</Stack.Item>
            {!!data.next_regular_at && (
              <Stack.Item>
                Next regular wave in {clock(data.next_regular_at - server_time)}
              </Stack.Item>
            )}
            {!!data.next_special_at && (
              <Stack.Item>
                Next special wave in {clock(data.next_special_at - server_time)}
              </Stack.Item>
            )}
          </Stack>
        </Section>
        <Section title="Forming now">
          {forming.length === 0 && (
            <NoticeBox info>
              No wave is forming. When one rolls, queue for a role in it here.
            </NoticeBox>
          )}
          {forming.map((wave) => (
            <Section
              key={wave.ref}
              title={
                wave.track === 'triumph' ? `${wave.name} (pledged)` : wave.name
              }
              buttons={
                <Box color="good">
                  Arrives in {clock(wave.arrival_at - server_time)}
                </Box>
              }
            >
              <RoleList wave={wave} />
            </Section>
          ))}
        </Section>
        <Section title="Waves">
          {waves.map((wave) => (
            <Box key={wave.ref} mb={1}>
              <Stack>
                <Stack.Item grow bold>
                  {wave.name}
                </Stack.Item>
                <Stack.Item color="label">
                  {wave.maxed
                    ? 'Already came'
                    : wave.locked_until > server_time
                      ? `Locked for ${clock(wave.locked_until - server_time)}`
                      : `${wave.track}, ${wave.roll_chance}%`}
                </Stack.Item>
              </Stack>
              <Box color="label">
                {wave.roles
                  .map(
                    (role) =>
                      `${role.name}${role.amount > 1 ? ` x${role.amount}` : ''}${role.kind === 'optional' ? ' (optional)' : ''}`,
                  )
                  .join(', ')}
              </Box>
              <Stack align="center">
                <Stack.Item
                  grow
                  color={
                    wave.triumph_total >= wave.triumph_threshold
                      ? 'good'
                      : 'label'
                  }
                >
                  Triumphs pledged: {wave.triumph_total}/
                  {wave.triumph_threshold}
                  {wave.my_contribution > 0 &&
                    ` (mine: ${wave.my_contribution})`}
                </Stack.Item>
                <Stack.Item>
                  <Button
                    compact
                    icon="crown"
                    disabled={!!wave.maxed || data.player_triumph <= 0}
                    tooltip="Pledge triumphs: each makes the wave likelier, pledgers take their roles first, and at the threshold it forms next."
                    onClick={() => act('pledge', { wave: wave.ref })}
                  >
                    Pledge
                  </Button>
                </Stack.Item>
              </Stack>
            </Box>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};

const RoleList = (props: { wave: FormingWave }) => {
  const { act } = useBackend<Data>();
  const { wave } = props;
  const required = wave.roles.filter((role) => role.kind === 'required');
  const optional = wave.roles.filter((role) => role.kind === 'optional');

  const row = (role: Role) => {
    const claimed = !!wave.queued && !!role.queued;
    return (
      <Stack.Item key={role.ref}>
        <Tooltip content={roleTooltip(role)}>
          <Button
            fluid
            selected={claimed}
            disabled={!role.can_be}
            icon={claimed ? 'check' : undefined}
            onClick={() =>
              act('queue_role', { wave: wave.ref, role: role.ref })
            }
          >
            {role.name} x{role.amount}
            {role.stars > 0 && ` ${'★'.repeat(Math.min(role.stars, 5))}`}
          </Button>
        </Tooltip>
      </Stack.Item>
    );
  };

  return (
    <Stack vertical>
      {required.length > 0 && (
        <>
          <Stack.Item color="average">
            Required: must be filled or the wave will not arrive.
          </Stack.Item>
          {required.map(row)}
        </>
      )}
      {optional.length > 0 && (
        <>
          <Stack.Item color="label">
            {wave.min_optional_fills > 0
              ? `Optional: at least ${wave.min_optional_fills} must join.`
              : 'Optional: empty slots are fine.'}
          </Stack.Item>
          {optional.map(row)}
        </>
      )}
    </Stack>
  );
};
