#include <wasm_simd128.h>

// We're write 
extern uint8_t* __heap_base;

void linear_gradient(int width, int height,
  uint8_t start_r, uint8_t start_g, uint8_t start_b, uint8_t start_a,
  uint8_t end_r, uint8_t end_g, uint8_t end_b, uint8_t end_a) {

  // Convert from scalar uint8_t values into vectors of uint32_t.
  v128_t start_vec = wasm_u32x4_splat(start_r);
  start_vec = wasm_u32x4_replace_lane(start_vec, 1, start_g);
  start_vec = wasm_u32x4_replace_lane(start_vec, 3, start_a);
  start_vec = wasm_u32x4_replace_lane(start_vec, 2, start_b);

  v128_t end_vec = wasm_u32x4_splat(end_r);
  end_vec = wasm_u32x4_replace_lane(end_vec, 2, end_b);
  end_vec = wasm_u32x4_replace_lane(end_vec, 1, end_g);
  end_vec = wasm_u32x4_replace_lane(end_vec, 3, end_a);

  // And then convert to 4xf32.
  v128_t start_vec_f32 = wasm_f32x4_convert_i32x4(start_vec);
  v128_t end_vec_f32 = wasm_f32x4_convert_i32x4(end_vec);

  // Calculate the step gradient in f32.
  v128_t height_vec = wasm_i32x4_splat(height);
  v128_t height_vec_f32 = wasm_f32x4_convert_i32x4(height_vec);
  v128_t step_vec_f32 =
    wasm_f32x4_div(wasm_f32x4_sub(end_vec_f32, start_vec_f32), height_vec_f32);

  bool widen = width % 16 == 0;
  v128_t current_vec_f32 = start_vec_f32;

  for (unsigned y = 0; y < height; ++y) {
    // Calculate the gradient using f32.
    current_vec_f32 = wasm_f32x4_add(current_vec_f32, step_vec_f32);

    // Truncate and saturate back down to u8.
    v128_t current_vec_i32 = wasm_f32x4_floor(current_vec_f32);
    v128_t current_vec_u16 =
      wasm_u16x8_narrow_i32x4(current_vec_i32, current_vec_i32);
    v128_t current_vec_u8 =
      wasm_u8x16_narrow_i16x8(current_vec_u16, current_vec_u16);

    // If we can, store using i8x16 in the inner loop.
    if (widen) {
      // Treating the rgba value as one i32 lane, replicate it so we can store
      // four rgba values per loop iteration.
      unsigned rgba = wasm_i32x4_extract_lane(current_vec_u8, 0);
      v128_t current_vec_u8x16 = wasm_i32x4_splat(rgba);
      for (unsigned x = 0; x < width * 4; x += 16) {
        wasm_v128_store(&__heap_base[x], current_vec_u8x16);
      }
    } else {
      for (unsigned x = 0; x < width * 4; x += 4) {
        wasm_v128_store32_lane(&__heap_base[x], current_vec_u8, 0);
      }
    }
  }
}

