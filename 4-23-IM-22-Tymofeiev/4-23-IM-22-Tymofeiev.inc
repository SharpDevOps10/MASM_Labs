; MACRO for printing MessageBox
TymofeievPrintMessageBox MACRO msgTymofeievText, msgTymofeievTitle, TymofeievMB_OK_OR_MB_ICONERROR
	;; macros 1. This comment is hidden
	;comment for MessageBox invoke
    invoke MessageBox, NULL, offset msgTymofeievText, offset msgTymofeievTitle, TymofeievMB_OK_OR_MB_ICONERROR
ENDM

; Macro for encrypting the password
TymofeievEncryptPassword MACRO
	;; macros 2. This comment is hidden
    LOCAL XORLoop, @@EncProccesingLoop ;  local labels for XOR Encrypt
    mov esi, offset TymofeievPrivateXORKey
    mov edi, offset TymofeivSecretKeeperBuffer
    mov ebx, offset TymofeievDecryptedPassword
    xor ecx, ecx
	; Local label for XOR Encrypt
    XORLoop: 
        mov al, [edi + ecx]
        xor al, [esi + ecx] ; XOR for password
        mov [ebx + ecx], al
        inc ecx
        cmp byte ptr [edi + ecx], 0
        jnz XORLoop
	
	; Local label for enc proccesing 
	@@EncProccesingLoop:
       mov al, [esi + ecx]
       add ecx, 2
       cmp byte ptr [esi + ecx], 0
       jnz @@EncProccesingLoop
		
ENDM

; Macro for comparing two strings
TymofeievComparePasswords MACRO TymofeievDecrypted, TymofeievHashPass, TymofeievlabelMatch, TymofeievlabelNOTMatch
	;; macros 3. This comment is hidden
    LOCAL TymofeievCopyLoop ; local label for TymofeievCopyLoop
    LOCAL TymofeievCopyMatch ; local label for TymofeievCopyMatch
    LOCAL TymofeievCopyNOTMatch ; local label for TymofeievCopyNOTMatch

    xor ecx, ecx
    xor eax, eax
    mov esi, TymofeievDecrypted
    mov edi, TymofeievHashPass
	; loop for password compare
    TymofeievCopyLoop:
        mov al, [esi + ecx]
        cmp al, [edi + ecx]
        jne TymofeievCopyNOTMatch
        inc ecx
        cmp al, 0
        jnz TymofeievCopyLoop

        jmp TymofeievCopyMatch
	; NOT match
    TymofeievCopyNOTMatch:
        jmp TymofeievlabelNOTMatch ; NOT match

	; Match
    TymofeievCopyMatch:
        jmp TymofeievlabelMatch ; Match
ENDM