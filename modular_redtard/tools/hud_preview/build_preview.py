"""Builds the mock-up of the rogue HUD: one HTML page that draws the HUD from the module's own layout, to look at and
to move things about without starting the game.

It reads
  - the layout table of tests/huds_rogue.dm (every element of the HUD: its type, place, icon, state, layer and group);
  - the places themselves, the `#define rogueui_...` lines of the module;
  - the numbers of the frame from hud/rogue_frame.dm and the view range from hud/view_range.dm and the config;
  - the sprites from the .dmi files,
and fills template.html with them.

    py -3 -I modular_redtard/tools/hud_preview/build_preview.py [--out <file>]

The page is published as an artifact; README.md of the module says how.
"""
import argparse
import base64
import datetime
import hashlib
import io
import json
import re
import sys
from pathlib import Path

from PIL import Image

HERE = Path(__file__).resolve().parent
MODULE = HERE.parent.parent
REPO = MODULE.parent
DEFAULT_OUT = REPO / '.cache' / 'modular_redtard' / 'hud_preview' / 'hud_layout.html'
DATA_MARK = '/*HUD_DATA*/null'

HUD_ICON = 'modular_redtard/icons/mob/roguehud.dmi'
INTENT_ICON = 'modular_redtard/icons/mob/rogueintents.dmi'

# What the game draws over or under an element at run time, for a mock-up that looks like a played HUD: the state to show
# where the table leaves it to the game, and the overlays as (icon or None for the element's own, state, x, y).
PREVIEW = {
    'HUD_MOB_MOOD': {'state': 'mood_idle', 'under': [(None, 'stressback', 0, 0)]},
    'HUD_MOB_HEALTH': {'under': [(HUD_ICON, 'stressback', -5, -8)]},
    'HUD_MOB_MOVE_INTENT': {'state': 'sprint0'},
    'HUD_MOB_ZONE_SELECTOR': {
        'state': 'm-zone_sel',
        'over': [(None, 'm-%s' % zone, 0, 0) for zone in ('head', 'chest', 'l_arm', 'r_arm', 'l_leg', 'r_leg')] + [(None, 'm_chest', 0, 0)],
    },
    'HUD_ROGUE_WEAPON_INTENTS': {
        'over': [(HUD_ICON, 'intentselected', 0, 16), (INTENT_ICON, 'intouch', 0, 16), (INTENT_ICON, 'inshove', 32, 16), (INTENT_ICON, 'ingrab', 0, 0), (INTENT_ICON, 'inpunch', 32, 0)],
    },
    'HUD_ROGUE_RMB_BUTTON': {'over': [(None, 'rmbaimed_x', 0, 0)]},
    'HUD_ROGUE_RMB_SLOT(3)': {'over': [(None, 'rmbaimed_x', 0, 0)]},
    'HUD_ROGUE_DOLL_TOGGLE': {'over': [(None, 'corner', 0, 0)]},
    'HUD_ROGUE_EYE': {'over': [(None, 'oeye', 0, 0)]},
    'HUD_KEY_HAND_SLOT(1)': {'over': [(None, 'hand_active', 0, 0)]},
    'HUD_ROGUE_MANA': {'state': 'mana100'},
}

# Elements the game draws at another size: the type's `transform` (the ring cells are half cells).
SCALES = {
    '/atom/movable/screen/inventory/rogue/indexed/ring': 0.5,
}

