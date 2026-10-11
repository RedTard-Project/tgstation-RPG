# Реестр переопределений апстрима

Всё, чем `modular_redtard` меняет поведение кода ТГ, не редактируя его файлы. При синхронизации с апстримом сверять каждую строку с текущей версией указанной процедуры.

Ступени (по возрастанию риска при мерже):

1. Новый тип или файл в модуле.
2. Подтип типа ТГ.
3. Новая процедура на типе ТГ.
4. Переопределение значения переменной на типе ТГ.
5. Переопределение процедуры типа ТГ в модуле (с `..()` к оригиналу или без).
6. Правка файла апстрима. **Цель: ноль строк. Сейчас: ноль.**

## Ступень 1 — новый файл вне папки модуля

| Файл | Зачем | При мерже проверить |
|---|---|---|
| `tgui/packages/tgui/interfaces/RogueStripMenu.tsx` | Меню раздевания для людей. TGUI ищет интерфейс по имени только в `tgui/packages/tgui/interfaces/` и собирает его одним бандлом, поэтому файл лежит там, а не в модуле. Это копия `StripMenu.tsx` ТГ плюс клетки `mouth` `[0,3]`, `cloak` `[1,0]`, `shirt` `[2,0]`, `wrists` `[3,3]`, `backr` `[3,5]` (спина ТГ подписана `back (left)`) и четыре кольца `ring1`–`ring4` четвертями клетки `[3,4]` (компонент `QuarterSlots`). Неизвестные ключи слотов и альтернативных действий пропускаются, поэтому новые действия ТГ не роняют окно, а просто не показываются, пока копию не обновят. Сам `StripMenu.tsx` ТГ не тронут | Сравнить с `StripMenu.tsx` ТГ (`git diff --no-index`) и перенести его изменения: новые `ALTERNATE_ACTIONS`, клетки, разметку. Ключи DM (`STRIPPABLE_ITEM_ROGUE_*`, `ring1`–`ring4`) должны совпадать с ключами `SLOTS`; клетки `[0,3]`, `[1,0]`, `[2,0]`, `[3,3]`, `[3,4]`, `[3,5]` не должны совпасть с новыми клетками ТГ |

## Ступень 5 — переопределения процедур

