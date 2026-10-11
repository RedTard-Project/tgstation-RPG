import fs from 'node:fs';
import zlib from 'node:zlib';

const PNG_SIGNATURE = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);

export type Rgba = { width: number; height: number; pixels: Uint8Array };

export type DmiState = { name: string; dirs: number; frames: number };

export type DmiSheet = { frameWidth: number; frameHeight: number; sheet: Rgba; states: DmiState[] };

const CRC_TABLE = (() => {
  const table = new Uint32Array(256);
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) {
      c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    }
    table[n] = c >>> 0;
  }
  return table;
})();

function crc32(bytes: Uint8Array): number {
  let c = 0xffffffff;
  for (let i = 0; i < bytes.length; i++) {
    c = CRC_TABLE[(c ^ bytes[i]) & 0xff] ^ (c >>> 8);
  }
  return (c ^ 0xffffffff) >>> 0;
}

function readU32(bytes: Uint8Array, at: number): number {
  return ((bytes[at] << 24) | (bytes[at + 1] << 16) | (bytes[at + 2] << 8) | bytes[at + 3]) >>> 0;
}

function writeU32(out: number[], value: number): void {
  out.push((value >>> 24) & 0xff, (value >>> 16) & 0xff, (value >>> 8) & 0xff, value & 0xff);
}

function chunks(bytes: Uint8Array): Array<{ type: string; data: Uint8Array }> {
  const result: Array<{ type: string; data: Uint8Array }> = [];
  let at = PNG_SIGNATURE.length;
  while (at < bytes.length) {
    const length = readU32(bytes, at);
    const type = String.fromCharCode(bytes[at + 4], bytes[at + 5], bytes[at + 6], bytes[at + 7]);
    result.push({ type, data: bytes.subarray(at + 8, at + 8 + length) });
    at += 12 + length;
  }
  return result;
}

export function decodePng(bytes: Uint8Array): Rgba {
  for (let i = 0; i < PNG_SIGNATURE.length; i++) {
    if (bytes[i] !== PNG_SIGNATURE[i]) {
      throw new Error('not a PNG');
    }
  }
  let width = 0;
  let height = 0;
  let colorType = 0;
  let palette = new Uint8Array(0);
  let transparency = new Uint8Array(0);
  const idat: Uint8Array[] = [];
  for (const chunk of chunks(bytes)) {
    if (chunk.type === 'IHDR') {
      width = readU32(chunk.data, 0);
      height = readU32(chunk.data, 4);
      colorType = chunk.data[9];
      if (chunk.data[8] !== 8 || chunk.data[12] !== 0) {
        throw new Error('only 8-bit, non-interlaced PNGs are supported');
      }
    } else if (chunk.type === 'PLTE') {
      palette = chunk.data;
    } else if (chunk.type === 'tRNS') {
      transparency = chunk.data;
    } else if (chunk.type === 'IDAT') {
      idat.push(chunk.data);
    }
  }
  const channels = ({ 0: 1, 2: 3, 3: 1, 4: 2, 6: 4 } as Record<number, number>)[colorType];
  if (!channels) {
    throw new Error(`unsupported PNG color type ${colorType}`);
  }
  const raw = new Uint8Array(zlib.inflateSync(Buffer.concat(idat)));
  const stride = width * channels;
  const unfiltered = new Uint8Array(height * stride);
  let previous = new Uint8Array(stride);
  let at = 0;
  for (let y = 0; y < height; y++) {
    const filter = raw[at];
    at += 1;
    const line = unfiltered.subarray(y * stride, (y + 1) * stride);
    for (let x = 0; x < stride; x++) {
      const value = raw[at + x];
      const left = x >= channels ? line[x - channels] : 0;
      const up = previous[x];
      const upLeft = x >= channels ? previous[x - channels] : 0;
      let predicted = 0;
      if (filter === 1) {
        predicted = left;
      } else if (filter === 2) {
        predicted = up;
      } else if (filter === 3) {
        predicted = (left + up) >> 1;
      } else if (filter === 4) {
        const p = left + up - upLeft;
        const pa = Math.abs(p - left);
        const pb = Math.abs(p - up);
        const pc = Math.abs(p - upLeft);
        predicted = pa <= pb && pa <= pc ? left : pb <= pc ? up : upLeft;
      }
      line[x] = (value + predicted) & 0xff;
    }
    at += stride;
    previous = line;
  }
  const pixels = new Uint8Array(width * height * 4);
  for (let i = 0; i < width * height; i++) {
    const src = i * channels;
    const dst = i * 4;
    if (colorType === 3) {
      const index = unfiltered[src];
      pixels[dst] = palette[index * 3];
      pixels[dst + 1] = palette[index * 3 + 1];
      pixels[dst + 2] = palette[index * 3 + 2];
      pixels[dst + 3] = index < transparency.length ? transparency[index] : 255;
    } else if (colorType === 0 || colorType === 4) {
      pixels[dst] = pixels[dst + 1] = pixels[dst + 2] = unfiltered[src];
      pixels[dst + 3] = colorType === 4 ? unfiltered[src + 1] : 255;
    } else if (colorType === 2) {
      pixels[dst] = unfiltered[src];
      pixels[dst + 1] = unfiltered[src + 1];
      pixels[dst + 2] = unfiltered[src + 2];
      pixels[dst + 3] = 255;
    } else {
      pixels.set(unfiltered.subarray(src, src + 4), dst);
    }
  }
  return { width, height, pixels };
}

