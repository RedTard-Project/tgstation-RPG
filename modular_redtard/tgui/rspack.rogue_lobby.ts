// The medieval main menu bundle (tgui-rogue-lobby): TG's tgui rspack config with this module's entry only, so TG's
// rspack.config.ts stays untouched. Run from tgui/ by modular_redtard/build/build_modular.ts; the bundle lands in
// tgui/public beside TG's. The sources live in the module, so packages resolve from tgui's node_modules; tegaki (the
// handwriting of the welcome, MIT) is a copy of its built files in vendor/, so TG's package.json and lockfile stay
// untouched too.
import path from 'node:path';

import base from '../../tgui/rspack.config';

const tgui = path.resolve();

export default {
  ...base,
  entry: {
    'tgui-rogue-lobby': path.resolve(tgui, '../modular_redtard/tgui/rogue_lobby'),
  },
  resolve: {
    ...base.resolve,
    alias: {
      ...base.resolve?.alias,
      'tegaki/react': path.resolve(
        tgui,
        '../modular_redtard/tgui/vendor/tegaki/react/index.mjs',
      ),
    },
    modules: [path.resolve(tgui, 'node_modules'), 'node_modules'],
  },
};
