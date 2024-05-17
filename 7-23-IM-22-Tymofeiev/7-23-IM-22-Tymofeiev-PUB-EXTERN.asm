.686
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc
include \masm32\include\dialogs.inc

PUBLIC TymofeievCalcDominatorWithTan
EXTERN TymofeievPublicArrayAState: QWORD, TymofeievPublicArrayBState: QWORD,  TymofeievForTanFour: QWORD, TymofeievTanArgument: TBYTE, TymofeievTanDominatorRes: TBYTE, TymofeievCheckZero: QWORD, PiOverTwo: QWORD, PiOverTwoMinus: QWORD,  ThreePiOverTwo: QWORD, ThreePiOverTwoMinus: QWORD

.data
    ERROR_ZERO_DENOMINATOR equ 1
    ERROR_UNDEFINED_TAN equ 2

.code

TymofeievCalcDominatorWithTan PROC
  ; Compute (a / 4 - b) and store it in TymofeievTanArgument
    FLD TymofeievPublicArrayAState
    FDIV TymofeievForTanFour
    FSUB TymofeievPublicArrayBState
    FSTP TymofeievTanArgument
  
  ; Check if (a / 4 - b) equals PiOverTwoMinus
    FLD TymofeievTanArgument
    FCOMP PiOverTwoMinus
    FSTSW ax
    SAHF
    JE TymofeievNotifyUnefinedTanInDominator
  
  ; Check if (a / 4 - b) equals PiOverTwo
	FLD TymofeievTanArgument
    FCOMP PiOverTwo
    FSTSW ax
    SAHF
    JE TymofeievNotifyUnefinedTanInDominator
  
  ; Check if (a / 4 - b) equals ThreePiOverTwo
	FLD TymofeievTanArgument
    FCOMP ThreePiOverTwo
    FSTSW ax
    SAHF
    JE TymofeievNotifyUnefinedTanInDominator
  
  ; Check if (a / 4 - b) equals ThreePiOverTwoMinus
	FLD TymofeievTanArgument
    FCOMP ThreePiOverTwoMinus
    FSTSW ax
    SAHF
    JE TymofeievNotifyUnefinedTanInDominator
  
  ; Calculate the tangent only if (a / 4 - b) is not equal to (PiOverTwo | PiOverTwoMinus) OR (ThreePiOverTwo | ThreePiOverTwoMinus)
    FLD TymofeievTanArgument
    FPTAN
    FSTP st(0) ; Discard the tangent result, we need only the division result
    FSTP TymofeievTanDominatorRes


    ; Check if the dominator with tg is 0
    FLD TymofeievTanDominatorRes
    FCOMP TymofeievCheckZero
    FSTSW ax
    SAHF
    JE TymofeievNotifyZeroDominator
  
  ret
  
TymofeievNotifyZeroDominator:
    mov ecx, ERROR_ZERO_DENOMINATOR
    ret

TymofeievNotifyUnefinedTanInDominator:
    mov ecx, ERROR_UNDEFINED_TAN
    ret
  
TymofeievCalcDominatorWithTan ENDP
end