export function encodePng(image: Rgba): Uint8Array {
  const stride = image.width * 4;
  const raw = new Uint8Array((stride + 1) * image.height);
  for (let y = 0; y < image.height; y++) {
    raw[y * (stride + 1)] = 0;
    raw.set(image.pixels.subarray(y * stride, (y + 1) * stride), y * (stride + 1) + 1);
  }
  const header: number[] = [];
  writeU32(header, image.width);
  writeU32(header, image.height);
  header.push(8, 6, 0, 0, 0);
  const parts = [
    chunk('IHDR', new Uint8Array(header)),
    chunk('IDAT', new Uint8Array(zlib.deflateSync(raw, { level: 9 }))),
    chunk('IEND', new Uint8Array(0)),
  ];
  const total = PNG_SIGNATURE.length + parts.reduce((sum, part) => sum + part.length, 0);
  const out = new Uint8Array(total);
  out.set(PNG_SIGNATURE, 0);
  let at = PNG_SIGNATURE.length;
  for (const part of parts) {
    out.set(part, at);
    at += part.length;
  }
  return out;
}

function chunk(type: string, data: Uint8Array): Uint8Array {
  const out = new Uint8Array(12 + data.length);
  const view: number[] = [];
  writeU32(view, data.length);
  out.set(view, 0);
  for (let i = 0; i < 4; i++) {
    out[4 + i] = type.charCodeAt(i);
  }
  out.set(data, 8);
  const crcInput = new Uint8Array(4 + data.length);
  for (let i = 0; i < 4; i++) {
    crcInput[i] = type.charCodeAt(i);
  }
  crcInput.set(data, 4);
  const crc: number[] = [];
  writeU32(crc, crc32(crcInput));
  out.set(crc, 8 + data.length);
  return out;
}

export function parseDmi(bytes: Uint8Array): DmiSheet {
  const sheet = decodePng(bytes);
  const description = chunks(bytes).find((chunk) => chunk.type === 'zTXt');
  if (!description) {
    throw new Error('DMI has no description chunk');
  }
  const separator = description.data.indexOf(0);
  const text = new TextDecoder().decode(zlib.inflateSync(description.data.subarray(separator + 2)));
  let frameWidth = 0;
  let frameHeight = 0;
  const states: DmiState[] = [];
  let current: DmiState | null = null;
  for (const raw of text.split('\n')) {
    const line = raw.trim();
    if (line.startsWith('width =')) {
      frameWidth = Number(line.split('=')[1]);
    } else if (line.startsWith('height =')) {
      frameHeight = Number(line.split('=')[1]);
    } else if (line.startsWith('state =')) {
      current = { name: line.slice(line.indexOf('"') + 1, line.lastIndexOf('"')), dirs: 1, frames: 1 };
      states.push(current);
    } else if (current && line.startsWith('dirs =')) {
      current.dirs = Number(line.split('=')[1]);
    } else if (current && line.startsWith('frames =')) {
      current.frames = Number(line.split('=')[1]);
    }
  }
  if (!frameWidth || !frameHeight) {
    throw new Error('DMI description has no width/height');
  }
  return { frameWidth, frameHeight, sheet, states };
}

export function cropFrame(sheet: DmiSheet, cell: number): Rgba {
  const columns = Math.floor(sheet.sheet.width / sheet.frameWidth);
  const originX = (cell % columns) * sheet.frameWidth;
  const originY = Math.floor(cell / columns) * sheet.frameHeight;
  const stride = sheet.sheet.width * 4;
  const out = new Uint8Array(sheet.frameWidth * sheet.frameHeight * 4);
  for (let y = 0; y < sheet.frameHeight; y++) {
    const from = (originY + y) * stride + originX * 4;
    out.set(sheet.sheet.pixels.subarray(from, from + sheet.frameWidth * 4), y * sheet.frameWidth * 4);
  }
  return { width: sheet.frameWidth, height: sheet.frameHeight, pixels: out };
}

export function framesOf(sheet: DmiSheet): Rgba[] {
  const frames: Rgba[] = [];
  let cell = 0;
  for (const state of sheet.states) {
    for (let frame = 0; frame < state.frames; frame++) {
      frames.push(cropFrame(sheet, cell + frame * state.dirs));
    }
    cell += state.frames * state.dirs;
  }
  return frames;
}

export function writePng(path: string, image: Rgba): void {
  fs.writeFileSync(path, encodePng(image));
}
