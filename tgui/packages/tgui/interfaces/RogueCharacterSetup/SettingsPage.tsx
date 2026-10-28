// Vibelin's Settings page on TG's player preferences: every game preference TG's own menu shows this player, edited
// by TG's own components and grouped as TG's game preferences page groups them (the category of their feature); TG's
// menu stays for the keybindings. Vibelin's interface themes, text size, "fancy tgui", midround antagonists, intimacy
// opt-in and bitfield toggles have no counterpart here.
import { useBackend } from 'tgui/backend';

import { features } from '../PreferencesMenu/preferences/features';
import { ActionButton, Panel } from './components';
import { FeatureList } from './features';
import { useTr } from './strings';
import type { SetupData } from './types';

/** TG's categories of game preferences in the page's order: category, title, icon. */
const CATEGORIES: [string, string, string][] = [
  ['UI', 'Interface', 'desktop'],
  ['GAMEPLAY', 'Gameplay', 'gamepad'],
  ['SOUND', 'Sound', 'volume-up'],
  ['CHAT', 'Chat', 'comment'],
  ['RUNECHAT', 'Runechat', 'comment-dots'],
  ['TOOLTIPS', 'Tooltips', 'info-circle'],
  ['ACCESSIBILITY', 'Accessibility', 'universal-access'],
  ['GHOST', 'Ghost', 'ghost'],
  ['ADMIN', 'Admin', 'user-shield'],
  ['OTHER', 'Other', 'cog'],
];

export function SettingsPage() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const values = data.character_preferences.game_preferences ?? {};
  const groups: Record<string, string[]> = {};
  for (const key of Object.keys(values)) {
    const category = features[key]?.category ?? '';
    const group = CATEGORIES.some(([id]) => id === category)
      ? category
      : 'OTHER';
    groups[group] = [...(groups[group] ?? []), key];
  }
  return (
    <>
      {CATEGORIES.filter(([id]) => groups[id]).map(([id, title, icon]) => (
        <Panel key={id} title={tr(title)} icon={icon}>
          <FeatureList values={values} keys={groups[id]} />
        </Panel>
      ))}
      <Panel title={tr('More')} icon="sliders-h">
        <ActionButton
          icon="keyboard"
          label={tr('Keybindings')}
          onClick={() => act('open_tg', { page: 'keybindings' })}
        />
      </Panel>
    </>
  );
}
