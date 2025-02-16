#include <stddef.h>

#include <wasm_simd128.h>

extern uint8_t* __heap_base;

#define PAGE_SIZE (1024 * 64)
#define CHANNELS 4

void* INVALID = (void*) 0xFFFFFFFF;

size_t get_memory_size() {
  return __builtin_wasm_memory_size(0) * PAGE_SIZE;
}

bool in_bounds(void* ptr, size_t access_size) {
  return (size_t)ptr + access_size < get_memory_size();
}

void* malloc(size_t size) {
  static size_t allocated = 0;
  if (in_bounds(__heap_base + allocated, size)) {
    void* ptr = __heap_base + allocated;
    allocated += size;
    return ptr;
  } else {
    return INVALID;
  }
}

// Return the number of bytes written.
int linear_gradient(uint32_t width, uint32_t height,
  int32_t start_r, int32_t start_g, int32_t start_b, int32_t start_a,
  int32_t end_r, int32_t end_g, int32_t end_b, int32_t end_a) {

  uint8_t* data_out = malloc(width * height * CHANNELS);
  if (data_out == INVALID) {
    return 0;
  }
  // Build i32x4 vectors from the input 'start' and 'end' values.
  v128_t start_vec = wasm_i32x4_splat(start_r);
  start_vec = wasm_i32x4_replace_lane(start_vec, 1, start_g);
  start_vec = wasm_i32x4_replace_lane(start_vec, 2, start_b);
  start_vec = wasm_i32x4_replace_lane(start_vec, 3, start_a);

  v128_t end_vec = wasm_i32x4_splat(end_r);
  end_vec = wasm_i32x4_replace_lane(end_vec, 1, end_g);
  end_vec = wasm_i32x4_replace_lane(end_vec, 2, end_b);
  end_vec = wasm_i32x4_replace_lane(end_vec, 3, end_a);

  // And then convert them to 4xf32 and calculate the difference in float too.
  v128_t start_vec_f32 = wasm_f32x4_convert_i32x4(start_vec);
  v128_t end_vec_f32 = wasm_f32x4_convert_i32x4(end_vec);
  v128_t diff_vec_f32 = wasm_f32x4_sub(end_vec_f32, start_vec_f32);

  // Calculate the step gradient in f32.
  v128_t height_vec = wasm_i32x4_splat(height);
  v128_t height_vec_f32 = wasm_f32x4_convert_i32x4(height_vec);
  v128_t step_vec_f32 = wasm_f32x4_div(diff_vec_f32, height_vec_f32);

  bool use_v128_store = width % 16 == 0;
  v128_t current_vec_f32 = start_vec_f32;
  v128_t byte_mask = wasm_u32x4_splat(0xff);

  uint32_t bytes_written = 0;
  uint32_t byte_width = width * CHANNELS;
  for (uint32_t y = 0; y < height; ++y) {
    // Calculate the gradient at each step, which is a row, using f32.
    current_vec_f32 = wasm_f32x4_add(current_vec_f32, step_vec_f32);

    // Truncate and saturate back down to u8.
    v128_t current_vec_i32 =
      wasm_v128_and(wasm_u32x4_trunc_sat_f32x4(current_vec_f32), byte_mask);
    v128_t current_vec_u16 =
      wasm_u16x8_narrow_i32x4(current_vec_i32, current_vec_i32);
    v128_t current_vec_u8 =
      wasm_u8x16_narrow_i16x8(current_vec_u16, current_vec_u16);

    // If we can, store using i8x16 in the inner loop.
    if (use_v128_store) {
      // Treating the rgba value as one i32 lane, replicate it so we can store
      // four rgba values per loop iteration.
      uint32_t rgba = wasm_i32x4_extract_lane(current_vec_u8, 0);
      v128_t current_vec_u8x16 = wasm_i32x4_splat(rgba);

      for (uint32_t x = 0; x < byte_width; x += sizeof(v128_t)) {
        uint32_t idx = (y * byte_width) + x;
        wasm_v128_store(&data_out[idx], current_vec_u8x16);
        bytes_written += sizeof(v128_t);
      }
    } else {
      for (uint32_t x = 0; x < byte_width; x += sizeof(uint32_t)) {
        uint32_t idx = (y * byte_width) + x;
        wasm_v128_store32_lane(&data_out[idx], current_vec_u8, 0);
        bytes_written += sizeof(uint32_t);
      }
    }
  }
  return bytes_written;
}

