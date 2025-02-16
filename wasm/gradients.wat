(module $gradients.wasm
  (type (;0;) (func (param i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)))
  (import "env" "memory" (memory (;0;) 2))
  (func $linear_gradient (type 0) (param i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    (local v128 v128 i32 v128 v128)
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 6
      i8x16.splat
      local.get 7
      i8x16.replace_lane 1
      local.get 8
      i8x16.replace_lane 2
      local.get 9
      i8x16.replace_lane 3
      i16x8.extend_low_i8x16_u
      i32x4.extend_low_i16x8_u
      local.get 2
      i8x16.splat
      local.get 3
      i8x16.replace_lane 1
      local.get 4
      i8x16.replace_lane 2
      local.get 5
      i8x16.replace_lane 3
      i16x8.extend_low_i8x16_u
      i32x4.extend_low_i16x8_u
      local.tee 10
      i32x4.sub
      f32x4.convert_i32x4_s
      local.get 1
      i32x4.splat
      f32x4.convert_i32x4_s
      local.get 10
      i8x16.shuffle 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3
      f32x4.div
      local.set 11
      local.get 0
      i32.const 15
      i32.and
      local.set 6
      local.get 0
      i32.const 2
      i32.shl
      local.tee 3
      i32.const 4
      local.get 3
      i32.const 4
      i32.gt_u
      select
      i32.const -1
      i32.add
      i32.const 2
      i32.shr_u
      i32.const 1
      i32.add
      local.tee 9
      i32.const 2147483644
      i32.and
      local.tee 7
      i32.const 2
      i32.shl
      local.set 12
      local.get 10
      f32x4.convert_i32x4_u
      local.set 13
      i32.const 0
      local.set 5
      local.get 3
      i32.const 12
      i32.gt_u
      local.set 8
      loop  ;; label = @2
        local.get 11
        local.get 13
        f32x4.add
        local.tee 13
        f32x4.floor
        local.tee 10
        local.get 10
        i16x8.narrow_i32x4_u
        local.tee 10
        local.get 10
        i8x16.narrow_i16x8_u
        local.set 14
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 6
              i32.eqz
              br_if 0 (;@5;)
              i32.const 0
              local.set 2
              local.get 8
              i32.eqz
              br_if 1 (;@4;)
              local.get 14
              local.get 10
              i8x16.shuffle 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3
              local.set 10
              i32.const 66560
              local.set 2
              local.get 7
              local.set 4
              loop  ;; label = @6
                local.get 2
                local.get 10
                v128.store align=1
                local.get 2
                i32.const 16
                i32.add
                local.set 2
                local.get 4
                i32.const -4
                i32.add
                local.tee 4
                br_if 0 (;@6;)
              end
              local.get 12
              local.set 2
              local.get 9
              local.get 7
              i32.ne
              br_if 1 (;@4;)
              br 2 (;@3;)
            end
            local.get 0
            i32.eqz
            br_if 1 (;@3;)
            local.get 14
            local.get 10
            i8x16.shuffle 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3
            local.set 10
            i32.const 0
            local.set 2
            loop  ;; label = @5
              i32.const 66560
              local.get 2
              i32.add
              local.get 10
              v128.store align=1
              local.get 2
              i32.const 16
              i32.add
              local.tee 2
              local.get 3
              i32.lt_u
              br_if 0 (;@5;)
              br 2 (;@3;)
            end
          end
          local.get 14
          i32x4.extract_lane 0
          local.set 4
          loop  ;; label = @4
            i32.const 66560
            local.get 2
            i32.add
            local.get 4
            i32.store align=1
            local.get 2
            i32.const 4
            i32.add
            local.tee 2
            local.get 3
            i32.lt_u
            br_if 0 (;@4;)
          end
        end
        local.get 5
        i32.const 1
        i32.add
        local.tee 5
        local.get 1
        i32.ne
        br_if 0 (;@2;)
      end
    end)
  (global $__stack_pointer (mut i32) (i32.const 66560))
  (global (;1;) i32 (i32.const 66560))
  (export "linear_gradient" (func $linear_gradient))
  (export "__heap_base" (global 1)))