| Процедура | Файл модуля | Оригинал | Поведение | При мерже проверить |
|---|---|---|---|---|
| `/mob/living/carbon/update_health_hud(shown_health_amount)` | `hud/rogue_hud_bridges.dm` | `code/modules/mob/living/carbon/carbon.dm` | Если под `HUD_MOB_HEALTH` лежит `/atom/movable/screen/healths/rogue`: шлёт `COMSIG_CARBON_UPDATING_HEALTH_HUD` как оригинал, рисует индикатор Азура, обновляет куклу. Иначе `..()`. | Сигнал и его флаг `COMPONENT_OVERRIDE_HEALTH_HUD`; `/mob/living/carbon/human/update_health_hud` по-прежнему зовёт `..()` |
| `/mob/living/update_stamina_hud(shown_stamina_loss)` | `hud/rogue_hud_bridges.dm` | `code/modules/mob/living/living.dm` | Если под `HUD_MOB_STAMINA` лежит `/atom/movable/screen/stamina/rogue`: шкала Азура. Иначе `..()`. | Формулу порога (`maxHealth - crit_threshold`) |
| `/atom/movable/screen/plane_master/generate_relay_to(target_plane, relay_loc, show_to, blend_override, relay_layer)` | `hud/rogue_hud_bridges.dm` | `code/_onclick/hud/rendering/render_plate.dm` | Если якорь не передан (путь `add_relay_to()`: эмиссивы, параллакс), берёт якорь группы (`home.relay_loc`, с префиксом карты для попапов) вместо жёсткого `"1,1"`, затем `..()` | Что оригинал по-прежнему подставляет `"1,1"` по умолчанию и что `generate_render_relays()` читает `home.relay_loc` |
| `/datum/map_config/LoadConfig(filename, error_if_missing)` | `maps/era.dm` | `code/datums/map_config.dm` | `..()`, затем читает ключ `era` из того же JSON; неизвестное значение пишет в лог и грузит карту как modern. Возвращает то, что вернул оригинал | Что оригинал по-прежнему возвращает декодированный JSON (проверка на истину в `load_map_config`) |
| `/datum/controller/subsystem/mapping/PreInit()` | `maps/pool.dm` | `code/controllers/subsystem/mapping.dm` | `..()`; если `next_map.json` нет (`current_map.defaulted`), загружает случайную votable medieval-карту из `config.maplist` | Что `next_map.json` по-прежнему читается первым, и что у оригинального `Initialize()` ветка `defaultmap` не срабатывает для медиевал-карты |
| `/datum/job/map_check()` | `maps/pool.dm` | `code/modules/jobs/job_types/_job.dm` | `..()`; если эпоха роли не `any` и не совпадает с эпохой карты, роль закрывается: снимается `JOB_NEW_PLAYER_JOINABLE`, `total_positions` и `spawn_positions` обнуляются, `map_check()` возвращает истину — роль остаётся в `all_occupations`, потому что `setup_officer_positions()` и ID-трим офицера СБ ищут её по типу | Что `setup_occupations()` по-прежнему вызывает `map_check()` до проверки `JOB_NEW_PLAYER_JOINABLE`, и что системы ТГ всё так же требуют существования роли офицера СБ |
| `/datum/map_config/LoadConfig(filename, error_if_missing)` | `maps/world_size.dm` | `code/datums/map_config.dm` | Второе переопределение (вызывает предыдущее через `..()`): читает ключ `world_size` (`[ширина, высота]`) из JSON карты | То же, что для `maps/era.dm` |
| `/mob/living/carbon/equip_to_slot(...)` | `clothing/slots.dm` | `code/modules/mob/living/carbon/inventory.dm` | `..()`; если вернулось «не обработано» и слот — слой модуля (`ITEM_SLOTS_ROGUE`) или спина ТГ с выбранной правой ячейкой (`rogue_back_target`), кладёт вещь в переменную человека, зовёт `has_equipped` и отвечает «обработано», поэтому `switch` человека до этих слотов не доходит | Что человеческий `equip_to_slot` по-прежнему начинается с `if(!..()) return`, а карбонный возвращает `not_handled` |
| `/mob/living/carbon/human/get_item_by_slot`, `get_slot_by_item`, `doUnEquip`, `update_clothing` | `clothing/slots.dm` | `code/modules/mob/living/carbon/human/inventory.dm`, `code/modules/mob/mob_update_icons.dm` | Слои модуля и правая спина (`ITEM_SLOT_BACK` при `rogue_back_target = 2` отдаёт `wear_backr`), иначе `..()`. `doUnEquip` после снятия пояса роняет вещи с бёдер, которые больше нельзя носить; `update_clothing` для пояса перерисовывает бёдра | Что `doUnEquip` оригинала по-прежнему сам роняет карманы при снятии формы через `can_equip(..., ignore_equipped = TRUE)` | Сигнатуры процедур |
| `/mob/living/carbon/human/get_worn_bodypart_armor_value(def_zone, damage_type)` | `clothing/slots.dm` | `code/modules/mob/living/carbon/human/human_defense.dm` | `..()`, затем домножает «непробитый урон» на броню слоёв модуля, покрывающих часть тела | Что оригинал по-прежнему возвращает `100 - unblocked_damage` и перебирает фиксированный список слотов |
| `/mob/living/carbon/human/equip_to_appropriate_slot(W, ...)` | `clothing/slots.dm` | `code/modules/mob/inventory.dm` (на `/mob`) | Если у вещи нет `slot_equipment_priority` и есть слой модуля в `slot_flags` — сначала пробует рубаху, плащ, наручи, кольца; рот — только если кроме него у вещи есть лишь карманы (иначе Ратвуд сначала пробует другие слоты); вещь для спины при занятой левой спине — в правую. Потом `..()` | Что приоритет слотов ТГ по-прежнему локальный список в этой процедуре |
| `/mob/living/carbon/human/get_clothing_examine_info(user)` | `clothing/slots.dm` | `code/modules/mob/living/carbon/examine.dm` | `..()`, затем строки про рубаху (прячется при `HIDEJUMPSUIT`), плащ, наручи, рот, кольца (прячутся при `HIDEGLOVES`) | Что процедура по-прежнему возвращает список строк |
| `/obj/item/bodypart/head/drop_limb(special, dismembered, move_to_floor)` | `clothing/slots.dm` | `code/modules/surgery/bodyparts/dismemberment.dm` | Если голову отрывают не «особым» образом (`special`), роняет вещь изо рта, затем `..()`. Оригинал роняет только вещи из фиксированного списка слотов ТГ (`EYES`, `EARS`, `MASK`, `HEAD`) | Что оригинал по-прежнему перебирает фиксированный список слотов и что `owner` ещё задан до `..()` |
| `/mob/living/carbon/human/update_worn_back()` | `clothing/onmob.dm` | `code/modules/mob/living/carbon/human/human_update_icons.dm` | `..()`; если у вещи на спине `rogue_onback`, снимает оверлей `BACK_LAYER` оригинала и кладёт спрайт из генератора (зеркальный, как левая спина Ратвуда) | Что оригинал по-прежнему кладёт спину в `overlays_standing[BACK_LAYER]` |
| `/mob/living/carbon/human/update_pockets()` | `clothing/onmob.dm` | там же | `..()` (ячейки HUD), затем рисует вещи на бёдрах: генератор для `rogue_onhip`, иначе `build_worn_icon` с листом стороны; правое бедро — `r_store`, левое (зеркальное) — `l_store` | Что карманы по-прежнему обновляются этой процедурой и что ТГ сам их не рисует |
| `/datum/controller/global_vars/InitGlobalstrippable_human_items()` | `clothing/stripping.dm` | `code/modules/mob/living/carbon/human/human_stripping.dm` (`GLOBAL_LIST_INIT`) | `..()`, затем дописывает в `GLOB.strippable_human_items` плащ, рубаху, наручи, рот и четыре кольца. Тот же приём, что у `GLOBAL_PROTECT` ТГ. Все люди получают элемент `strippable` с этим же списком, поэтому новые ячейки видны в меню раздевания | Что список по-прежнему объявлен через `GLOBAL_LIST_INIT` (процедура `InitGlobal<имя>`) и что `/mob/living/carbon/human/Initialize` передаёт его в `AddElement` |
| `/datum/strip_menu/ui_interact(user, ui)` | `clothing/stripping.dm` | `code/datums/elements/strippable.dm` | Для людей открывает интерфейс `RogueStripMenu` вместо `StripMenu` (те же три строки, что в оригинале, с другим именем); для остальных (собаки, манекены) `..()` | Что оригинал по-прежнему только создаёт или обновляет `/datum/tgui` и ничего больше не делает |
| `/datum/species/can_equip(...)` | `clothing/slots.dm` | `code/modules/mob/living/carbon/human/_species.dm` | Для слоёв модуля: слот свободен, `slot_flags` совпадает, для рта есть голова, `equip_delay_self_check`. Для карманов и пояса — своя `can_equip_rogue_hip()` без `..()`: начало оригинала (`no_equip_flags`, занятость, `slot_flags` или мелкий размер для кармана), затем правило Ратвуда — карману (бедру) нужен пояс, поясу ничего не нужно. Иначе `..()` | Что `equip_delay_self_check` существует |
| `/datum/outfit/job/roguetown/pre_equip()`, `equip()` | `rockhill/jobs.dm` | свой подтип | `pre_equip` пропускает штатный выбор рюкзака работ ТГ; `equip` после `..()` надевает рубаху, наручи, кольцо, плащ, вещь во рту | — |
| `/datum/controller/subsystem/air/Initialize()` | `maps/era_limits.dm` | `code/controllers/subsystem/air.dm` | `..()`, затем на medieval-карте `can_fire = FALSE` | Что `setup_allturfs()` по-прежнему пропускает турфы с `init_air = FALSE` и что турф создаёт `air` сам в `/turf/open/Initialize` |
| `/datum/controller/subsystem/machines/Initialize()` | `maps/era_limits.dm` | `code/controllers/subsystem/machines.dm` | `..()`, затем на medieval-карте `can_fire = FALSE` | Что ничего на medieval-карте не требует `process()` машин |
| `/datum/controller/subsystem/mapping/loadWorld()` | `maps/world_size.dm` | `code/controllers/subsystem/mapping.dm` | Если у карты есть `world_size` больше текущего мира — `world.increase_max_x/y`, затем `..()`. Иначе `LoadGroup` центрирует карту в мире 255×255 с отрицательным смещением и обрезает её | Формулу смещения в `LoadGroup` (`round(world.maxx / 2 - bounds / 2) + 1`) и что `loadWorld()` по-прежнему грузит станцию через `LoadGroup` |
| `/datum/mood/update_mood_icon()` | `hud/rogue_hud_bridges.dm` | `code/datums/mood.dm` | Если под `HUD_MOB_MOOD` лежит `/atom/movable/screen/mood/rogue`: спрайт Азура по `mood_level`, без тонировки по рассудку и без спец-иконок мудлетов. Иначе `..()`. | Шкалу `MOOD_LEVEL_*` (1..9) |
| `/datum/mood/modify_hud(datum/source)` | `hud/rogue_hud_bridges.dm` | `code/datums/mood.dm` | `..()`, затем на рогатаунном HUD сразу `update_mood_icon()`, чтобы снять синюю тонировку, которую ставит оригинал. | Что оригинал по-прежнему добавляет элемент через `add_screen_object` |

