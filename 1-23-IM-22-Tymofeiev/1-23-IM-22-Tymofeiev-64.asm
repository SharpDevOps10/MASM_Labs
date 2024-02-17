OPTION DOTNAME
	
option casemap:none
include \masm64\include\temphls.inc
include \masm64\include\win64.inc
include \masm64\include\kernel32.inc
includelib \masm64\lib\kernel32.lib
include \masm64\include\user32.inc
includelib \masm64\lib\user32.lib
OPTION PROLOGUE:rbpFramePrologue
OPTION EPILOGUE:none

.data
TymofeievHead      db 'Лабораторна робота 1 під MASM64',0
TymofeievInfo      db 'ПІБ: Тимофеєв Даниіл Костянтинович',13,
					  'Дата народження: 10.04.2005',13,
				      'Номер залікової книжки: 8828',0
.code
WinMain proc 
	sub rsp,28h
      invoke MessageBox, NULL, &TymofeievInfo, &TymofeievHead, MB_OK
      invoke ExitProcess,NULL
WinMain endp
end