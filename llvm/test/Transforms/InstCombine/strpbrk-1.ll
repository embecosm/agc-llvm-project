; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the strpbrk library call simplifier works correctly.
;
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

@hello = constant [12 x i8] c"hello world\00"
@w = constant [2 x i8] c"w\00"
@null = constant [1 x i8] zeroinitializer

declare i8* @strpbrk(i8*, i8*)

; Check strpbrk(s, "") -> NULL.

define i8* @test_simplify1(i8* %str) {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    ret i8* null
;
  %pat = getelementptr [1 x i8], [1 x i8]* @null, i32 0, i32 0

  %ret = call i8* @strpbrk(i8* %str, i8* %pat)
  ret i8* %ret
}

; Check strpbrk("", s) -> NULL.

define i8* @test_simplify2(i8* %pat) {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    ret i8* null
;
  %str = getelementptr [1 x i8], [1 x i8]* @null, i32 0, i32 0

  %ret = call i8* @strpbrk(i8* %str, i8* %pat)
  ret i8* %ret
}

; Check strpbrk(s1, s2), where s1 and s2 are constants.

define i8* @test_simplify3() {
; CHECK-LABEL: @test_simplify3(
; CHECK-NEXT:    ret i8* getelementptr inbounds ([12 x i8], [12 x i8]* @hello, i32 0, i32 6)
;
  %str = getelementptr [12 x i8], [12 x i8]* @hello, i32 0, i32 0
  %pat = getelementptr [2 x i8], [2 x i8]* @w, i32 0, i32 0

  %ret = call i8* @strpbrk(i8* %str, i8* %pat)
  ret i8* %ret
}

; Check strpbrk(s, "a") -> strchr(s, 'a').

define i8* @test_simplify4(i8* %str) {
; CHECK-LABEL: @test_simplify4(
; CHECK-NEXT:    [[STRCHR:%.*]] = call i8* @strchr(i8* noundef nonnull dereferenceable(1) [[STR:%.*]], i32 119)
; CHECK-NEXT:    ret i8* [[STRCHR]]
;
  %pat = getelementptr [2 x i8], [2 x i8]* @w, i32 0, i32 0

  %ret = call i8* @strpbrk(i8* %str, i8* %pat)
  ret i8* %ret
}

; Check cases that shouldn't be simplified.

define i8* @test_no_simplify1(i8* %str, i8* %pat) {
; CHECK-LABEL: @test_no_simplify1(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @strpbrk(i8* [[STR:%.*]], i8* [[PAT:%.*]])
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ret = call i8* @strpbrk(i8* %str, i8* %pat)
  ret i8* %ret
}
