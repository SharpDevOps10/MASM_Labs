.486 
.model flat, stdcall

option casemap: none 

include \masm32\include\masm32rt.inc

.data 

	TymofeievMessageBoxHead db "Laboratory Work 2 made by Tymofeiev Danyil from IM-22", 0
	
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
	
	
	
	
	
	