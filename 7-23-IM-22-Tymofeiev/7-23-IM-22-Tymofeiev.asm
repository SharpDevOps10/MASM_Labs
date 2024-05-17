.686
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc
include \masm32\include\dialogs.inc

public TymofeievPublicArrayAState, TymofeievPublicArrayBState, TymofeievForTanFour, TymofeievTanArgument, TymofeievTanDominatorRes, TymofeievCheckZero, PiOverTwo, PiOverTwoMinus,  ThreePiOverTwo, ThreePiOverTwoMinus
extern TymofeievCalcDominatorWithTan: PROTO

.data? 

	TymofeievSummaryBuffer db 256 dup (?)
	TymofeievSummaryBufferForTempValues db 256 dup (?)
    
	TymofeievEventualResult dq ?
    
	TymofeievTemporaryAState dq ?
	TymofeievRoutineAState dq ?
    
	TymofeievTemporaryDState dq ?
	TymofeievRoutineDState dq ?
    
	TymofeievTemporaryCState dq ?
	TymofeievRoutineCState dq ?
    
	TymofeievTanDominatorRes dt ?
	TymofeievNumeratorRes dt ?
	TymofeievTanArgument dt ?
  
	TymofeievARoutineString db 32 dup (?)
    TymofeievBRoutineString db 32 dup (?)
    TymofeievCRoutineString db 32 dup (?)
    TymofeievDRoutineString db 32 dup (?)
  
	TymofeievEventualResultBuffer dq ?
  
	TymofeievPublicArrayAState dq 1 dup (?)
	TymofeievPublicArrayBState dq 1 dup (?)
  
	TymofeievEventualResultBufferStr db 256 dup(?)
  

.data 

    ControlCalculationsCount dd 1
    ArrayStartPosition dd 0
    
    Pi dq 3.1415926536
    TwoPi dq 6.2831853072
    
    TymofeievArrayForAValues dq 20.4, 22.8, 44.4, 13.8, 198.8, 6.2831853072, 6.2831853072
    TymofeievArrayForBValues dq 0.5, 3.2, 7.2, -5.2, 49.7, 3.1415926536, -3.1415926536
    TymofeievArrayForCValues dq -5.9, -7.8, -3.4, -7.4, 48.4, -36.7, -48.9
    TymofeievArrayForDValues dq -1.7, -4.5, 5.7, 10.7, 0.3, 0.9, 1.5

    PiOverTwo dq 1.5707963268
	PiOverTwoMinus dq -1.5707963268
  
	ThreePiOverTwo dq 4.7123889804
	ThreePiOverTwoMinus dq -4.7123889804

    TymofeievCheckZero dq 0.0
    TymofeievNominatorTwo dq 2.0
    TymofeievForTanFour dq 4.0
    TymofeievEightyTwo dq 82.0


    TymofeievValidLabCaption db "Laboratory Work 7 made by Tymofeiev Danyil from IM-22", 0
    
	TymofeievFatalIOperationCaption db "Oops :( Fatal operation error", 0
	TymofeievFatalIOperationBody db "Fatal math opeartion: the denominator cannot be zero :(", 0
  
	TymofeievFatalITanArgCaption db "Oops :( Fatal tangent argument", 0
  
                                
    TymofeivUndefinedTanErrorMsg db "Tangent is undefined!", 0

    TymofeivVariantMessgBoxInfo db "Control calculation %d/7", 13,
                    "The regular formula is (-2 * c - d * 82) / tg(a / 4 - b)", 13,
                  "The digits are: a = %s, b = %s, c = %s, d = %s", 13,
                  "The digital formula is (-2 * %s - %s * 82) / tg(%s / 4 - %s)", 13,     
                  "The Eventual Result: %s", 0
          
          
	TymofeivVariantInvalidMessgBoxInfo db "Control calculation %d/7", 13,
                    "The regular formula is (-2 * c - d * 82) / tg(a / 4 - b)", 13,
                     "The digits are: a = %s, b = %s, c = %s, d = %s", 13,
                     "The digital formula is (-2 * %s - %s * 82) / tg(%s / 4 - %s)", 13,     
                     "Fatal math opeartion: the denominator cannot be zero :(", 0
           
	TymofeivVariantUndefinedTanMessgBoxInfo db "Control calculation %d/7", 13,
                    "The regular formula is (-2 * c - d * 82) / tg(a / 4 - b)", 13,
                     "The digits are: a = %s, b = %s, c = %s, d = %s", 13,
                     "The digital formula is (-2 * %s - %s * 82) / tg(%s / 4 - %s)", 13,     
                     "Fatal tg opeartion: tangent is not defined in Pi/2 + Pi*k", 0
           
  ERROR_ZERO_DENOMINATOR equ 1
  ERROR_UNDEFINED_TAN equ 2
           
.code 

; Procedure to compute (-2 * c)
TymofeievComputeMinusTwoCReg PROC uses ebx eax

    ; Load c into FPU stack
    FLD qword ptr [eax]
    FMUL TymofeievNominatorTwo ; Multiply by -2
    FCHS                        ; Change sign
    FSTP qword ptr [eax]        ; Store the result back to edx

    ret

TymofeievComputeMinusTwoCReg ENDP

; Procedure to compute (d * 82)
TymofeievComputeEightyTwoDReg PROC uses ebx edx


    PUSH edx           
    PUSH ebx 
    
    ; Load d into FPU stack
    mov edx, [esp + 8]      
    FLD qword ptr [edx]
    FMUL TymofeievEightyTwo 
    FSTP qword ptr [edx]
    
    POP ebx                 
    POP edx    
    ret                      
