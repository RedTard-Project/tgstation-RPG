import math
import re
import struct
import zlib

SIGNATURE = b'\x89PNG\r\n\x1a\n'
N, S, E, W = 1, 2, 4, 8
NE, SE, SW, NW = 16, 32, 64, 128
CORNER_STATES = [f'{q}-{s}' for q, sides in ((1, 'i n w nw f'), (2, 'i n e ne f'), (3, 'i s w sw f'), (4, 'i s e se f')) for s in sides.split()]
BITMASK_JUNCTIONS = sorted({
    (j & (N | S | E | W))
    | (NE if (j & N and j & E and j & NE) else 0)
    | (SE if (j & S and j & E and j & SE) else 0)
    | (SW if (j & S and j & W and j & SW) else 0)
    | (NW if (j & N and j & W and j & NW) else 0)
    for j in range(256)
})


class Dmi:
    def __init__(self, width, height, frame_width, frame_height, pixels, states):
        self.width = width
        self.height = height
        self.frame_width = frame_width
        self.frame_height = frame_height
        self.pixels = pixels
        self.states = states

    def cells(self):
        columns = self.width // self.frame_width
        out = {}
        index = 0
        for state in self.states:
            if state['name'] not in out:
                out[state['name']] = self.crop(index, columns)
            index += state['dirs'] * state['frames']
        return out

    def state_cells(self):
        """Every cell of every state in sheet order (frame by frame, each frame's directions south, north, east, west, ...),
        as {name: (dirs, frames, [cells])}; the first state of a repeated name wins, as BYOND picks it."""
        columns = self.width // self.frame_width
        out = {}
        index = 0
        for state in self.states:
            count = state['dirs'] * state['frames']
            if state['name'] not in out:
                out[state['name']] = (state['dirs'], state['frames'], [self.crop(index + k, columns) for k in range(count)])
            index += count
        return out

    def crop(self, index, columns):
        row, col = divmod(index, columns)
        x0, y0 = col * self.frame_width, row * self.frame_height
        rows = []
        for y in range(self.frame_height):
            start = ((y0 + y) * self.width + x0) * 4
            rows.append(self.pixels[start:start + self.frame_width * 4])
        return b''.join(rows)


def _chunks(data):
    if data[:8] != SIGNATURE:
        raise ValueError('not a PNG')
    pos = 8
    while pos < len(data):
        length = struct.unpack('>I', data[pos:pos + 4])[0]
        kind = data[pos + 4:pos + 8]
        yield kind, data[pos + 8:pos + 8 + length]
        pos += 12 + length


def _paeth(a, b, c):
    p = a + b - c
    pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
    if pa <= pb and pa <= pc:
        return a
    return b if pb <= pc else c


def state_names(path):
    data = open(path, 'rb').read()
    for kind, body in _chunks(data):
        if kind == b'zTXt':
            key, rest = body.split(b'\x00', 1)
            if key == b'Description':
                text = zlib.decompress(rest[1:]).decode('utf-8', 'replace')
                return {m.group(1) for m in re.finditer(r'^state = "((?:[^"\\]|\\.)*)"', text, re.M)}
        elif kind in (b'tEXt', b'iTXt'):
            key, rest = body.split(b'\x00', 1)
            if key == b'Description':
                text = rest.split(b'\x00', 3)[-1] if kind == b'iTXt' else rest
                return {m.group(1) for m in re.finditer(r'^state = "((?:[^"\\]|\\.)*)"', text.decode('utf-8', 'replace'), re.M)}
    return set()