## Ступень 4 — значения переменных

| Переменная | Файл модуля | Было | Стало |
|---|---|---|---|
| `/mob/living/carbon/human/hud_type` | `hud/human_hud_switch.dm` | `/datum/hud/human` (`human_defines.dm`) | `/datum/hud/rogue/human` |
| `/datum/plane_master_group/main/relay_loc` | `hud/rogue_hud_bridges.dm` | `"1,1"` (`plane_master_group.dm`) | `"SCREEN_SOUTHWEST"`: копии плейнов якорятся в угол плейна, а не вида; без бордюра это тот же тайл. Без этого левый HUD сдвигает весь мир вправо |

## Ступень 4 — дополнение (пул карт)

| `/datum/job/var/map_era` (новая переменная) | `maps/era.dm` | — | `"modern"`: эпоха роли, по умолчанию modern |
| `/datum/map_config/var/map_era` (новая переменная) | `maps/era.dm` | — | `"modern"`: эпоха карты, читается из JSON |
| `/datum/job/assistant/map_era` | `maps/era.dm` | `"modern"` | `"any"`: тестовый Ассистент доступен на любой карте |
| `/obj/item/var/worn_icon_backr`, `worn_icon_hipl`, `worn_icon_hipr` (новые переменные) | `clothing/slots.dm` | — | `null`: листы спрайтов для правой спины и бёдер, если вещь своего `worn_icon` не имеет (у Ратвуда стороны нарисованы зеркально: `back_l/back_r.dmi`, `belt_l/belt_r.dmi`); пишет портер |
| `/obj/item/var/rogue_onhip`, `rogue_onback` (новые переменные) | `clothing/onmob.dm` | — | `FALSE`: рисовать вещь на бедре или спине генератором из её спрайта (флаги `experimental_onhip`/`onback` Ратвуда); пишет портер |
| `/datum/map_config/var/world_size` (новая переменная) | `maps/world_size.dm` | — | `null`: размер мира `[x, y]`, который нужен карте; пишет генератор Рокхилла |