TymofeievComputeEightyTwoDReg ENDP

TymofeievOutputNormalMSGBoxLoop PROC uses ebx edi

    invoke FloatToStr2, TymofeievEventualResultBuffer, offset TymofeievEventualResultBufferStr
    
    invoke wsprintf, offset TymofeievSummaryBuffer, offset TymofeivVariantMessgBoxInfo, 
       ebx,  
       offset TymofeievARoutineString, offset TymofeievBRoutineString, offset TymofeievCRoutineString, offset TymofeievDRoutineString,
       offset TymofeievCRoutineString, offset TymofeievDRoutineString, offset TymofeievARoutineString, offset TymofeievBRoutineString,
       offset TymofeievEventualResultBufferStr

    invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievValidLabCaption, MB_OK
    
    ret

TymofeievOutputNormalMSGBoxLoop ENDP

start:

    mov edi, 0
    mov ebx, 1

TymofeievCountTheFormulaLoop:

    cmp edi, 7
    je TymofeievEscapeLoop
    
    FINIT

	FLD [TymofeievArrayForAValues + edi * 8]
    FSTP TymofeievPublicArrayAState
    FLD [TymofeievArrayForBValues + edi * 8]
    FSTP TymofeievPublicArrayBState
  
	call TymofeievCalcDominatorWithTan
   
  
  ; Check if (a / 4 - b) equals undefined value
    cmp ecx, ERROR_UNDEFINED_TAN
    JE TymofeievUndefinedTanArgumentMSGBoxLoop
  

    ; Check if the dominator with tg is 0
    cmp ecx, ERROR_ZERO_DENOMINATOR
    JE TymofeievOutputInvalidMSGBoxLoop
  
  invoke FloatToStr2, [TymofeievArrayForAValues + edi * 8], offset TymofeievARoutineString
		invoke FloatToStr2, [TymofeievArrayForBValues + edi * 8], offset TymofeievBRoutineString
		invoke FloatToStr, [TymofeievArrayForCValues + edi * 8], offset TymofeievCRoutineString
		invoke FloatToStr, [TymofeievArrayForDValues + edi * 8], offset TymofeievDRoutineString

  ; Compute (-2 * c) and (d * 82)
  lea eax, [TymofeievArrayForCValues + edi * 8]
    call TymofeievComputeMinusTwoCReg ; Call procedure to compute (-2 * c)

  lea edx, [TymofeievArrayForDValues + edi * 8]
  push edx  ; Сохраняем edx
  call TymofeievComputeEightyTwoDReg ; Call procedure to compute (d * 82)
  pop edx
  
    ; Add (-2 * c) and (d * 82) to get the numerator  
    FLD qword ptr [eax]       ; Загружаем (-2 * c) в стек FPU
	FSUB qword ptr [edx]  ; Вычитаем (d * 82)
	ADD esp, 8 
    FSTP TymofeievNumeratorRes

    ; Divide numerator with digits by denominator with tg
    FLD TymofeievNumeratorRes
    FLD TymofeievTanDominatorRes
    FDIV
  
  ; SAVE!
    FSTP TymofeievEventualResultBuffer

  call TymofeievOutputNormalMSGBoxLoop

    inc edi ; Increment calculation counter
    inc ebx ; Increment window title counter
    jmp TymofeievCountTheFormulaLoop
  
  
TymofeievOutputInvalidMSGBoxLoop:

    invoke FloatToStr2, [TymofeievArrayForAValues + edi * 8], offset TymofeievARoutineString
    invoke FloatToStr2, [TymofeievArrayForBValues + edi * 8], offset TymofeievBRoutineString
    invoke FloatToStr, [TymofeievArrayForCValues + edi * 8], offset TymofeievCRoutineString
    invoke FloatToStr, [TymofeievArrayForDValues + edi * 8], offset TymofeievDRoutineString
  
    invoke wsprintf, offset TymofeievSummaryBuffer, offset TymofeivVariantInvalidMessgBoxInfo,
       ebx,
       offset TymofeievARoutineString, offset TymofeievBRoutineString, offset TymofeievCRoutineString, offset TymofeievDRoutineString,
       offset TymofeievCRoutineString, offset TymofeievDRoutineString, offset TymofeievARoutineString, offset TymofeievBRoutineString
    
    invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievFatalIOperationCaption, MB_OK
	inc edi
	inc ebx ; Increment window title counter
    jmp TymofeievCountTheFormulaLoop   
  
  
TymofeievUndefinedTanArgumentMSGBoxLoop:

    invoke FloatToStr2, [TymofeievArrayForAValues + edi * 8], offset TymofeievARoutineString
    invoke FloatToStr2, [TymofeievArrayForBValues + edi * 8], offset TymofeievBRoutineString
    invoke FloatToStr, [TymofeievArrayForCValues + edi * 8], offset TymofeievCRoutineString
    invoke FloatToStr, [TymofeievArrayForDValues + edi * 8], offset TymofeievDRoutineString
  
    invoke wsprintf, offset TymofeievSummaryBuffer, offset TymofeivVariantUndefinedTanMessgBoxInfo,
       ebx,
       offset TymofeievARoutineString, offset TymofeievBRoutineString, offset TymofeievCRoutineString, offset TymofeievDRoutineString,
       offset TymofeievCRoutineString, offset TymofeievDRoutineString, offset TymofeievARoutineString, offset TymofeievBRoutineString
    
    invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievFatalITanArgCaption, MB_OK
	inc edi
	inc ebx ; Increment window title counter
    jmp TymofeievCountTheFormulaLoop 


TymofeievEscapeLoop:
    invoke ExitProcess, 0 
  
end start