import { useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import type { RogueLoan } from './RogueStewardry';

type Poll = {
  class: string | null;
  rate: number;
  exempt: BooleanLike;
  owed: number;
  overdue: number;
  advance: number;
  advance_max: number;
  fallback: number;
  opened: BooleanLike;
};

type Data = {
  holder: string | null;
  balance: number;
  day: number;
  loan: RogueLoan | null;
  poll: Poll;
};

/** NERVELOCK, right click: a subject's loan and poll tax (Ratwood MeisterPanel, Loans and Poll Tax tabs). */
export const RogueDebts = () => {
  const { data } = useBackend<Data>();
  return (
    <Window title="NERVELOCK" width={420} height={460}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title={data.holder || 'No account'}>
              <LabeledList>
                <LabeledList.Item label="Balance">
                  {data.balance} mammons
                </LabeledList.Item>
                <LabeledList.Item label="Day">{data.day}</LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <LoanSection />
          </Stack.Item>
          <Stack.Item grow>
            <PollSection />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const LoanSection = () => {
  const { act, data } = useBackend<Data>();
  const loan = data.loan;
  const [amount, setAmount] = useState(1);
  if (!loan) {
    return (
      <Section title="Loan">
        <Box color="label">I owe no one.</Box>
      </Section>
    );
  }
  const most = Math.max(1, Math.min(loan.remaining, data.balance));
  return (
    <Section title={`Loan from ${loan.lender}`}>
      {!!loan.defaulted && (
        <NoticeBox danger>
          Defaulted. I am marked a defaulter until the debt is settled.
        </NoticeBox>
      )}
      <LabeledList>
        <LabeledList.Item label="Principal">
          {loan.principal}m at {loan.interest}% a day
        </LabeledList.Item>
        <LabeledList.Item label="Owed now">{loan.remaining}m</LabeledList.Item>
        <LabeledList.Item label="Due">
          dawn of day {loan.due_day} ({loan.days_left} dawn
          {loan.days_left === 1 ? '' : 's'} left)
        </LabeledList.Item>
      </LabeledList>
      <Stack align="center" mt={1}>
        <Stack.Item>
          <NumberInput
            value={Math.min(amount, most)}
            minValue={1}
            maxValue={most}
            step={1}
            width="70px"
            onChange={(value) => setAmount(value)}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="coins"
            disabled={data.balance <= 0}
            onClick={() => act('repay', { amount: Math.min(amount, most) })}
          >
            Repay
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const PollSection = () => {
  const { act, data } = useBackend<Data>();
  const poll = data.poll;
  const [days, setDays] = useState(1);
  if (!poll?.class) {
    return (
      <Section fill title="Poll tax">
        <Box color="label">The Crown does not tax my class.</Box>
      </Section>
    );
  }
  const room = Math.max(0, poll.advance_max - poll.advance);
  const perDay = poll.rate > 0 ? poll.rate : poll.fallback;
  let rateText = 'none';
  if (poll.exempt) {
    rateText = 'exempt by decree';
  } else if (poll.rate > 0) {
    rateText = `${poll.rate}m a dawn`;
  } else if (poll.rate < 0) {
    rateText = `${-poll.rate}m a dawn subsidy`;
  }
  const canAdvance =
    !!poll.opened && !poll.exempt && poll.rate >= 0 && room > 0;
  return (
    <Section fill title={`Poll tax: ${poll.class}`}>
      <LabeledList>
        <LabeledList.Item label="Rate">{rateText}</LabeledList.Item>
        {poll.owed > 0 && (
          <LabeledList.Item label="Owed" color="bad">
            {poll.owed}m, {poll.overdue} day{poll.overdue === 1 ? '' : 's'}{' '}
            overdue
          </LabeledList.Item>
        )}
        <LabeledList.Item label="Paid ahead">
          {poll.advance} of {poll.advance_max} days
        </LabeledList.Item>
      </LabeledList>
      <Stack align="center" mt={1}>
        <Stack.Item>
          <NumberInput
            value={Math.min(days, Math.max(1, room))}
            minValue={1}
            maxValue={Math.max(1, room)}
            step={1}
            width="50px"
            onChange={(value) => setDays(value)}
          />
        </Stack.Item>
        <Stack.Item grow>
          days = {Math.min(days, Math.max(1, room)) * perDay}m
        </Stack.Item>
        <Stack.Item>
          <Button
            disabled={!canAdvance}
            tooltip={
              poll.opened
                ? undefined
                : "The Crown's ledgers have not yet opened for the day."
            }
            onClick={() =>
              act('advance', { days: Math.min(days, Math.max(1, room)) })
            }
          >
            Pay ahead
          </Button>
        </Stack.Item>
      </Stack>
      <Box mt={1} color="label">
        What I owe is taken from the next coin that reaches my account.
      </Box>
    </Section>
  );
};
