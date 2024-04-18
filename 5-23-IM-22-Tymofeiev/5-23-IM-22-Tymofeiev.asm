.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    resultString db 256 dup(?)
    titleString db "Результат", 0

.data
    DovzhenkoBasicTitle db "Lab 5 by Dovzhenko Anton - Example %d", 0
    DovzhenkoDivByZeroErrorMsg db "Error! You can't divide by 0!", 0
    DovzhenkoResultsWin db "The formula is (c/d + 3*a/2)/(c - a + 1)", 13,
                       "a = %d, c = %d, d = %d", 13,
                       "So the example is (%d/%d + 3*%d/2)/(%d - %d + 1)", 13,
                       "Result before modifying: %d", 13,
                       "Final result: %d", 0
    DovzhenkoFourKm dd 4

.data
    DovzhenkoA dd 4, 10, 3, 7, 4
    DovzhenkoC dd 6, 7, 48, 28, 8
    DovzhenkoD dd 2, 7, 2, 6, 4

.code
start:
    call main            ; Call the main procedure
    invoke ExitProcess, 0  ; Exit the program

main proc
    LOCAL DovzhenkoLpIndx: DWORD
    
    LOCAL DovzhenkoTitle[100]: BYTE
    LOCAL DovzhenkoError[100]: BYTE
    LOCAL DovzhenkoResultStr[256]: BYTE
    
    LOCAL DovzhenkoIntrmdRes: DWORD
    LOCAL DovzhenkoFinalRes: DWORD
    
    LOCAL DovzhenkoPAVal: DWORD, DovzhenkoPCVal: DWORD, DovzhenkoPDVal: DWORD
    LOCAL DovzhenkoNumZm: DWORD, DovzhenkoDenumZN: DWORD

    mov DovzhenkoLpIndx, 0

DovzhenkoCalcLoop:
    mov eax, DovzhenkoLpIndx
    inc eax  ; Increment index
    
    invoke wsprintf, addr DovzhenkoTitle, addr DovzhenkoBasicTitle , eax  ; Format the window title
    invoke wsprintf, addr DovzhenkoError, addr DovzhenkoDivByZeroErrorMsg  ; Format the error message

    mov eax, DovzhenkoLpIndx
    shl eax, 2
    lea ebx, [DovzhenkoA]
    add ebx, eax
    mov ecx, [ebx]
    mov DovzhenkoPAVal, ecx

    lea ebx, [DovzhenkoC]
    add ebx, eax
    mov ecx, [ebx]
    mov DovzhenkoPCVal, ecx

    lea ebx, [DovzhenkoD]
    add ebx, eax
    mov ecx, [ebx]
    mov DovzhenkoPDVal, ecx

    ; Calculating the numerator
    mov eax, DovzhenkoPCVal     ; Load the value of c
    cdq                         ; Extend eax into edx:eax
    idiv DovzhenkoPDVal         ; Divide by d, result in edx:eax
    mov ebx, eax                ; Save the result c/d in ebx

    mov eax, DovzhenkoPAVal     ; Load the value of a
    imul eax, 3                 ; Multiply by 3
    sar eax, 1                  ; Divide by 2 (shift right by 1 bit)

    add eax, ebx                ; Add c/d
    mov DovzhenkoNumZm, eax     ; Save the result in the numerator

    ; Calculating the denominator
    mov eax, DovzhenkoPCVal     ; Load the value of c
    sub eax, DovzhenkoPAVal     ; Subtract a
    add eax, 1                  ; Add 1
    mov DovzhenkoDenumZN, eax   ; Save the result in the denominator

    ; Check for division by zero
    cmp DovzhenkoDenumZN, 0
    je DovzhenkoDivByZeroErr    ; Jump to error handling if the denominator is zero

    ; Perform division of the numerator by the denominator
    mov eax, DovzhenkoNumZm     ; Load the numerator
    cdq                         ; Extend eax into edx:eax
    idiv DovzhenkoDenumZN       ; Divide by the denominator
    mov DovzhenkoFinalRes, eax  ; Save the result

    ; Check if the result is odd or even
    mov eax, DovzhenkoFinalRes  ; Load the final result
    test eax, 1                  ; Check for odd/even
    jz DovzhenkoEvenIntResult   ; If even, skip modification

    imul eax, 5                  ; If odd, multiply by 5

DovzhenkoEvenIntResult:
    ; Calculate the string for the result window
    invoke wsprintf, addr DovzhenkoResultStr, addr DovzhenkoResultsWin, DovzhenkoPAVal, DovzhenkoPCVal, DovzhenkoPDVal, DovzhenkoPCVal, DovzhenkoPDVal, DovzhenkoPAVal, DovzhenkoPCVal, DovzhenkoPAVal, DovzhenkoNumZm, DovzhenkoFinalRes
    
    ; Display the result window
    invoke MessageBox, NULL, addr DovzhenkoResultStr, addr DovzhenkoTitle, MB_OK

    add DovzhenkoLpIndx, 1
    cmp DovzhenkoLpIndx, 5
    
    jl DovzhenkoCalcLoop
    jmp DovzhenkoExitProcessLbl

DovzhenkoDivByZeroErr:
    invoke MessageBox, NULL, addr DovzhenkoError, addr DovzhenkoTitle, MB_ICONERROR or MB_OK
    jmp DovzhenkoExitProcessLbl

DovzhenkoExitProcessLbl:
    invoke ExitProcess, 0
main endp

end start