## Ступени 1–2 — импорт Рокхилла (`rockhill/`)

Только новые типы. Пути Ратвуда, которых нет в ТГ, объявлены в `rockhill/ported/` (генерирует `tools/port_rockhill.py`) и пришиты к базе через `parent_type`. Часть из них лежит под путями ТГ (`/turf/open/floor/carpet/inn`, `/obj/structure/flora/newtree`, `/turf/closed/wall/mineral/rogue`), но `parent_type` уводит их от поведения родителя ТГ. Переопределений процедур ТГ здесь нет.

| Корень | Пришит к | Файл |
|---|---|---|
| `/area/rogue` | `/area/station` (без питания; `/area/rogue/outdoors` — `outdoors`, `static_lighting = FALSE`, `base_lighting_alpha = 255`) | `rockhill/bases.dm` |
| Полы Ратвуда (`/turf/open/floor/rogue` и др.) | `/turf/open/floor/rockhill` (подтип `/turf/open/floor` без групп сглаживания) | `rockhill/ported/turfs_open.dm` |
| Стены и скалы (`/turf/closed/mineral/rogue`, `/turf/closed/wall/mineral/rogue`, `/turf/closed/basic` и др.) | `/turf/closed/rockhill` (подтип `/turf/closed`, `smoothing_flags = NONE`) | `rockhill/ported/turfs_closed.dm` |
| Конструкции, флора, декор | `/obj/structure/rockhill` | `rockhill/ported/structures.dm` |
| Окна `/obj/structure/roguewindow` | `/obj/structure/rockhill/window` | `rockhill/ported/windows.dm` |
| Огни `/obj/machinery/light/rogue`, `/obj/machinery/light/roguestreet` | `/obj/structure/rockhill/light` (свет — переменные `light_*` атома) | `rockhill/ported/lights.dm` |
| Вода `/turf/open/water/*` | `/turf/open/water/rockhill` (подтип воды ТГ) | `rockhill/ported/turfs_water.dm` |
| Декали `/obj/effect/decal/*` | свои родители ТГ, только имя/иконка | `rockhill/ported/decals.dm` |
| Лава, ковры | рескин: `/turf/open/lava/rockhill`, `/turf/open/floor/carpet/rockhill/*` с `parent_type` на исходный тип ТГ | `rockhill/ported/turfs_reskin.dm` |
| Предметы `/obj/item/*` | `/obj/item/rockhill`; одежда, контейнеры, сумки — естественные родители ТГ | `rockhill/ported/items.dm` |
| Мобы `/mob/living/*` | `/mob/living/basic/rockhill` (без ИИ); люди — естественные родители ТГ | `rockhill/ported/mobs.dm`, `humans.dm` |
| Лут `/obj/effect/spawner/lootdrop/*` | `/obj/effect/spawner/random/rockhill` | `rockhill/ported/spawners.dm` |

