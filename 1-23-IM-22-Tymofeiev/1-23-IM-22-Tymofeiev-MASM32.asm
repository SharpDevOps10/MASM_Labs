.486
.model flat, stdcall

extern MessageBoxA@16:near

includelib \masm32\lib\user32.lib

data segment
	TymofeievHead db "Лабораторна робота 1 MASM32",0
    TymofeievInfo db "ПІБ: Тимофеєв Даниіл Костянтинович",13,
					 "Дата народження: 10.04.2005",13,
				     "Номер залікової книжки: 8828",0
							 
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