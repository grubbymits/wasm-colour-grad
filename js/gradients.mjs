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

export function canvas_gradient(canvas, colour_start, colour_end) {
  const width = canvas.width;
  const height = canvas.height;
  const page_size_bytes = 64 * 1024;
  const channels = 4;
  const required_bytes = width * height * channels;
  // Add a page for the stack..?
  const required_pages = 1 + Math.ceil(required_bytes / page_size_bytes);

  const memory = new WebAssembly.Memory({
    initial: required_pages,
  });

  WebAssembly.instantiateStreaming(fetch("../wasm/gradients.wasm"), {
    env: { memory: memory },
  }).then((obj) => {
    const bytes_written = obj.instance.exports.linear_gradient(
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
    if (bytes_written == required_bytes) {
      const clamped_array = new Uint8ClampedArray(memory.buffer, 0, required_bytes);
      const image_data = new ImageData(clamped_array, width, height);
      const context = canvas.getContext('2d');
      context.putImageData(image_data, 0, 0);
    }
  });
}
