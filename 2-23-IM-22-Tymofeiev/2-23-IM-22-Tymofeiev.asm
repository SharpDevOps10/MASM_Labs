.486 
.model flat, stdcall

option casemap: none 

include \masm32\include\masm32rt.inc

.data 

	TymofeievMessageBoxHead db "Laboratory Work 2 made by Tymofeiev Danyil from IM-22", 0
	
	; A=10 B=1004 C=10042005 N=8828 D=0.001 E=0.114 F=1137.518
	TymofeievDateOfBirthInfo db "10042005", 0
	
	; <---> These are numbers of the day (A and -A) in Byte 
	TymofeievDayPositiveByteA db 10
	TymofeievDayNegativeByteA db -10

	; <---> These are numbers of the day (A and -A) in Word
	TymofeievDayPositiveWordA dw 10
	TymofeievDayNegativeWordA dw -10
	
	; These are numbers of the day and the month (B and -B) in Word
	TymofeievDayMonthPositiveWordB dw 1004
	TymofeievDayMonthNegativeWordB dw -1004
	
	; <---> These are numbers of the day (A and -A) in ShortInt
	TymofeievDayPositiveShortIntA dd 10
	TymofeievDayNegativeShortIntA dd -10
	
	; These are numbers of the day and the month (B and -B) in ShortInt
	TymofeievDayMonthPositiveShortIntB dd 1004
	TymofeievDayMonthNegativeShortIntB dd -1004
	
	; These are numbers of the day, month, and year (C and -C) in ShortInt
	TymofeievDayMonthYearPositiveShortIntC dd 10042005
	TymofeievDayMonthYearNegativeShortIntC dd -10042005
	
	; <---> These are numbers of the day (A and -A) in LongInt
	TymofeievDayPositiveLongIntA dq 10
	TymofeievDayNegativeLongIntA dq -10
	
	; These are numbers of the day and the month (B and -B) in LongInt
	TymofeievDayMonthPositiveLongIntB dq 1004
	TymofeievDayMonthNegativeLongIntB dq -1004
	
	; These are numbers of the day, month, and year (C and -C) in LongInt
	TymofeievDayMonthYearPositiveLongIntC dq 10042005
	TymofeievDayMonthYearNegativeLongIntC dq -10042005
	
	; <---> These are numbers of the day divided by gradebook (D and -D) in Single (float)
	TymofeievDayDividedByGradebookPositiveSingleD dd 0.001
	TymofeievDayDividedByGradebookNegativeSingleD dd -0.001
	
	; <---> These are numbers of the day divided by gradebook (D and -D) in Double (double)
	TymofeievDayDividedByGradebookPositiveDoubleD dq 0.001
	TymofeievDayDividedByGradebookNegativeDoubleD dq -0.001
	
	; These are numbers of the day and month divided by gradebook (E and -E) in Double (double)
	TymofeievDayMonthDividedByGradebookPositiveDoubleE dq 0.114
	TymofeievDayMonthDividedByGradebookNegativeDoubleE dq -0.114
	
	; These are numbers of the day, month, and year divided by gradebook (F and -F) in Double (double)
	TymofeievDayMonthYearDividedByGradebookPositiveDoubleF dt 1137.518
	TymofeievDayMonthYearDividedByGradebookNegativeDoubleF dt -1137.518
	
	; <---> These are numbers of the day, month, and year divided by gradebook (F and -F) in Extended (long double)
	TymofeievDayMonthYearDividedByGradebookPositiveExtendedF dt 1137.518
	TymofeievDayMonthYearDividedByGradebookNegativeExtendedF dt -1137.518
	
	; <---> Information Layouts (templates for formatting output messages)
	TymofeievInfoLayoutDateOfBirth db "The Date of Birth (ddmmyyyy) is: %s", 10, 10, 0
	
	TymofeievInfoLayoutDayA db "Numbers A and -A (the day of birth; dd): ", 10, "A = %d", 10, "-A = %d", 10, 10, 0
	TymofeievInfoLayoutDayMonthB db "Numbers B and -B (the day and month of the birth; ddmm): ", 10, "B = %d", 10, "-B = %d", 10, 10, 0
	TymofeievInfoLayoutDayMonthYearC db "Numbers C and -C (the day, month, and year of the birth; ddmmyyyy): ", 10, "C = %d", 10, "-C = %d", 10, 10, 0
	
	TymofeievInfoLayoutDayDividedByGradebookD db "Numbers D and -D (the day of birth divided by the gradebook; A/N): ", 10, "D = %s", 10, "-D = %s", 10, 10, 0
	TymofeievInfoLayoutDayMonthDividedByGradebookE db "Numbers E and -E (the day and the month of birth divided by the gradebook; B/N): ", 10, "E = %s", 10, "-E = %s", 10, 10, 0
	TymofeievInfoLayoutDayMonthYearDividedByGradebookF db "Numbers F and -F (the full date of birth divided by the gradebook; C/N): ", 10, "F = %s", 10, "-F = %s", 10, 10, 0

; The section is for reserving space for buffers that will be filled with data during the program's execution
.data?

	TymofeievBufferDateOfBirth db 128 dup (?)
	
	TymofeievBufferDayA db 64 dup (?)
	TymofeievBufferDayMonthB db 64 dup (?)
	TymofeievBufferDayMonthYearC db 64 dup (?)
	
	TymofeievBufferDayDividedByGradebookD db 64 dup (?)
	TymofeievBufferDayMonthDividedByGradebookE db 64 dup (?)
	TymofeievBufferDayMonthYearDividedByGradebookF db 64 dup (?)
	
	TymofeievBufferDayDividedByGradebookPositiveD db 32 dup (?)
	TymofeievBufferDayDividedByGradebookNegativeD db 32 dup (?)
	
	TymofeievBufferDayMonthDividedByGradebookPositiveE db 64 dup (?)
	TymofeievBufferDayMonthDividedByGradebookNegativeE db 64 dup (?)
	
	TymofeievBufferDayMonthYearDividedByGradebookPositiveF db 128 dup (?)
	TymofeievBufferDayMonthYearDividedByGradebookNegativeF db 128 dup (?)
	
	TymofeievMessageBuffer db 1024
	
.code