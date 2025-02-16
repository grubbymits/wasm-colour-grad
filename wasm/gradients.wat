(module $gradients.wasm
  (type (;0;) (func (param i32 i32 i32 i32 i32 i32 i32 i32 i32 i32) (result i32)))
  (import "env" "memory" (memory (;0;) 2))
  (func $linear_gradient (type 0) (param i32 i32 i32 i32 i32 i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 v128 v128 v128 v128 v128)
    i32.const 0
    local.set 10
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.shl
      local.tee 11
      local.get 1
      i32.mul
      local.tee 12
      i32.const 0
      i32.load offset=66576
      i32.const 0
      i32.load offset=1028
      local.tee 13
      i32.add
      local.tee 14
      i32.add
      memory.size
      i32.const 16
      i32.shl
      i32.ge_u
      br_if 0 (;@1;)
      i32.const 0
      local.set 10
      i32.const 0
      local.get 13
      local.get 12
      i32.add
      i32.store offset=1028
      local.get 14
      i32.const 0
      i32.load offset=1024
      i32.eq
      br_if 0 (;@1;)
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 6
      i32x4.splat
      local.get 7
      i32x4.replace_lane 1
      local.get 8
      i32x4.replace_lane 2
      local.get 9
      i32x4.replace_lane 3
      f32x4.convert_i32x4_s
      local.get 2
      i32x4.splat
      local.get 3
      i32x4.replace_lane 1
      local.get 4
      i32x4.replace_lane 2
      local.get 5
      i32x4.replace_lane 3
      f32x4.convert_i32x4_s
      local.tee 15
      f32x4.sub
      local.get 1
      i32x4.splat
      f32x4.convert_i32x4_s
      local.get 16
      i8x16.shuffle 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3
      f32x4.div
      local.set 17
      local.get 0
      i32.const 15
      i32.and
      local.set 8
      local.get 11
      i32.const -1
      i32.add
      local.tee 0
      i32.const 4
      i32.shr_u
      i32.const 1
      i32.add
      local.set 2
      local.get 0
      i32.const 2
      i32.shr_u
      i32.const 1
      i32.add
      local.tee 4
      i32.const 2147483644
      i32.and
      local.tee 7
      i32.const 2
      i32.shl
      local.set 3
      i32.const 0
      local.set 10
      local.get 11
      i32.const 49
      i32.lt_u
      local.set 5
      local.get 11
      i32.const 12
      i32.gt_u
      local.set 6
      i32.const 0
      local.set 9
      loop  ;; label = @2
        local.get 17
        local.get 15
        f32x4.add
        local.tee 15
        i32x4.trunc_sat_f32x4_u
        v128.const i32x4 0x000000ff 0x000000ff 0x000000ff 0x000000ff
        v128.and
        local.tee 16
        local.get 16
        i16x8.narrow_i32x4_u
        local.tee 16
        local.get 16
        i8x16.narrow_i16x8_u
        local.set 18
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 8
              i32.eqz
              br_if 0 (;@5;)
              local.get 11
              i32.eqz
              br_if 2 (;@3;)
              i32.const 0
              local.set 0
              local.get 6
              i32.eqz
              br_if 1 (;@4;)
              local.get 18
              local.get 16
              i8x16.shuffle 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3
              local.set 19
              v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
              local.get 10
              i32x4.replace_lane 0
              local.set 16
              local.get 7
              local.set 10
              local.get 14
              local.set 0
              loop  ;; label = @6
                local.get 0
                local.get 19
                v128.store align=1
                local.get 0
                i32.const 16
                i32.add
                local.set 0
                local.get 16
                v128.const i32x4 0x00000004 0x00000004 0x00000004 0x00000004
                i32x4.add
                local.set 16
                local.get 10
                i32.const -4
                i32.add
                local.tee 10
                br_if 0 (;@6;)
              end
              local.get 16
              local.get 16
              local.get 16
              i8x16.shuffle 8 9 10 11 12 13 14 15 0 1 2 3 0 1 2 3
              i32x4.add
              local.tee 16
              local.get 16
              local.get 16
              i8x16.shuffle 4 5 6 7 0 1 2 3 0 1 2 3 0 1 2 3
              i32x4.add
              i32x4.extract_lane 0
              local.set 10
              local.get 3
              local.set 0
              local.get 4
              local.get 7
              i32.ne
              br_if 1 (;@4;)
              br 2 (;@3;)
            end
            local.get 11
            i32.eqz
            br_if 1 (;@3;)
            local.get 5
            br_if 1 (;@3;)
            local.get 18
            local.get 16
            i8x16.shuffle 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3
            local.set 16
            i32.const 0
            local.set 12
            local.get 2
            local.set 13
            loop  ;; label = @5
              local.get 14
              local.get 12
              i32.add
              local.tee 0
              local.get 16
              v128.store align=1
              local.get 0
              i32.const 48
              i32.add
              local.get 16
              v128.store align=1
              local.get 0
              i32.const 32
              i32.add
              local.get 16
              v128.store align=1
              local.get 0
              i32.const 16
              i32.add
              local.get 16
              v128.store align=1
              local.get 12
              i32.const 64
              i32.add
              local.set 12
              local.get 13
              i32.const -4
              i32.add
              local.tee 13
              br_if 0 (;@5;)
            end
            local.get 10
            local.get 12
            i32.add
            local.set 10
            br 1 (;@3;)
          end
          local.get 18
          i32x4.extract_lane 0
          local.set 12
          loop  ;; label = @4
            local.get 14
            local.get 0
            i32.add
            local.get 12
            i32.store align=1
            local.get 10
            i32.const 4
            i32.add
            local.set 10
            local.get 0
            i32.const 4
            i32.add
            local.tee 0
            local.get 11
            i32.lt_u
            br_if 0 (;@4;)
          end
        end
        local.get 14
        local.get 11
        i32.add
        local.set 14
        local.get 9
        i32.const 1
        i32.add
        local.tee 9
        local.get 1
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 10)
  (global $__stack_pointer (mut i32) (i32.const 66576))
  (export "linear_gradient" (func $linear_gradient))
  (data $.data (i32.const 1024) "\ff\ff\ff\ff")
  (data $.bss (i32.const 1028) "\00\00\00\00"))