Сглаживание: `smooth_icon()` переопределена у своих подтипов `/turf/open/floor/rockhill`, `/turf/open/water/rockhill`, `/turf/open/lava/rockhill` (у ТГ так же сделано для `/turf/open/lava/smooth`): для турфов из `GLOB.rockhill_turf_edge_sources` вместо `bitmask_smooth()` накладываются края Ратвуда, остальные идут в `..()`. Сами края — ступень 3: новая переменная `/turf/open/var/rockhill_edges` и процедура `/turf/open/proc/update_rockhill_edges()` (`rockhill/edges.dm`), общие для трёх подтипов. `/turf/open/water/rockhill/Initialize()` — свой подтип, после `..()` добавляет слои воды Ратвуда. При мерже проверить, что `/atom/proc/smooth_icon()` по-прежнему снимает `SMOOTH_QUEUED` и что `QUEUE_SMOOTH`/`QUEUE_SMOOTH_NEIGHBORS` ставят турфы с `SMOOTH_BITMASK_CARDINALS` в очередь. Использованы группы ТГ `SMOOTH_GROUP_MINERAL_WALLS`, `SMOOTH_GROUP_WALLS`, `SMOOTH_GROUP_WOOD_WALLS`, `SMOOTH_GROUP_OPEN_FLOOR`.

