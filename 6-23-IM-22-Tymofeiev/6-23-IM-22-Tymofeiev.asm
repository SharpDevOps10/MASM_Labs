User
.686
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc
include \masm32\include\dialogs.inc

.data?

    TymofeievSummaryBuffer db 256 dup (?)
    TymofeievSummaryBufferForTempValues db 256 dup (?)

    TymofeievMediumResult dq ?
    TymofeievEventualResult dq ?

    TymofeievTemporaryAState dq ?
    TymofeievRoutineAState dq ?  
	
	TymofeievTemporaryBState dq ?
	TymofeievRoutineBState dq ?

    TymofeievTemporaryDState dq ?
    TymofeievRoutineDState dq ?

    TymofeievTemporaryCState dq ?
    TymofeievRoutineCState dq ?
	
	TymofeievAStr db 20 dup(?)
	TymofeievBStr db 20 dup(?)
	TymofeievCStr db 20 dup(?)
	TymofeievDStr db 20 dup(?)
	TymofeievMediumResultStr db 20 dup(?)


.data

    ControlCalculationsCount dd 1

    ArrayStartPosition dd 0

    Pi dq 3.14159265358979323846
    TwoPi dq 6.28318530717958647692

    TymofeievArrayForAValues dq 20.4, 22.8, 44.4, 13.8, 198.8, TwoPi
    TymofeievArrayForBValues dq 0.5, 3.2, 7.2, -5.2, 49.7, TwoPi
    TymofeievArrayForCValues dq -5.9, -7.8, -3.4, -7.4, 48.4, -36.7
    TymofeievArrayForDValues dq -1.7, -4.5, 5.7, 10.7, 0.3, 0.9

    TymofeievFatalIOperationCaption db "Oops :( Fatal operation error", 0
    TymofeievFatalIOperationBody db "Fatal math operation: the denominator cannot be zero :(", 0

    TymofeievValidLabCaption db "Laboratory Work 6 made by Tymofeiev Danyil from IM-22", 0

    TymofeivVariantMessgBoxInfo db "Control calculation %d/6", 13,
                    "The regular formula is (-2*c - d*82)/tg(a/4 - b)", 13,
					"The digital formula is (-2*%s - %s*82)/tg(%s/4 - %s)", 13,
                    "The digits are: a = %s, b = %s, c = %s, d = %s", 13,
                    "The Eventual Result: %s", 0

    TymofeivVariantInvalidMessgBoxInfo db "Control calculation %d/6", 13,
                    "Fatal math operation: the denominator cannot be zero :(", 0


.code

start:

    mov ArrayStartPosition, 0
    mov ControlCalculationsCount, 1

TymofeievCountTheFormulaLoop:

    mov eax, ArrayStartPosition

    ; Multiply by 8 (since each element in the array occupies 8 bytes)
    mov edx, 8
    mul edx

    ; Loading TymofeievRoutineAState from TymofeievArrayForAValues
    fld qword ptr [TymofeievArrayForAValues + eax]
    fstp TymofeievRoutineAState

    ; Loading TymofeievRoutineBState from TymofeievArrayForBValues
    fld qword ptr [TymofeievArrayForBValues + eax]
    fstp TymofeievRoutineBState

    ; Loading TymofeievRoutineCState from TymofeievArrayForCValues
    fld qword ptr [TymofeievArrayForCValues + eax]
    fstp TymofeievRoutineCState

    ; Loading TymofeievRoutineDState from TymofeievArrayForDValues
    fld qword ptr [TymofeievArrayForDValues + eax]
    fstp TymofeievRoutineDState

    ; Numerator calculation
    fld TymofeievRoutineCState  ; c
    fld TymofeievRoutineDState  ; d
    fdiv  ; c / d
    fstp TymofeievMediumResult  ; Save result c / d

    fld TymofeievRoutineAState
    fmul dword ptr [Three]  ; 3 * a
    fstp TymofeievTemporaryAState

    fld TymofeievRoutineBState
    fmul dword ptr [EightyTwo]  ; 82 * b
    fstp TymofeievTemporaryBState

    fld TymofeievTemporaryAState
    fsub TymofeievTemporaryBState
    fstp TymofeievMediumResult  ; Save result 3 * a - 82 * b

    fld TymofeievRoutineAState
    fdiv dword ptr [Four]  ; a / 4
    fstp TymofeievTemporaryAState

    fld TymofeievRoutineBState
    fstp TymofeievTemporaryBState

    fld TymofeievTemporaryAState
    fsin
    fstp TymofeievTemporaryAState  ; sin(a / 4)

    fld TymofeievTemporaryBState
    fcos
    fstp TymofeievTemporaryBState  ; cos(b)

    fdiv  ; sin(a / 4) / cos(b)
    fstp TymofeievTemporaryAState

    fld TymofeievTemporaryAState  ; Store the result in TymofeievMediumResult
    fstp TymofeievMediumResult

    ; Конвертировать числа с плавающей точкой в строки
    invoke FloatToStr, TymofeievRoutineAState, addr TymofeievAStr
	invoke FloatToStr, TymofeievRoutineBState, addr TymofeievBStr
    invoke FloatToStr, TymofeievRoutineCState, addr TymofeievCStr
    invoke FloatToStr, TymofeievRoutineDState, addr TymofeievDStr
    invoke FloatToStr, TymofeievMediumResult, addr TymofeievMediumResultStr

    ; Output medium result
    invoke wsprintf, offset TymofeievSummaryBuffer, offset TymofeivVariantMessgBoxInfo,
        ControlCalculationsCount, addr TymofeievAStr, addr TymofeievBStr, addr TymofeievCStr, addr TymofeievDStr,
        addr TymofeievMediumResultStr
    invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievValidLabCaption, MB_OK

    ; Increment counters
    inc ArrayStartPosition
    inc ControlCalculationsCount

    ; Check if we've done 5 calculations
    cmp ControlCalculationsCount, 7
    jl TymofeievCountTheFormulaLoop

    ; Exit
    jmp TymofeievEscapeLoop

TymofeievOutputInvalidMSGBoxLoop:
    ; Handle division by zero error
    invoke MessageBox, NULL, offset TymofeievFatalIOperationBody, offset TymofeievFatalIOperationCaption, MB_OK

TymofeievEscapeLoop:
    ; Exit
    invoke ExitProcess, 0

Three dd 3.0
EightyTwo dd 82.0
Four dq 4.0

end start