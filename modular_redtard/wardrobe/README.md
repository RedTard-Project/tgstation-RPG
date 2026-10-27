# wardrobe — гардероб Вайблина

Одежда, которую Вайблин (`modular_abel`) перенёс с Azure Peak, Twilight Axis и Rivermist, плюс его собственная
`gear/clothing`, и записи лоадаута, через которые Вайблин её выдаёт.

| Файл | Что это |
|---|---|
| `port.json` | настройки переноса: какие файлы Вайблина, куда ложатся пути, какие переменные и как их переводить |
| `ported.dm` | **генерируется**, руками не править |
| `icons/` | спрайты, на которые ссылаются перенесённые вещи, под их путями в Вайблине (`icons/modular_abel/...`, `icons/icons/roguetown/...`) |
| `loadout.dm` | вкладка «Wardrobe» в ТГ-лоадауте и раскладка вещи по слоту наряда |

Перегенерировать (из корня репозитория, Вайблин рядом в `../Vibelin`):

```
tools/bootstrap/python -I C:/Axis/ai-skills/scripts/dm_type_port.py modular_redtard/wardrobe/port.json
```

Скрипт универсальный (`ai-skills/scripts/dm_type_port.py`): он разбирает всю сборку Вайблина, у каждой вещи
проходит её родителей до ядра и пишет плоский тип со всеми нужными переменными, поэтому родители Вайблина нам не
нужны.

## Куда ложатся вещи

Корни Вайблина (Vanderlin) переложены под корни Ratwood, уже перенесённые портером `rockhill`, чтобы вещи
наследовали поведение своей категории:

| Вайблин | У нас |
|---|---|
| `/obj/item/clothing/head` | `/obj/item/clothing/head/roguetown/wardrobe` |
| `/obj/item/clothing/face` | `/obj/item/clothing/mask/rogue/wardrobe` |
| `/obj/item/clothing/neck` | `/obj/item/clothing/neck/roguetown/wardrobe` |
| `/obj/item/clothing/cloak` | `/obj/item/clothing/cloak/wardrobe` |
| `/obj/item/clothing/shirt` | `/obj/item/clothing/suit/roguetown/shirt/wardrobe` |
| `/obj/item/clothing/armor` | `/obj/item/clothing/suit/roguetown/armor/wardrobe` |
| `/obj/item/clothing/pants` | `/obj/item/clothing/under/roguetown/wardrobe` |
| `/obj/item/clothing/{gloves,shoes,wrists,ring}` | те же корни Ratwood + `/wardrobe` |
| `/datum/loadout_item/...` | `/datum/loadout_item/rogue_wardrobe/...` |

Корни `/wardrobe` объявлены абстрактными.

## Как переводятся переменные

- `mob_overlay_icon` → `worn_icon`, `item_state` → `worn_icon_state`, `sleeved` → `rogue_sleeved`.
- Слоты Вайблина → наши (`ITEM_SLOT_SHIRT` → `ITEM_SLOT_ROGUE_SHIRT`, `ITEM_SLOT_ARMOR` → `ITEM_SLOT_OCLOTHING`,
  `ITEM_SLOT_PANTS` → `ITEM_SLOT_ICLOTHING` и т. д., та же таблица, что у портера `rockhill`).
- `body_parts_covered`: части лица Вайблина (`MOUTH`, `NOSE`, `EARS`, `EYES`) → `HEAD`, `VITALS` → `CHEST`.
- `flags_inv` — только ТГ-шные флаги; `HIDEBOOB`, `HIDECROTCH`, `HIDETAIL` у нас ничего не прячут и отброшены.
- `block2add` → флаги конуса обзора `ROGUE_FOV_*` (см. `combat/fov.dm`).
- `armor_type` (датумы брони Vanderlin) → ближайший тир Ratwood в `rogue_armor`; `/datum/armor/none` — без брони.
- Цвета, детали (`detail_tag`, `detail_color`), «бюст» (`boobed`) — как есть; рисует их `clothing/details.dm`.
- `rogue_female_worn` ставится, если в листе есть женский вариант состояния (`_f`); `worn_x/y_dimension` —
  по размеру кадра листа (64×64, 32×48).
- Списки, звуки и цены (`sellprice`, `triumph_cost_permanent`) не переносятся.

## Что не перенесено

- Рецепты (наковальня, шитьё) — у нас нет этих ремёсел. Маски `facemasks`, которые у Вайблина только куются,
  получили записи лоадаута, иначе их не достать.
- Донатный лоадаут Вайблина (`gear/items/donor_loadout.dm`) — вещи перенесены, но в лоадауте их нет.
- Пояса `gear/clothing/belt.dm` — у Вайблина это хранилища (`/obj/item/storage/belt`), не одежда.
- `snouted_helms` — варианты шлемов под морды, у нас нет таких рас.
- Цена в триумфах — в ТГ-лоадауте её нет, всё бесплатно.
