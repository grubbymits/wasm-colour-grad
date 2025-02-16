#/bin/sh

set -x

/opt/homebrew/opt/llvm/bin/clang \
  --target=wasm32 -O2 -msimd128 \
  -nostdlib \
  -Wl,--no-entry,--import-memory \
  -Wl,--export=linear_gradient \
  c/gradients.c \
  -o wasm/gradients.wasm