Роли Ратвуда — подтипы ТГ: `/datum/job/roguetown/*` (`/datum/job`), `/datum/outfit/job/roguetown/*` (`/datum/outfit/job`), `/datum/job_department/rockhill_*` (`/datum/job_department`), `/obj/effect/landmark/start/rockhill/*` (`/obj/effect/landmark/start`, часть пришита к `start/assistant`). Переопределена одна процедура своего подтипа: `/datum/job/roguetown/config_check()` возвращает ложь для `abstract_type`, потому что `SSjob.setup_occupations()` создаёт все `subtypesof(/datum/job)`. Битовые флаги отделов `(1<<10)…(1<<18)` — проверить при мерже, что ТГ не занял эти биты под свои `DEPARTMENT_BITFLAG_*`.

При мерже проверить: что у `/turf/open/floor`, `/turf/closed` и `/area/station` остались переменные `smoothing_groups`, `canSmoothWith`, `smoothing_flags`, `requires_power`, `outdoors`, `static_lighting`, `base_lighting_alpha`.

## Ступень 3 — новые процедуры на типах ТГ

| Процедура | Файл модуля | Назначение |
|---|---|---|
| `/atom/movable/screen/proc/rogue_hud_not_implemented(mob/user)` | `hud/rogue_hud_stubs.dm` | `balloon_alert` «не реализовано» |
| `/obj/item/proc/rogue_onmob_prop(tag)`, `rogue_onmob_overlays()`, `rogue_onmob_icon()`, `build_rogue_onmob_icon()`; `/proc/rogue_mirror_fix()` | `clothing/onmob.dm` | Генератор спрайтов на теле: таблица на сторону (база — значения по умолчанию Ратвуда, переопределения — `rockhill/ported/onmob.dm`), сборка 4-направленной иконки через `icon` (`Blend`, `Flip`, `Turn`, `Scale`), кэш по типу/иконке/состоянию/цвету |
| `/mob/living/carbon/human/proc/update_rogue_hip()`, `set_rogue_overlay()` и другие процедуры слоёв | `clothing/slots.dm`, `clothing/onmob.dm` | Оверлеи слоёв модуля по ключу |
| `/datum/species/proc/can_equip_rogue_hip()` | `clothing/slots.dm` | Правила кармана (бедра) и пояса по Ратвуду, см. ступень 5 |
| `/atom/movable/screen/proc/rogue_has_click_listener()` | `hud/rogue_hud_elements.dm` | Есть ли подписчик на `COMSIG_SCREEN_ELEMENT_CLICK`. Опирается на внутреннюю `_listen_lookup` из `code/datums/signals.dm` (один подписчик хранится как датум, несколько — как список) |

## Ступень 2 — подтипы типов ТГ

Переопределяют процедуры только своих подтипов, апстрим не затрагивают. Перечислены места, чувствительные к изменениям родителя.

