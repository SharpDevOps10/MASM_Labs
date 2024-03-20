.686
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc
include \masm32\include\dialogs.inc

.data? 
    Buffer db 512 dup(?)
.data
    Password db "PinkFloyd", 0
	
    PrivateInfo db "Full Name: D K E",13, \
                 "The Date of The Birth: 10.04.2005",13, \
                 "The Gradebook Number: 8828",0
	HurrayCaption db "Hurray :) You have entered the valid password", 0
    OopsCaption db "Oops :( Something went wrong", 0
    ErrorText db "You have entered the wrong password. Pls, try again", 0

.code
start:
    invoke GetModuleHandle, NULL
    call main
    invoke ExitProcess, 0

dlgproc proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .if uMsg == WM_COMMAND
        mov eax, wParam
        .if eax == IDOK
            mov edx, 512
            invoke GetDlgItemText, hWin, 102, addr Buffer, edx
            invoke lstrcmp, addr Buffer, addr Password
            .if eax == 0
                ; Correct Password
                invoke MessageBox, hWin, addr PrivateInfo, addr HurrayCaption, MB_OK
				invoke ExitProcess, 0
            .else
                ; Incorrect Password
                invoke MessageBox, hWin, addr ErrorText, addr OopsCaption, MB_OK or MB_ICONERROR
                invoke ExitProcess, 0
            .endif
        .elseif eax == 2
            jmp quit_dialog
        .endif
    .elseif uMsg == WM_CLOSE
        quit_dialog:
        invoke EndDialog, hWin, 0
    .endif

    xor eax, eax
    ret
dlgproc endp

main proc
    Dialog "Enter Password", "Tahoma", 14, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, \
        50, 50, 276, 100, \
        1024

    DlgStatic "Please enter the password:", SS_CENTER, 85,  12, 100,  10, 228
    DlgEdit   WS_BORDER, 20, 25, 230, 15, 102
    DlgButton "Submit", WS_TABSTOP, 20, 52, 50, 13, IDOK
    DlgButton "Cancel", WS_TABSTOP, 200, 52, 50, 13, IDCANCEL

    CallModalDialog 0, 0, dlgproc, NULL
    ret

main endp
end start