; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple powerpc64 -mcpu=pwr10 < %s | FileCheck %s --check-prefix=BE
; RUN: llc -mtriple powerpc64le -mcpu=pwr10 < %s | FileCheck %s --check-prefix=LE
; RUN: llc -mtriple powerpc64le -mcpu=pwr10 -ppc-disable-perfect-shuffle=false < %s | FileCheck %s --check-prefix=LE
; RUN: llc -mtriple powerpc64 -mcpu=pwr10 -ppc-disable-perfect-shuffle=false < %s | FileCheck %s --check-prefix=BE-ENABLE

; TODO: Fix the worse codegen when disabling perfect shuffle

define <4 x float> @shuffle1(<16 x i8> %v1, <16 x i8> %v2) {
; BE-LABEL: shuffle1:
; BE:       # %bb.0:
; BE-NEXT:    addis 3, 2, .LCPI0_0@toc@ha
; BE-NEXT:    addi 3, 3, .LCPI0_0@toc@l
; BE-NEXT:    lxv 36, 0(3)
; BE-NEXT:    vperm 2, 2, 3, 4
; BE-NEXT:    blr
;
; LE-LABEL: shuffle1:
; LE:       # %bb.0:
; LE-NEXT:    vpkudum 2, 3, 2
; LE-NEXT:    blr
;
; BE-ENABLE-LABEL: shuffle1:
; BE-ENABLE:       # %bb.0:
; BE-ENABLE-NEXT:    xxmrglw 0, 34, 35
; BE-ENABLE-NEXT:    xxmrghw 1, 34, 35
; BE-ENABLE-NEXT:    xxmrghw 34, 1, 0
; BE-ENABLE-NEXT:    blr
  %shuf = shufflevector <16 x i8> %v1, <16 x i8> %v2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19, i32 24, i32 25, i32 26, i32 27>
  %cast = bitcast <16 x i8> %shuf to <4 x float>
  ret <4 x float> %cast
}

define <4 x float> @shuffle2(<16 x i8> %v1, <16 x i8> %v2) {
; BE-LABEL: shuffle2:
; BE:       # %bb.0:
; BE-NEXT:    vpkudum 2, 2, 3
; BE-NEXT:    blr
;
; LE-LABEL: shuffle2:
; LE:       # %bb.0:
; LE-NEXT:    plxv 36, .LCPI1_0@PCREL(0), 1
; LE-NEXT:    vperm 2, 3, 2, 4
; LE-NEXT:    blr
;
; BE-ENABLE-LABEL: shuffle2:
; BE-ENABLE:       # %bb.0:
; BE-ENABLE-NEXT:    vpkudum 2, 2, 3
; BE-ENABLE-NEXT:    blr
  %shuf = shufflevector <16 x i8> %v1, <16 x i8> %v2, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15, i32 20, i32 21, i32 22, i32 23, i32 28, i32 29, i32 30, i32 31>
  %cast = bitcast <16 x i8> %shuf to <4 x float>
  ret <4 x float> %cast
}

define <4 x float> @shuffle3(<16 x i8> %v1, <16 x i8> %v2, <16 x i8> %v3, <16 x i8> %v4) {
; BE-LABEL: shuffle3:
; BE:       # %bb.0:
; BE-NEXT:    addis 3, 2, .LCPI2_0@toc@ha
; BE-NEXT:    addi 3, 3, .LCPI2_0@toc@l
; BE-NEXT:    lxv 32, 0(3)
; BE-NEXT:    vperm 2, 2, 3, 0
; BE-NEXT:    vperm 3, 4, 5, 0
; BE-NEXT:    xvaddsp 34, 34, 35
; BE-NEXT:    blr
;
; LE-LABEL: shuffle3:
; LE:       # %bb.0:
; LE-NEXT:    vpkudum 2, 3, 2
; LE-NEXT:    vpkudum 3, 5, 4
; LE-NEXT:    xvaddsp 34, 34, 35
; LE-NEXT:    blr
;
; BE-ENABLE-LABEL: shuffle3:
; BE-ENABLE:       # %bb.0:
; BE-ENABLE-NEXT:    xxmrglw 0, 34, 35
; BE-ENABLE-NEXT:    xxmrghw 1, 34, 35
; BE-ENABLE-NEXT:    xxmrghw 34, 1, 0
; BE-ENABLE-NEXT:    xxmrglw 0, 36, 37
; BE-ENABLE-NEXT:    xxmrghw 1, 36, 37
; BE-ENABLE-NEXT:    xxmrghw 35, 1, 0
; BE-ENABLE-NEXT:    xvaddsp 34, 34, 35
; BE-ENABLE-NEXT:    blr
  %shuf1 = shufflevector <16 x i8> %v1, <16 x i8> %v2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19, i32 24, i32 25, i32 26, i32 27>
  %shuf2 = shufflevector <16 x i8> %v3, <16 x i8> %v4, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19, i32 24, i32 25, i32 26, i32 27>
  %cast1 = bitcast <16 x i8> %shuf1 to <4 x float>
  %cast2 = bitcast <16 x i8> %shuf2 to <4 x float>
  %add = fadd <4 x float> %cast1, %cast2
  ret <4 x float> %add
}

