"""Cuts rectangles out of a frame of a DMI sheet into a new single-frame DMI.

Usage:
    python -I dmi_crop.py <source.dmi> <frame_index> <frame_w> <frame_h> <out.dmi> <state>=<x>,<y>,<w>,<h> [...]

x, y are measured from the frame's top-left corner. Every state in the output must be the same size,
because a DMI has one icon size; the states are laid out left to right.
Standard library only (zlib), RGBA 8-bit non-interlaced PNGs, which is what DreamMaker writes.
"""
import struct
import sys
import zlib

PNG_SIGNATURE = b'\x89PNG\r\n\x1a\n'


def read_chunks(data):
    pos = 8
    while pos < len(data):
        length = struct.unpack('>I', data[pos:pos + 4])[0]
        kind = data[pos + 4:pos + 8]
        yield kind, data[pos + 8:pos + 8 + length]
        pos += 12 + length


def paeth(a, b, c):
    p = a + b - c
    pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
    if pa <= pb and pa <= pc:
        return a
    return b if pb <= pc else c


def decode_rgba(path):
    data = open(path, 'rb').read()
    assert data[:8] == PNG_SIGNATURE, 'not a PNG'
    idat = b''
    for kind, body in read_chunks(data):
        if kind == b'IHDR':
            width, height, depth, color, _, _, interlace = struct.unpack('>IIBBBBB', body)
            assert depth == 8 and color == 6 and interlace == 0, 'only RGBA8 non-interlaced'
        elif kind == b'IDAT':
            idat += body
    raw = zlib.decompress(idat)
    stride = width * 4
    rows = []
    prev = bytearray(stride)
    pos = 0
    for _ in range(height):
        kind = raw[pos]
        line = bytearray(raw[pos + 1:pos + 1 + stride])
        pos += 1 + stride
        for i in range(stride):
            left = line[i - 4] if i >= 4 else 0
            up = prev[i]
            up_left = prev[i - 4] if i >= 4 else 0
            if kind == 1:
                line[i] = (line[i] + left) & 0xFF
            elif kind == 2:
                line[i] = (line[i] + up) & 0xFF
            elif kind == 3:
                line[i] = (line[i] + ((left + up) >> 1)) & 0xFF
            elif kind == 4:
                line[i] = (line[i] + paeth(left, up, up_left)) & 0xFF
        rows.append(line)
        prev = line
    return width, height, rows


def chunk(kind, body):
    return struct.pack('>I', len(body)) + kind + body + struct.pack('>I', zlib.crc32(kind + body) & 0xFFFFFFFF)


def encode_dmi(path, width, height, rows, description):
    raw = b''.join(b'\x00' + bytes(row) for row in rows)
    out = PNG_SIGNATURE
    out += chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0))
    out += chunk(b'zTXt', b'Description\x00\x00' + zlib.compress(description.encode('utf-8')))
    out += chunk(b'IDAT', zlib.compress(raw, 9))
    out += chunk(b'IEND', b'')
    open(path, 'wb').write(out)


def main():
    source, frame_index, frame_w, frame_h, out = sys.argv[1:6]
    frame_index, frame_w, frame_h = int(frame_index), int(frame_w), int(frame_h)
    sheet_w, _, rows = decode_rgba(source)
    per_row = sheet_w // frame_w
    origin_x = (frame_index % per_row) * frame_w
    origin_y = (frame_index // per_row) * frame_h
    states = []
    for spec in sys.argv[6:]:
        name, box = spec.split('=')
        x, y, w, h = (int(v) for v in box.split(','))
        states.append((name, x, y, w, h))
    size_w, size_h = states[0][3], states[0][4]
    assert all(s[3] == size_w and s[4] == size_h for s in states), 'states must share one size'
    out_rows = [bytearray(size_w * 4 * len(states)) for _ in range(size_h)]
    for index, (_, x, y, w, h) in enumerate(states):
        for row in range(h):
            src = rows[origin_y + y + row]
            start = (origin_x + x) * 4
            out_rows[row][index * w * 4:(index + 1) * w * 4] = src[start:start + w * 4]
    lines = ['# BEGIN DMI', 'version = 4.0', f'\twidth = {size_w}', f'\theight = {size_h}']
    for name, *_ in states:
        lines += [f'state = "{name}"', '\tdirs = 1', '\tframes = 1']
    lines.append('# END DMI')
    encode_dmi(out, size_w * len(states), size_h, out_rows, '\n'.join(lines) + '\n')


if __name__ == '__main__':
    main()