LABELS = {
    'HUD_HUMAN_TOGGLE_INVENTORY': 'Кнопка инвентаря',
    'HUD_ROGUE_WEAPON_INTENTS': 'Намерения оружия',
    'HUD_MOB_MOOD': 'Стресс',
    'HUD_ROGUE_RMB_BUTTON': 'Кнопка ПКМ-намерений',
    'HUD_MOB_HEALTH': 'Сердце',
    'HUD_ROGUE_QUAD_INTENTS': 'СКМ: укус, прыжок, пинок, особое',
    'HUD_ROGUE_DEF_INTENT': 'Защита: парирование или уклонение',
    'HUD_MOB_INTENTS': 'Боевой режим',
    'HUD_ROGUE_GIVE': 'Дать или взять',
    'HUD_ROGUE_HEATSTAM_OVERLAY': 'Оправа шкал',
    'HUD_ROGUE_DEFDELAY': 'Задержка защиты',
    'HUD_KEY_HAND_SLOT(1)': 'Левая рука',
    'HUD_KEY_HAND_SLOT(2)': 'Правая рука',
    'HUD_ROGUE_RING_SLOT(1)': 'Кольцо 1',
    'HUD_ROGUE_RING_SLOT(2)': 'Кольцо 2',
    'HUD_ROGUE_RING_SLOT(3)': 'Кольцо 3',
    'HUD_ROGUE_RING_SLOT(4)': 'Кольцо 4',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_ROGUE_WRISTS)': 'Запястья',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_MASK)': 'Маска',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_NECK)': 'Шея',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_BACK)': 'Спина, левая',
    'HUD_ROGUE_BACKR': 'Спина, правая',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_GLOVES)': 'Перчатки',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_HEAD)': 'Голова',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_FEET)': 'Обувь',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_BELT)': 'Пояс',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_RPOCKET)': 'Бедро, правое',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_LPOCKET)': 'Бедро, левое',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_ROGUE_SHIRT)': 'Рубаха',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_ICLOTHING)': 'Штаны',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_OCLOTHING)': 'Броня',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_ROGUE_CLOAK)': 'Плащ',
    'HUD_KEY_ITEM_SLOT(ITEM_SLOT_ROGUE_MOUTH)': 'Рот',
    'HUD_MOB_DROP': 'Бросить из руки',
    'HUD_MOB_THROW': 'Метнуть или поймать',
    'HUD_ROGUE_STAND_UP': 'Встать',
    'HUD_MOB_REST': 'Лечь',
    'HUD_ROGUE_SKILLS': 'Навыки',
    'HUD_MOB_CRAFTING_MENU': 'Ремесло',
    'HUD_ROGUE_SNEAK': 'Красться',
    'HUD_MOB_MOVE_INTENT': 'Бег',
    'HUD_ROGUE_EYE': 'Глаз',
    'HUD_MOB_ZONE_SELECTOR': 'Горгулья',
    'HUD_ROGUE_DOLL_BACK': 'Подложка горгульи',
    'HUD_ROGUE_DOLL_TOGGLE': 'Кнопка горгульи',
    'HUD_ROGUE_FIELD_FRAME': 'Рамка поля',
    'HUD_ROGUE_BUILD': 'Стройка',
    'HUD_MOB_STAMINA': 'Выносливость',
    'HUD_ROGUE_ENERGY': 'Энергия',
    'HUD_ROGUE_MANA': 'Мана',
    'HUD_ROGUE_FEINT': 'Шкала финта',
}

GROUPS = {
    'HUD_GROUP_STATIC': 'static',
    'HUD_GROUP_ROGUE_PANEL': 'panel',
    'HUD_GROUP_ROGUE_DOLL': 'doll',
    'HUD_GROUP_ROGUE_RMB': 'rmb',
    'HUD_GROUP_TOGGLEABLE_INVENTORY': 'inventory',
}


