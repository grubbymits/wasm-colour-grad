export class RGBA {
  constructor(r, g, b, a) {
    this._r = r;
    this._g = g;
    this._b = b;
    this._a = a;
    Object.freeze(this);
  }
  get r() { return this._r; }
  get g() { return this._g; }
  get b() { return this._b; }
  get a() { return this._a; }
}

export function colour_gradient(width, height, colour_start, colour_end) {
  const page_size_bytes = 64 * 1024;
  const required_bytes = width * height * 4;
  // Plus some stack space..?
  const required_pages = Math.ceil(required_bytes / page_size_bytes);

  const memory = new WebAssembly.Memory({
    initial: required_pages,
  });

  WebAssembly.instantiateStreaming(fetch("gradients.wasm"), {
    env: { memory: memory },
  }).then((obj) => {
    obj.instance.export.linear_gradient(
      width & 0xFFFFFFFF,
      height & 0xFFFFFFFF,
      colour_start.r & 0xFF,
      colour_start.g & 0xFF,
      colour_start.b & 0xFF,
      colour_start.a & 0xFF,
      colour_end.r & 0xFF,
      colour_end.g & 0xFF,
      colour_end.b & 0xFF,
      colour_end.a & 0xFF
    );
    const summands = new DataView(memory.buffer);
    for (let i = 0; i < 10; i++) {
      summands.setUint32(i * 4, i, true); // WebAssembly is little endian
    }
    const sum = obj.instance.exports.accumulate(0, 10);
    console.log(sum);
  });
}
