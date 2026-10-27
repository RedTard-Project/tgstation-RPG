// Vibelin's Character Profile page on the module's texts: the flavor text and OOC notes the medieval lobby asks for
// before readying up (rogue_join_rules.dm), edited by their own TG feature (rogue_character_notes.tsx), and any other
// rogue_* text a character gets. Vibelin's voice, descriptors, culture, food preferences, relations, OOC extra and
// headshot have no system here.
import { useBackend } from 'tgui/backend';
import { Box, LabeledList } from 'tgui-core/components';

import { Panel } from './components';
import { FeatureList, FeatureRow } from './features';
import type { SetupData } from './types';

const NOTE_KEYS = ['rogue_flavor_text', 'rogue_ooc_notes'];

function LengthHint(props: { text: unknown; minimum: number }) {
  const length = String(props.text ?? '').length;
  if (props.minimum <= 0) {
    return null;
  }
  return (
    <Box color={length >= props.minimum ? 'good' : 'bad'} mt={0.5}>
      {length} / {props.minimum} characters needed to ready up
    </Box>
  );
}

export function ProfilePage() {
  const { data } = useBackend<SetupData>();
  const texts = data.character_preferences.non_contextual ?? {};
  const others: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(texts)) {
    if (key.startsWith('rogue_') && !NOTE_KEYS.includes(key)) {
      others[key] = value;
    }
  }

  return (
    <>
      {'rogue_flavor_text' in texts && (
        <Panel title="Flavour" icon="scroll">
          <LabeledList>
            <FeatureRow
              featureKey="rogue_flavor_text"
              value={texts.rogue_flavor_text}
            />
          </LabeledList>
          <LengthHint
            text={texts.rogue_flavor_text}
            minimum={data.flavor_min}
          />
        </Panel>
      )}
      {'rogue_ooc_notes' in texts && (
        <Panel title="OOC" icon="sticky-note">
          <LabeledList>
            <FeatureRow
              featureKey="rogue_ooc_notes"
              value={texts.rogue_ooc_notes}
            />
          </LabeledList>
          <LengthHint text={texts.rogue_ooc_notes} minimum={data.ooc_min} />
        </Panel>
      )}
      {Object.keys(others).length > 0 && (
        <Panel title="Other" icon="feather">
          <FeatureList values={others} />
        </Panel>
      )}
      {!('rogue_flavor_text' in texts) && !('rogue_ooc_notes' in texts) && (
        <Box color="label">This map asks for no character profile.</Box>
      )}
    </>
  );
}
