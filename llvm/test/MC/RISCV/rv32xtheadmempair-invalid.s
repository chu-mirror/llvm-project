# RUN: not llvm-mc -triple riscv32 -mattr=+xtheadmempair < %s 2>&1 | FileCheck %s

th.ldd t0, t1, (t2), 5, 4   # CHECK: [[@LINE]]:22: error: invalid operand for instruction
th.ldd t0, t1, (t2)         # CHECK: [[@LINE]]:1: error: too few operands for instruction
th.ldd t0, t1, (t2), 3, 5   # CHECK: [[@LINE]]:25: error: invalid operand for instruction
th.sdd a0, a1, (a2), 5, 4   # CHECK: [[@LINE]]:22: error: invalid operand for instruction
th.sdd a0, a1, (a2)         # CHECK: [[@LINE]]:1: error: too few operands for instruction
th.sdd a0, a1, (a2), 3, 5   # CHECK: [[@LINE]]:25: error: invalid operand for instruction
th.lwud t0, t1, (t2), 5, 4  # CHECK: [[@LINE]]:23: error: immediate must be an integer in the range [0, 3]
th.lwud t0, t1, (t2)        # CHECK: [[@LINE]]:1: error: too few operands for instruction
th.lwud t0, t1, (t2), 3, 5  # CHECK: [[@LINE]]:26: error: operand must be constant 3
th.lwd a3, a4, (a5), 5, 4   # CHECK: [[@LINE]]:22: error: immediate must be an integer in the range [0, 3]
th.lwd a3, a4, (a5)         # CHECK: [[@LINE]]:1: error: too few operands for instruction
th.lwd a3, a4, (a5), 3, 5   # CHECK: [[@LINE]]:25: error: operand must be constant 3
th.swd t3, t4, (t5), 5, 4   # CHECK: [[@LINE]]:22: error: immediate must be an integer in the range [0, 3]
th.swd t3, t4, (t5)         # CHECK: [[@LINE]]:1: error: too few operands for instruction
th.swd t3, t4, (t5), 3, 5   # CHECK: [[@LINE]]:25: error: operand must be constant 3
th.lwd x6, x7, (x7), 2, 3   # CHECK: [[@LINE]]:8: error: rs1, rd1, and rd2 cannot overlap
th.lwud x6, x6, (x6), 2, 3  # CHECK: [[@LINE]]:9: error: rs1, rd1, and rd2 cannot overlap
th.ldd t0, t1, (t2), 2, 4   # CHECK: [[@LINE]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
th.sdd t0, t1, (t2), 2, 4   # CHECK: [[@LINE]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
