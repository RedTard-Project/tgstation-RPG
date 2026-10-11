# modular_redtard

Модуль форка tgstation-RPG. Весь код, ассеты, тесты и обёртка сборки лежат здесь; файлы апстрима ТГ не редактируются (реестр переопределений — `OVERRIDES.md`).

Сейчас в модуле один компонент: **рогатаунный HUD** (порт HUD Azure Peak на HUD-механику ТГ).

## Как устроена модульность

- **Свой код — только в `modular_redtard/`.** Файлы ТГ не правятся. Поведение ТГ меняется тремя способами, от безопасного к рискованному: свои подтипы типов ТГ; новые процедуры и значения переменных на типах ТГ; переопределение процедуры ТГ в модуле с `..()` к оригиналу. Всё, что сложнее подтипа, записано в `OVERRIDES.md`, чтобы при обновлении апстрима знать, что сверять.
- **Подключение — через сборку, а не через `tgstation.dme`.** Обёртка `build/` делает временную копию `tgstation.dme` со строкой `#include "modular_redtard\_module.dme"` и собирает её. `tgstation.dme` остаётся байт в байт апстримным, поэтому слияние с ТГ не даёт в нём конфликтов.
- **Один вход в модуль** — `_module.dme`, он подключает файлы модуля по порядку (константы → элементы → датумы → переопределения → тесты).
- **Тесты модуля** — обычные `/datum/unit_test` ТГ, подключаются только при `UNIT_TESTS`.

## Сборка и тесты

Модуль подключается не строкой в `tgstation.dme`, а обёрткой `build/`. Она копирует `tgstation.dme` во временный `tgstation.redtard.m.dme` (или `tgstation.redtard.test.dme`), вставляет `#include "modular_redtard\_module.dme"` перед `// END_INCLUDE`, компилирует копию и кладёт результат в обычные `tgstation.dmb`/`tgstation.rsc`. Временные файлы попадают под правила `.gitignore` (`*.m.dme`, `*.test.dme`, `*.dmb`, `*.rsc`) и удаляются после сборки.

| Команда | Что делает |
|---|---|
| `modular_redtard\build\BUILD_REDTARD.cmd` | Кнопка «собрать» (аналог `BUILD.cmd` ТГ): цель `build`, окно ждёт нажатия клавиши |
| `modular_redtard\build\build.cmd build` или `dm` (Linux: `modular_redtard/build/build.sh ...`) | Апстримные `icon-cutter`, `behavior-tree-compiler`, `tgui`, `tg-font`, затем компиляция с модулем → `tgstation.dmb`/`.rsc` |
| `... server` | То же и запуск DreamDaemon (`--port`, по умолчанию 1337) |
| `modular_redtard\build\LOWMEM_REDTARD.cmd` или `... lowmem` | Лёгкий запуск для проверок: сборка (пропустить — `--no-build`) и DreamDaemon на одной тестовой карте без шахтёрского уровня (лаваленда) и без космических руин. Карта — `--map`, по умолчанию `runtimestation` |
| `... dm-test` | Те же подготовительные цели, затем как апстримный `dm-test`: `-DCIBUILDING`, юнит-тесты на `runtimestation` (`--map runtimestation_minimal` — карта, на которой CI ТГ гоняет основной набор), вердикт по `data/logs/ci/clean_run.lk` |
| `... dm-test --no-run` | Только скомпилировать тестовую сборку, мир не поднимать |
| `... dm-test --focus` | То же, но только тесты из `tests/focus.dm`: тесты HUD и апстримные тесты, касающиеся HUD человека |
| `... clean` | Удаляет временные файлы модуля и вызывает апстримный `clean` |
| любая другая цель | Передаётся апстримному `tools/build/build` без модуля |

Подготовительные цели — апстримные цели Juke. Juke сравнивает их входы и выходы, поэтому TGUI пересобирается при каждой сборке, если в `tgui/` что-то менялось, и пропускается, если нет; так же иконки из `.toml`, деревья поведения и шрифт.

Флаги `-D`, `-W error`, `-I`, `--dm-version` передаются компилятору так же, как в апстримной сборке.

### Лёгкий запуск (`lowmem`)