define <4 x float> @shuffle4(<16 x i8> %v1, <16 x i8> %v2, <16 x i8> %v3, <16 x i8> %v4) {
; BE-LABEL: shuffle4:
; BE:       # %bb.0:
; BE-NEXT:    vpkudum 2, 2, 3
; BE-NEXT:    vpkudum 3, 4, 5
; BE-NEXT:    xvaddsp 34, 34, 35
; BE-NEXT:    blr
;
; LE-LABEL: shuffle4:
; LE:       # %bb.0:
; LE-NEXT:    plxv 32, .LCPI3_0@PCREL(0), 1
; LE-NEXT:    vperm 2, 3, 2, 0
; LE-NEXT:    vperm 3, 5, 4, 0
; LE-NEXT:    xvaddsp 34, 34, 35
; LE-NEXT:    blr
;
; BE-ENABLE-LABEL: shuffle4:
; BE-ENABLE:       # %bb.0:
; BE-ENABLE-NEXT:    vpkudum 2, 2, 3
; BE-ENABLE-NEXT:    vpkudum 3, 4, 5
; BE-ENABLE-NEXT:    xvaddsp 34, 34, 35
; BE-ENABLE-NEXT:    blr
  %shuf1 = shufflevector <16 x i8> %v1, <16 x i8> %v2, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15, i32 20, i32 21, i32 22, i32 23, i32 28, i32 29, i32 30, i32 31>
  %shuf2 = shufflevector <16 x i8> %v3, <16 x i8> %v4, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15, i32 20, i32 21, i32 22, i32 23, i32 28, i32 29, i32 30, i32 31>
  %cast1 = bitcast <16 x i8> %shuf1 to <4 x float>
  %cast2 = bitcast <16 x i8> %shuf2 to <4 x float>
  %add = fadd <4 x float> %cast1, %cast2
  ret <4 x float> %add
}

define <4 x float> @shuffle5(<16 x i8> %v1, <16 x i8> %v2, <16 x i8> %v3, <16 x i8> %v4) {
; BE-LABEL: shuffle5:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis 3, 2, .LCPI4_0@toc@ha
; BE-NEXT:    addi 3, 3, .LCPI4_0@toc@l
; BE-NEXT:    lxv 32, 0(3)
; BE-NEXT:    li 3, 8
; BE-NEXT:    vextublx 3, 3, 2
; BE-NEXT:    andi. 3, 3, 255
; BE-NEXT:    vperm 3, 2, 3, 0
; BE-NEXT:    vmr 2, 3
; BE-NEXT:    beq 0, .LBB4_2
; BE-NEXT:  # %bb.1: # %exit
; BE-NEXT:    xvaddsp 34, 35, 34
; BE-NEXT:    blr
; BE-NEXT:  .LBB4_2: # %second
; BE-NEXT:    vperm 2, 4, 5, 0
; BE-NEXT:    xvaddsp 34, 35, 34
; BE-NEXT:    blr
;
; LE-LABEL: shuffle5:
; LE:       # %bb.0: # %entry
; LE-NEXT:    vpkudum 3, 3, 2
; LE-NEXT:    li 3, 8
; LE-NEXT:    vextubrx 3, 3, 2
; LE-NEXT:    vmr 2, 3
; LE-NEXT:    andi. 3, 3, 255
; LE-NEXT:    beq 0, .LBB4_2
; LE-NEXT:  # %bb.1: # %exit
; LE-NEXT:    xvaddsp 34, 35, 34
; LE-NEXT:    blr
; LE-NEXT:  .LBB4_2: # %second
; LE-NEXT:    vpkudum 2, 5, 4
; LE-NEXT:    xvaddsp 34, 35, 34
; LE-NEXT:    blr
;
; BE-ENABLE-LABEL: shuffle5:
; BE-ENABLE:       # %bb.0: # %entry
; BE-ENABLE-NEXT:    xxmrglw 0, 34, 35
; BE-ENABLE-NEXT:    xxmrghw 1, 34, 35
; BE-ENABLE-NEXT:    li 3, 8
; BE-ENABLE-NEXT:    vextublx 3, 3, 2
; BE-ENABLE-NEXT:    xxmrghw 0, 1, 0
; BE-ENABLE-NEXT:    andi. 3, 3, 255
; BE-ENABLE-NEXT:    xxlor 1, 0, 0
; BE-ENABLE-NEXT:    beq 0, .LBB4_2
; BE-ENABLE-NEXT:  # %bb.1: # %exit
; BE-ENABLE-NEXT:    xvaddsp 34, 0, 1
; BE-ENABLE-NEXT:    blr
; BE-ENABLE-NEXT:  .LBB4_2: # %second
; BE-ENABLE-NEXT:    xxmrglw 1, 36, 37
; BE-ENABLE-NEXT:    xxmrghw 2, 36, 37
; BE-ENABLE-NEXT:    xxmrghw 1, 2, 1
; BE-ENABLE-NEXT:    xvaddsp 34, 0, 1
; BE-ENABLE-NEXT:    blr
entry:
  %shuf1 = shufflevector <16 x i8> %v1, <16 x i8> %v2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19, i32 24, i32 25, i32 26, i32 27>
  %fetch = extractelement <16 x i8> %shuf1, i32 4
  %icmp = icmp eq i8 %fetch, 0
  br i1 %icmp, label %second, label %exit

second:
  %shufs = shufflevector <16 x i8> %v3, <16 x i8> %v4, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19, i32 24, i32 25, i32 26, i32 27>
  br label %exit

exit:
  %shuf2 = phi <16 x i8> [%shuf1, %entry], [%shufs, %second]
  %cast1 = bitcast <16 x i8> %shuf1 to <4 x float>
  %cast2 = bitcast <16 x i8> %shuf2 to <4 x float>
  %add = fadd <4 x float> %cast1, %cast2
  ret <4 x float> %add
}
