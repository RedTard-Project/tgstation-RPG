// Vibelin's accent of a character (modular_redtard/heritage/accents.dm, its selected_accent): the race's own, none, or
// one the race or the culture speaks with; the server sends what the edited character may pick, in the player's language.
import { useBackend } from 'tgui/backend';
import { Dropdown } from 'tgui-core/components';

import { FieldBlock } from './components';
import { useTr } from './strings';
import type { SetupData } from './types';

export function AccentField() {
  const { act, data } = useBackend<SetupData>();
  const tr = useTr();
  const accents = data.accents;
  const values = data.character_preferences.non_contextual ?? {};
  if (!accents?.length || !('rogue_accent' in values)) {
    return null;
  }
  const picked =
    accents.find((accent) => accent.id === values.rogue_accent) ?? accents[0];
  return (
    <FieldBlock label={tr('Accent')}>
      <Dropdown
        width="100%"
        selected={picked.id}
        displayText={picked.name}
        options={accents.map((accent) => ({
          displayText: accent.name,
          value: accent.id,
        }))}
        onSelected={(value) =>
          act('set_preference', { preference: 'rogue_accent', value })
        }
      />
    </FieldBlock>
  );
}
