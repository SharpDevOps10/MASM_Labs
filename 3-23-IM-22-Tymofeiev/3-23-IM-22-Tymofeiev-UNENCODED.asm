.686

.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

include \masm32\include\dialogs.inc

.data? 

    TymofeivSecretKeeperBuffer db 512 dup (?)
	
.data
	
	; This is my SECRET CODE. Use it to get private info
    TymofeievPersonalSecredCode db "blackbird", 0
	
    TymofeievPrivateInfo db "Full Name: Tymofeiev Danyil Kostyantinovych",13, \
                 "The Date of The Birth: 10.04.2005",13, \
                 "The Gradebook Number: 8828",0
				 
	TymofeievHurrayValidCaption db "Hurray :) You have entered the valid secret code", 0
	
    TymofeievOopsWrongCaption db "Oops :( Something went wrong", 0
	
    TymofeievFailedValidationText db "You have entered the wrong secret code. Pls, try again", 0

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
            
            ; lstrcmp for comparing strings
            invoke lstrcmp, addr TymofeivSecretKeeperBuffer, addr TymofeievPersonalSecredCode

            .if eax == 0
                ; Check that the lines are identical using cmp
                call TymofeievCompareStrings
                ; If the block is here => the secret code is valid
                jmp @@FoundValidSecretCode
            .endif
            ; If the block is here => the strings are not the same
            jmp @@NotFoundValidSecretCode

            @@FoundValidSecretCode:
                ; Correct Password
                invoke MessageBox, TymofeievDialogWDescriptor, addr TymofeievPrivateInfo, addr TymofeievHurrayValidCaption, MB_OK
                invoke ExitProcess, 0

            @@NotFoundValidSecretCode:
                ; Incorrect Password
                invoke MessageBox, TymofeievDialogWDescriptor, addr TymofeievFailedValidationText, addr TymofeievOopsWrongCaption, MB_OK or MB_ICONERROR
                invoke ExitProcess, 0
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
    Dialog "Laboratory Work 3 made by Tymofeiev Danyil from IM-22 (Without XOR)", "Tahoma", 14, \
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