// Vibelin's Settings page on TG's player preferences: the toggles and sliders that exist here, by group, edited by
// TG's own components, and TG's menu for the rest and for the keybindings. Vibelin's interface themes, text size,
// "fancy tgui", midround antagonists, intimacy opt-in and bitfield toggles have no counterpart here.
import { useBackend } from 'tgui/backend';

import { ActionButton, Panel } from './components';
import { FeatureList } from './features';
import { useTr } from './strings';
import type { SetupData } from './types';

export function SettingsPage() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const values = data.character_preferences.game_preferences ?? {};
  return (
    <>
      {data.settings.map((group) => (
        <Panel key={group.title} title={tr(group.title)} icon="cog">
          <FeatureList values={values} keys={group.keys} />
        </Panel>
      ))}
      <Panel title={tr('More')} icon="sliders-h">
        <ActionButton
          icon="keyboard"
          label={tr('Keybindings')}
          onClick={() => act('open_tg', { page: 'keybindings' })}
        />
        <ActionButton
          icon="cogs"
          label={tr('All Game Preferences')}
          onClick={() => act('open_tg', { page: 'game' })}
        />
      </Panel>
    </>
  );
}
