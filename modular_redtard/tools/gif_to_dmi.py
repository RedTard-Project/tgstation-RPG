import argparse
import os
import struct
import sys
from collections import namedtuple

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dmi

KEEP = 256
Frame = namedtuple('Frame', 'left top width height indices palette delay disposal transparent')


def read_subblocks(data, pos):
    out = bytearray()
    while True:
        size = data[pos]
        pos += 1
        if not size:
            return bytes(out), pos
        out += data[pos:pos + size]
        pos += size


def lzw_decode(data, min_size, count):
    clear = 1 << min_size
    end = clear + 1
    size = min_size + 1
    table = [bytes([i]) for i in range(clear)] + [b'', b'']
    out = []
    produced = 0
    previous = None
    buffer = 0
    bits = 0
    pos = 0
    while produced < count:
        while bits < size:
            buffer |= data[pos] << bits
            pos += 1
            bits += 8
        code = buffer & ((1 << size) - 1)
        buffer >>= size
        bits -= size
        if code == clear:
            del table[end + 1:]
            size = min_size + 1
            previous = None
            continue
        if code == end:
            break
        if previous is None:
            entry = table[code]
        else:
            if code < len(table):
                entry = table[code]
                added = previous + entry[:1]
            else:
                entry = previous + previous[:1]
                added = entry
            if len(table) < 4096:
                table.append(added)
                if len(table) >= (1 << size) and size < 12:
                    size += 1
        out.append(entry)
        produced += len(entry)
        previous = entry
    return b''.join(out)[:count]


def deinterlace(indices, width, height):
    order = list(range(0, height, 8)) + list(range(4, height, 8)) + list(range(2, height, 4)) + list(range(1, height, 2))
    out = bytearray(width * height)
    for row, target in enumerate(order):
        out[target * width:(target + 1) * width] = indices[row * width:(row + 1) * width]
    return bytes(out)


def read_gif(data):
    if data[:6] not in (b'GIF87a', b'GIF89a'):
        raise SystemExit('not a GIF file')
    width, height, packed, _, _ = struct.unpack_from('<HHBBB', data, 6)
    pos = 13
    screen = b''
    if packed & 0x80:
        size = 3 * (1 << ((packed & 7) + 1))
        screen = data[pos:pos + size]
        pos += size
    frames = []
    control = (0, 0, None)
    while True:
        block = data[pos]
        if block == 0x3B:
            break
        if block == 0x21:
            label = data[pos + 1]
            payload, pos = read_subblocks(data, pos + 2)
            if label == 0xF9 and len(payload) >= 4:
                flags = payload[0]
                delay = struct.unpack_from('<H', payload, 1)[0]
                transparent = payload[3] if flags & 1 else None
                control = ((flags >> 2) & 7, delay if delay > 1 else 10, transparent)
            continue
        if block == 0x2C:
            left, top, frame_width, frame_height, flags = struct.unpack_from('<HHHHB', data, pos + 1)
            pos += 10
            palette = screen
            if flags & 0x80:
                size = 3 * (1 << ((flags & 7) + 1))
                palette = data[pos:pos + size]
                pos += size
            min_size = data[pos]
            payload, pos = read_subblocks(data, pos + 1)
            indices = lzw_decode(payload, min_size, frame_width * frame_height)
            if flags & 0x40:
                indices = deinterlace(indices, frame_width, frame_height)
            disposal, delay, transparent = control
            frames.append(Frame(left, top, frame_width, frame_height, indices, palette, delay, disposal, transparent))
            control = (0, 0, None)
            continue
        raise SystemExit(f'unknown GIF block {block:#x} at byte {pos}')
    return width, height, frames


def composed(width, height, frames):
    canvas = [KEEP] * (width * height)
    saved = None
    previous = None
    for frame in frames:
        if previous is not None:
            if previous.disposal == 2:
                canvas = list(canvas)
                for y in range(previous.height):
                    start = (previous.top + y) * width + previous.left
                    canvas[start:start + previous.width] = [KEEP] * previous.width
            elif previous.disposal == 3 and saved is not None:
                canvas = saved
        if frame.disposal == 3:
            saved = list(canvas)
        layer = [KEEP] * (width * height)
        for y in range(frame.height):
            start = (frame.top + y) * width + frame.left
            layer[start:start + frame.width] = frame.indices[y * frame.width:(y + 1) * frame.width]
        if frame.transparent is not None:
            layer = [KEEP if value == frame.transparent else value for value in layer]
        canvas = [value if value != KEEP else old for value, old in zip(layer, canvas)]
        previous = frame
        yield canvas, frame.delay


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('gif')
    parser.add_argument('dmi')
    parser.add_argument('--every', type=int, default=9)
    args = parser.parse_args()

    width, height, frames = read_gif(open(args.gif, 'rb').read())
    palettes = {frame.palette for frame in frames}
    if len(palettes) != 1:
        raise SystemExit('the GIF changes its palette between frames; only one palette is supported')
    colors = palettes.pop()
    count = len(colors) // 3
    lut = [colors[3 * i:3 * i + 3] + b'\xff' if i < count else b'\x00\x00\x00\x00' for i in range(256)]
    lut.append(b'\x00\x00\x00\x00')

    starts = []
    clock = 0
    for frame in frames:
        starts.append(clock)
        clock += frame.delay
    bounds = starts + [clock]

    def ticks_at(cs):
        return (cs + 5) // 10

    samples = []
    ticks = []
    for index, (canvas, _) in enumerate(composed(width, height, frames)):
        if index % args.every:
            continue
        end = min(index + args.every, len(frames))
        samples.append(b''.join([lut[value] for value in canvas]))
        ticks.append(max(1, ticks_at(bounds[end]) - ticks_at(bounds[index])))

    dmi.write_animated(args.dmi, width, height, samples, ticks)
    size = os.path.getsize(args.dmi)
    print(f'GIF: {len(frames)} frames, {clock / 100:.2f} s; kept every {args.every}th frame: {len(samples)} frames, {sum(ticks) / 10:.1f} s loop')
    print(f'wrote {args.dmi}: {size} bytes; memory per client for the icon: {len(samples) * width * height * 4 / 1024 / 1024:.0f} MB')


if __name__ == '__main__':
    main()
