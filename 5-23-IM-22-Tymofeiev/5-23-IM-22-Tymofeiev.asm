.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

.data
aArray DWORD 1, 2, 3, 4, 5   ; массив значений переменной a
bArray DWORD 2, 3, 4, 5, 6   ; массив значений переменной b
cArray DWORD 3, 4, 5, 6, 7   ; массив значений переменной c
resultString db 128 dup(?)   ; буфер для строки результата
className db "MyClass", 0    ; имя класса окна
AppName db "MyApp", 0         ; имя приложения

.data?
hInstance HINSTANCE ?
hWnd HWND ?
msg MSG

.code
start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    invoke WinMain, hInstance, NULL, NULL, SW_SHOWDEFAULT

    invoke ExitProcess, 0

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
    LOCAL wc:WNDCLASSEX

    mov wc.cbSize, SIZEOF WNDCLASSEX
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, OFFSET WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    push hInst
    pop wc.hInstance
    mov wc.hbrBackground, COLOR_WINDOW+1
    mov wc.lpszMenuName, NULL
    mov wc.lpszClassName, OFFSET className
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    mov wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax
    invoke RegisterClassEx, addr wc

    invoke CreateWindowEx, NULL, ADDR className, ADDR AppName, WS_OVERLAPPEDWINDOW, \
           CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInst, NULL
    mov hWnd, eax
    invoke ShowWindow, hWnd, SW_SHOWNORMAL
    invoke UpdateWindow, hWnd

    mov esi, 0  ; начинаем с первого элемента массива
    mov ecx, 5  ; общее количество итераций

calc_loop:
    ; Вычисление выражения
    mov eax, DWORD PTR [aArray + esi * 4]     ; загружаем значение a
    mov ebx, DWORD PTR [bArray + esi * 4]     ; загружаем значение b
    mov edx, DWORD PTR [cArray + esi * 4]     ; загружаем значение c

    imul eax, 3  ; вычисляем 3*a
    shr eax, 1   ; делим на 2
    add eax, ebx ; прибавляем к результату b
    idiv edx     ; делим на c

    push eax     ; сохраняем результат

    ; Проверка четности результата
    test eax, 1  ; проверяем младший бит
    jz even_result  ; если четное, переходим к обработке четного результата

odd_result:
    pop eax      ; возвращаем результат обратно
    imul eax, 5  ; умножаем на 5
    jmp print_result

even_result:
    pop eax      ; возвращаем результат обратно
    shr eax, 1   ; делим на 2

print_result:
    ; Печать результата в окне сообщения
    mov edx, OFFSET resultString
    invoke wsprintf, edx, OFFSET resultString, eax
    invoke MessageBox, hWnd, edx, ADDR resultString, MB_OKCANCEL
    cmp eax, IDOK  ; проверяем, что пользователь нажал "ОК"
    je continue_loop

exit:
    invoke ExitProcess, 0
    ret

continue_loop:
    inc esi          ; переходим к следующему набору данных
    loop calc_loop   ; продолжаем цикл, если есть еще наборы данных

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .if uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
    .elseif uMsg == WM_CLOSE
        invoke DestroyWindow, hWnd
    .else
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    .endif
    ret
WndProc endp

end start