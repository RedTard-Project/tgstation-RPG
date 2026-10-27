/** How BYOND plays a DMI's first state: its frame size, where each frame lies in the sheet, how long it shows. */
export type DmiAnimation = {
  width: number;
  height: number;
  /** Sheet cells in the order they are shown, a rewinding state played there and back. */
  cells: number[];
  /** Deciseconds each of those cells stays on screen. */
  delays: number[];
  /** Times the sequence plays before it stops on its last frame; 0 plays it forever. */
  loops: number;
};

const PNG_SIGNATURE = [137, 80, 78, 71, 13, 10, 26, 10];

/**
 * Reads the description BYOND keeps in a DMI (a PNG with a zTXt/tEXt "Description" chunk) and returns how its first
 * state animates, or null for anything that is not a DMI or does not animate.
 */
export async function readDmiAnimation(
  data: ArrayBuffer,
): Promise<DmiAnimation | null> {
  const text = await readDescription(new Uint8Array(data));
  const state = text?.split(/^state\s*=/m)[1];
  if (!text || !state) {
    return null;
  }
  const value = (source: string, key: string) =>
    new RegExp(`^\\s*${key}\\s*=\\s*([\\d.,]+)`, 'm').exec(source)?.[1];
  const dirs = Number(value(state, 'dirs') ?? 1);
  const frames = Number(value(state, 'frames') ?? 1);
  if (frames < 2) {
    return null;
  }
  const listed = value(state, 'delay')?.split(',');
  const order = Array.from({ length: frames }, (_, frame) => frame);
  if (value(state, 'rewind') === '1') {
    order.push(...order.slice(1, -1).reverse());
  }
  return {
    width: Number(value(text, 'width') ?? 32),
    height: Number(value(text, 'height') ?? 32),
    // Cells go frame by frame, each frame holding its directions; the title faces south, the first of them.
    cells: order.map((frame) => frame * dirs),
    delays: order.map((frame) => Number(listed?.[frame] ?? 1)),
    loops: Number(value(state, 'loop') ?? 0),
  };
}

async function readDescription(bytes: Uint8Array): Promise<string | null> {
  if (PNG_SIGNATURE.some((byte, i) => bytes[i] !== byte)) {
    return null;
  }
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
  let offset = 8;
  while (offset + 8 <= bytes.length) {
    const length = view.getUint32(offset);
    const type = String.fromCharCode(...bytes.subarray(offset + 4, offset + 8));
    const body = bytes.subarray(offset + 8, offset + 8 + length);
    offset += 12 + length;
    if (type !== 'zTXt' && type !== 'tEXt') {
      continue;
    }
    const keywordEnd = body.indexOf(0);
    if (
      keywordEnd < 0 ||
      new TextDecoder().decode(body.subarray(0, keywordEnd)) !== 'Description'
    ) {
      continue;
    }
    if (type === 'tEXt') {
      return new TextDecoder().decode(body.subarray(keywordEnd + 1));
    }
    // zTXt: the keyword, its zero, a compression method byte, then zlib data.
    const stream = new Blob([body.slice(keywordEnd + 2)])
      .stream()
      .pipeThrough(new DecompressionStream('deflate'));
    return new Response(stream).text();
  }
  return null;
}
