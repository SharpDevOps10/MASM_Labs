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
    
	TymofeievTemporaryDState dq ?
	TymofeievRoutineDState dq ?
    
	TymofeievTemporaryCState dq ?
	TymofeievRoutineCState dq ?
	
	TymofeievTanDominatorRes dt ?
	TymofeievNumeratorRes dt ?
	
	TymofeievARoutineString db 32 dup (?)
    TymofeievBRoutineString db 32 dup (?)
    TymofeievCRoutineString db 32 dup (?)
    TymofeievDRoutineString db 32 dup (?)
	
	TymofeievEventualResultBuffer dq ?
	
	TymofeievEventualResultBufferStr db 256 dup(?)
	

.data 

    ControlCalculationsCount dd 1
    ArrayStartPosition dd 0
    
    Pi dq 3.141592653589793
    TwoPi dq 6.283185307179586
    
    TymofeievArrayForAValues dq 20.4, 22.8, 44.4, 13.8, 198.8
    TymofeievArrayForBValues dq 0.5, 3.2, 7.2, -5.2, 49.7
    TymofeievArrayForCValues dq -5.9, -7.8, -3.4, -7.4, 48.4
    TymofeievArrayForDValues dq -1.7, -4.5, 5.7, 10.7, 0.3

    PiOverTwo dq 1.570796326794897

    TymofeievCheckZero dq 0.0
    TymofeievNominatorTwo dq 2.0
    TymofeievForTanFour dq 4.0
    TymofeievEightyTwo dq 82.0


    TymofeievValidLabCaption db "Laboratory Work 6 made by Tymofeiev Danyil from IM-22", 0
    
	TymofeievFatalIOperationCaption db "Oops :( Fatal operation error", 0
	TymofeievFatalIOperationBody db "Fatal math opeartion: the denominator cannot be zero :(", 0
	
                                
    TymofeivUndefinedTanErrorMsg db "Tangent is undefined!", 0

    TymofeivVariantMessgBoxInfo db "Control calculation %d/5", 13,
                    "The regular formula is (-2 * c - d * 82) / tg(a / 4 - b)", 13,
                	"The digits are: a = %s, b = %s, c = %s, d = %s", 13,
                	"The digital formula is (-2 * %s - %s * 82) / tg(%s / 4 - %s)", 13,     
                	"The Eventual Result: %s", 0
					
					
	TymofeivVariantInvalidMessgBoxInfo db "Control calculation %d/5", 13,
                    "The regular formula is (-2 * c - d * 82) / tg(a / 4 - b)", 13,
                     "The digits are: a = %s, b = %s, c = %s, d = %s", 13,
                     "The digital formula is (-2 * %s - %s * 82) / tg(%s / 4 - %s)", 13,     
                     "Fatal math opeartion: the denominator cannot be zero :(", 0
					 
.code 

TymofeievOutputNormalMSGBoxLoop PROC uses ebx edi

    ; Update variables for display
    invoke FloatToStr, [TymofeievArrayForAValues + edi * 8], offset TymofeievARoutineString
    invoke FloatToStr, [TymofeievArrayForBValues + edi * 8], offset TymofeievBRoutineString
    invoke FloatToStr, [TymofeievArrayForCValues + edi * 8], offset TymofeievCRoutineString
    invoke FloatToStr, [TymofeievArrayForDValues + edi * 8], offset TymofeievDRoutineString

    invoke FloatToStr2, TymofeievEventualResultBuffer, offset TymofeievEventualResultBufferStr
    
    invoke wsprintf, offset TymofeievSummaryBuffer, offset TymofeivVariantMessgBoxInfo, 
       ebx,  
       offset TymofeievARoutineString, offset TymofeievBRoutineString, offset TymofeievCRoutineString, offset TymofeievDRoutineString,
       offset TymofeievCRoutineString, offset TymofeievDRoutineString, offset TymofeievARoutineString, offset TymofeievBRoutineString,
       offset TymofeievEventualResultBufferStr

    invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievValidLabCaption, MB_OK
    
    ret

TymofeievOutputNormalMSGBoxLoop ENDP

TymofeievTangentProcedure PROC 
    ; Prologue of the procedure
    push ebp
    mov ebp, esp
    sub esp, 8     ; Reserving space for local variables
    
     ; Loading argument into) and calculating tangent
	; Load the argument into the register
    fptan          ; Calculate the tangent

    
    ; Stack correction and procedure completion
  
    mov esp, ebp    ; Recovering the stack pointer
    pop ebp         ; Recovering the base stack pointer
    ret             ; Taking back control
TymofeievTangentProcedure ENDP

TymofeievHandleErrorMessage PROC uses ebx edi

    ; Formatting an Error Message
    invoke wsprintf, offset TymofeievSummaryBuffer, offset TymofeivVariantInvalidMessgBoxInfo,
       ebx,
       offset TymofeievARoutineString, offset TymofeievBRoutineString, offset TymofeievCRoutineString, offset TymofeievDRoutineString,
       offset TymofeievCRoutineString, offset TymofeievDRoutineString, offset TymofeievARoutineString, offset TymofeievBRoutineString
    
    ; Error message output
    invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievFatalIOperationCaption, MB_OK
   
    inc edi

TymofeievHandleErrorMessage ENDP

start:

    mov edi, 0
    mov ebx, 1

TymofeievCountTheFormulaLoop:

    cmp edi, 5
    je TymofeievEscapeLoop
    
    FINIT

    ; Compute tg(a / 4 - b)
    FLD [TymofeievArrayForAValues + edi * 8]
    FDIV TymofeievForTanFour
    FSUB [TymofeievArrayForBValues + edi * 8]
    FPTAN ; Calculate tangent
    FSTP st(0) ; Discard the tangent result, we need only the division result
    FSTP TymofeievTanDominatorRes


    ; Check if the dominator with tg is undefined
    FLD TymofeievTanDominatorRes
    FCOMP TymofeievCheckZero
    FSTSW ax
    SAHF
    JE TymofeievOutputInvalidMSGBoxLoop

    ; Compute numerator (-2 * c - d * 82)
    FLD [TymofeievArrayForCValues + edi * 8]
    FMUL TymofeievNominatorTwo
    FCHS ; Multiply by -2
    FLD [TymofeievArrayForDValues + edi * 8]
    FMUL TymofeievEightyTwo
    FSUB
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
    invoke wsprintf, offset TymofeievSummaryBuffer, offset TymofeivVariantInvalidMessgBoxInfo,
       ebx,
       offset TymofeievARoutineString, offset TymofeievBRoutineString, offset TymofeievCRoutineString, offset TymofeievDRoutineString,
       offset TymofeievCRoutineString, offset TymofeievDRoutineString, offset TymofeievARoutineString, offset TymofeievBRoutineString
    
    invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievFatalIOperationCaption, MB_OK
	inc edi
	inc ebx ; Increment window title counter
    jmp TymofeievCountTheFormulaLoop   


TymofeievEscapeLoop:
    invoke ExitProcess, 0 
	
end start