def read(path):
    data = open(path, 'rb').read()
    idat = []
    palette = b''
    alpha = b''
    description = ''
    for kind, body in _chunks(data):
        if kind == b'IHDR':
            width, height, depth, color, _, _, interlace = struct.unpack('>IIBBBBB', body)
            if interlace:
                raise ValueError(f'{path}: interlaced PNG')
        elif kind == b'PLTE':
            palette = body
        elif kind == b'tRNS':
            alpha = body
        elif kind == b'IDAT':
            idat.append(body)
        elif kind == b'zTXt':
            key, rest = body.split(b'\x00', 1)
            if key == b'Description':
                description = zlib.decompress(rest[1:]).decode('utf-8', 'replace')
    channels = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}[color]
    bits = channels * depth
    stride = (width * bits + 7) // 8
    step = max(1, bits // 8)
    raw = zlib.decompress(b''.join(idat))
    rows = []
    previous = bytearray(stride)
    pos = 0
    for _ in range(height):
        kind = raw[pos]
        line = bytearray(raw[pos + 1:pos + 1 + stride])
        pos += 1 + stride
        for x in range(stride):
            left = line[x - step] if x >= step else 0
            up = previous[x]
            corner = previous[x - step] if x >= step else 0
            if kind == 1:
                line[x] = (line[x] + left) & 0xFF
            elif kind == 2:
                line[x] = (line[x] + up) & 0xFF
            elif kind == 3:
                line[x] = (line[x] + ((left + up) >> 1)) & 0xFF
            elif kind == 4:
                line[x] = (line[x] + _paeth(left, up, corner)) & 0xFF
        rows.append(line)
        previous = line
    pixels = bytearray(width * height * 4)
    for y, line in enumerate(rows):
        for x in range(width):
            if depth < 8:
                per = 8 // depth
                byte = line[x // per]
                shift = 8 - depth * (x % per + 1)
                value = (byte >> shift) & ((1 << depth) - 1)
                samples = [value]
            else:
                width_bytes = depth // 8
                base = x * channels * width_bytes
                samples = [line[base + c * width_bytes] for c in range(channels)]
            o = (y * width + x) * 4
            if color == 3:
                i = samples[0]
                pixels[o:o + 3] = palette[i * 3:i * 3 + 3]
                pixels[o + 3] = alpha[i] if i < len(alpha) else 255
            elif color == 0:
                v = samples[0] * 255 // ((1 << depth) - 1) if depth < 8 else samples[0]
                pixels[o:o + 4] = bytes((v, v, v, 255))
            elif color == 4:
                pixels[o:o + 4] = bytes((samples[0], samples[0], samples[0], samples[1]))
            elif color == 2:
                pixels[o:o + 4] = bytes((samples[0], samples[1], samples[2], 255))
            else:
                pixels[o:o + 4] = bytes(samples)
    frame_width = int(re.search(r'width = (\d+)', description).group(1)) if 'width =' in description else 32
    frame_height = int(re.search(r'height = (\d+)', description).group(1)) if 'height =' in description else 32
    states = []
    for line in description.split('\n'):
        line = line.strip()
        if line.startswith('state ='):
            states.append({'name': line[line.index('"') + 1:line.rindex('"')], 'dirs': 1, 'frames': 1})
        elif states and line.startswith('dirs ='):
            states[-1]['dirs'] = int(line.split('=')[1])
        elif states and line.startswith('frames ='):
            states[-1]['frames'] = int(line.split('=')[1])
    return Dmi(width, height, frame_width, frame_height, bytes(pixels), states)


def _chunk(kind, body):
    return struct.pack('>I', len(body)) + kind + body + struct.pack('>I', zlib.crc32(kind + body) & 0xFFFFFFFF)


def write(path, frame_width, frame_height, named_cells):
    states = []
    for name, _ in named_cells:
        states += [f'state = "{name}"', '\tdirs = 1', '\tframes = 1']
    _sheet(path, frame_width, frame_height, [cell for _, cell in named_cells], states)


def write_states(path, frame_width, frame_height, states):
    """A sheet of (name, dirs, cells) states, one frame each: cells hold the directions in sheet order."""
    lines = []
    cells = []
    for name, dirs, state_cells in states:
        if len(state_cells) != dirs:
            raise ValueError(f'{path}: state {name} has {len(state_cells)} cells for {dirs} directions')
        lines += [f'state = "{name}"', f'\tdirs = {dirs}', '\tframes = 1']
        cells += state_cells
    _sheet(path, frame_width, frame_height, cells, lines)


def write_animated(path, frame_width, frame_height, cells, delays):
    states = ['state = ""', '\tdirs = 1', f'\tframes = {len(cells)}']
    if len(cells) > 1:
        states.append('\tdelay = ' + ','.join(str(delay) for delay in delays))
    _sheet(path, frame_width, frame_height, cells, states)


def _sheet(path, frame_width, frame_height, cells, states):
    count = len(cells)
    columns = max(1, math.ceil(math.sqrt(count)))
    rows = math.ceil(count / columns)
    width, height = columns * frame_width, rows * frame_height
    canvas = bytearray(width * height * 4)
    for index, cell in enumerate(cells):
        row, col = divmod(index, columns)
        for y in range(frame_height):
            start = ((row * frame_height + y) * width + col * frame_width) * 4
            canvas[start:start + frame_width * 4] = cell[y * frame_width * 4:(y + 1) * frame_width * 4]
    description = ['# BEGIN DMI', 'version = 4.0', f'\twidth = {frame_width}', f'\theight = {frame_height}'] + states + ['# END DMI']
    text = ('\n'.join(description) + '\n').encode('utf-8')
    raw = b''.join(b'\x00' + bytes(canvas[y * width * 4:(y + 1) * width * 4]) for y in range(height))
    out = SIGNATURE
    out += _chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0))
    out += _chunk(b'zTXt', b'Description\x00\x00' + zlib.compress(text))
    out += _chunk(b'IDAT', zlib.compress(raw, 9))
    out += _chunk(b'IEND', b'')
    open(path, 'wb').write(out)


