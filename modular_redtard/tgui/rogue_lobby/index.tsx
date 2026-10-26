// The medieval main menu bundle (tgui-rogue-lobby, modular_redtard/lobby/rogue_lobby.dm). A copy of TG's
// tgui-lobby/index.tsx (scaling, key passthrough to BYOND, asset loading) that renders RogueLobby: TG's LobbyMenu and
// Azure Peak's panel. Built by the module build with modular_redtard/tgui/rspack.rogue_lobby.ts.
import 'tgui-lobby/styles/main.scss';
import './rogue_lobby.scss';

import { loadMappings, loadStyleSheet } from 'common/assets';
import { createRoot, type Root } from 'react-dom/client';
import { assetMap } from 'tgui-lobby/assets';
import { updateScaling } from 'tgui-lobby/scaling';
import { RogueLobby } from './RogueLobby';

let reactRoot: Root | null = null;

document.onreadystatechange = () => {
  if (document.readyState !== 'complete') return;

  updateScaling();

  window.addEventListener('resize', () => {
    updateScaling();
  });

  const KEY_CODE_TO_BYOND: Record<string, string> = {
    DEL: 'Delete',
    DELETE: 'Delete',
    DOWN: 'South',
    ARROWDOWN: 'South',
    END: 'Southwest',
    HOME: 'Northwest',
    INSERT: 'Insert',
    LEFT: 'West',
    ARROWLEFT: 'West',
    PAGEDOWN: 'Southeast',
    PAGEUP: 'Northeast',
    RIGHT: 'East',
    ARROWRIGHT: 'East',
    ' ': 'Space',
    UP: 'North',
    ARROWUP: 'North',
    ESCAPE: 'Escape',
    TAB: 'Tab',
    ENTER: 'Enter',
    BACKSPACE: 'Back',
    SHIFT: 'Shift',
    CONTROL: 'Ctrl',
    ALT: 'Alt',
  };

  function toBYONDKey(e: KeyboardEvent): string {
    const upper = e.key.toUpperCase();
    let text = '';
    if (e.altKey && upper !== 'ALT') text += 'Alt';
    if (e.ctrlKey && upper !== 'CONTROL') text += 'Ctrl';
    if (e.shiftKey && upper !== 'SHIFT') text += 'Shift';
    text += KEY_CODE_TO_BYOND[upper] || upper;
    return text;
  }

  const heldKeys = new Set<string>();

  window.addEventListener('keydown', (e) => {
    const key = toBYONDKey(e);
    if (!key || heldKeys.has(key)) return;
    heldKeys.add(key);
    Byond.command(`KeyDown "${key}" 0 0 0 0`);
  });

  window.addEventListener('keyup', (e) => {
    const key = toBYONDKey(e);
    if (!key || !heldKeys.has(key)) return;
    heldKeys.delete(key);
    Byond.command(`KeyUp "${key}" 0 0 0 0`);
  });

  Byond.winget('mapwindow.map_lobby_selector').then(
    (info: { size: string }) => {
      Byond.winset('lobby_menu', { size: info.size });
    },
  );

  if (!reactRoot) {
    const root = document.getElementById('react-root');
    reactRoot = createRoot(root!);
  }

  reactRoot.render(<RogueLobby />);

  Byond.subscribeTo('asset/stylesheet', loadStyleSheet);
  Byond.subscribeTo('asset/mappings', (payload: Record<string, string>) => {
    loadMappings(payload, assetMap);
  });
};
