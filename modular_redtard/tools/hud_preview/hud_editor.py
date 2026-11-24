"""The editor of the rogue HUD's layout: reads the module's code, builds the mock-up of the HUD and shows it in the
browser of this computer. What is moved there is written beside this file, as recommendations in plain words:
hud_layout_changes.txt.

    py -3 modular_redtard/tools/hud_preview/hud_editor.py [--port 8765] [--no-browser]

or hud_editor.cmd by a double click. The page is built anew from the code on every reload; Ctrl+C stops the program.
Nothing in the code is changed: the recommendations are for whoever carries them over.
"""
import argparse
import datetime
import json
import re
import sys
import threading
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

import build_preview  # noqa: E402  (beside this file)

REPORT = HERE / 'hud_layout_changes.txt'
EDITS = build_preview.REPO / '.cache' / 'modular_redtard' / 'hud_preview' / 'edits.json'
# What a published artifact's page is wrapped in; the same here, so the page looks the same.
PAGE_HEAD = (
    '<!doctype html><html><head><meta charset=utf8>'
    '<meta name=viewport content="width=device-width,initial-scale=1,viewport-fit=cover">'
    '<style>:root{color-scheme:light}body{margin:0;font:14px system-ui,sans-serif}img{max-width:100%}'
    '[hidden]{display:none!important}</style></head><body>'
)
PLACE = re.compile(r'^(WEST|EAST|CENTER)([+-]\d+)?(:-?\d+)?,(SOUTH|NORTH|CENTER)([+-]\d+)?(:-?\d+)?$')
COLUMN = re.compile(r'^WEST-1(:-?\d+)?,')
BOTTOM = re.compile(r',SOUTH-1(:-?\d+)?$')
MOST_BYTES = 200000


def define_sources():
    """Where each `#define rogueui_...` stands: name -> (file from the repository's root, line)."""
    found = {}
    pattern = re.compile(r'^#define (rogueui_\w+)\b')
    for path in sorted(build_preview.MODULE.rglob('*.dm')):
        for number, line in enumerate(path.read_text(encoding='utf-8', errors='replace').splitlines(), 1):
            match = pattern.match(line)
            if match:
                found.setdefault(match.group(1), (path.relative_to(build_preview.REPO).as_posix(), number))
    return found


def zone(place):
    column = bool(COLUMN.search(place))
    bottom = bool(BOTTOM.search(place))
    if column and bottom:
        return 'угол: левая колонка и нижний ряд'
    if column:
        return 'левая колонка (на черноте, вплотную к рамке поля)'
    if bottom:
        return 'нижний ряд (на черноте, вплотную к нижнему краю поля)'
    return 'поле'


def shift_words(shift):
    if not isinstance(shift, list) or len(shift) != 2 or not all(isinstance(part, int) for part in shift):
        return None
    across, up = shift
    words = []
    if across:
        words.append('на %d px %s' % (abs(across), 'вправо' if across > 0 else 'влево'))
    if up:
        words.append('на %d px %s' % (abs(up), 'вверх' if up > 0 else 'вниз'))
    return ', '.join(words) if words else 'на экране остаётся на месте, меняется только запись места'


def clean_moves(moves, data):
    """Only the places the code has, written the way BYOND reads them, and only where they differ from the code."""
    if not isinstance(moves, dict):
        return {}
    known = data['defines']
    return {
        name: place
        for name, place in sorted(moves.items())
        if name in known and isinstance(place, str) and PLACE.match(place) and place != known[name]
    }


def size_words(size):
    if isinstance(size, dict) and isinstance(size.get('w'), int) and isinstance(size.get('h'), int):
        return '%d × %d' % (size['w'], size['h'])
    return None


