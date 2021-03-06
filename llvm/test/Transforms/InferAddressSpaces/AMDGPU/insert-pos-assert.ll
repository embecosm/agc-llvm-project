; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -infer-address-spaces %s | FileCheck %s

; Addrspacecasts or bitcasts must be inserted after the instructions that define their uses.

%struct.s0 = type { i32*, i32 }
%struct.s1 = type { %struct.s0 }

@global0 = protected addrspace(4) externally_initialized global %struct.s1 zeroinitializer

declare i32 @func(i32* %arg)

define i32 @addrspacecast_insert_pos_assert() {
; CHECK-LABEL: @addrspacecast_insert_pos_assert(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; CHECK-NEXT:    [[LOAD0:%.*]] = load i32*, i32* addrspace(4)* getelementptr inbounds ([[STRUCT_S1:%.*]], [[STRUCT_S1]] addrspace(4)* @global0, i32 0, i32 0, i32 0), align 8
; CHECK-NEXT:    [[TMP1:%.*]] = addrspacecast i32* [[LOAD0]] to i32 addrspace(1)*
; CHECK-NEXT:    [[TMP2:%.*]] = addrspacecast i32 addrspace(1)* [[TMP1]] to i32*
; CHECK-NEXT:    [[LOAD1:%.*]] = load i32, i32 addrspace(5)* [[ALLOCA]], align 4
; CHECK-NEXT:    [[SEXT:%.*]] = sext i32 [[LOAD1]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i64 [[SEXT]]
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @func(i32* [[GEP]])
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %alloca = alloca i32, align 4, addrspace(5)
  %cast = addrspacecast i32 addrspace(5)* %alloca to i32*
  %load0 = load i32*, i32* addrspace(4)* getelementptr inbounds (%struct.s1, %struct.s1 addrspace(4)* @global0, i32 0, i32 0, i32 0)
  %load1 = load i32, i32* %cast
  %sext = sext i32 %load1 to i64
  %gep = getelementptr inbounds i32, i32* %load0, i64 %sext
  %call = call i32 @func(i32* %gep)
  ret i32 %call
}

define void @bitcast_insert_pos_assert_1() {
; CHECK-LABEL: @bitcast_insert_pos_assert_1(
; CHECK-NEXT:  bb.0:
; CHECK-NEXT:    [[ASC0:%.*]] = bitcast [[STRUCT_S1:%.*]] addrspace(5)* undef to i8 addrspace(5)*
; CHECK-NEXT:    [[BC0:%.*]] = bitcast i8 addrspace(5)* [[ASC0]] to [[STRUCT_S1]] addrspace(5)*
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast [[STRUCT_S1]] addrspace(5)* [[BC0]] to double* addrspace(5)*
; CHECK-NEXT:    [[TMP1:%.*]] = addrspacecast double* addrspace(5)* [[TMP0]] to %struct.s1*
; CHECK-NEXT:    [[PTI0:%.*]] = ptrtoint %struct.s1* [[TMP1]] to i64
; CHECK-NEXT:    br label [[BB_1:%.*]]
; CHECK:       bb.1:
; CHECK-NEXT:    br i1 undef, label [[BB_2:%.*]], label [[BB_3:%.*]]
; CHECK:       bb.2:
; CHECK-NEXT:    [[LOAD0:%.*]] = load double*, double* addrspace(5)* [[TMP0]], align 8
; CHECK-NEXT:    br label [[BB_3]]
; CHECK:       bb.3:
; CHECK-NEXT:    ret void
;
bb.0:
  %asc0 = addrspacecast %struct.s1 addrspace(5)* undef to i8*
  %bc0 = bitcast i8* %asc0 to %struct.s1*
  %pti0 = ptrtoint %struct.s1* %bc0 to i64
  br label %bb.1

bb.1:
  br i1 undef, label %bb.2, label %bb.3

bb.2:
  %pti1 = ptrtoint %struct.s1* %bc0 to i64
  %itp0 = inttoptr i64 %pti1 to double**
  %load0 = load double*, double** %itp0, align 8
  br label %bb.3

bb.3:
  ret void
}

define void @bitcast_insert_pos_assert_2() {
; CHECK-LABEL: @bitcast_insert_pos_assert_2(
; CHECK-NEXT:    [[ALLOCA0:%.*]] = alloca [[STRUCT_S1:%.*]], align 16, addrspace(5)
; CHECK-NEXT:    [[ASC0:%.*]] = bitcast [[STRUCT_S1]] addrspace(5)* [[ALLOCA0]] to i8 addrspace(5)*
; CHECK-NEXT:    [[BC0:%.*]] = bitcast i8 addrspace(5)* [[ASC0]] to [[STRUCT_S1]] addrspace(5)*
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast [[STRUCT_S1]] addrspace(5)* [[BC0]] to i64 addrspace(5)*
; CHECK-NEXT:    [[TMP2:%.*]] = addrspacecast i64 addrspace(5)* [[TMP1]] to %struct.s1*
; CHECK-NEXT:    [[PTI0:%.*]] = ptrtoint %struct.s1* [[TMP2]] to i64
; CHECK-NEXT:    [[ITP0:%.*]] = inttoptr i64 [[PTI0]] to i64*
; CHECK-NEXT:    [[TMP3:%.*]] = addrspacecast i64 addrspace(5)* [[TMP1]] to i64*
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr i64, i64* [[TMP3]], i64 0
; CHECK-NEXT:    ret void
;
  %alloca0 = alloca %struct.s1, align 16, addrspace(5)
  %asc0 = addrspacecast %struct.s1 addrspace(5)* %alloca0 to i8*
  %bc0 = bitcast i8* %asc0 to %struct.s1*
  %pti0 = ptrtoint %struct.s1* %bc0 to i64
  %itp0 = inttoptr i64 %pti0 to i64*
  %itp1 = ptrtoint %struct.s1* %bc0 to i64
  %itp2 = inttoptr i64 %itp1 to i64*
  %gep0 = getelementptr i64, i64* %itp2, i64 0
  ret void
}
