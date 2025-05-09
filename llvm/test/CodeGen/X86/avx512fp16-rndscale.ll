; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-darwin -mattr=+avx512fp16,+avx512vl | FileCheck %s

declare <8 x half> @llvm.ceil.v8f16(<8 x half>)
declare <16 x half> @llvm.ceil.v16f16(<16 x half>)
declare <32 x half> @llvm.ceil.v32f16(<32 x half>)

define <8 x half> @ceil_v8f16(<8 x half> %p) {
; CHECK-LABEL: ceil_v8f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $10, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t = call <8 x half> @llvm.ceil.v8f16(<8 x half> %p)
  ret <8 x half> %t
}

define <16 x half> @ceil_v16f16(<16 x half> %p) {
; CHECK-LABEL: ceil_v16f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $10, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %t = call <16 x half> @llvm.ceil.v16f16(<16 x half> %p)
  ret <16 x half> %t
}

define <32 x half> @ceil_v32f16(<32 x half> %p) {
; CHECK-LABEL: ceil_v32f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $10, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %t = call <32 x half> @llvm.ceil.v32f16(<32 x half> %p)
  ret <32 x half> %t
}

declare <8 x half> @llvm.floor.v8f16(<8 x half>)
declare <16 x half> @llvm.floor.v16f16(<16 x half>)
declare <32 x half> @llvm.floor.v32f16(<32 x half>)

define <8 x half> @floor_v8f16(<8 x half> %p) {
; CHECK-LABEL: floor_v8f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $9, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t = call <8 x half> @llvm.floor.v8f16(<8 x half> %p)
  ret <8 x half> %t
}

define <16 x half> @floor_v16f16(<16 x half> %p) {
; CHECK-LABEL: floor_v16f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $9, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %t = call <16 x half> @llvm.floor.v16f16(<16 x half> %p)
  ret <16 x half> %t
}

define <32 x half> @floor_v32f16(<32 x half> %p) {
; CHECK-LABEL: floor_v32f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $9, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %t = call <32 x half> @llvm.floor.v32f16(<32 x half> %p)
  ret <32 x half> %t
}

declare <8 x half> @llvm.trunc.v8f16(<8 x half>)
declare <16 x half> @llvm.trunc.v16f16(<16 x half>)
declare <32 x half> @llvm.trunc.v32f16(<32 x half>)

define <8 x half> @trunc_v8f16(<8 x half> %p) {
; CHECK-LABEL: trunc_v8f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $11, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t = call <8 x half> @llvm.trunc.v8f16(<8 x half> %p)
  ret <8 x half> %t
}

define <16 x half> @trunc_v16f16(<16 x half> %p) {
; CHECK-LABEL: trunc_v16f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $11, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %t = call <16 x half> @llvm.trunc.v16f16(<16 x half> %p)
  ret <16 x half> %t
}

define <32 x half> @trunc_v32f16(<32 x half> %p) {
; CHECK-LABEL: trunc_v32f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $11, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %t = call <32 x half> @llvm.trunc.v32f16(<32 x half> %p)
  ret <32 x half> %t
}

declare <8 x half> @llvm.nearbyint.v8f16(<8 x half>)
declare <16 x half> @llvm.nearbyint.v16f16(<16 x half>)
declare <32 x half> @llvm.nearbyint.v32f16(<32 x half>)

define <8 x half> @nearbyint_v8f16(<8 x half> %p) {
; CHECK-LABEL: nearbyint_v8f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $12, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t = call <8 x half> @llvm.nearbyint.v8f16(<8 x half> %p)
  ret <8 x half> %t
}

define <16 x half> @nearbyint_v16f16(<16 x half> %p) {
; CHECK-LABEL: nearbyint_v16f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $12, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %t = call <16 x half> @llvm.nearbyint.v16f16(<16 x half> %p)
  ret <16 x half> %t
}

define <32 x half> @nearbyint_v32f16(<32 x half> %p) {
; CHECK-LABEL: nearbyint_v32f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $12, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %t = call <32 x half> @llvm.nearbyint.v32f16(<32 x half> %p)
  ret <32 x half> %t
}

declare <8 x half> @llvm.rint.v8f16(<8 x half>)
declare <16 x half> @llvm.rint.v16f16(<16 x half>)
declare <32 x half> @llvm.rint.v32f16(<32 x half>)

define <8 x half> @rint_v8f16(<8 x half> %p) {
; CHECK-LABEL: rint_v8f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $4, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %t = call <8 x half> @llvm.rint.v8f16(<8 x half> %p)
  ret <8 x half> %t
}

define <16 x half> @rint_v16f16(<16 x half> %p) {
; CHECK-LABEL: rint_v16f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $4, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %t = call <16 x half> @llvm.rint.v16f16(<16 x half> %p)
  ret <16 x half> %t
}

define <32 x half> @rint_v32f16(<32 x half> %p) {
; CHECK-LABEL: rint_v32f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrndscaleph $4, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %t = call <32 x half> @llvm.rint.v32f16(<32 x half> %p)
  ret <32 x half> %t
}
