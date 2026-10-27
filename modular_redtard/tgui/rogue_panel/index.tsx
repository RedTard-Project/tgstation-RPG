// The chat panel bundle (tgui-rogue-panel): TG's tgui-panel whole, plus Vibelin's chat translation and Ratwood's chat
// look. Served under TG's file names by modular_redtard/localization/panel.dm; built by the module build with
// modular_redtard/tgui/rspack.rogue_panel.ts.
import 'tgui-panel';
import './chat/ratwood.scss';

import { setupLocalization } from './localization/setup';

setupLocalization();
