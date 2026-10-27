// Building blocks of the character menu (Vibelin's PreferencesMenu.components.tsx). Everything is declared at module
// scope, so a data update re-renders these components instead of mounting new ones; the big option grids are memoised
// and send their action themselves (sendAct), so an update that does not touch them skips them altogether.
import {
  memo,
  type ReactNode,
  useEffect,
  useMemo,
  useReducer,
  useState,
} from 'react';
import { sendAct } from 'tgui/events/act';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useTr } from './strings';
import type { StatChip } from './types';

export const display = (value: unknown, fallback = 'None') => {
  const text = String(value ?? '').trim();
  return text || fallback;
};

export const swatchColor = (value: unknown) => {
  const text = String(value ?? '').trim();
  if (!text) {
    return '#888888';
  }
  return text.startsWith('#') ? text : `#${text}`;
};

type PanelProps = {
  title: ReactNode;
  icon?: string;
  buttons?: ReactNode;
  children?: ReactNode;
};

/** A titled section with an icon (Vibelin's Panel). */
export function Panel(props: PanelProps) {
  const { title, icon, buttons, children } = props;
  return (
    <Section
      mb={1}
      title={
        <Stack align="center">
          {!!icon && (
            <Stack.Item>
              <Icon name={icon} />
            </Stack.Item>
          )}
          <Stack.Item>{title}</Stack.Item>
        </Stack>
      }
      buttons={buttons}
    >
      {children}
    </Section>
  );
}

type InfoRowProps = {
  icon: string;
  label: string;
  value?: ReactNode;
  valueColor?: string;
  tooltip?: string;
};

/** A label and a value on one line (Vibelin's InfoRow). */
export function InfoRow(props: InfoRowProps) {
  const { icon, label, value, valueColor, tooltip } = props;
  const row = (
    <Box mb={0.5} p={0.5}>
      <Stack align="center">
        <Stack.Item>
          <Icon name={icon} />
        </Stack.Item>
        <Stack.Item grow>
          <Box textAlign="left">{label}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box bold color={valueColor}>
            {value ?? 'None'}
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
  return tooltip ? <Tooltip content={tooltip}>{row}</Tooltip> : row;
}

type ActionButtonProps = {
  icon: string;
  label: string;
  onClick: () => void;
  color?: string;
  disabled?: boolean;
  tooltip?: string;
};

/** A full-width labelled button (Vibelin's ActionButton). */
export function ActionButton(props: ActionButtonProps) {
  const { icon, label, onClick, color, disabled, tooltip } = props;
  return (
    <Button
      fluid
      mb={0.5}
      textAlign="center"
      icon={icon}
      color={color}
      disabled={disabled}
      tooltip={tooltip}
      onClick={onClick}
    >
      {label}
    </Button>
  );
}

type FieldBlockProps = {
  label: ReactNode;
  children: ReactNode;
};

/** A small caption over a control (Vibelin's FieldBlock). */
export function FieldBlock(props: FieldBlockProps) {
  return (
    <Box mb={1}>
      <Box
        color="label"
        mb={0.5}
        style={{ fontSize: '12px', lineHeight: '1.2' }}
      >
        {props.label}
      </Box>
      {props.children}
    </Box>
  );
}

/** Stat modifiers as coloured chips (Vibelin's species stat modifiers). */
export function StatChips(props: { stats: StatChip[]; empty?: string }) {
  const { stats, empty } = props;
  const tr = useTr();
  if (!stats.length) {
    return <Box color="label">{empty ?? tr('No stat modifiers.')}</Box>;
  }
  return (
    <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
      {stats.map((stat) => (
        <Button
          key={stat.name}
          compact
          tooltip={stat.name}
          color={stat.value > 0 ? 'green' : 'bad'}
        >
          {stat.label} {stat.value > 0 ? '+' : ''}
          {stat.value}
        </Button>
      ))}
    </Box>
  );
}

type IconGridProps = {
  /** The preference the grid sets. */
  featureKey: string;
  /** Value -> class of TG's preferences spritesheet. */
  icons: Record<string, string>;
  /** Value -> display name, when TG gives one. */
  names?: Record<string, string>;
  selected: string;
  /** The search box's placeholder, in the player's language. */
  searchText: string;
};

const ICON_GRID_SEARCH_FROM = 12;

/**
 * Vibelin's OptionGrid with thumbnails, on TG's preferences spritesheet: one button per choice with its icon and
 * name. Memoised on its props (the catalog comes from static data, so its reference holds between updates), it is
 * skipped when an update changes something else.
 */
export const IconGrid = memo(function IconGrid(props: IconGridProps) {
  const { featureKey, icons, names, selected, searchText } = props;
  const [search, setSearch] = useState('');
  const entries = useMemo(() => Object.entries(icons), [icons]);
  const needle = search.trim().toLowerCase();
  const shown = needle
    ? entries.filter(([value]) =>
        (names?.[value] ?? value).toLowerCase().includes(needle),
      )
    : entries;

  return (
    <Box>
      {entries.length > ICON_GRID_SEARCH_FROM && (
        <Input
          fluid
          mb={0.5}
          placeholder={searchText}
          value={search}
          onChange={setSearch}
        />
      )}
      <Box style={{ display: 'flex', flexWrap: 'wrap' }}>
        {shown.map(([value, icon]) => {
          const name = names?.[value] ?? value;
          return (
            <Button
              key={value}
              mr={0.5}
              mb={0.5}
              tooltip={name}
              selected={value === selected}
              onClick={() =>
                sendAct('set_preference', { preference: featureKey, value })
              }
              style={{ width: '66px', height: '80px', padding: '2px' }}
            >
              <Box
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  height: '50px',
                }}
              >
                <Box
                  className={classes(['preferences32x32', icon])}
                  style={{
                    transform: 'scale(1.4)',
                    imageRendering: 'pixelated',
                  }}
                />
              </Box>
              <Box
                style={{
                  fontSize: '10px',
                  lineHeight: '1.15',
                  overflow: 'hidden',
                  whiteSpace: 'nowrap',
                  textOverflow: 'ellipsis',
                  textAlign: 'center',
                }}
              >
                {name}
              </Box>
            </Button>
          );
        })}
      </Box>
    </Box>
  );
});

/**
 * The time to the round's start, counted down here from the last value the server sent: the window is never
 * refreshed on a timer, only this line re-renders once a second.
 */
export function Countdown(props: { seconds: number }) {
  const { seconds } = props;
  const tr = useTr();
  const [start, setStart] = useState(() => ({ seconds, at: Date.now() }));
  if (start.seconds !== seconds) {
    setStart({ seconds, at: Date.now() });
  }
  const [, tick] = useReducer((count: number) => count + 1, 0);
  useEffect(() => {
    const timer = setInterval(tick, 1000);
    return () => clearInterval(timer);
  }, []);

  if (seconds < 0) {
    return <>{tr('DELAYED')}</>;
  }
  const left = Math.max(
    0,
    start.seconds - Math.floor((Date.now() - start.at) / 1000),
  );
  const minutes = Math.floor(left / 60);
  const rest = left % 60;
  return (
    <>
      {minutes > 0 ? `${minutes}:${String(rest).padStart(2, '0')}` : `${rest}s`}
    </>
  );
}
