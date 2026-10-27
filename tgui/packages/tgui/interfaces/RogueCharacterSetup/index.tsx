// The character menu of medieval maps (modular_redtard/charsetup/): Vibelin's PreferencesMenu.tsx laid out the same
// way (header, round box and sections on the left, the looking glass, the open section, the footer) on TG's
// preferences. Unlike Vibelin's single 2,500-line component, every part is a component at module scope, so a data
// update re-renders the tree without remounting it; the doll is a TG map view embedded with tgui-core's ByondUi, as in
// TG's own menu, and every catalog comes from static data, not from a fetched JSON asset.
import { type JSX, type ReactNode, useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ByondUi,
  Dropdown,
  Icon,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { Window } from '../../layouts';
import { ServerPrefs } from '../PreferencesMenu/useServerPrefs';
import { AppearancePage } from './AppearancePage';
import { Countdown, display } from './components';
import { buildServerData } from './features';
import { GameplayPage, highestJob } from './GameplayPage';
import { IdentityPage } from './IdentityPage';
import { ProfilePage } from './ProfilePage';
import { SettingsPage } from './SettingsPage';
import { useTr } from './strings';
import type { RoundState, SetupData } from './types';

const SECTIONS = [
  { id: 'identity', label: 'Identity', icon: 'id-card' },
  { id: 'appearance', label: 'Appearance', icon: 'palette' },
  { id: 'gameplay', label: 'Gameplay', icon: 'gamepad' },
  { id: 'profile', label: 'Character Profile', icon: 'scroll' },
  { id: 'settings', label: 'Settings', icon: 'cog' },
] as const;

type SectionId = (typeof SECTIONS)[number]['id'];

const PAGES: Record<SectionId, () => JSX.Element> = {
  identity: IdentityPage,
  appearance: AppearancePage,
  gameplay: GameplayPage,
  profile: ProfilePage,
  settings: SettingsPage,
};

export function RogueCharacterSetup() {
  const { data } = useBackend<SetupData>();
  const tr = useTr();
  const [section, setSection] = useState<SectionId>('identity');
  // The catalogs are static data: their reference holds between updates, so this is built once per window.
  const serverData = useMemo(
    () => buildServerData(data.features ?? {}),
    [data.features],
  );
  const Page = PAGES[section];

  return (
    <Window title={tr('Character Setup')} width={1180} height={760}>
      <Window.Content>
        <ServerPrefs.Provider value={serverData}>
          <Stack vertical fill>
            <Stack.Item>
              <Header />
            </Stack.Item>
            <Stack.Item grow>
              <Stack fill>
                <Stack.Item basis="210px">
                  <Stack vertical fill>
                    {!!data.round && (
                      <Stack.Item>
                        <RoundBox round={data.round} />
                      </Stack.Item>
                    )}
                    <Stack.Item grow>
                      <Section fill>
                        <Tabs vertical>
                          {SECTIONS.map((entry) => (
                            <Tabs.Tab
                              key={entry.id}
                              icon={entry.icon}
                              selected={section === entry.id}
                              onClick={() => setSection(entry.id)}
                            >
                              {tr(entry.label)}
                            </Tabs.Tab>
                          ))}
                        </Tabs>
                      </Section>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item basis="250px">
                  <LookingGlass />
                </Stack.Item>
                <Stack.Item grow basis={0}>
                  <Section fill scrollable>
                    <Page />
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Footer onOpenSection={setSection} />
            </Stack.Item>
          </Stack>
        </ServerPrefs.Provider>
      </Window.Content>
    </Window>
  );
}

function Header() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const prefs = data.character_preferences;
  const species = data.species.find(
    (entry) => entry.id === prefs.misc?.species,
  );
  const meta = [
    species?.name,
    prefs.misc?.gender,
    tr('Slot {0}', data.active_slot),
  ]
    .filter(Boolean)
    .join('  /  ');
  const slots = Array.from({ length: data.max_slots }, (_, index) => ({
    displayText: data.profiles[index] || tr('Empty slot {0}', index + 1),
    value: index + 1,
  }));

  return (
    <Section>
      <Stack align="center">
        <Stack.Item grow>
          <Box bold fontSize="18px">
            {display(prefs.names?.real_name, tr('Unnamed'))}
          </Box>
          <Box color="label">{meta}</Box>
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            width="220px"
            icon="exchange-alt"
            displayText={tr('Change Character')}
            selected={slots[data.active_slot - 1]}
            options={slots}
            onSelected={(slot) => act('change_slot', { slot })}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
}

const ROUND_TEXT = {
  pregame: 'Starts In',
  setting_up: 'Setting Up',
  playing: 'Round Started',
  postgame: 'Round Finished',
} as const;

/** Vibelin's "Round Start" box: the countdown, the ready or join button and how many are ready. */
function RoundBox(props: { round: RoundState }) {
  const { round } = props;
  const { act } = useBackend<SetupData>();
  const tr = useTr();
  let label = 'Unavailable';
  let color: string | undefined;
  let icon = 'ban';
  let disabled = true;
  if (round.phase === 'pregame') {
    disabled = false;
    if (round.ready) {
      label = 'Cancel Ready';
      color = 'bad';
      icon = 'times';
    } else {
      label = 'Ready';
      color = 'green';
      icon = 'user-check';
    }
  } else if (round.phase === 'playing') {
    disabled = !!round.migrant;
    label = round.migrant ? 'In the migrant queue' : 'Join Now';
    color = 'green';
    icon = 'sign-in-alt';
  } else if (round.phase === 'setting_up') {
    label = 'Setting Up';
    icon = 'hourglass-half';
  }

  return (
    <Section title={tr('Round Start')} mb={1}>
      <Box
        bold
        fontSize="22px"
        color={
          round.phase === 'pregame'
            ? round.seconds < 0
              ? 'bad'
              : 'good'
            : 'average'
        }
      >
        {round.phase === 'pregame' ? (
          <Countdown seconds={round.seconds} />
        ) : (
          tr(ROUND_TEXT[round.phase])
        )}
      </Box>
      <Box color="label" mb={0.5}>
        {round.phase === 'pregame' && round.seconds < 0
          ? tr('Delayed')
          : tr(ROUND_TEXT[round.phase])}
      </Box>
      <Button
        fluid
        mb={0.75}
        icon={icon}
        color={color}
        disabled={disabled}
        onClick={() => act('round_action')}
      >
        {tr(label)}
      </Button>
      <Stack align="center">
        <Stack.Item>
          <Icon name="user-check" />
        </Stack.Item>
        <Stack.Item grow>
          <Box color="label">{tr('Ready')}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box bold>
            {round.ready_count} / {round.players}
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
}

/** Vibelin's "Looking Glass": the character as the game draws it, in a map view (TG's character preview). */
function LookingGlass() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  return (
    <Section fill title={tr('Looking Glass')}>
      <Stack vertical fill>
        <Stack.Item grow>
          {data.preview_view ? (
            <ByondUi
              key={data.preview_view}
              width="100%"
              height="100%"
              params={{ id: data.preview_view, type: 'map' }}
            />
          ) : (
            <Box textAlign="center" pt={8}>
              <Icon name="user" size={6} color="label" />
            </Box>
          )}
        </Stack.Item>
        <Stack.Item>
          <Stack mb={0.5}>
            <Stack.Item grow>
              <Button
                fluid
                textAlign="center"
                icon="arrow-left"
                tooltip={tr('Rotate left')}
                onClick={() => act('rotate', { dir: 'left' })}
              />
            </Stack.Item>
            <Stack.Item>
              <Box color="label" style={{ lineHeight: '24px' }}>
                {tr('Rotate')}
              </Box>
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fluid
                textAlign="center"
                icon="arrow-right"
                tooltip={tr('Rotate right')}
                onClick={() => act('rotate', { dir: 'right' })}
              />
            </Stack.Item>
          </Stack>
          <Button
            fluid
            mb={0.5}
            icon={data.job_clothes ? 'check-square' : 'square'}
            selected={!!data.job_clothes}
            onClick={() => act('toggle_job_clothes')}
          >
            {tr('Work Clothes Layer')}
          </Button>
          <Button fluid icon="dice" onClick={() => act('randomize_appearance')}>
            {tr('Randomise Appearance')}
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
}

function Footer(props: { onOpenSection: (section: SectionId) => void }) {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  return (
    <Section>
      <Stack align="center">
        <Stack.Item grow>
          <Stack>
            <Stack.Item>
              <FooterSummary
                icon="shield-alt"
                label={tr('Class')}
                value={highestJob(data.job_preferences) ?? tr('None')}
                onClick={() => props.onOpenSection('gameplay')}
              />
            </Stack.Item>
            <Stack.Item>
              <FooterSummary
                icon="trophy"
                label={tr('Triumphs')}
                value={data.triumphs}
                onClick={() => props.onOpenSection('gameplay')}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="dice"
            tooltip={tr('Randomise Appearance')}
            onClick={() => act('randomize_appearance')}
          >
            {tr('Randomise')}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="undo"
            tooltip={tr('Undo the changes since the last save')}
            onClick={() => act('undo')}
          >
            {tr('Undo')}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button icon="save" color="blue" onClick={() => act('save')}>
            {tr('Save')}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button icon="check" color="green" onClick={() => act('done')}>
            {tr('Done')}
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
}

type FooterSummaryProps = {
  icon: string;
  label: string;
  value: ReactNode;
  onClick: () => void;
};

/** Vibelin's footer summary, declared here instead of inside the menu so it is not remounted on every update. */
function FooterSummary(props: FooterSummaryProps) {
  return (
    <Button color="transparent" onClick={props.onClick} tooltip={props.label}>
      <Stack align="center">
        <Stack.Item>
          <Icon name={props.icon} />
        </Stack.Item>
        <Stack.Item>
          <Box color="label" fontSize="10px">
            {props.label}
          </Box>
          <Box bold>{props.value}</Box>
        </Stack.Item>
      </Stack>
    </Button>
  );
}
