.486
.model flat, stdcall

extern MessageBoxA@16:near

includelib \masm32\lib\user32.lib

data segment
	TymofeievHead db "����������� ������ 1 MASM32",0
    TymofeievInfo db "ϲ�: ������� ����� �������������",13,
					 "���� ����������: 10.04.2005",13,
				     "����� ������� ������: 8828",0
							 
data ends
text segment
start: 
	push 0
    push offset TymofeievHead 
    push offset TymofeievInfo 
	push 0
    call MessageBoxA@16
    
    ret
text ends
end start