Использует штатный механизм ТГ: при загрузке мир берёт карту из `data/next_map.json`. Обёртка пишет туда JSON выбранной карты из `_maps/map_jsons/` с `"minetype": "none"`, `"space_ruin_levels": 0`, `"space_empty_levels": 1` и меткой `redtard_lowmem`. Прежний `next_map.json`, если был, откладывается в `data/next_map.json.redtard-backup` и возвращается, когда DreamDaemon завершается. Если запуск оборвали, файл с меткой уберут следующие `lowmem`, `server` или `dm-test`. Ни код, ни конфиги ТГ не меняются.

Замер 2026-10-11 (сборка с модулем, без игроков, память процесса DreamDaemon через 15 с после конца инициализации):

| Запуск | Инициализация | Память |
|---|---|---|
| Обычный (MetaStation, лаваленд, 7 уровней руин) | 66,9 с | ~1420 МБ |
| `lowmem` (`runtimestation`) | 15,9 с | ~955 МБ |
| `lowmem --map runtimestation_minimal` | 8,1 с | ~945 МБ |

Около 940 МБ — это код и ресурсы сборки (`.dmb`, `.rsc`, глобальные данные), их картой не уменьшить.

CI ТГ (`.github/workflows`) собирает `tgstation.dme` без модуля; подключение модуля в CI требует правки воркфлоу вне `modular_redtard` и в рамках задания не делалось (см. «Отклонения»).

## Рогатаунный HUD

### Как устроен

- `/datum/hud/rogue` наследует базовый `/datum/hud`. Плейн-мастеры, палитра действий и скринтипы остаются штатными. `ui_style` задан на подтипе (`roguehud.dmi`), глобальный `GLOB.available_ui_styles` не тронут.
- `/datum/hud/rogue/human` строит раскладку Азура в `initialize_screen_objects()` через `add_screen_object()` с ключами `HUD_MOB_*` (где у ТГ есть такой элемент) или `HUD_ROGUE_*` (где нет; по образцу доменных ключей ТГ `HUD_CYBORG_*`, `HUD_GHOST_*`), и с группами `HUD_GROUP_*`. Контейнеры Азура (`static_inventory`, `infodisplay`, `hotkeybuttons`) не переносились.
- Ячейки инвентаря — штатные `/datum/inventory_slot` (подтипы `/datum/inventory_slot/rogue/*`), руки — через переопределённый `build_hand_slots()`.
- Элементы с аналогом в ТГ — подтипы штатных экранных типов (`combattoggle`, `healths`, `stamina`, `zone_sel`, `mood`, `throw_catch`, `rest`, `mov_intent`, `drop`, `craft`, `inventory`, `inventory/hand`), поэтому код ТГ, читающий `screen_objects[HUD_MOB_*]` и приводящий тип, продолжает работать.
- Настроение и личный крафт ТГ сами добавляют свои элементы при создании HUD; `/datum/hud/rogue/add_screen_object()` отдаёт им рогатаунный элемент (`adopted_types`): уже созданный или, если его удалили, новый на месте Азура, и они вешают на него свои обработчики кликов.
- Тип HUD для `/mob/living/carbon/human` (все виды: люди, ящеры, мотыльки, обезьяны и т.д.) задаётся в `hud/human_hud_switch.dm`. `/datum/hud/human` больше не создаётся.
- Рамки Азура вокруг карты нет. Из спрайта Азура (`roguehudback2.dmi`, 640×480) вырезан только верх левой панели (`roguehud_panel.dmi`, 160×256, ряды SOUTH+7 и выше) — `tools/dmi_crop.py`, команда в разделе «Атрибуция ассетов». Карта не привязана к виду 15×15, настройка widescreen ТГ работает.
- Инвентарь — минималистичный блок 3×6 голых ячеек в левом нижнем углу, без готического фона, сворачивается как у ТГ: 17 ячеек лежат в `HUD_GROUP_TOGGLEABLE_INVENTORY`, кнопка-сумка (`HUD_HUMAN_TOGGLE_INVENTORY`, спрайт `back` Азура) стоит в самом углу `WEST-5,SOUTH`, блок раскрывается от неё вправо и вверх. Расстановка «по телу» из Азура сохранена (голова сверху, ноги снизу), блок сдвинут на колонку влево и ряд вниз от места Азура. По умолчанию инвентарь свёрнут. Руки, бросок, «бросить» и «дать» остаются на панели.
- Левый HUD расширяет карту бордюром. Реле плейн-мастеров ТГ копируют картинку плейна с якорем `"1,1"` (угол вида), поэтому с бордюром каждый плейн съезжал вправо на ширину бордюра за каждый шаг реле — отсюда «съехавший» экран и чёрная полоса слева. Якорь основной группы — `SCREEN_SOUTHWEST`, угол плейна по справочнику BYOND (`render_source` копии); без бордюра это тот же `1,1` (см. `OVERRIDES.md`). Так же сделано в Vanderlin (там жёстко `"-4,1"`).
- Никаких `process()`, подсистем и тиковых таймеров. Песочные часы задержки клика включаются по сигналу `COMSIG_LIVING_CHANGENEXT_MOVE` и гаснут одноразовым таймером.

