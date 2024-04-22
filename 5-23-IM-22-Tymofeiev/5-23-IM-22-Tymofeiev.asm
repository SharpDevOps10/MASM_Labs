.686
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc
include \masm32\include\dialogs.inc


.data?

	TymofeievSummaryBuffer db 256 dup (?)
	TymofeievSummaryBufferForTempValues db 256 dup (?)
    
	TymofeievMediumResult dd ?
	TymofeievEventualResult dd ?
    
	TymofeievTemporaryAState dd ?
	TymofeievRoutineAState dd ?
    
	TymofeievTemporaryDState dd ?
	TymofeievRoutineDState dd ?
    
	TymofeievTemporaryCState dd ?
	TymofeievRoutineCState dd ?
    
.data

	ControlCalculationsCount dd 1

	ArrayStartPosition dd 0
    
	TymofeievArrayForAValues dd 4, 10, -2, -25, 38
	TymofeievArrayForCValues dd 6, 7, 24, -27, 37
	TymofeievArrayForDValues dd 2, 7, -1, 6, 43
    
	TymofeievFatalIOperationCaption db "Oops :( Fatal operation error", 0
	TymofeievFatalIOperationBody db "Fatal math opeartion: the denominator cannot be zero :(", 0
    
	TymofeievValidLabCaption db "Laboratory Work 5 made by Tymofeiev Danyil from IM-22", 0
    
	TymofeivVariantMessgBoxInfo db "Control calculation %d/5", 13,
                	"The regular formula is (c/d + 3*a/2)/(c - a + 1)", 13,
                	"The digits are: a = %d, c = %d, d = %d", 13,
                	"The digital formula is (%d/%d + 3*%d/2)/(%d - %d + 1)", 13,
                	"The Medium Result(without div or mul): %d", 13,
                	"The Eventual Result(with div or mul): %d", 0
                	 
	TymofeivVariantInvalidMessgBoxInfo db "Control calculation %d/5", 13,
                	"Fatal math opeartion: the denominator cannot be zero :(", 0
               	 

.code

TymofeievCheckTemporaryStatesEvenOrOdd PROC
	push ebp
	mov ebp, esp
	mov eax, [ebp + 8]

	test eax, 1
	jz EvenNumber
	jmp OddNumber

EvenNumber:
	mov eax, 0
	jmp EndCheck

OddNumber:
	mov eax, 1  
	jmp EndCheck

EndCheck:
	pop ebp
	ret 4
TymofeievCheckTemporaryStatesEvenOrOdd ENDP

start:

	mov ArrayStartPosition, 0
	mov ControlCalculationsCount, 1

TymofeievCountTheFormulaLoop:
    
	mov eax, ArrayStartPosition

    ; Multiply by 4
    mov edx, 4
    mul edx

    ; Loading TymofeievRoutineAState from TymofeievArrayForAValues
    mov ecx, [TymofeievArrayForAValues + eax]
    mov TymofeievRoutineAState, ecx

    ; Loading TymofeievRoutineCState from TymofeievArrayForCValues
    mov ecx, [TymofeievArrayForCValues + eax]
    mov TymofeievRoutineCState, ecx

    ; Loading TymofeievRoutineDState from the TymofeievArrayForDValues array
    mov ecx, [TymofeievArrayForDValues + eax]
    mov TymofeievRoutineDState, ecx

	; Numerator calculation
	mov eax, TymofeievRoutineCState  ; c
	cdq
	mov ebx, TymofeievRoutineDState  ; d
    
    ; Check for division by zero in the denominator (d)
    cmp ebx, 0
    je TymofeievOutputInvalidMSGBoxLoop
    
	idiv ebx  ; c / d
	mov ecx, eax  ; Save result c / d in ecx

	mov eax, TymofeievRoutineAState
	imul eax, 3
	sar eax, 1
	add eax, ecx

	; Denominator calculation
	mov ecx, TymofeievRoutineCState  ; c
	sub ecx, TymofeievRoutineAState  ; c - a
	inc ecx  ; c - a + 1

	; Check for division by zero in the denominator
	cmp ecx, 0
	je TymofeievOutputInvalidMSGBoxLoop

	; Final division
	cdq
	idiv ecx
	mov TymofeievMediumResult, eax

	; even or odd?
	mov eax, TymofeievMediumResult
    ; even or odd?
	test eax, 1
	jz TymofeievCheckPairOfNumbersLoop
    
    ; is odd => *5
	jmp TymofeievCheckOddNumbersLoop

; is odd => *5
TymofeievCheckOddNumbersLoop:  
	imul eax, 5
    
	jmp TymofeievOutputNormalMSGBoxLoop

; is even => /2
TymofeievCheckPairOfNumbersLoop:
    mov ebx, 2
    cdq
    idiv ebx
    jmp TymofeievOutputNormalMSGBoxLoop

TymofeievOutputNormalMSGBoxLoop:
    
	invoke wsprintf, offset TymofeievSummaryBuffer, offset TymofeivVariantMessgBoxInfo,
    	ControlCalculationsCount, TymofeievRoutineAState, TymofeievRoutineCState, TymofeievRoutineDState,
    	TymofeievRoutineCState, TymofeievRoutineDState, TymofeievRoutineAState,
    	TymofeievRoutineCState, TymofeievRoutineAState, TymofeievMediumResult, eax
   	 
	invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievValidLabCaption, MB_OK

	inc ArrayStartPosition
	inc ControlCalculationsCount
	jmp TymofeievLoopCheck
    
TymofeievLoopCheck:
    push ControlCalculationsCount

	; Checking whether the number of calculations has exceeded the limit of 6
	cmp ControlCalculationsCount, 6
	jge TymofeievEscapeLoop  ; If it reaches 6 or more, we exit the cycle

	; In other cases, we continue the calculation cycle
	jmp TymofeievCountTheFormulaLoop
    pop ControlCalculationsCount
    
TymofeievOutputInvalidMSGBoxLoop:
	mov edx, 1

	; Perform the MessageBox operation
	invoke wsprintf,
   	 offset TymofeievSummaryBuffer,
   	 offset TymofeivVariantInvalidMessgBoxInfo,
   	 ControlCalculationsCount
   	 
	invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievFatalIOperationCaption, MB_OK
    
	imul edx, edx, 2
	test edx, edx
	jz TymofeievEscapeLoop

TymofeievEscapeLoop:
	invoke ExitProcess, 0

TymofeievDisplayHandlerInvalidOperationProc proc
	invoke wsprintf, offset TymofeievSummaryBuffer, offset TymofeievFatalIOperationCaption, ControlCalculationsCount
	invoke MessageBox, NULL, offset TymofeievSummaryBuffer, offset TymofeievFatalIOperationCaption, MB_OK
	ret
TymofeievDisplayHandlerInvalidOperationProc endp

end start
