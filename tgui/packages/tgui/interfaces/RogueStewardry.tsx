import { useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  NumberInput,
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
  floor: number;
};

type Account = {
  ref: string;
  holder: string;
  job: string | null;
  balance: number;
  estate: number;
  suspended: BooleanLike;
  max_fine: number;
  poll_owed: number;
  poll_overdue: number;
  defaulter: BooleanLike;
};

type PollClass = {
  id: string;
  name: string;
  rate: number;
  heads: number;
  taxable: number;
  flow: number;
};

type Solvency = {
  state: string;
  sequestered: BooleanLike;
  debt: number;
  wage_outlay: number;
  ftc_blocker: string | null;
  ftc_min: number;
  ftc_max: number;
  ftc_interest: number;
};

export type RogueLoan = {
  ref: string;
  debtor: string;
  lender: string;
  lender_id: string;
  borrower_id: string | null;
  principal: number;
  interest: number;
  due_day: number;
  days_left: number;
  remaining: number;
  defaulted: BooleanLike;
};

type Fund = {
  id: string;
  holder: string;
  balance: number;
  lent: number;
};

type Data = {
  purse: number;
  floor: number;
  ledger: LedgerEntry[];
  totals: Record<string, number>;
  solvency: Solvency;
  levies: Levy[];
  levy_locked: BooleanLike;
  poll: { classes: PollClass[]; income: number; subsidy: number };
  poll_locked: BooleanLike;
  poll_min: number;
  poll_max: number;
  carta: BooleanLike;
  wages: Wage[];
  accounts: Account[];
  loans: RogueLoan[];
  funds: Fund[];
  stocks: RogueStock[];
};

const TOTALS: [string, string][] = [
  ['rural_tax', 'Rural tax'],
  ['tariff', 'Import tariff'],
  ['poll_tax', 'Poll tax'],
  ['poll_subsidy', 'Poll subsidies'],
  ['fines', 'Fines'],
  ['tithe', 'Concordat tithe'],
  ['wages', 'Wages paid'],
  ['export', 'Exports'],
  ['import', 'Imports'],
  ['trade', 'Stockpile trade'],
];