class Dmi:
    """One .dmi file: the first frame of a state, facing south."""

    def __init__(self, path):
        image = Image.open(path)
        description = image.info.get('Description')
        if not description:
            raise ValueError('%s is not a .dmi file' % path)
        self.image = image.convert('RGBA')
        self.width = self.height = 32
        self.cells = {}
        cell = 0
        state = None
        for line in description.splitlines():
            key, _, value = line.strip().partition(' = ')
            if key == 'width':
                self.width = int(value)
            elif key == 'height':
                self.height = int(value)
            elif key == 'state':
                if state:
                    cell += state['dirs'] * state['frames']
                state = {'name': value.strip('"'), 'dirs': 1, 'frames': 1, 'movement': False, 'cell': cell}
                self.cells.setdefault(state['name'], state)
            elif state and key in ('dirs', 'frames'):
                state[key] = int(value)
            elif state and key == 'movement':
                # A movement state shares its name with the standing one, which comes first and is the one shown.
                state['movement'] = True
        self.columns = self.image.width // self.width

    def has(self, state):
        return state in self.cells

    def frame(self, state):
        cell = self.cells[state]['cell']
        left = (cell % self.columns) * self.width
        top = (cell // self.columns) * self.height
        return self.image.crop((left, top, left + self.width, top + self.height))


class Sprites:
    def __init__(self):
        self.files = {}
        self.sheet = {}
        self.by_hash = {}

    def dmi(self, path):
        if path not in self.files:
            self.files[path] = Dmi(REPO / path)
        return self.files[path]

    def add(self, image, origin):
        """Stores a picture once and returns its record: the name in the sheet and where the element's own lower left
        corner is inside it."""
        buffer = io.BytesIO()
        image.save(buffer, 'PNG', optimize=True)
        raw = buffer.getvalue()
        digest = hashlib.sha1(raw).hexdigest()[:10]
        name = self.by_hash.get(digest)
        if not name:
            name = 's%d' % (len(self.sheet) + 1)
            self.by_hash[digest] = name
            box = image.getbbox() or (0, 0, image.width, image.height)
            self.sheet[name] = {
                'src': 'data:image/png;base64,' + base64.b64encode(raw).decode('ascii'),
                'w': image.width,
                'h': image.height,
                'box': list(box),
            }
        return {'sprite': name, 'ox': origin[0], 'oy': origin[1]}

    def compose(self, icon, state, under=(), over=()):
        """The element's picture with what the game draws under and over it. Layers may reach past the element's own
        icon (the upper row of intents does), so the picture is their common box."""
        layers = []
        for layer_icon, layer_state, x, y in under:
            layers.append((self.layer(layer_icon or icon, layer_state), x, y))
        base = self.layer(icon, state)
        if base:
            layers.append((base, 0, 0))
        for layer_icon, layer_state, x, y in over:
            layers.append((self.layer(layer_icon or icon, layer_state), x, y))
        layers = [layer for layer in layers if layer[0]]
        if not layers:
            return None
        left = min(x for _, x, _ in layers)
        bottom = min(y for _, _, y in layers)
        right = max(x + image.width for image, x, _ in layers)
        top = max(y + image.height for image, _, y in layers)
        canvas = Image.new('RGBA', (right - left, top - bottom), (0, 0, 0, 0))
        for image, x, y in layers:
            canvas.alpha_composite(image, (x - left, top - y - image.height))
        if canvas.getbbox() is None:
            # An empty state: the element shows nothing until the game gives it one.
            return None
        return self.add(canvas, (-left, -bottom))

    def layer(self, icon, state):
        if not icon or state is None:
            return None
        dmi = self.dmi(icon)
        return dmi.frame(state) if dmi.has(state) else None


def split_arguments(text):
    """Splits `a, b(c, d), "e, f"` at the commas of the top level."""
    parts = []
    depth = 0
    quote = None
    current = ''
    for char in text:
        if quote:
            current += char
            if char == quote:
                quote = None
            continue
        if char in '"\'':
            quote = char
        elif char == '(':
            depth += 1
        elif char == ')':
            depth -= 1
        elif char == ',' and depth == 0:
            parts.append(current.strip())
            current = ''
            continue
        current += char
    parts.append(current.strip())
    return parts


def read_defines():
    """The module's `#define rogueui_name "place"` and `#define rogueui_name number` lines."""
    defines = {}
    pattern = re.compile(r'^#define (rogueui_\w+) (?:"([^"]*)"|(-?\d+(?:\.\d+)?))\s*$')
    for path in sorted(MODULE.rglob('*.dm')):
        for line in path.read_text(encoding='utf-8', errors='replace').splitlines():
            match = pattern.match(line)
            if match:
                defines[match.group(1)] = match.group(2) if match.group(2) is not None else float(match.group(3))
    return defines


def read_table():
    """The rows of the layout test: every element the HUD has."""
    text = (MODULE / 'tests' / 'huds_rogue.dm').read_text(encoding='utf-8')
    start = text.index('var/list/expected = list(')
    end = text.index('\n\t)\n', start)
    icons = dict(re.findall(r"var/icon/(\w+) = '([^']+)'", text[:start]))
    rows = []
    for line in text[start:end].splitlines()[1:]:
        match = re.match(r'^\t\t(.+?) = list\((.+)\),$', line)
        if not match:
            raise ValueError('unreadable row of the layout table: %s' % line.strip())
        arguments = split_arguments(match.group(2))
        if len(arguments) != 7:
            raise ValueError('the row of %s has %d fields, not 7' % (match.group(1), len(arguments)))
        rows.append((match.group(1), arguments, icons))
    return rows


def number_define(path, name):
    match = re.search(r'^#define %s (-?\d+(?:\.\d+)?)' % name, path.read_text(encoding='utf-8'), re.M)
    if not match:
        raise ValueError('%s has no #define %s' % (path.name, name))
    return float(match.group(1))


def read_view():
    """Tiles of the field each way: the config's ROGUE_VIEW_RANGE if it is set, else the entry's default."""
    source = (MODULE / 'hud' / 'view_range.dm').read_text(encoding='utf-8')
    view_range = int(re.search(r'/datum/config_entry/number/rogue_view_range\s+default = (\d+)', source).group(1))
    config = REPO / 'config' / 'redtard' / 'config.txt'
    if config.exists():
        match = re.search(r'^ROGUE_VIEW_RANGE\s+(\d+)', config.read_text(encoding='utf-8', errors='replace'), re.M)
        if match:
            view_range = int(match.group(1))
    return view_range * 2 + 1


def build():
    defines = read_defines()
    sprites = Sprites()
    elements = []
    used = set()
    skipped = []
    for key, arguments, icons in read_table():
        type_path, place, icon, state, layer, plane, group = arguments
        define = None
        if place.startswith('"'):
            place = place.strip('"')
        else:
            define = place
            place = defines.get(define)
            if not isinstance(place, str):
                raise ValueError('%s stands at %s, which is not a place the module defines' % (key, define))
        icon = icons.get(icon, icon.strip("'")) if icon != 'null' else None
        state = None if state == 'null' else state.strip('"')
        preview = PREVIEW.get(key, {})
        state = preview.get('state', state)
        if plane != 'HUD_PLANE' or '/placeholder/' in type_path or '/darkness' in type_path or not icon:
            skipped.append(key)
            continue
        try:
            layer = float(layer)
        except ValueError:
            skipped.append(key)
            continue
        picture = sprites.compose(icon, state, preview.get('under', ()), preview.get('over', ()))
        if not picture:
            skipped.append(key)
            continue
        element = {
            'id': key,
            'label': LABELS.get(key) or type_path.rsplit('/', 1)[-1],
            'type': type_path,
            'define': define,
            'loc': place,
            'layer': layer,
            'group': GROUPS.get(group, 'none'),
        }
        element.update(picture)
        if type_path in SCALES:
            element['scale'] = SCALES[type_path]
        if key == 'HUD_ROGUE_FIELD_FRAME':
            element['kind'] = 'frame'
        rmb = re.match(r'HUD_ROGUE_RMB_SLOT\((\d+)\)', key)
        if rmb:
            # The list of RMB intents stands over its button: rogueui_rmb_menu_slot(index).
            index = int(rmb.group(1))
            element['label'] = 'ПКМ-намерение %d' % index
            element['follows'] = 'rogueui_rmb_button'
            element['dy'] = int(defines['rogueui_rmb_menu_base'] + (index - 1) * defines['rogueui_rmb_menu_step'])
            element['define'] = None
        if element.get('define'):
            used.add(element['define'])
        if element.get('follows'):
            used.add(element['follows'])
        elements.append(element)
    frame = MODULE / 'hud' / 'rogue_frame.dm'
    view = read_view()
    data = {
        'generated': datetime.date.today().isoformat(),
        'icon': 32,
        'view': [view, view],
        'frame': {
            'minControl': number_define(frame, 'ROGUE_FRAME_MIN_CONTROL'),
            'overhang': number_define(frame, 'ROGUE_FRAME_OVERHANG'),
            'maxColumns': number_define(frame, 'ROGUE_FRAME_MAX_COLUMNS'),
            'maxRows': number_define(frame, 'ROGUE_FRAME_MAX_ROWS'),
            'fieldTiles': number_define(frame, 'ROGUE_FIELD_FRAME_TILES'),
        },
        # Where the game puts what it adds on the run: alerts, buffs and TG's action buttons (hud/rogue_hud.dm,
        # hud/rogue_hud_bridges.dm).
        'alerts': {
            'slots': int(defines['rogueui_alert_slots']),
            'inset': int(defines['rogueui_alert_inset']),
            'step': int(defines['rogueui_alert_step']),
        },
        'buffs': {
            'slots': int(defines['rogueui_buff_slots']),
            'drop': int(defines['rogueui_buff_drop']),
            'column': re.search(r'return "(EAST[^,"]*),CENTER', (MODULE / 'hud' / 'rogue_hud.dm').read_text(encoding='utf-8')).group(1),
        },
        'actions': {
            'left': int(defines['rogueui_action_left']),
            'inset': int(defines['rogueui_action_inset']),
            'rows': int(defines['rogueui_action_rows']),
        },
        'defines': {name: defines[name] for name in sorted(used)},
        'elements': elements,
        'sprites': sprites.sheet,
    }
    return data, skipped


def render_page():
    """The page as text, the data it was filled with and the elements left out of it."""
    data, skipped = build()
    template = (HERE / 'template.html').read_text(encoding='utf-8')
    if template.count(DATA_MARK) != 1:
        raise ValueError('template.html must hold %s exactly once' % DATA_MARK)
    payload = json.dumps(data, ensure_ascii=False, separators=(',', ':')).replace('<', '\\u003c')
    return template.replace(DATA_MARK, payload), data, skipped


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    parser.add_argument('--out', type=Path, default=DEFAULT_OUT, help='the page to write (default: %(default)s)')
    options = parser.parse_args()
    try:
        page, data, skipped = render_page()
    except ValueError as error:
        sys.exit(str(error))
    options.out.parent.mkdir(parents=True, exist_ok=True)
    options.out.write_text(page, encoding='utf-8')
    size = options.out.stat().st_size
    print('%s: %d elements, %d sprites, %d places, %.0f KB' % (options.out, len(data['elements']), len(data['sprites']), len(data['defines']), size / 1024))
    print('not drawn (hidden or drawn by the game alone): %s' % ', '.join(skipped))


if __name__ == '__main__':
    main()