Файлы: `hud/rogue_hud_layout.dm` (константы раскладки `rogueui_*` из Азура, слои, ключи), `hud/rogue_hud_elements.dm` (элементы), `hud/rogue_hud_stubs.dm` (заглушки и невидимые плейсхолдеры), `hud/rogue_hud.dm` (датумы HUD и ячеек), `hud/rogue_hud_bridges.dm` (переопределения процедур апстрима), `hud/human_hud_switch.dm`, `tests/huds_rogue.dm`.

### Таблица соответствия (К1)

Источник раскладки: `code/_onclick/hud/_defines.dm` и `/datum/hud/human/New` Азура. `screen_loc` скопированы символ в символ, кроме блока инвентаря, перенесённого в угол по решению заказчика (у ячеек в скобках — место в Азуре); тест `rogue_hud/layout` сверяет каждый элемент с буквальными строками Азура, а также тип, иконку, состояние, слой, план и группу. Слои: значения Азура (HUD_LAYER 24, ABOVE_HUD_LAYER 25, +0.1 и т.д.) на штатном `HUD_PLANE`; у элементов на плане полноэкранных оверлеев сохранён относительный порядок (панель выше вспышки/слепоты/крита, как в Азуре).

Спрайты — `modular_redtard/icons/mob/*` и `icons/hud/*`, копии файлов Азура без изменений.