/** Nerve master: the Steward's treasury desk (Ratwood steward.dm, StewardTrade.tsx and TaxSetter.tsx, cut to the money loop). */
export const RogueStewardry = () => {
  const { data } = useBackend<Data>();
  const [tab, setTab] = useState('treasury');
  return (
    <Window title="Nerve Master" width={760} height={640}>
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
                selected={tab === 'poll'}
                onClick={() => setTab('poll')}
              >
                Poll tax
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
                selected={tab === 'loans'}
                onClick={() => setTab('loans')}
              >
                Loans
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
            {tab === 'poll' && <PollTax />}
            {tab === 'wages' && <Wages />}
            {tab === 'accounts' && <Accounts />}
            {tab === 'loans' && <Loans />}
            {tab === 'stockpile' && <Stockpile />}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Treasury = () => {
  const { act, data } = useBackend<Data>();
  const solvency = data.solvency;
  return (
    <Stack fill vertical>
      {!!solvency?.sequestered && (
        <Stack.Item>
          <NoticeBox danger>
            The realm is sequestered: wages stand suspended and the Company
            takes the Purse&apos;s income above its reserve.
          </NoticeBox>
        </Stack.Item>
      )}
      <Stack.Item>
        <Section
          title="Crown's Purse"
          buttons={
            <>
              <Button icon="scroll" onClick={() => act('charters')}>
                Charters
              </Button>
              <Button icon="coins" onClick={() => act('withdraw')}>
                Withdraw coins
              </Button>
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Balance">
              {data.purse} mammons
            </LabeledList.Item>
            <LabeledList.Item label="Solvency">
              {solvency?.state}
            </LabeledList.Item>
            <LabeledList.Item label="Wages due at dawn">
              {solvency?.wage_outlay}m
            </LabeledList.Item>
            <LabeledList.Item
              label="Debt to the Company"
              buttons={
                <Button
                  disabled={!!solvency?.ftc_blocker}
                  tooltip={
                    solvency?.ftc_blocker ||
                    `${solvency?.ftc_min}-${solvency?.ftc_max}m at ${solvency?.ftc_interest}% interest. The next payroll the Purse cannot meet means sequestration.`
                  }
                  onClick={() => act('ftc_loan')}
                >
                  Borrow
                </Button>
              }
            >
              {solvency?.debt || 0}m
            </LabeledList.Item>
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
  );
};

/** Ratwood TaxSetter: every class's rate is drafted here and proclaimed at once, once a day. */
const PollTax = () => {
  const { act, data } = useBackend<Data>();
  const classes = data.poll?.classes || [];
  const [draft, setDraft] = useState<Record<string, number>>({});
  const rateOf = (entry: PollClass) => draft[entry.id] ?? entry.rate;
  const changed = classes.some((entry) => rateOf(entry) !== entry.rate);
  return (
    <Section
      fill
      scrollable
      title="Poll tax, a head at every dawn"
      buttons={
        <Button
          icon="bullhorn"
          disabled={!!data.poll_locked || !changed}
          tooltip={
            data.poll_locked ? 'The poll tax changes once a day.' : undefined
          }
          onClick={() => {
            act('set_poll', { rates: draft });
            setDraft({});
          }}
        >
          Proclaim
        </Button>
      }
    >
      {!!data.carta && (
        <NoticeBox>
          The Magna Carta stands: the Crown may tax no head, only grant
          subsidies.
        </NoticeBox>
      )}
      <Table>
        <Table.Row header>
          <Table.Cell>Class</Table.Cell>
          <Table.Cell collapsing>Heads</Table.Cell>
          <Table.Cell collapsing>Taxable</Table.Cell>
          <Table.Cell collapsing>Rate</Table.Cell>
          <Table.Cell collapsing>Per dawn</Table.Cell>
        </Table.Row>
        {classes.map((entry) => (
          <Table.Row key={entry.id} className="candystripe">
            <Table.Cell>{entry.name}</Table.Cell>
            <Table.Cell collapsing>{entry.heads}</Table.Cell>
            <Table.Cell collapsing>{entry.taxable}</Table.Cell>
            <Table.Cell collapsing>
              <NumberInput
                value={rateOf(entry)}
                minValue={data.poll_min}
                maxValue={data.poll_max}
                step={1}
                width="60px"
                onChange={(value) =>
                  setDraft((old) => ({ ...old, [entry.id]: value }))
                }
              />
            </Table.Cell>
            <Table.Cell collapsing color={entry.flow < 0 ? 'bad' : 'good'}>
              {entry.flow}m
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
      <Box mt={1} color="label">
        Below zero the Crown pays the class a subsidy. Charters exempt or cap
        some classes. Income {data.poll?.income || 0}m, subsidies{' '}
        {data.poll?.subsidy || 0}m a dawn.
      </Box>
    </Section>
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
            <Table.Cell collapsing>
              {entry.wage}m
              {entry.floor > 0 && (
                <Box inline color="label">
                  &nbsp;(charter: {entry.floor}m)
                </Box>
              )}
            </Table.Cell>
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
            <Table.Cell>
              {account.holder}
              {!!account.defaulter && (
                <Box inline color="bad">
                  &nbsp;[DEFAULTER]
                </Box>
              )}
              {account.poll_owed > 0 && (
                <Box inline color="average">
                  &nbsp;[ARREARS: {account.poll_owed}m, {account.poll_overdue}d]
                </Box>
              )}
            </Table.Cell>
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
                disabled={account.max_fine <= 0}
                tooltip={
                  account.max_fine > 0
                    ? `At most ${account.max_fine}m.`
                    : 'Fined today, shielded by a charter, or nothing to take.'
                }
                onClick={() => act('fine', { ref: account.ref })}
              >
                Fine
              </Button>
              {account.poll_owed > 0 && (
                <Button
                  compact
                  onClick={() => act('clear_arrears', { ref: account.ref })}
                >
                  Clear arrears
                </Button>
              )}
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

const Loans = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section title="Funds of the realm">
          <Table>
            {(data.funds || []).map((fund) => (
              <Table.Row key={fund.id}>
                <Table.Cell>{fund.holder}</Table.Cell>
                <Table.Cell collapsing>{fund.balance}m</Table.Cell>
                <Table.Cell collapsing color="label">
                  lent {fund.lent}m
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable title="Loans and indentures">
          {(data.loans || []).length === 0 ? (
            <Box color="label">No active loans.</Box>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>Debtor</Table.Cell>
                <Table.Cell>Lender</Table.Cell>
                <Table.Cell collapsing>Principal</Table.Cell>
                <Table.Cell collapsing>Due</Table.Cell>
                <Table.Cell collapsing>Owed</Table.Cell>
                <Table.Cell collapsing />
              </Table.Row>
              {data.loans.map((loan) => (
                <Table.Row
                  key={loan.ref}
                  className="candystripe"
                  color={loan.defaulted ? 'bad' : undefined}
                >
                  <Table.Cell>{loan.debtor}</Table.Cell>
                  <Table.Cell>{loan.lender}</Table.Cell>
                  <Table.Cell collapsing>
                    {loan.principal}m @ {loan.interest}%
                  </Table.Cell>
                  <Table.Cell collapsing>
                    {loan.defaulted ? 'DEFAULTED' : `day ${loan.due_day}`}
                  </Table.Cell>
                  <Table.Cell collapsing>{loan.remaining}m</Table.Cell>
                  <Table.Cell collapsing>
                    {loan.lender_id === 'crown' && !loan.borrower_id && (
                      <Button
                        compact
                        tooltip="Write off the debt and lift the defaulter's mark."
                        onClick={() => act('forgive', { ref: loan.ref })}
                      >
                        Forgive
                      </Button>
                    )}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Stack.Item>
    </Stack>
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
