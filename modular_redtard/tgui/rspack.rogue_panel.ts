// The chat panel bundle with Vibelin's translation (tgui-rogue-panel): TG's tgui rspack config with this module's entry
// only, so TG's rspack.config.ts stays untouched. Run from tgui/ by modular_redtard/build/build_modular.ts; the bundle
// lands in tgui/public beside TG's.
import path from 'node:path';

import base from '../../tgui/rspack.config';

const tgui = path.resolve();

export default {
  ...base,
  entry: {
    'tgui-rogue-panel': path.resolve(
      tgui,
      '../modular_redtard/tgui/rogue_panel',
    ),
  },
  module: {
    ...base.module,
    rules: [
      ...(base.module?.rules ?? []),
      // Ratwood's chat font, inlined into the stylesheet: the panel is served as its two bundle files only.
      { test: /\.ttf$/, type: 'asset/inline' },
    ],
  },
  resolve: {
    ...base.resolve,
    modules: [path.resolve(tgui, 'node_modules'), 'node_modules'],
  },
};
