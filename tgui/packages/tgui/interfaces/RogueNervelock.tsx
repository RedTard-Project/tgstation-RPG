import { useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Coin = {
  kind: string;
  name: string;
  value: number;
};

type LedgerEntry = {
  amount: number;
  reason: string | null;
};

type Data = {
  holder: string | null;
  balance: number;
  wage: number;
  estate: number;
  tariff: number;
  ledger: LedgerEntry[];
  coins: Coin[];
  max_coins: number;
};

/** NERVELOCK: a subject's account at the realm's bank (Ratwood MeisterPanel, cut to the account itself). */
export const RogueNervelock = () => {
  const { act, data } = useBackend<Data>();
  const coins = data.coins || [];
  const [kind, setKind] = useState(coins[0]?.kind || '');
  const [count, setCount] = useState(1);
  const chosen = coins.find((coin) => coin.kind === kind) || coins[0];
  const total = (chosen?.value || 0) * count;
  return (
    <Window title="NERVELOCK" width={420} height={520}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title={data.holder || 'No account'}>
              <LabeledList>
                <LabeledList.Item label="Balance">
                  {data.balance} mammons
                </LabeledList.Item>
                {data.wage > 0 && (
                  <LabeledList.Item label="Daily wage">
                    {data.wage} mammons at dawn
                  </LabeledList.Item>
                )}
                {data.estate > 0 && (
                  <LabeledList.Item label="Estate income">
                    {data.estate} mammons at dawn
                  </LabeledList.Item>
                )}
                <LabeledList.Item label="Crown levies">
                  Import {data.tariff}%
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Withdraw">
              <Stack align="center">
                {coins.map((coin) => (
                  <Stack.Item key={coin.kind}>
                    <Button
                      selected={chosen?.kind === coin.kind}
                      onClick={() => setKind(coin.kind)}
                    >
                      {coin.name} ({coin.value})
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
              <Stack align="center" mt={1}>
                <Stack.Item>
                  <NumberInput
                    value={count}
                    minValue={1}
                    maxValue={data.max_coins}
                    step={1}
                    width="60px"
                    onChange={(value) => setCount(value)}
                  />
                </Stack.Item>
                <Stack.Item grow>coins = {total} mammons</Stack.Item>
                <Stack.Item>
                  <Button
                    icon="coins"
                    disabled={!chosen || total > data.balance}
                    onClick={() =>
                      act('withdraw', { kind: chosen?.kind, count: count })
                    }
                  >
                    Withdraw
                  </Button>
                </Stack.Item>
              </Stack>
              <Box mt={1} color="label">
                Insert coins to deposit them.
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title="Ledger">
              <Table>
                {(data.ledger || []).map((entry, i) => (
                  <Table.Row key={i}>
                    <Table.Cell
                      collapsing
                      color={entry.amount < 0 ? 'bad' : 'good'}
                    >
                      {entry.amount > 0 ? `+${entry.amount}` : entry.amount}
                    </Table.Cell>
                    <Table.Cell>{entry.reason}</Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
