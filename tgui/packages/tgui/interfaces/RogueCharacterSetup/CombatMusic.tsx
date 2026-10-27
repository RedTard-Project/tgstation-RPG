// Ratwood's combat music preference (its "Combat Music" row and picker with a listen button) on the rogue_combat_music
// preference (modular_redtard/charsetup/combat_music.dm): the track heard in combat mode, "Default" for the role's.
// The Combat Mode Music verb still changes it for one life.
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Input, Stack } from 'tgui-core/components';

import { FieldBlock, InfoRow, Panel } from './components';
import { useTr } from './strings';
import type { SetupData } from './types';

/** The value of the role's own track (combat/music.dm ROGUE_CMODE_MUSIC_DEFAULT_NAME). */
const DEFAULT_TRACK = 'Default';

export function CombatMusicPanel() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const values = data.character_preferences.non_contextual ?? {};
  const [search, setSearch] = useState('');
  if (!('rogue_combat_music' in values)) {
    return null;
  }
  const current = String(values.rogue_combat_music ?? DEFAULT_TRACK);
  const tracks = data.combat_music ?? [];
  const picked = tracks.find((track) => track.name === current);
  const needle = search.trim().toLowerCase();
  const shown = tracks.filter(
    (track) => !needle || track.name.toLowerCase().includes(needle),
  );
  const choose = (value: string) =>
    act('set_preference', { preference: 'rogue_combat_music', value });

  return (
    <Panel
      title={tr('Combat Music')}
      icon="music"
      buttons={
        <Button
          icon="stop"
          tooltip={tr('Stop listening')}
          onClick={() => act('stop_combat_music')}
        />
      }
    >
      <InfoRow
        icon="drum"
        label={tr('Heard in combat mode')}
        value={picked ? picked.name : tr("My role's track")}
      />
      {!!picked && (
        <Box mb={1}>
          {!!picked.desc && <Box italic>{picked.desc}</Box>}
          {!!picked.credits && (
            <Box color="label">{tr('Song: {0}', picked.credits)}</Box>
          )}
        </Box>
      )}
      <FieldBlock label={tr('Choose a track')}>
        <Input
          fluid
          mb={0.5}
          placeholder={tr('Search tracks...')}
          value={search}
          onChange={setSearch}
        />
        <Button
          fluid
          mb={0.5}
          icon={current === DEFAULT_TRACK ? 'check-circle' : 'user'}
          selected={current === DEFAULT_TRACK}
          onClick={() => choose(DEFAULT_TRACK)}
        >
          {tr("My role's track")}
        </Button>
        <Box style={{ maxHeight: '240px', overflowY: 'auto' }}>
          {shown.map((track) => (
            <Stack key={track.name} mb={0.5} align="center">
              <Stack.Item grow>
                <Button
                  fluid
                  icon={track.name === current ? 'check-circle' : 'music'}
                  selected={track.name === current}
                  tooltip={track.desc || undefined}
                  onClick={() => choose(track.name)}
                >
                  {track.name}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="play"
                  disabled={!track.playable}
                  tooltip={
                    track.playable
                      ? tr('Listen')
                      : tr('The server does not have this track')
                  }
                  onClick={() =>
                    act('listen_combat_music', { track: track.name })
                  }
                />
              </Stack.Item>
            </Stack>
          ))}
        </Box>
      </FieldBlock>
    </Panel>
  );
}