def report_text(body, data):
    moves = clean_moves(body.get('moves'), data)
    shifts = body.get('shifts') if isinstance(body.get('shifts'), dict) else {}
    sources = define_sources()
    labels = {}
    for element in data['elements']:
        if element.get('define'):
            labels.setdefault(element['define'], []).append(element['label'])
    lines = [
        'Рекомендации по раскладке ХУДа',
        'Записано: %s. Раскладка прочитана из кода %s.' % (datetime.datetime.now().strftime('%Y-%m-%d %H:%M'), data['generated']),
    ]
    client = size_words(body.get('client'))
    game_map = size_words(body.get('map'))
    if client and game_map:
        lines.append('Сдвиги измерены при окне клиента %s и карте %s пикселей.' % (client, game_map))
    lines.append('')
    if not moves:
        lines.append('Сдвигов нет: макет совпадает с кодом.')
        return '\n'.join(lines) + '\n', moves
    lines.append('Сдвинуть мест: %d. Клетка — 32 пикселя значка; «вверх» и «вправо» — как на экране.' % len(moves))
    for number, (name, place) in enumerate(moves.items(), 1):
        was = data['defines'][name]
        where = sources.get(name)
        lines.append('')
        lines.append('%d. %s' % (number, ', '.join(labels.get(name, [name]))))
        lines.append('   Имя в коде: %s%s' % (name, ' — %s, строка %d' % where if where else ''))
        words = shift_words(shifts.get(name))
        if words:
            lines.append('   Сдвинуть:   %s' % words)
        lines.append('   Было:       "%s" — %s' % (was, zone(was)))
        lines.append('   Стало:      "%s" — %s' % (place, zone(place)))
        lines.append('   Строка:     #define %s "%s"' % (name, place))
        if name == 'rogueui_rmb_button':
            lines.append('   Заодно:     то же место записано в макросе rogueui_rmb_menu_slot(index) — список ПКМ-намерений стоит над кнопкой.')
    lines += [
        '',
        'Как перенести: заменить названные строки #define и собрать модуль. Места в таблице теста',
        'modular_redtard/tests/huds_rogue.dm записаны теми же именами и меняются вместе с ними; места списка',
        'ПКМ-намерений там записаны буквально. После переноса запустите программу заново: макет соберётся',
        'из нового кода, и перенесённые сдвиги из этого файла уйдут.',
    ]
    return '\n'.join(lines) + '\n', moves


def stored_moves(data):
    try:
        return clean_moves(json.loads(EDITS.read_text(encoding='utf-8')).get('moves'), data)
    except (OSError, ValueError, AttributeError):
        return {}


class Editor(BaseHTTPRequestHandler):
    server_version = 'RogueHudEditor'

    def answer(self, status, kind, body):
        raw = body.encode('utf-8')
        self.send_response(status)
        self.send_header('Content-Type', kind + '; charset=utf-8')
        self.send_header('Content-Length', str(len(raw)))
        self.send_header('Cache-Control', 'no-store')
        self.end_headers()
        self.wfile.write(raw)

    def build(self):
        page, data, _skipped = build_preview.render_page()
        self.server.data = data
        return page

    def do_GET(self):
        path = self.path.split('?', 1)[0]
        try:
            if path in ('/', '/index.html'):
                self.answer(200, 'text/html', PAGE_HEAD + self.build() + '</body></html>')
            elif path == '/edits':
                if self.server.data is None:
                    self.build()
                self.answer(200, 'application/json', json.dumps({'moves': stored_moves(self.server.data)}))
            else:
                self.answer(404, 'text/plain', 'not found')
        except (OSError, ValueError, KeyError) as error:
            # The code could not be read into a layout: say why on the page instead of a blank one.
            self.answer(500, 'text/plain', 'Макет не собрался: %s' % error)

    def do_POST(self):
        if self.path.split('?', 1)[0] != '/edits':
            self.answer(404, 'text/plain', 'not found')
            return
        try:
            length = int(self.headers.get('Content-Length') or 0)
            if not 0 < length <= MOST_BYTES:
                raise ValueError('bad length')
            body = json.loads(self.rfile.read(length).decode('utf-8'))
            if not isinstance(body, dict):
                raise ValueError('not an object')
            if self.server.data is None:
                self.build()
            text, moves = report_text(body, self.server.data)
            with self.server.write_lock:
                EDITS.parent.mkdir(parents=True, exist_ok=True)
                EDITS.write_text(json.dumps({'moves': moves}, ensure_ascii=False, indent=1), encoding='utf-8')
                REPORT.write_text(text, encoding='utf-8')
            self.answer(200, 'application/json', json.dumps({'ok': True, 'moved': len(moves), 'file': REPORT.name}))
        except (OSError, ValueError, KeyError) as error:
            self.answer(400, 'text/plain', 'Правки не записаны: %s' % error)

    def log_message(self, format, *args):
        pass


def make_server(port):
    server = ThreadingHTTPServer(('127.0.0.1', port), Editor)
    server.data = None
    server.write_lock = threading.Lock()
    return server


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    parser.add_argument('--port', type=int, default=8765, help='the port on this computer (default: %(default)s)')
    parser.add_argument('--no-browser', action='store_true', help='do not open the browser')
    options = parser.parse_args()
    try:
        build_preview.render_page()
    except (OSError, ValueError, KeyError) as error:
        sys.exit('Макет не собрался: %s' % error)
    try:
        server = make_server(options.port)
    except OSError as error:
        sys.exit('Порт %d занят (%s). Возможно, редактор уже запущен; иначе: --port <другой>.' % (options.port, error))
    address = 'http://127.0.0.1:%d/' % server.server_address[1]
    print('Редактор раскладки ХУДа: %s' % address)
    print('Рекомендации пишутся в %s' % REPORT)
    print('Остановить: Ctrl+C.')
    if not options.no_browser:
        webbrowser.open(address)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == '__main__':
    main()
