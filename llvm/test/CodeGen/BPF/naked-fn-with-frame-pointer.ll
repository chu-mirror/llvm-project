; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc < %s -mtriple bpfel | FileCheck %s -check-prefixes=CHECK-LE
; RUN: llc < %s -mtriple bpfeb | FileCheck %s -check-prefixes=CHECK-BE

declare dso_local void @main()

define dso_local void @naked() naked "frame-pointer"="all" {
; CHECK-LE-LABEL: naked:
; CHECK-LE:       .Lnaked$local:
; CHECK-LE-NEXT:    .type .Lnaked$local,@function
; CHECK-LE-NEXT:    .cfi_startproc
; CHECK-LE-NEXT:  # %bb.0:
; CHECK-LE-NEXT:    call main
;
; CHECK-BE-LABEL: naked:
; CHECK-BE:       .Lnaked$local:
; CHECK-BE-NEXT:    .type .Lnaked$local,@function
; CHECK-BE-NEXT:    .cfi_startproc
; CHECK-BE-NEXT:  # %bb.0:
; CHECK-BE-NEXT:    call main
  call void @main()
  unreachable
}

define dso_local void @normal() "frame-pointer"="all" {
; CHECK-LE-LABEL: normal:
; CHECK-LE:       .Lnormal$local:
; CHECK-LE-NEXT:    .type .Lnormal$local,@function
; CHECK-LE-NEXT:    .cfi_startproc
; CHECK-LE-NEXT:  # %bb.0:
; CHECK-LE-NEXT:    call main
;
; CHECK-BE-LABEL: normal:
; CHECK-BE:       .Lnormal$local:
; CHECK-BE-NEXT:    .type .Lnormal$local,@function
; CHECK-BE-NEXT:    .cfi_startproc
; CHECK-BE-NEXT:  # %bb.0:
; CHECK-BE-NEXT:    call main
  call void @main()
  unreachable
}
