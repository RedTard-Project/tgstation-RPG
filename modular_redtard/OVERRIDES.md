# Реестр переопределений апстрима

Всё, чем `modular_redtard` меняет поведение кода ТГ, не редактируя его файлы. При синхронизации с апстримом сверять каждую строку с текущей версией указанной процедуры.

Ступени (по возрастанию риска при мерже):

1. Новый тип или файл в модуле.
2. Подтип типа ТГ.
3. Новая процедура на типе ТГ.
4. Переопределение значения переменной на типе ТГ.
5. Переопределение процедуры типа ТГ в модуле (с `..()` к оригиналу или без).
6. Правка файла апстрима. **Цель: ноль строк. Сейчас: ноль.**

## Ступень 5 — переопределения процедур

| Процедура | Файл модуля | Оригинал | Поведение | При мерже проверить |
|---|---|---|---|---|
| `/mob/living/carbon/update_health_hud(shown_health_amount)` | `hud/rogue_hud_bridges.dm` | `code/modules/mob/living/carbon/carbon.dm` | Если под `HUD_MOB_HEALTH` лежит `/atom/movable/screen/healths/rogue`: шлёт `COMSIG_CARBON_UPDATING_HEALTH_HUD` как оригинал, рисует индикатор Азура, обновляет куклу. Иначе `..()`. | Сигнал и его флаг `COMPONENT_OVERRIDE_HEALTH_HUD`; `/mob/living/carbon/human/update_health_hud` по-прежнему зовёт `..()` |
| `/mob/living/update_stamina_hud(shown_stamina_loss)` | `hud/rogue_hud_bridges.dm` | `code/modules/mob/living/living.dm` | Если под `HUD_MOB_STAMINA` лежит `/atom/movable/screen/stamina/rogue`: шкала Азура. Иначе `..()`. | Формулу порога (`maxHealth - crit_threshold`) |
| `/atom/movable/screen/plane_master/generate_relay_to(target_plane, relay_loc, show_to, blend_override, relay_layer)` | `hud/rogue_hud_bridges.dm` | `code/_onclick/hud/rendering/render_plate.dm` | Если якорь не передан (путь `add_relay_to()`: эмиссивы, параллакс), берёт якорь группы (`home.relay_loc`, с префиксом карты для попапов) вместо жёсткого `"1,1"`, затем `..()` | Что оригинал по-прежнему подставляет `"1,1"` по умолчанию и что `generate_render_relays()` читает `home.relay_loc` |
| `/datum/mood/update_mood_icon()` | `hud/rogue_hud_bridges.dm` | `code/datums/mood.dm` | Если под `HUD_MOB_MOOD` лежит `/atom/movable/screen/mood/rogue`: спрайт Азура по `mood_level`, без тонировки по рассудку и без спец-иконок мудлетов. Иначе `..()`. | Шкалу `MOOD_LEVEL_*` (1..9) |
| `/datum/mood/modify_hud(datum/source)` | `hud/rogue_hud_bridges.dm` | `code/datums/mood.dm` | `..()`, затем на рогатаунном HUD сразу `update_mood_icon()`, чтобы снять синюю тонировку, которую ставит оригинал. | Что оригинал по-прежнему добавляет элемент через `add_screen_object` |

## Ступень 4 — значения переменных

| Переменная | Файл модуля | Было | Стало |
|---|---|---|---|
| `/mob/living/carbon/human/hud_type` | `hud/human_hud_switch.dm` | `/datum/hud/human` (`human_defines.dm`) | `/datum/hud/rogue/human` |
| `/datum/plane_master_group/main/relay_loc` | `hud/rogue_hud_bridges.dm` | `"1,1"` (`plane_master_group.dm`) | `"SCREEN_SOUTHWEST"`: копии плейнов якорятся в угол плейна, а не вида; без бордюра это тот же тайл. Без этого левый HUD сдвигает весь мир вправо |

## Ступень 3 — новые процедуры на типах ТГ

| Процедура | Файл модуля | Назначение |
|---|---|---|
| `/atom/movable/screen/proc/rogue_hud_not_implemented(mob/user)` | `hud/rogue_hud_stubs.dm` | `balloon_alert` «не реализовано» |
| `/atom/movable/screen/proc/rogue_has_click_listener()` | `hud/rogue_hud_elements.dm` | Есть ли подписчик на `COMSIG_SCREEN_ELEMENT_CLICK`. Опирается на внутреннюю `_listen_lookup` из `code/datums/signals.dm` (один подписчик хранится как датум, несколько — как список) |

## Ступень 2 — подтипы типов ТГ

Переопределяют процедуры только своих подтипов, апстрим не затрагивают. Перечислены места, чувствительные к изменениям родителя.

| Подтип | Родитель | Что переопределено |
|---|---|---|
| `/datum/hud/rogue` | `/datum/hud` | `add_screen_object()` (под ключами `adopted_types` — настроение, крафт — отдаёт рогатаунный элемент вместо создания элемента ТГ или `CRASH` на дубликат), `initialize_screen_objects()`, `build_hand_slots()` (копия логики родителя с позициями Азура, без перестановки `swap_hand`/`drop`) |
| `/datum/hud/rogue/human` | `/datum/hud/rogue` | `initialize_screen_objects()`, `show_hud()` (интенты в углу в режиме F12), `update_locked_slots()` (копия логики `/datum/hud/human` без ушей, глаз и хранилища костюма) |
| `/datum/inventory_slot/rogue/*` | `/datum/inventory_slot` | только значения |
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
| `/atom/movable/screen/inventory/rogue` | `inventory` | `update_icon_state()`, `add_overlays()` (копия логики родителя с цветами Азура) |
| `/atom/movable/screen/inventory/hand/rogue` | `inventory/hand` | `update_overlays()` (убирает строки `lhandactive`/`rhandactive` родителя) |
| `/atom/movable/screen/zone_sel/rogue` | `zone_sel` | `Click()`, `MouseMove()`, `MouseExited()`, `get_zone_at()`, `update_icon_state()`, `update_overlays()`; `overlay_icon = null`, чтобы родитель не рисовал свой оверлей |
| `/obj/effect/overlay/zone_sel/rogue` | `/obj/effect/overlay/zone_sel` | только значения |

## Тесты

`tests/huds_rogue.dm` заново определяет `TEST_ASSERT` и `TEST_ASSERT_EQUAL` тем же текстом, что `code/modules/unit_tests/_unit_tests.dm` (тот снимает их `#undef` после своих файлов), и снимает в конце файла. При изменении макросов в апстриме синхронизировать.
