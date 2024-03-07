.486 
.model flat, stdcall

option casemap: none 

include \masm32\include\masm32rt.inc

.data 

	TymofeievMessageBoxHead db "Laboratory Work 2 made by Tymofeiev Danyil from IM-22", 0
	; A=10 B=1004 C=10042005 N=8828 D=0.001 E=0.114 F=1137.518
	
	; <---> These are numbers of the day (A and -A) in Byte 
	TymofeievPositiveByteA db 10
	TymofeievNegativeByteA db -10

	; <---> These are numbers of the day (A and -A) in Word
	TymofeievPositiveWordA dw 10
	TymofeievNegativeWordA dw -10
	
	; These are numbers of the day and the month (B and -B) in Word
	TymofeievPositiveWordB dw 1004
	TymofeievNegativeWordB dw -1004
	
	; <---> These are numbers of the day (A and -A) in ShortInt
	TymofeievPositiveShortIntA dd 10
	TymofeievNegativeShortIntA dd -10
	
	; These are numbers of the day and the month (B and -B) in ShortInt
	TymofeievPositiveShortIntB dd 1004
	TymofeievNegativeShortIntB dd -1004
	
	; These are numbers of the day, month, and year (C and -C) in ShortInt
	TymofeievPositiveShortIntC dd 10042005
	TymofeievNegativeShortIntC dd -10042005
	
	; <---> These are numbers of the day (A and -A) in LongInt
	TymofeievPositiveLongIntA dq 10
	TymofeievNegativeLongIntA dq -10
	
	; These are numbers of the day and the month (B and -B) in LongInt
	TymofeievPositiveLongIntB dq 1004
	TymofeievNegativeLongIntB dq -1004
	
	; These are numbers of the day, month, and year (C and -C) in LongInt
	TymofeievPositiveLongIntC dq 10042005
	TymofeievNegativeLongIntC dq -10042005
	
	; <---> These are numbers of the day divided by gradebook (D and -D) in Single (float)
	TymofeievPositiveSingleD dd 0.001
	TymofeievNegativeSingleD dd -0.001
	
	; <---> These are numbers of the day divided by gradebook (D and -D) in Double (double)
	TymofeievPositiveDoubleD dq 0.001
	TymofeievNegativeDoubleD dq -0.001
	
	; These are numbers of the day and month divided by gradebook (E and -E) in Double (double)
	TymofeievPositiveDoubleE dq 0.114
	TymofeievNegativeDoubleE dq -0.114
	
	; These are numbers of the day, month, and year divided by gradebook (F and -F) in Double (double)
	TymofeievPositiveDoubleF dq 1137.518
	TymofeievNegativeDoubleF dq -1137.518
	
	; <---> These are numbers of the day, month, and year divided by gradebook (F and -F) in Extended (long double)
	TymofeievPositiveExtendedF dt 1137.518
	TymofeievNegativeExtendedF dt -1137.518
	
	; <---> Information Layouts (templates for formatting output messages)
	TymofeievInfoLayoutDateOfBirth db "my ddmmyyyy is 10042005", 13, 0
	
	TymofeievInfoLayoutGeneral db "personal info: ", "%s", 13
          db "A and -A (day; dd):", 13, "A = %d", 10, "-A = %d", 13, 13
          db "B and -B (day and month; ddmm):", 13, "B = %d", 10, "-B = %d", 13, 13
          db "C and -C (full birth info; ddmmyyyy):", 13, "C = %d", 10, "-C = %d", 13, 13
          db "D and -D (A/N; N=gradebook):", 13, "D = %s", 10, "-D = %s", 13, 13
          db "E and -E (B/N; N=gradebook):", 13, "E = %s", 10, "-E = %s", 13, 13
          db "F and -F (C/N; N=gradebook):", 13, "F = %s", 10, "-F = %s", 13, 0

; The section is for reserving space for buffers that will be filled with data during the program's execution
.data?
	TymofeievMessageBuffer db 1024 dup (?)
	
	TymofeievBufferPositiveD db 64 dup (?)
	TymofeievBufferNegativeD db 64 dup (?)
	
	TymofeievBufferPositiveE db 64 dup (?)
	TymofeievBufferNegativeE db 64 dup (?)
	
	TymofeievBufferPositiveF db 64 dup (?)
	TymofeievBufferNegativeF db 64 dup (?)
	
.code
start: 
	; <---> FloatToStr
	invoke FloatToStr2, TymofeievPositiveDoubleD, offset TymofeievBufferPositiveD
	invoke FloatToStr2, TymofeievNegativeDoubleD, offset TymofeievBufferNegativeD

	invoke FloatToStr2, TymofeievPositiveDoubleE, offset TymofeievBufferPositiveE
	invoke FloatToStr2, TymofeievNegativeDoubleE, offset TymofeievBufferNegativeE

	invoke FloatToStr2, TymofeievPositiveDoubleF, offset TymofeievBufferPositiveF
	invoke FloatToStr2, TymofeievNegativeDoubleF, offset TymofeievBufferNegativeF

	; <---> wsprintf
	invoke wsprintf, offset TymofeievMessageBuffer, offset TymofeievInfoLayoutGeneral, offset TymofeievInfoLayoutDateOfBirth,
		TymofeievPositiveShortIntA, TymofeievNegativeShortIntA, 
		TymofeievPositiveShortIntB, TymofeievNegativeShortIntB,
		TymofeievPositiveShortIntC, TymofeievNegativeShortIntC,
		offset TymofeievBufferPositiveD, offset TymofeievBufferNegativeD,
		offset TymofeievBufferPositiveE, offset TymofeievBufferNegativeE,
		offset TymofeievBufferPositiveF, offset TymofeievBufferNegativeF
	
	invoke MessageBox, NULL, offset TymofeievMessageBuffer, offset TymofeievMessageBoxHead, 0
	invoke ExitProcess, 0

end start