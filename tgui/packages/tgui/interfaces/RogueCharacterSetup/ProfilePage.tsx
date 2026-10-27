// Vibelin's Character Profile page on the module's texts: the flavor text and OOC notes the medieval lobby asks for
// before readying up (rogue_join_rules.dm), edited by their own TG feature (rogue_character_notes.tsx), the name in
// Russian cases the chat translation declines it by (localization/declensions.dm), and any other rogue_* text a
// character gets. Vibelin's voice, descriptors, food preferences, relations, OOC extra and headshot have no system here;
// the faith, patron and culture are on the identity page.
import { useBackend } from 'tgui/backend';
import { Box, LabeledList } from 'tgui-core/components';

import { Panel } from './components';
import { FeatureList, FeatureRow } from './features';
import { useTr } from './strings';
import type { SetupData } from './types';

const NOTE_KEYS = ['rogue_flavor_text', 'rogue_ooc_notes'];
/** In the order of the cases, not of their names. */
const DECLENSION_KEYS = [
  'rogue_declension_genitive',
  'rogue_declension_dative',
  'rogue_declension_accusative',
  'rogue_declension_instrumental',
  'rogue_declension_prepositional',
];
/** Edited on the identity page (the origin in the ancestry picker). */
const HERITAGE_KEYS = [
  'rogue_faith',
  'rogue_patron',
  'rogue_culture',
  'rogue_origin',
];

function LengthHint(props: { text: unknown; minimum: number }) {
  const tr = useTr();
  const length = String(props.text ?? '').length;
  if (props.minimum <= 0) {
    return null;
  }
  return (
    <Box color={length >= props.minimum ? 'good' : 'bad'} mt={0.5}>
      {tr('{0} / {1} characters needed to ready up', length, props.minimum)}
    </Box>
  );
}

export function ProfilePage() {
  const { data } = useBackend<SetupData>();
  const tr = useTr();
  const texts = data.character_preferences.non_contextual ?? {};
  const others: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(texts)) {
    if (
      key.startsWith('rogue_') &&
      !NOTE_KEYS.includes(key) &&
      !DECLENSION_KEYS.includes(key) &&
      !HERITAGE_KEYS.includes(key)
    ) {
      others[key] = value;
    }
  }
  const declensions = DECLENSION_KEYS.filter((key) => key in texts);

  return (
    <>
      {'rogue_flavor_text' in texts && (
        <Panel title={tr('Flavour')} icon="scroll">
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
        <Panel title={tr('OOC')} icon="sticky-note">
          <LabeledList>
            <FeatureRow
              featureKey="rogue_ooc_notes"
              value={texts.rogue_ooc_notes}
            />
          </LabeledList>
          <LengthHint text={texts.rogue_ooc_notes} minimum={data.ooc_min} />
        </Panel>
      )}
      {declensions.length > 0 && (
        <Panel title={tr('Declensions')} icon="language">
          <Box color="label" mb={0.5}>
            {tr('How the chat names your character in each case.')}
          </Box>
          <LabeledList>
            {declensions.map((key) => (
              <FeatureRow key={key} featureKey={key} value={texts[key]} />
            ))}
          </LabeledList>
        </Panel>
      )}
      {Object.keys(others).length > 0 && (
        <Panel title={tr('Other')} icon="feather">
          <FeatureList values={others} />
        </Panel>
      )}
      {!('rogue_flavor_text' in texts) && !('rogue_ooc_notes' in texts) && (
        <Box color="label">{tr('This map asks for no character profile.')}</Box>
      )}
    </>
  );
}
