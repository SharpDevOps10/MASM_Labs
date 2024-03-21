.686

.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

include \masm32\include\dialogs.inc

.data? 

    TymofeivSecretKeeperBuffer db 512 dup (?)
	
	TymofeievDecryptedPassword db 512 dup (?)
	
.data
	
	; This is my XOR SECRET CODE
    TymofeievPersonalSecredCode db "$%&+?':&U", 0
	
    TymofeievPrivateInfo db "Full Name: Tymofeiev Danyil Kostyantinovych",13, \
                 "The Date of The Birth: 10.04.2005",13, \
                 "The Gradebook Number: 8828",0
				 
	TymofeievHurrayValidCaption db "Hurray :) You have entered the valid secret code", 0
	
    TymofeievOopsWrongCaption db "Oops :( Something went wrong", 0
	
    TymofeievFailedValidationText db "You have entered the wrong secret code. Pls, try again", 0
	
	; The Key for XOR
	TymofeievPrivateXORKey db "FIGHTEST1899"

.code
start:

    invoke GetModuleHandle, NULL
    call TymofeievDisplayMainDialog
    invoke ExitProcess, 0

; The procedure for encrypting a SECRET code 
TymofeievEncryptPassword proc uses esi edi ebx ecx
    mov esi, offset TymofeievPrivateXORKey
    mov edi, offset TymofeivSecretKeeperBuffer
    mov ebx, offset TymofeievDecryptedPassword
    xor ecx, ecx
    @@XORLoop:
        mov al, [edi + ecx]
        xor al, [esi + ecx]
        mov [ebx + ecx], al ; save the decrypted symbol in a new buffer
        inc ecx
        cmp byte ptr [edi + ecx], 0
        jnz @@XORLoop
    ret
TymofeievEncryptPassword endp

TymofeievHandleDialogProcedure proc TymofeievDialogWDescriptor:HWND, TymofeievDialogMessageType:UINT, TymofeievMessage:WPARAM, TymofeievAdditionalMessage:LPARAM
    .if TymofeievDialogMessageType == WM_COMMAND
        mov eax, TymofeievMessage
        .if eax == IDOK
            mov edx, 512
            invoke GetDlgItemText, TymofeievDialogWDescriptor, 102, addr TymofeivSecretKeeperBuffer, edx
            
            ; Call the procedure to encrypt the password
            call TymofeievEncryptPassword

            ; Extra cycle for encryption
            mov esi, offset TymofeievDecryptedPassword
            xor ecx, ecx
            @@ExtraEncLoop:
                mov al, [esi + ecx]
                add ecx, 2
                cmp byte ptr [esi + ecx], 0
                jnz @@ExtraEncLoop

            ; Compare the changed password with the encrypted password TymofeievPersonalSecredCode
            invoke lstrcmp, offset TymofeievDecryptedPassword, offset TymofeievPersonalSecredCode

            .if eax == 0
                ; If the passwords match, we display a message about the correct password
                invoke MessageBox, TymofeievDialogWDescriptor, offset TymofeievPrivateInfo, offset TymofeievHurrayValidCaption, MB_OK
                invoke ExitProcess, 0
            .else
                ; If the passwords do not match, we display an incorrect password message
                invoke MessageBox, TymofeievDialogWDescriptor, offset TymofeievFailedValidationText, offset TymofeievOopsWrongCaption, MB_OK or MB_ICONERROR
                invoke ExitProcess, 0
            .endif
        .elseif eax == 2
            jmp quit_dialog
        .endif
    .elseif TymofeievDialogMessageType == WM_CLOSE
        quit_dialog:
        invoke EndDialog, TymofeievDialogWDescriptor, 0
    .endif
    xor eax, eax
    ret
TymofeievHandleDialogProcedure endp

TymofeievCompareStrings proc
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

TymofeievCompareStrings endp

TymofeievDisplayMainDialog proc
	; The Creation of Dialog with title fonts and coordinates
    Dialog "Laboratory Work 3 made by Tymofeiev Danyil from IM-22 (With XOR)", "Tahoma", 14, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, \
        50, 50, 276, 100, \
        1024

	; The main text of Dialog
    DlgStatic "Enter your secret code here", SS_CENTER, 80,  12, 100,  10, 228
	; The editor with secret input
    DlgEdit   WS_BORDER, 20, 25, 230, 15, 102
	
	; The button to confirm your super super secret code
    DlgButton "Validate", WS_TABSTOP, 20, 52, 50, 13, IDOK
	; The button to exit from the programme
    DlgButton "Cancel", WS_TABSTOP, 200, 52, 50, 13, IDCANCEL

    CallModalDialog 0, 0, TymofeievHandleDialogProcedure, NULL
    ret

TymofeievDisplayMainDialog endp

end start