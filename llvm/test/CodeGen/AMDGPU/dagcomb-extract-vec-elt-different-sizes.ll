; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx90a < %s | FileCheck -enable-var-scope %s
;
; This code is used to trigger the following dag node, with different return type and vector element type: i16 extract_vec_elt <N x i8> v, 0

define amdgpu_kernel void @eggs(i1 %arg, ptr addrspace(1) %arg1, ptr %arg2, ptr %arg3, ptr %arg4, ptr %arg5, ptr %arg6, ptr %arg7, ptr %arg8, ptr %arg9) {
; CHECK-LABEL: eggs:
; CHECK:       ; %bb.0: ; %bb
; CHECK-NEXT:    s_add_u32 flat_scratch_lo, s12, s17
; CHECK-NEXT:    s_addc_u32 flat_scratch_hi, s13, 0
; CHECK-NEXT:    s_load_dword s0, s[8:9], 0x0
; CHECK-NEXT:    s_load_dwordx16 s[12:27], s[8:9], 0x8
; CHECK-NEXT:    v_mov_b32_e32 v0, 0
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    s_bitcmp0_b32 s0, 0
; CHECK-NEXT:    s_cbranch_scc1 .LBB0_2
; CHECK-NEXT:  ; %bb.1: ; %bb10
; CHECK-NEXT:    global_load_dwordx2 v[8:9], v0, s[12:13]
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    v_and_b32_e32 v7, 0xff, v8
; CHECK-NEXT:    v_bfe_u32 v6, v8, 8, 8
; CHECK-NEXT:    v_bfe_u32 v5, v8, 16, 8
; CHECK-NEXT:    v_lshrrev_b32_e32 v4, 24, v8
; CHECK-NEXT:    v_and_b32_e32 v3, 0xff, v9
; CHECK-NEXT:    v_bfe_u32 v2, v9, 8, 8
; CHECK-NEXT:    v_bfe_u32 v1, v9, 16, 8
; CHECK-NEXT:    v_lshrrev_b32_e32 v0, 24, v9
; CHECK-NEXT:    s_branch .LBB0_3
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    v_mov_b32_e32 v1, 0
; CHECK-NEXT:    v_mov_b32_e32 v2, 0
; CHECK-NEXT:    v_mov_b32_e32 v3, 0
; CHECK-NEXT:    v_mov_b32_e32 v4, 0
; CHECK-NEXT:    v_mov_b32_e32 v5, 0
; CHECK-NEXT:    v_mov_b32_e32 v6, 0
; CHECK-NEXT:    v_mov_b32_e32 v7, 0
; CHECK-NEXT:  .LBB0_3: ; %bb41
; CHECK-NEXT:    s_load_dwordx2 s[0:1], s[8:9], 0x48
; CHECK-NEXT:    v_mov_b32_e32 v8, s14
; CHECK-NEXT:    v_mov_b32_e32 v9, s15
; CHECK-NEXT:    v_mov_b32_e32 v10, s16
; CHECK-NEXT:    v_mov_b32_e32 v11, s17
; CHECK-NEXT:    v_mov_b32_e32 v12, s18
; CHECK-NEXT:    v_mov_b32_e32 v13, s19
; CHECK-NEXT:    v_mov_b32_e32 v14, s20
; CHECK-NEXT:    v_mov_b32_e32 v15, s21
; CHECK-NEXT:    v_mov_b32_e32 v16, s22
; CHECK-NEXT:    v_mov_b32_e32 v17, s23
; CHECK-NEXT:    v_mov_b32_e32 v18, s24
; CHECK-NEXT:    v_mov_b32_e32 v19, s25
; CHECK-NEXT:    v_mov_b32_e32 v20, s26
; CHECK-NEXT:    v_mov_b32_e32 v21, s27
; CHECK-NEXT:    flat_store_byte v[8:9], v7
; CHECK-NEXT:    flat_store_byte v[10:11], v6
; CHECK-NEXT:    flat_store_byte v[12:13], v5
; CHECK-NEXT:    flat_store_byte v[14:15], v4
; CHECK-NEXT:    flat_store_byte v[16:17], v3
; CHECK-NEXT:    flat_store_byte v[18:19], v2
; CHECK-NEXT:    flat_store_byte v[20:21], v1
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    v_pk_mov_b32 v[2:3], s[0:1], s[0:1] op_sel:[0,1]
; CHECK-NEXT:    flat_store_byte v[2:3], v0
; CHECK-NEXT:    s_endpgm
bb:
  br i1 %arg, label %bb10, label %bb41

bb10:                                             ; preds = %bb
  %tmp12 = load <1 x i8>, ptr addrspace(1) %arg1
  %tmp13 = getelementptr i8, ptr addrspace(1) %arg1, i64 1
  %tmp16 = load <1 x i8>, ptr addrspace(1) %tmp13
  %tmp17 = getelementptr i8, ptr addrspace(1) %arg1, i64 2
  %tmp20 = load <1 x i8>, ptr addrspace(1) %tmp17
  %tmp21 = getelementptr i8, ptr addrspace(1) %arg1, i64 3
  %tmp24 = load <1 x i8>, ptr addrspace(1) %tmp21
  %tmp25 = getelementptr i8, ptr addrspace(1) %arg1, i64 4
  %tmp28 = load <1 x i8>, ptr addrspace(1) %tmp25
  %tmp29 = getelementptr i8, ptr addrspace(1) %arg1, i64 5
  %tmp32 = load <1 x i8>, ptr addrspace(1) %tmp29
  %tmp33 = getelementptr i8, ptr addrspace(1) %arg1, i64 6
  %tmp36 = load <1 x i8>, ptr addrspace(1) %tmp33
  %tmp37 = getelementptr i8, ptr addrspace(1) %arg1, i64 7
  %tmp40 = load <1 x i8>, ptr addrspace(1) %tmp37
  br label %bb41

bb41:                                             ; preds = %bb10, %bb
  %tmp42 = phi <1 x i8> [ %tmp40, %bb10 ], [ zeroinitializer, %bb ]
  %tmp43 = phi <1 x i8> [ %tmp36, %bb10 ], [ zeroinitializer, %bb ]
  %tmp44 = phi <1 x i8> [ %tmp32, %bb10 ], [ zeroinitializer, %bb ]
  %tmp45 = phi <1 x i8> [ %tmp28, %bb10 ], [ zeroinitializer, %bb ]
  %tmp46 = phi <1 x i8> [ %tmp24, %bb10 ], [ zeroinitializer, %bb ]
  %tmp47 = phi <1 x i8> [ %tmp20, %bb10 ], [ zeroinitializer, %bb ]
  %tmp48 = phi <1 x i8> [ %tmp16, %bb10 ], [ zeroinitializer, %bb ]
  %tmp49 = phi <1 x i8> [ %tmp12, %bb10 ], [ zeroinitializer, %bb ]
  store <1 x i8> %tmp49, ptr %arg2
  store <1 x i8> %tmp48, ptr %arg3
  store <1 x i8> %tmp47, ptr %arg4
  store <1 x i8> %tmp46, ptr %arg5
  store <1 x i8> %tmp45, ptr %arg6
  store <1 x i8> %tmp44, ptr %arg7
  store <1 x i8> %tmp43, ptr %arg8
  store <1 x i8> %tmp42, ptr %arg9
  ret void
}
