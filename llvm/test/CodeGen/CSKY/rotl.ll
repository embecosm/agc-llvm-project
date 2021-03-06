; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -csky-no-aliases -mattr=+e2 < %s -mtriple=csky | FileCheck %s

define i32 @ROTLI32(i32 %x) {
; CHECK-LABEL: ROTLI32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rotli32 a0, a0, 4
; CHECK-NEXT:    rts16
entry:
  %shl = shl i32 %x, 4
  %shr = lshr i32 %x, 28
  %or = or i32 %shl, %shr
  ret i32 %or
}

define i32 @ROTL32(i32 %x, i32 %y) {
; CHECK-LABEL: ROTL32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi32 a1, a1, 31
; CHECK-NEXT:    rotl16 a0, a1
; CHECK-NEXT:    rts16
entry:
  %0 = shl i32 %x, %y
  %1 = sub i32 32, %y
  %2 = lshr i32 %x, %1
  %3 = or i32 %2, %0
  ret i32 %3
}