def has_corners(dmi):
    names = {s['name'] for s in dmi.states}
    return all(state in names for state in CORNER_STATES)


def corners_to_bitmask(dmi, prefix, preview_state=None):
    cells = dmi.cells()
    w, h = dmi.frame_width, dmi.frame_height
    hw, hh = w // 2, h // 2
    boxes = {1: (0, 0, hw, hh), 2: (hw, 0, w, hh), 3: (0, hh, hw, h), 4: (hw, hh, w, h)}

    def quadrant(q, j):
        if q == 1:
            a, b, d, names = j & N, j & W, j & NW, ('1-n', '1-w', '1-nw', '1-f', '1-i')
        elif q == 2:
            a, b, d, names = j & N, j & E, j & NE, ('2-n', '2-e', '2-ne', '2-f', '2-i')
        elif q == 3:
            a, b, d, names = j & S, j & W, j & SW, ('3-s', '3-w', '3-sw', '3-f', '3-i')
        else:
            a, b, d, names = j & S, j & E, j & SE, ('4-s', '4-e', '4-se', '4-f', '4-i')
        edge_a, edge_b, corner, full, inner = names
        if a and b:
            return full if d else corner
        if a:
            return edge_a
        if b:
            return edge_b
        return inner

    out = []
    for j in BITMASK_JUNCTIONS:
        canvas = bytearray(w * h * 4)
        for q in (1, 2, 3, 4):
            source = cells[quadrant(q, j)]
            x0, y0, x1, y1 = boxes[q]
            for y in range(y0, y1):
                start = (y * w + x0) * 4
                canvas[start:(y * w + x1) * 4] = source[start:(y * w + x1) * 4]
        out.append((f'{prefix}-{j}', bytes(canvas)))
    preview = cells.get(preview_state) if preview_state else None
    out.insert(0, (prefix, preview if preview else out[0][1]))
    taken = {name for name, _ in out}
    for name, cell in cells.items():
        if name not in CORNER_STATES and name not in taken:
            out.append((name, cell))
    return out