| Элемент Азура | Ключ ТГ | Класс ТГ | Спрайт (иконка / состояние) | screen_loc | Слой / план | Группа | Клик (К3) |
|---|---|---|---|---|---|---|---|
| backhudl, верх панели | `HUD_ROGUE_PANEL` | `screen/rogue/panel` | roguehud_panel / panel (вырезка из roguehudback2) | `WEST-5,SOUTH+7` | над `CURSE_LAYER` / FULLSCREEN | STATIC | не кликается (как в Азуре) |
| — (нет в Азуре) | `HUD_HUMAN_TOGGLE_INVENTORY` | `screen/human/toggle/rogue` | roguehud / back | `WEST-5,SOUTH` | 24 / HUD | STATIC | свернуть/развернуть инвентарь |
| grain | `HUD_ROGUE_GRAIN` | `screen/rogue/placeholder/grain` | grain / grain | `1,1` | 13 / HUD | — | плейсхолдер, см. ниже |
| scannies | `HUD_ROGUE_SCANNIES` | `.../placeholder/scannies` | roguehudback2 / crt | `WEST-5:0,SOUTH:0` | над панелью / FULLSCREEN | — | плейсхолдер |
| reads | `HUD_ROGUE_READ` | `.../placeholder/read` | read / "" | `1,1` | 24 / HUD | — | плейсхолдер |
| textr, textl | `HUD_ROGUE_READ_TEXT_RIGHT/LEFT` | `.../placeholder/readtext` | — | `5,5` | 24.02 / HUD | — | плейсхолдер |
| action_intent (rogintent) | `HUD_ROGUE_WEAPON_INTENTS` | `screen/rogue/weapon_intents` | rogueintentbase / intentbase | `WEST-5:-16,SOUTH+8` | 24 / HUD | STATIC | 4 ячейки Азура → сигнал `COMSIG_MOB_ROGUE_HUD_INTENT_CLICK`; без обработчика — заглушка |
| stressies | `HUD_MOB_MOOD` | `screen/mood/rogue` | roguehud / уровень настроения ТГ → stress4…mood_nirvana | `WEST-3,CENTER+3` | 24 / HUD | STATIC | настроение ТГ (`print_mood`) |
| rmb_intent | `HUD_ROGUE_RMB_INTENT` | `screen/rogue/stub/rmb_intent` | roguehud / rmbintent | `WEST-4:-16,CENTER+1` | 24 / HUD | STATIC | заглушка |
| bloods | `HUD_MOB_HEALTH` | `screen/healths/rogue` | rogueheat / dam0…damelse + toxloss*/oxyloss* | `WEST-1:6,CENTER+4:17` | 24 / HUD | STATIC | ЛКМ: осмотр ран ТГ; ПКМ: заглушка (знакомые) |
| quad_intents | `HUD_ROGUE_QUAD_INTENTS` | `.../stub/quad_intents` | roguehud / mmbintents0 | `WEST-4:-16,SOUTH+7` | 24 / HUD | STATIC | заглушка |
| def_intent | `HUD_ROGUE_DEF_INTENT` | `.../stub/def_intent` | roguehud / def1n | `WEST-2,NORTH-5` | 24 / HUD | STATIC | заглушка |
| cmode | `HUD_MOB_INTENTS` | `screen/combattoggle/rogue` | roguehud / combat0, combat1 | `WEST-1:-16,CENTER+1` | 24 / HUD | STATIC | ЛКМ: боевой режим ТГ; ПКМ: эмоция surrender; СКМ: заглушка (compliance); Shift: справка |
| give_intent | `HUD_ROGUE_GIVE` | `screen/rogue/give` | roguehud / take0, give0, give1 ¹ | `WEST-1:-16,SOUTH+7` | 24 / HUD | STATIC | с предметом в руке: `give()` ТГ (предложить предмет); с пустой рукой: заглушка («взять») |
| hsover | `HUD_ROGUE_HEATSTAM_OVERLAY` | `screen/rogue/heatstam_overlay` | rogueheat / heatstamover | `WEST-1,CENTER+2` | 24.1 / HUD | STATIC | не кликается (как в Азуре) |
| fov | `HUD_ROGUE_FOV` | `.../placeholder/fov` | vision_cone / combat | `1,1` | ниже вспышки / FULLSCREEN | — | плейсхолдер |
| fov_blocker | `HUD_ROGUE_FOV_BLOCKER` | `.../placeholder/fov_blocker` | vision_cone / combat_v | `1,1` | 24 / FIELD_OF_VISION_BLOCKER | — | плейсхолдер |
| cdleft | `HUD_ROGUE_CLICKDELAY_LEFT` | `screen/rogue/clickdelay/left` | roguehud / "" (resiswait) | `WEST-3:-16,SOUTH+7` | 25 / HUD | STATIC | не кликается (как в Азуре); ждёт задержек по рукам из порта боёвки |
| cdright | `HUD_ROGUE_CLICKDELAY_RIGHT` | `.../clickdelay/right` | то же | `WEST-2:-16,SOUTH+7` | 25 / HUD | STATIC | то же |
| cdmid | `HUD_ROGUE_CLICKDELAY_MID` | `.../clickdelay/next_move` | roguehud / "" ↔ resiswait | `WEST-3:0,SOUTH+7` | 25 / HUD | STATIC | не кликается; показывает `next_move` ТГ |
| defdelay | `HUD_ROGUE_DEFDELAY` | `.../stub/defdelay` | roguehud / defdelay0 | `WEST-1:-5,SOUTH+10:15` | 25 / HUD | STATIC | заглушка |
| руки (2) | `HUD_KEY_HAND_SLOT(1..2)` | `screen/inventory/hand/rogue` | roguehud / hand_l, hand_r + hand_active | `WEST-3:-16,SOUTH+7`, `WEST-2:-16,SOUTH+7` | 24 / HUD | STATIC | штатно ТГ (смена руки / клик предметом) |
| ring | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_ID)` | `screen/inventory/rogue` | roguehud / ring, genslot, slotdmg, slotbroke | `WEST-5,SOUTH+2` (Азур: `WEST-4,SOUTH+3`) | 24 / HUD | TOGGLEABLE | штатный слот ТГ |
| wrists | `HUD_ROGUE_SLOT_STUB("wrists")` | `.../stub/slot/wrists` | roguehud / wrist | `WEST-3,SOUTH+3` (Азур: `WEST-2,SOUTH+4`) | 24 / HUD | TOGGLEABLE | заглушка (нет слота в ТГ) |
| mask | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_MASK)` | `screen/inventory/rogue` | roguehud / mask | `WEST-5,SOUTH+5` (Азур: `WEST-4,SOUTH+6`) | 24 / HUD | TOGGLEABLE | слот ТГ |
| neck | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_NECK)` | то же | roguehud / neck | `WEST-5,SOUTH+3` (Азур: `WEST-4,SOUTH+4`) | 24 / HUD | TOGGLEABLE | слот ТГ |
| backl | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_BACK)` | то же | roguehud / back | `WEST-3,SOUTH+4` (Азур: `WEST-2,SOUTH+5`) | 24 / HUD | TOGGLEABLE | слот ТГ |
| backr | `HUD_ROGUE_SLOT_STUB("backr")` | `.../stub/slot/backr` | roguehud / back | `WEST-5,SOUTH+4` (Азур: `WEST-4,SOUTH+5`) | 24 / HUD | TOGGLEABLE | заглушка |
| gloves | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_GLOVES)` | `screen/inventory/rogue` | roguehud / gloves | `WEST-3,SOUTH+2` (Азур: `WEST-2,SOUTH+3`) | 24 / HUD | TOGGLEABLE | слот ТГ |
| head | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_HEAD)` | то же | roguehud / head | `WEST-4,SOUTH+5` (Азур: `WEST-3,SOUTH+6`) | 24 / HUD | TOGGLEABLE | слот ТГ |
| shoes | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_FEET)` | то же | roguehud / shoes | `WEST-3,SOUTH` (Азур: `WEST-3:16,SOUTH+1`) | 24 / HUD | TOGGLEABLE | слот ТГ |
| belt | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_BELT)` | то же | roguehud / belt | `WEST-4,SOUTH+1` (Азур: `WEST-3,SOUTH+2`) | 24 / HUD | TOGGLEABLE | слот ТГ |
| hip r | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_RPOCKET)` | то же | roguehud / hip | `WEST-5,SOUTH+1` (Азур: `WEST-4,SOUTH+2`) | 24 / HUD | TOGGLEABLE | слот ТГ (правый карман) |
| hip l | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_LPOCKET)` | то же | roguehud / hip | `WEST-3,SOUTH+1` (Азур: `WEST-2,SOUTH+2`) | 24 / HUD | TOGGLEABLE | слот ТГ (левый карман) |
| shirt | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_ICLOTHING)` | то же | roguehud / shirt | `WEST-4,SOUTH+2` (Азур: `WEST-3,SOUTH+3`) | 24 / HUD | TOGGLEABLE | слот ТГ (униформа) |
| trou | `HUD_ROGUE_SLOT_STUB("pants")` | `.../stub/slot/pants` | roguehud / pants | `WEST-4,SOUTH` (Азур: `WEST-4:16,SOUTH+1`) | 24 / HUD | TOGGLEABLE | заглушка |
| armor | `HUD_KEY_ITEM_SLOT(ITEM_SLOT_OCLOTHING)` | `screen/inventory/rogue` | roguehud / armor | `WEST-4,SOUTH+3` (Азур: `WEST-3,SOUTH+4`) | 24 / HUD | TOGGLEABLE | слот ТГ (верхняя одежда) |
| cloak | `HUD_ROGUE_SLOT_STUB("cloak")` | `.../stub/slot/cloak` | roguehud / cloak | `WEST-4,SOUTH+4` (Азур: `WEST-3,SOUTH+5`) | 24 / HUD | TOGGLEABLE | заглушка |
| mouth | `HUD_ROGUE_SLOT_STUB("mouth")` | `.../stub/slot/mouth` | roguehud / mouth | `WEST-3,SOUTH+5` (Азур: `WEST-2,SOUTH+6`) | 24 / HUD | TOGGLEABLE | заглушка |
| drop | `HUD_MOB_DROP` | `screen/drop/rogue` | roguehud / act_drop | `WEST-1:-16,SOUTH+7` | 24 / HUD | STATIC | бросить предмет из руки (ТГ) |
| throw_icon | `HUD_MOB_THROW` | `screen/throw_catch/rogue` | roguehud / catch0/1, throw0/1 | `WEST-1:-16,SOUTH+7` | 24 / HUD | HOTKEYS | режим броска ТГ |
| restup | `HUD_ROGUE_STAND_UP` | `screen/rogue/stand_up` | roguehud / act_rest_up | `WEST-4,CENTER+2` | 24 / HUD | STATIC | ЛКМ: встать; ПКМ: смотреть вверх |
| restdown | `HUD_MOB_REST` | `screen/rest/rogue` | roguehud / act_rest_down | `WEST-4,CENTER+2` | 24 / HUD | STATIC | ЛКМ: лечь; ПКМ: смотреть вниз |
| skills | `HUD_ROGUE_SKILLS` | `screen/rogue/skills` | roguehud / skills | `WEST-4,CENTER+3` | 24 / HUD | STATIC | ЛКМ: навыки ТГ (`mind.print_levels`); ПКМ: заглушка (черты/языки) |
| craft | `HUD_MOB_CRAFTING_MENU` | `screen/craft/rogue` | roguehud / craft | `WEST-4,CENTER+3` | 24 / HUD | STATIC | меню крафта ТГ (`personal_crafting`); без компонента — заглушка |
| rogmove (sneak) | `HUD_ROGUE_SNEAK` | `.../stub/sneak` | roguehud / sneak0 | `WEST-3,CENTER+2` | 24 / HUD | STATIC | заглушка |
| sprint | `HUD_MOB_MOVE_INTENT` | `screen/mov_intent/rogue` | roguehud / sprint0, sprint1 | `WEST-3,CENTER+2` | 24 / HUD | STATIC | бег/шаг ТГ |
| eye | `HUD_ROGUE_EYE` | `screen/rogue/eye` | roguehud / eye + oeye (цвет глаз) | `WEST-2,CENTER+3` | 24 / HUD | STATIC | СКМ: смотреть вверх; остальное — заглушка |
| advsetup | `HUD_ROGUE_ADVSETUP` | `.../placeholder/advsetup` | — (advsetup.dmi появляется только при выборе класса) | `CENTER-1,CENTER-1:16` | 24 / HUD | — | плейсхолдер |
| zone_select | `HUD_MOB_ZONE_SELECTOR` | `screen/zone_sel/rogue` | roguehud64 / m-zone_sel, f-zone_sel + слои конечностей, ран, кровотечения, выбора | `WEST-3:-16,CENTER+4:6` | 24 / HUD | STATIC | ЛКМ: зона ТГ (карта пикселей Азура); ПКМ: осмотр ран |
| stamina | `HUD_MOB_STAMINA` | `screen/stamina/rogue` | rogueheat / stam100…stam0 | `WEST-1,CENTER+2` | 24 / HUD | INFO | вывод выносливости в чат |
| energy | `HUD_ROGUE_ENERGY` | `.../stub/energy` | rogueheat / energy100 | `WEST-1,CENTER+2` | 24 / HUD | INFO | заглушка |
| feint_bar | `HUD_ROGUE_FEINT` | `.../stub/feint` | roguefeint / feintbar0 | `WEST-1:-6,SOUTH+10:15` | 24.1 / HUD | INFO | заглушка |

¹ Состояний `take0`/`give0`/`give1` в `roguehud.dmi` Азура нет; кнопка «give/take» в Азуре ссылается на них, порт сохраняет то же. Тест фиксирует это как известный факт.

Плейсхолдеры (grain, scannies, reads, textl/textr, fov, fov_blocker, advsetup) в Азуре невидимы, пока их не включит механика, которой в ТГ нет (настройки зерна/ЭЛТ, чтение книг, конус обзора в бою, выбор класса). Они зарегистрированы под своими ключами со спрайтами и местом Азура, но не входят ни в одну группу и на экран клиента не попадают. Механика при переносе добавит их в группу.

Зоны куклы: Азур различает 19 зон, ТГ целится в 9. Глаза → `eyes`, рот → `mouth`, пах → `groin`; нос, уши, шея, череп → `head`; живот → `chest`; кисти → руки; стопы → ноги. Подсветка выбора рисуется по зоне ТГ.

### Заглушки (К4)

Текст всех заглушек — `ROGUE_HUD_STUB_TEXT` = «не реализовано», показывается штатным `balloon_alert` над персонажем. Тест `rogue_hud/stub_clicks` кликает каждую (ЛКМ и ПКМ) без рантаймов и следит, чтобы их было ровно 12; `rogue_hud/all_clicks` кликает ЛКМ/ПКМ/СКМ по всем видимым элементам.

| Элемент | Текст | Статус |
|---|---|---|
| rmb_intent (альтернативные интенты) | не реализовано | заглушка, ждёт порт боёвки |
| quad_intents (СКМ-интенты: пинок, прыжок, укус, особое) | не реализовано | заглушка, ждёт порт боёвки |
| def_intent (уклонение/парирование) | не реализовано | заглушка, ждёт порт боёвки |
| defdelay (готовность к защите) | не реализовано | заглушка, ждёт порт боёвки |
| energy (синяя выносливость) | не реализовано | заглушка |
| feint_bar | не реализовано | заглушка, ждёт порт боёвки |
| sneak (режим скрытности) | не реализовано | заглушка |
| wrists, backr, trou, cloak, mouth (5 ячеек) | не реализовано | заглушки: в ТГ нет таких слотов |
| weapon intents без обработчика | не реализовано | ячейки кликаются и маршрутизируются в сигнал; сами интенты придут с портом боёвки |
| cmode, СКМ (compliance) | не реализовано | частичная заглушка |
| bloods, ПКМ (знакомые) | не реализовано | частичная заглушка |
| skills, ПКМ (черты, языки) | не реализовано | частичная заглушка |
| give с пустой рукой («взять») | не реализовано | частичная заглушка |
| eye: ЛКМ (веки, фиксация взгляда), ПКМ (осмотреться) | не реализовано | частичная заглушка |
| craft / stress без компонента крафта / настроения | не реализовано | срабатывает, только если у моба нет механики ТГ |

Крафт и навыки, которые в задании числились заглушками, подключены к штатным механикам ТГ (`personal_crafting`, `mind.print_levels`), потому что они в ТГ есть.

### Число экранных объектов

Измерено тестом `rogue_hud/screen_object_count` (выводит `TEST_NOTICE` в `data/logs/ci/runtime.log`), 2026-10-11, без настроения и крафта (они не добавляют объектов: у ТГ это +2, у рогатаунного HUD они переиспользуют свои элементы). «На экране» — стандартный режим со свёрнутым инвентарём:

| HUD | Зарегистрировано в `screen_objects` | На экране |
|---|---|---|
| ТГ, `/datum/hud/human` | 42 | 33 (+9 при развёрнутом инвентаре) |
| `/datum/hud/rogue/human` | 59 | 34 (+17 при развёрнутом инвентаре) |

Тест держит потолок `ROGUE_HUD_MAX_SCREEN_OBJECTS` = 59 и `ROGUE_HUD_MAX_SHOWN_OBJECTS` = 34 (`hud/rogue_hud_layout.dm`). Зарегистрированных объектов на 17 больше, чем у ТГ; 8 из них — невидимые плейсхолдеры Азура, которые на экран не попадают. Числа для 59 выведены из состава HUD после переноса инвентаря; тестовый прогон, который их подтвердит, — `dm-test --focus`.

## Отклонения от задания

1. **К5, число объектов.** На экране рогатаунный HUD почти равен ТГ (34 против 33 со свёрнутым инвентарём), но зарегистрированных объектов больше (59 против 42). Тест следит за потолком, а не за равенством с ТГ.
2. **К3, интенты оружия.** Виджет кликается и маршрутизирует клик в одну из 4 ячеек Азура (сигнал `COMSIG_MOB_ROGUE_HUD_INTENT_CLICK`, тест проверяет маршрутизацию), но интентов оружия нет, пока нет порта боёвки. «Интент» ТГ (`HUD_MOB_INTENTS`, боевой режим) переключается кнопкой cmode, это тоже покрыто тестом.
3. **К4, grain/scannies/advsetup.** В задании они названы кликабельными заглушками. Grain и scannies — полноэкранные оверлеи: кликабельные, они перехватывали бы все клики по миру. Advsetup в Азуре невидим вне выбора класса; кликабельный, он висел бы спрайтом 133×64 в центре экрана. Все три оставлены невидимыми плейсхолдерами, как в Азуре.
4. **Слоты ТГ без места в HUD Азура:** уши (`ITEM_SLOT_EARS`, гарнитура), глаза (`ITEM_SLOT_EYES`), хранилище костюма (`ITEM_SLOT_SUITSTORE`). Предметы в них работают и снимаются через меню раздевания, но на HUD не видны. Решается портом инвентаря.
5. **Отличия от Азура по решению заказчика (2026-10-11):** нет рамки вокруг карты; инвентарь — голый блок ячеек в левом нижнем углу без готического фона, свёрнут и открывается кнопкой-сумкой, как инвентарь ТГ.
6. **CI.** Воркфлоу ТГ собирают `tgstation.dme` без модуля. Тесты модуля запускаются обёрткой (`dm-test`), а чтобы CI их видел, нужна правка `.github/workflows` или `tgstation.dme` вне модуля — по заданию это эскалируется, не делается.
7. **`ROGUE_FORK_MIGRATION_PLAN.md`** в рабочем пространстве не найден. Обёртка сделана по схеме `modular_abel/build` из соседнего Vibelin (временный DME, компиляция, копирование артефактов).
8. **Скриншоты на трёх разрешениях** — см. отчёт о приёмке (раздел о проверке в клиенте).
9. **Область действия.** Рогатаунный HUD получают все люди любого вида (тип назначен базовому `/mob/living/carbon/human`; тест проверяет ящера и обезьяну). Призрак (роль наблюдателя) остаётся на HUD ТГ по решению заказчика. Силиконы, ксеноморфы, простые и базовые мобы, лобби тоже на HUD ТГ: в Азуре для них нет источника.

## TGUI (§11 задания)

HUD на TGUI не делался. Окно TGUI — отдельный браузерный элемент поверх карты, без прозрачности и без доступа к экранным объектам: в нём нельзя показать предметы в ячейках (`vis_contents`), перетаскивать предметы мышью на ячейки и руки, держать клики по карте рядом с HUD. Каждый клик шёл бы через `ui_act`, то есть с той же задержкой сервера, что и сейчас, так что разгрузки сервера это не даёт.

## Атрибуция ассетов

Спрайты скопированы без изменений из Azure Peak (кроме вырезки панели, см. ниже) (`RedTard-Project/Azure-Peak-Fork`), лицензия ассетов Azure Peak — [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/). Первые коммиты 2024-03-30 (d3e606bfdf, Bob) — импорт из Roguetown/Blackstone, авторы оригинальных спрайтов — команда Roguetown.

| Файл в модуле | Путь в Азуре | Последнее изменение в Азуре | Появление в Азуре |
|---|---|---|---|
| icons/mob/roguehud.dmi | icons/mob/roguehud.dmi | 587ab9ab49, 2026-06-25, FreeStylaLT | d3e606bfdf, 2024-03-30 |
| icons/mob/roguehud64.dmi | icons/mob/roguehud64.dmi | e45c216157, 2024-05-31, Useroth | d3e606bfdf, 2024-03-30 |
| icons/mob/roguehudback2.dmi | icons/mob/roguehudback2.dmi | 7fec142a1e, 2025-12-19, FreeStylaLT | d3e606bfdf, 2024-03-30 |
| icons/mob/roguehudbackghost.dmi | icons/mob/roguehudbackghost.dmi | d3e606bfdf, 2024-03-30, Bob | d3e606bfdf, 2024-03-30 |
| icons/mob/roguehudgrabs.dmi | icons/mob/roguehudgrabs.dmi | 9692418083, 2025-04-30, Shourya Biswas | d3e606bfdf, 2024-03-30 |
| icons/mob/rogueintentbase.dmi | icons/mob/rogueintentbase.dmi | d3e606bfdf, 2024-03-30, Bob | d3e606bfdf, 2024-03-30 |
| icons/mob/rogueintents.dmi | icons/mob/rogueintents.dmi | 884c2aa132, 2026-09-27, Mumblemancer | b69c48a485, 2026-03-07, WeNeedMorePhoron |
| icons/mob/rogueheat.dmi | icons/mob/rogueheat.dmi | a63649f689, 2026-02-04, FreeStylaLT | d3e606bfdf, 2024-03-30 |
| icons/mob/roguefeint.dmi | icons/mob/roguefeint.dmi | 61f6d3af1b, 2026-04-23, FreeStylaLT | 61f6d3af1b, 2026-04-23, FreeStylaLT |
| icons/mob/advsetup.dmi | icons/mob/advsetup.dmi | be60a664b6, 2025-03-13, Lutowski | d3e606bfdf, 2024-03-30 |
| icons/mob/vision_cone.dmi | icons/mob/vision_cone.dmi | d3e606bfdf, 2024-03-30, Bob | d3e606bfdf, 2024-03-30 |
| icons/hud/grain.dmi | icons/grain.dmi | a7fae3add1, 2024-05-04, RaShCAt | d3e606bfdf, 2024-03-30 |
| icons/hud/read.dmi | icons/roguetown/hud/read.dmi | d3e606bfdf, 2024-03-30, Bob | d3e606bfdf, 2024-03-30 |

Вырезка из `icons/mob/roguehudback2.dmi` (состояние `""`, кадр 0, 640×480), та же лицензия и авторы:

```
python -I modular_redtard/tools/dmi_crop.py modular_redtard/icons/mob/roguehudback2.dmi 0 640 480 modular_redtard/icons/mob/roguehud_panel.dmi panel=0,0,160,256
```

`roguehudgrabs.dmi` (захваты придут с портом боёвки) и `roguehudbackghost.dmi` (HUD призрака не переносится) пока не используются; в `.rsc` они не попадают, пока на них нет ссылок в коде.