| Подтип | Родитель | Что переопределено |
|---|---|---|
| `/datum/hud/rogue` | `/datum/hud` | `add_screen_object()` (под ключами `adopted_types` — настроение, крафт — отдаёт рогатаунный элемент вместо создания элемента ТГ или `CRASH` на дубликат), `initialize_screen_objects()`, `build_hand_slots()` (копия логики родителя с позициями Азура, без перестановки `swap_hand`/`drop`) |
| `/datum/hud/rogue/human` | `/datum/hud/rogue` | `initialize_screen_objects()`, `show_hud()` (интенты в углу в режиме F12), `update_locked_slots()` (копия логики `/datum/hud/human` без ушей, глаз и хранилища костюма; карманы-бёдра заперты без пояса, пояс не требует формы) |
| `/datum/inventory_slot/rogue/*` | `/datum/inventory_slot` | только значения |
| `/datum/inventory_slot/rogue/ring` | `/datum/inventory_slot/rogue` | `create_element()` (четыре ячейки `ring1`–`ring4` вместо одной), `get_slot_item()`, `get_screen_slot()`, `update_inventory_slot()` с номером кольца — по образцу `/datum/inventory_slot/hands` ТГ |
| `/datum/inventory_slot/rogue/backl` | `/datum/inventory_slot/rogue` | Те же четыре процедуры с номером спины: кроме ячейки спины ТГ создаёт ячейку `backr`. ТГ зовёт `update_inventory_slot(ITEM_SLOT_BACK)` без номера — обновляются обе |
| `/datum/strippable_item/mob_item_slot/rogue/*` | `/datum/strippable_item/mob_item_slot` | `get_obscuring()` (после `..()`: рубаха прячется при `HIDEJUMPSUIT`, кольца при `HIDEGLOVES`); у `rogue/indexed/*` (кольца, правая спина) ещё `get_item()`, `try_equip()`, `finish_equip()` (на время вызова выбирают ячейку через `aim_rogue_slot`) и `start_equip()` — копия `mob_item_slot/start_equip()` ТГ, где ячейка выбирается только вокруг проверки `mob_can_equip`, а не на время `do_after`. При мерже сверить с оригиналом |
| `/atom/movable/screen/combattoggle/rogue` | `combattoggle` | `update_icon_state()` (после `..()`), `Click()` |
| `/atom/movable/screen/mood/rogue` | `mood` | `Initialize()`, `Click()` |
| `/atom/movable/screen/healths/rogue` | `healths` | `Click()` |
| `/atom/movable/screen/stamina/rogue` | `stamina` | `Click()` |
| `/atom/movable/screen/throw_catch/rogue` | `throw_catch` | `update_icon_state()`; слушает `COMSIG_LIVING_THROW_MODE_TOGGLE`, потому что `throw_mode_on/off` пишут в `icon_state` состояния ТГ |
| `/atom/movable/screen/rest/rogue` | `rest` | `update_icon_state()`, `Click()` |
| `/atom/movable/screen/mov_intent/rogue` | `mov_intent` | `update_icon_state()` |
| `/atom/movable/screen/drop/rogue` | `drop` | только значения |
| `/atom/movable/screen/human/toggle/rogue` | `human/toggle` | `update_icon_state()` (после `..()`), `Click()` (та же логика, что у родителя, но без обращения к `usr.client` без проверки — родитель падает у моба без клиента) |
| `/atom/movable/screen/craft/rogue` | `craft` | `Click()` |
| `/atom/movable/screen/inventory/rogue` | `inventory` | `update_icon_state()`, `add_overlays()` (копия логики родителя с цветами Азура); своя процедура `get_worn_item()` |
| `/atom/movable/screen/inventory/rogue/indexed` (кольца — подтип `ring` с масштабом 0.5, правая спина) | `inventory/rogue` | `get_worn_item()` (вещь своей ячейки), `Click()` и `add_overlays()` (выбирают ячейку через `aim_rogue_slot` на время `..()`, чтобы штатный клик ТГ взял или надел вещь именно этой ячейки) |
| `/atom/movable/screen/inventory/hand/rogue` | `inventory/hand` | `update_overlays()` (убирает строки `lhandactive`/`rhandactive` родителя) |
| `/atom/movable/screen/zone_sel/rogue` | `zone_sel` | `Click()`, `MouseMove()`, `MouseExited()`, `get_zone_at()`, `update_icon_state()`, `update_overlays()`; `overlay_icon = null`, чтобы родитель не рисовал свой оверлей |
| `/obj/effect/overlay/zone_sel/rogue` | `/obj/effect/overlay/zone_sel` | только значения |

## Тесты

Тестовые файлы обёрнуты в собственные `#ifdef` (`UNIT_TESTS`, `REDTARD_TEST_FOCUS`), потому что Dream Maker дописывает их в блок `BEGIN_INCLUDE` модуля без условий.

`tests/huds_rogue.dm` заново определяет `TEST_ASSERT` и `TEST_ASSERT_EQUAL` тем же текстом, что `code/modules/unit_tests/_unit_tests.dm` (тот снимает их `#undef` после своих файлов), и снимает в конце файла. При изменении макросов в апстриме синхронизировать.
