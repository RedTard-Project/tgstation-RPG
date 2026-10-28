// The triumph shop of medieval maps (modular_redtard/triumphs/shop.dm): Ratwood's triumph buy menu and its leaderboard
// "Champions of the Vale" in one window, with the leaderboards of past seasons.
import { useState } from 'react';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Buy = {
  type: string;
  name: string;
  desc: string;
  cost: number;
  category: string;
  pre_round_only: BooleanLike;
};

type ActiveBuy = {
  ref: string;
  name: string;
  desc: string;
  cost: number;
  buyer: string;
  locked: BooleanLike;
};

type BoardRow = {
  key: string;
  triumphs: number;
};

type PastSeason = {
  season: number;
  board: BoardRow[];
};

type Data = {
  categories: string[];
  buys: Buy[];
  past_seasons: PastSeason[];
  board_min: number;
  refund_percent: number;
  enabled: BooleanLike;
  triumphs: number;
  pq: number;
  pq_rank: string;
  pq_color: string | null;
  season: number;
  round_started: BooleanLike;
  blocked: string[];
  active: ActiveBuy[];
  mine: string[];
  board: BoardRow[];
};

const ACTIVE_TAB = 'Active';
const BOARD_TAB = 'Leaderboard';

export const RogueTriumphShop = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState(BOARD_TAB);
  const tabs = [...data.categories, ACTIVE_TAB, BOARD_TAB];

  return (
    <Window title="Triumphs" width={520} height={640}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow bold fontSize={1.2}>
                  I have {data.triumphs} Triumphs
                </Stack.Item>
                <Stack.Item>
                  PQ:{' '}
                  <Box as="span" color={data.pq_color || undefined} bold>
                    {data.pq_rank}
                  </Box>{' '}
                  ({data.pq})
                </Stack.Item>
                <Stack.Item>
                  <Button icon="scroll" onClick={() => act('my_pq')}>
                    Record
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Tabs fluid>
              {tabs.map((name) => (
                <Tabs.Tab
                  key={name}
                  selected={tab === name}
                  onClick={() => setTab(name)}
                >
                  {name}
                  {name === ACTIVE_TAB &&
                    data.active.length > 0 &&
                    ` (${data.active.length})`}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              {tab === BOARD_TAB && <Leaderboard />}
              {tab === ACTIVE_TAB && <ActiveBuys />}
              {tab !== BOARD_TAB && tab !== ACTIVE_TAB && (
                <BuyList category={tab} />
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Why a buy cannot be bought now, or null. */
const buyBlocker = (data: Data, buy: Buy) => {
  if (!data.enabled) {
    return 'Triumphs cannot be spent here.';
  }
  if (buy.pre_round_only && data.round_started) {
    return 'Only before the round starts.';
  }
  if (data.blocked.includes(buy.type)) {
    return 'Conflicts with something already bought.';
  }
  if (data.triumphs < buy.cost) {
    return "I haven't TRIUMPHED enough.";
  }
  return null;
};

const BuyList = (props: { category: string }) => {
  const { act, data } = useBackend<Data>();
  const buys = data.buys.filter((buy) => buy.category === props.category);
  if (!buys.length) {
    return <NoticeBox info>Nothing to buy here.</NoticeBox>;
  }
  return (
    <Table>
      <Table.Row header>
        <Table.Cell>Description</Table.Cell>
        <Table.Cell collapsing textAlign="center">
          Cost
        </Table.Cell>
        <Table.Cell collapsing />
      </Table.Row>
      {buys.map((buy) => {
        const blocker = buyBlocker(data, buy);
        return (
          <Table.Row key={buy.type} className="candystripe">
            <Table.Cell py={0.5}>
              <Box bold>{buy.name}</Box>
              <Box color="label">{buy.desc}</Box>
              {!!buy.pre_round_only && (
                <Box color="average">Before the round only.</Box>
              )}
            </Table.Cell>
            <Table.Cell collapsing textAlign="center" bold>
              {buy.cost}
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                disabled={!!blocker}
                tooltip={blocker}
                onClick={() => act('buy', { type: buy.type })}
              >
                Buy
              </Button>
            </Table.Cell>
          </Table.Row>
        );
      })}
    </Table>
  );
};

const ActiveBuys = () => {
  const { act, data } = useBackend<Data>();
  return (
    <>
      {data.active.length === 0 ? (
        <NoticeBox info>Nothing bought is active this round.</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell>Description</Table.Cell>
            <Table.Cell collapsing textAlign="center">
              Cost
            </Table.Cell>
            <Table.Cell collapsing />
          </Table.Row>
          {data.active.map((held) => (
            <Table.Row key={held.ref} className="candystripe">
              <Table.Cell py={0.5}>
                <Box bold>{held.name}</Box>
                <Box color="label">{held.desc}</Box>
                <Box color="label">Bought by: {held.buyer}</Box>
              </Table.Cell>
              <Table.Cell collapsing textAlign="center" bold>
                {held.cost}
              </Table.Cell>
              <Table.Cell collapsing>
                <Button
                  disabled={
                    !data.enabled || !!held.locked || data.triumphs < held.cost
                  }
                  tooltip={
                    held.locked
                      ? 'The round has started.'
                      : `Pay as much to take it back; its buyer gets ${data.refund_percent}% back.`
                  }
                  onClick={() => act('unbuy', { ref: held.ref })}
                >
                  Unbuy
                </Button>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
      {data.mine.length > 0 && (
        <Box mt={1} color="good">
          Waiting for my next character: {data.mine.join(', ')}.
        </Box>
      )}
    </>
  );
};

const Leaderboard = () => {
  const { data } = useBackend<Data>();
  const [season, setSeason] = useState(0);
  const past = data.past_seasons.find((entry) => entry.season === season);
  const board = past ? past.board : data.board;
  return (
    <>
      <Box bold textAlign="center" fontSize={1.2}>
        CHAMPIONS OF THE VALE
      </Box>
      <Stack wrap="wrap" justify="center" my={1}>
        <Stack.Item>
          <Button selected={!past} onClick={() => setSeason(0)}>
            Season {data.season}
          </Button>
        </Stack.Item>
        {data.past_seasons.map((entry) => (
          <Stack.Item key={entry.season}>
            <Button
              selected={entry.season === season}
              onClick={() => setSeason(entry.season)}
            >
              Season {entry.season}
            </Button>
          </Stack.Item>
        ))}
      </Stack>
      {board.length === 0 ? (
        <NoticeBox info>The hall of triumphs is quite empty, Yes?</NoticeBox>
      ) : (
        <Table>
          {board.map((row, index) => (
            <Table.Row key={row.key} className="candystripe">
              <Table.Cell collapsing textAlign="right" pr={1}>
                {index + 1}.
              </Table.Cell>
              <Table.Cell>{row.key}</Table.Cell>
              <Table.Cell collapsing textAlign="right" bold>
                {row.triumphs}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
      {!past && (
        <Box mt={1} color="label" textAlign="center">
          Only those with at least {data.board_min} triumphs are listed.
        </Box>
      )}
    </>
  );
};
