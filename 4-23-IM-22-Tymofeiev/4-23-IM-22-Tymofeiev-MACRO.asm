.686

.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

include \masm32\include\dialogs.inc

include 4-23-IM-22-Tymofeiev.inc

.data? 

    TymofeivSecretKeeperBuffer db 512 dup (?)
	
    TymofeievDecryptedPassword db 512 dup (?)
	
.data
	; This is my XOR SECRET CODE
    TymofeievPersonalSecredCode db "$%&+?':&U", 0

    TymofeievFullName db "Full Name: Tymofeiev Danyil Kostyantinovych", 0
    TymofeievBirthDate db "The Date of The Birth: 10.04.2005", 0
    TymofeievGradebookNumber db "The Gradebook Number: 8828", 0

    TymofeievHurrayValidCaption db "Hurray :) You have entered the valid secret code", 0
    TymofeievOopsWrongCaption db "Oops :( Something went wrong", 0
    TymofeievFailedValidationText db "You have entered the wrong secret code. Pls, try again", 0
	
	; The Key for XOR
    TymofeievPrivateXORKey db "FIGHTEST1", 0

.code
start:
    invoke GetModuleHandle, NULL
    call TymofeievDisplayMainDialog
    invoke ExitProcess, 0

TymofeievHandleDialogProcedure proc TymofeievDialogWDescriptor:HWND, TymofeievDialogMessageType:UINT, TymofeievMessage:WPARAM, TymofeievAdditionalMessage:LPARAM
    .if TymofeievDialogMessageType == WM_COMMAND
        mov eax, TymofeievMessage
        .if eax == IDOK
            mov edx, 512
            invoke GetDlgItemText, TymofeievDialogWDescriptor, 102, addr TymofeivSecretKeeperBuffer, edx
            
            ; Encrypt the password
            TymofeievEncryptPassword
            
            ; Compare the encrypted password with the stored one
            TymofeievComparePasswords offset TymofeievDecryptedPassword, offset TymofeievPersonalSecredCode, @TymofeievpasswordsMatch, @TymofeievpasswordsMismatch

            @TymofeievpasswordsMatch:
                ; If the password is correct, print the messages
                TymofeievPrintMessageBox TymofeievFullName, TymofeievHurrayValidCaption, MB_OK
                TymofeievPrintMessageBox TymofeievBirthDate, TymofeievHurrayValidCaption, MB_OK
                TymofeievPrintMessageBox TymofeievGradebookNumber, TymofeievHurrayValidCaption, MB_OK
                invoke ExitProcess, 0

            @TymofeievpasswordsMismatch:
                ; If the password is incorrect, show error message
                TymofeievPrintMessageBox TymofeievFailedValidationText, TymofeievOopsWrongCaption, MB_OK or MB_ICONERROR
                invoke ExitProcess, 0
        .elseif eax == 2
            jmp @quit_dialog
        .endif
    .elseif TymofeievDialogMessageType == WM_CLOSE
        @quit_dialog:
        invoke EndDialog, TymofeievDialogWDescriptor, 0
    .endif
    xor eax, eax
    ret
TymofeievHandleDialogProcedure endp


TymofeievCompareStringsPROC proc
    mov ecx, offset TymofeievPersonalSecredCode
    mov esi, offset TymofeivSecretKeeperBuffer
    xor ebx, ebx
    @@CompareSStrings:
        mov al, [esi + ebx]
        cmp al, [ecx + ebx]
        jne @@NotFoundValidSecretCode ; Jump to label if characters don't match
        inc ebx
        cmp al, 0
        jne @@CompareSStrings ; Continue comparison if characters match and do not reach end of line
		
    ; If execution has reached this point, then the lines are identical
    ret

    @@NotFoundValidSecretCode: ; Label where it goes if the characters don't match
	
        ; Handling the case when the strings are not identical
    ret

TymofeievCompareStringsPROC endp

TymofeievDisplayMainDialog proc
    ; Create the dialog window
    Dialog "Laboratory Work 4 made by Tymofeiev Danyil from IM-22 (MACRO)", "Tahoma", 14, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, \
        50, 50, 276, 100, \
        1024

    ; Main text of the dialog
    DlgStatic "Enter your secret code here", SS_CENTER, 80,  12, 100,  10, 228
    ; Input field for the secret code
    DlgEdit WS_BORDER, 20, 25, 230, 15, 102
    ; Button to validate the secret code
    DlgButton "Validate", WS_TABSTOP, 20, 52, 50, 13, IDOK
    ; Button to cancel
    DlgButton "Cancel", WS_TABSTOP, 200, 52, 50, 13, IDCANCEL

    ; Call the modal dialog
    CallModalDialog 0, 0, TymofeievHandleDialogProcedure, NULL
    ret
TymofeievDisplayMainDialog endp

end start