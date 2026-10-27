// The character's description and OOC notes of medieval maps (modular_redtard/lobby/rogue_join_rules.dm, Azure Peak's
// flavor text and OOC notes): long texts, so a text area instead of TG's one-line input.
import { TextArea } from 'tgui-core/components';

import type { Feature, FeatureValueProps } from '../base';

type TextData = {
  maximum_length: number;
};

function FeatureLongTextInput(
  props: FeatureValueProps<string, string, TextData>,
) {
  const { serverData, value, handleSetValue } = props;

  return (
    <TextArea
      disabled={!serverData}
      fluid
      height="8em"
      value={value}
      maxLength={serverData?.maximum_length}
      onBlur={handleSetValue}
    />
  );
}

export const rogue_flavor_text: Feature<string, string, TextData> = {
  name: 'Flavor text',
  description:
    'How others see your character when they examine closer. Medieval maps need it before you ready up.',
  component: FeatureLongTextInput,
};

export const rogue_ooc_notes: Feature<string, string, TextData> = {
  name: 'OOC notes',
  description:
    'What you want other players to know out of character. Medieval maps need a few words before you ready up.',
  component: FeatureLongTextInput,
};
