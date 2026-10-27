import { useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  Section,
  Stack,
  Table,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import type { RogueStock } from './RogueStockpile';

type LedgerEntry = {
  amount: number;
  reason: string | null;
};

type Levy = {
  name: string;
  percent: number;
};

type Wage = {
  title: string;
  wage: number;
};

type Account = {
  ref: string;
  holder: string;
  job: string | null;
  balance: number;
  estate: number;
  suspended: BooleanLike;
  fined: BooleanLike;
};

type Data = {
  purse: number;
  floor: number;
  ledger: LedgerEntry[];
  totals: Record<string, number>;
  levies: Levy[];
  levy_locked: BooleanLike;
  wages: Wage[];
  accounts: Account[];
  stocks: RogueStock[];
};

const TOTALS: [string, string][] = [
  ['rural_tax', 'Rural tax'],
  ['tariff', 'Import tariff'],
  ['wages', 'Wages paid'],
  ['export', 'Exports'],
  ['import', 'Imports'],
  ['trade', 'Stockpile trade'],
];

/** Nerve master: the Steward's treasury desk (Ratwood steward.dm and StewardTrade.tsx, cut to the money loop). */
export const RogueStewardry = () => {
  const { data } = useBackend<Data>();
  const [tab, setTab] = useState('treasury');
  return (
    <Window title="Nerve Master" width={720} height={620}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                selected={tab === 'treasury'}
                onClick={() => setTab('treasury')}
              >
                Crown&apos;s Purse: {data.purse}m
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'wages'}
                onClick={() => setTab('wages')}
              >
                Wages
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'accounts'}
                onClick={() => setTab('accounts')}
              >
                Accounts
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'stockpile'}
                onClick={() => setTab('stockpile')}
              >
                Stockpile
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            {tab === 'treasury' && <Treasury />}
            {tab === 'wages' && <Wages />}
            {tab === 'accounts' && <Accounts />}
            {tab === 'stockpile' && <Stockpile />}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Treasury = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section
          title="Crown's Purse"
          buttons={
            <Button icon="coins" onClick={() => act('withdraw')}>
              Withdraw coins
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Balance">{data.purse} mammons</LabeledList.Item>
            <LabeledList.Item
              label="Purchase floor"
              buttons={<Button onClick={() => act('set_floor')}>Set</Button>}
            >
              {data.floor} mammons
            </LabeledList.Item>
            {(data.levies || []).map((levy) => (
              <LabeledList.Item
                key={levy.name}
                label={levy.name}
                buttons={
                  <Button
                    disabled={!!data.levy_locked}
                    tooltip={
                      data.levy_locked ? 'Levies change once a day.' : undefined
                    }
                    onClick={() => act('set_levy', { name: levy.name })}
                  >
                    Set
                  </Button>
                }
              >
                {levy.percent}%
              </LabeledList.Item>
            ))}
            {TOTALS.map(([key, label]) => (
              <LabeledList.Item key={key} label={label}>
                {data.totals?.[key] || 0}m
              </LabeledList.Item>
            ))}
          </LabeledList>
          <Box mt={1} color="label">
            Insert coins to deposit them in the Purse.
          </Box>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable title="Ledger">
          <Table>
            {(data.ledger || []).map((entry, i) => (
              <Table.Row key={i}>
                <Table.Cell collapsing color={entry.amount < 0 ? 'bad' : 'good'}>
                  {entry.amount > 0 ? `+${entry.amount}` : entry.amount}
                </Table.Cell>
                <Table.Cell>{entry.reason}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const Wages = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Section fill scrollable title="Daily wages, paid at dawn">
      <Table>
        {(data.wages || []).map((entry) => (
          <Table.Row key={entry.title} className="candystripe">
            <Table.Cell>{entry.title}</Table.Cell>
            <Table.Cell collapsing>{entry.wage}m</Table.Cell>
            <Table.Cell collapsing>
              <Button onClick={() => act('set_wage', { title: entry.title })}>
                Set
              </Button>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const Accounts = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Section fill scrollable title="NERVELOCK accounts">
      <Table>
        <Table.Row header>
          <Table.Cell>Holder</Table.Cell>
          <Table.Cell>Role</Table.Cell>
          <Table.Cell collapsing>Balance</Table.Cell>
          <Table.Cell collapsing />
        </Table.Row>
        {(data.accounts || []).map((account) => (
          <Table.Row key={account.ref} className="candystripe">
            <Table.Cell>{account.holder}</Table.Cell>
            <Table.Cell>
              {account.job}
              {account.estate > 0 && (
                <Box inline color="label">
                  &nbsp;(estate {account.estate}m)
                </Box>
              )}
            </Table.Cell>
            <Table.Cell collapsing>{account.balance}m</Table.Cell>
            <Table.Cell collapsing>
              <Button
                compact
                onClick={() => act('grant', { ref: account.ref })}
              >
                Grant
              </Button>
              <Button
                compact
                disabled={!!account.fined}
                tooltip={account.fined ? 'Fined today.' : undefined}
                onClick={() => act('fine', { ref: account.ref })}
              >
                Fine
              </Button>
              <Button.Checkbox
                compact
                checked={!!account.suspended}
                onClick={() => act('toggle_wages', { ref: account.ref })}
              >
                Withhold wage
              </Button.Checkbox>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const Stockpile = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Section fill scrollable title="The Crown's stockpile">
      <Table>
        <Table.Row header>
          <Table.Cell>Good</Table.Cell>
          <Table.Cell collapsing>Stock</Table.Cell>
          <Table.Cell collapsing>Pays</Table.Cell>
          <Table.Cell collapsing>Sells</Table.Cell>
          <Table.Cell collapsing>Export</Table.Cell>
          <Table.Cell collapsing />
        </Table.Row>
        {(data.stocks || []).map((stock) => (
          <Table.Row key={stock.ref} className="candystripe">
            <Table.Cell>
              <Tooltip content={stock.desc}>
                <Box inline>{stock.name}</Box>
              </Tooltip>
              <Box inline color="label">
                &nbsp;({stock.category})
              </Box>
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                compact
                onClick={() => act('stock_limit', { ref: stock.ref })}
              >
                {stock.amount}/{stock.limit}
              </Button>
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                compact
                onClick={() => act('stock_payout', { ref: stock.ref })}
              >
                {stock.payout_price}m
              </Button>
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                compact
                onClick={() => act('stock_withdraw', { ref: stock.ref })}
              >
                {stock.withdraw_price}m
              </Button>
            </Table.Cell>
            <Table.Cell collapsing>{stock.export_price}m</Table.Cell>
            <Table.Cell collapsing>
              <Button.Checkbox
                compact
                checked={!!stock.accept_enabled}
                tooltip="The Crown buys this good from sellers."
                onClick={() => act('stock_accept', { ref: stock.ref })}
              >
                Buy
              </Button.Checkbox>
              <Button.Checkbox
                compact
                checked={!stock.withdraw_disabled}
                tooltip="Anyone may buy it; otherwise only the Crown's officers."
                onClick={() => act('stock_lock', { ref: stock.ref })}
              >
                Sell
              </Button.Checkbox>
              <Button.Checkbox
                compact
                checked={!stock.autoexport_disabled}
                tooltip="Ship the surplus abroad on its own."
                onClick={() => act('stock_autoexport', { ref: stock.ref })}
              >
                Auto
              </Button.Checkbox>
              <Button
                compact
                disabled={stock.amount <= 0}
                onClick={() => act('stock_export', { ref: stock.ref })}
              >
                Export
              </Button>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
