// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --version 5

// RUN: %clang_cc1 -O2 -triple aarch64 -emit-llvm -x c   -DUSE_NEON_H  %s -o - | FileCheck %s
// RUN: %clang_cc1 -O2 -triple aarch64 -emit-llvm -x c   -DUSE_SVE_H   %s -o - | FileCheck %s
// RUN: %clang_cc1 -O2 -triple aarch64 -emit-llvm -x c   -DUSE_SME_H   %s -o - | FileCheck %s
// RUN: %clang_cc1 -O2 -triple aarch64 -emit-llvm -x c++ -DUSE_NEON_H  %s -o - | FileCheck %s
// RUN: %clang_cc1 -O2 -triple aarch64 -emit-llvm -x c++ -DUSE_SVE_H   %s -o - | FileCheck %s
// RUN: %clang_cc1 -O2 -triple aarch64 -emit-llvm -x c++ -DUSE_SME_H   %s -o - | FileCheck %s

// REQUIRES: aarch64-registered-target

#ifdef USE_NEON_H
#include "arm_neon.h"
#endif

#ifdef USE_SVE_H
#include "arm_sve.h"
#endif

#ifdef USE_SME_H
#include "arm_sme.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define INIT_ZERO 0
#define INIT_ONES 0xffffffffffffffffU

// CHECK-LABEL: define dso_local noundef i64 @test_init(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0:[0-9]+]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 0
//
fpm_t test_init() { return __arm_fpm_init(); }

// CHECK-LABEL: define dso_local noundef range(i64 0, -6) i64 @test_src1_1(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 -8
//
fpm_t test_src1_1() {
  return __arm_set_fpm_src1_format(INIT_ONES, __ARM_FPM_E5M2);
}

// CHECK-LABEL: define dso_local noundef range(i64 0, -6) i64 @test_src1_2(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 1
//
fpm_t test_src1_2() {
  return __arm_set_fpm_src1_format(INIT_ZERO, __ARM_FPM_E4M3);
}

// CHECK-LABEL: define dso_local noundef range(i64 0, -48) i64 @test_src2_1(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 -57
//
fpm_t test_src2_1() {
  return __arm_set_fpm_src2_format(INIT_ONES, __ARM_FPM_E5M2);
}

// CHECK-LABEL: define dso_local noundef range(i64 0, -48) i64 @test_src2_2(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 8
//
fpm_t test_src2_2() {
  return __arm_set_fpm_src2_format(INIT_ZERO, __ARM_FPM_E4M3);
}

// CHECK-LABEL: define dso_local noundef range(i64 0, -384) i64 @test_dst1_1(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 -449
//
fpm_t test_dst1_1() {
  return __arm_set_fpm_dst_format(INIT_ONES, __ARM_FPM_E5M2);
}

// CHECK-LABEL: define dso_local noundef range(i64 0, -384) i64 @test_dst2_2(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 64
//
fpm_t test_dst2_2() {
  return __arm_set_fpm_dst_format(INIT_ZERO, __ARM_FPM_E4M3);
}

// CHECK-LABEL: define dso_local noundef i64 @test_of_mul_1(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 -16385
//
fpm_t test_of_mul_1() {
  return __arm_set_fpm_overflow_mul(INIT_ONES, __ARM_FPM_INFNAN);
}

// CHECK-LABEL: define dso_local noundef i64 @test_of_mul_2(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 16384
//
fpm_t test_of_mul_2() {
  return __arm_set_fpm_overflow_mul(INIT_ZERO, __ARM_FPM_SATURATE);
}

// CHECK-LABEL: define dso_local noundef i64 @test_of_cvt_1(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 -32769
//
fpm_t test_of_cvt_1() {
  return __arm_set_fpm_overflow_cvt(INIT_ONES, __ARM_FPM_INFNAN);
}

// CHECK-LABEL: define dso_local noundef i64 @test_of_cvt_2(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 32768
//
fpm_t test_of_cvt_2() {
  return __arm_set_fpm_overflow_cvt(INIT_ZERO, __ARM_FPM_SATURATE);
}

// CHECK-LABEL: define dso_local noundef i64 @test_lscale(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 8323072
//
fpm_t test_lscale() { return __arm_set_fpm_lscale(INIT_ZERO, 127); }

// CHECK-LABEL: define dso_local noundef i64 @test_lscale2(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 270582939648
//
fpm_t test_lscale2() { return __arm_set_fpm_lscale2(INIT_ZERO, 63); }

// CHECK-LABEL: define dso_local noundef range(i64 0, 4278190081) i64 @test_nscale_1(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 2147483648
//
fpm_t test_nscale_1() { return __arm_set_fpm_nscale(INIT_ZERO, -128); }

// CHECK-LABEL: define dso_local noundef range(i64 0, 4278190081) i64 @test_nscale_2(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 2130706432
//
fpm_t test_nscale_2() { return __arm_set_fpm_nscale(INIT_ZERO, 127); }

// CHECK-LABEL: define dso_local noundef range(i64 0, 4278190081) i64 @test_nscale_3(
// CHECK-SAME: ) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret i64 4278190080
//
fpm_t test_nscale_3() { return __arm_set_fpm_nscale(INIT_ZERO, -1); }

#ifdef __cplusplus
}
#endif
