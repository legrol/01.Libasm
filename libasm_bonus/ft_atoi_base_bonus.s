# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_atoi_base_bonus.s                               :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/17 11:24:34 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/19 17:55:00 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;                                                                             
;   int ft_atoi_base(char *str, char *base);                                  
;                                                                             
;   Converts the initial portion of the string pointed to by str              
;   into an integer representation in the specified base.                     
;                                                                             
;   - Validates the base according to strict rules.                           
;   - Skips leading whitespace characters (space, tab, newline, etc.).        
;   - Handles optional sign characters ('+' or '-').                          
;   - Converts valid digits until an invalid character is found.              
;   - Returns 0 if the base is invalid or conversion fails.                   
;                                                                             
;   Base validation rules:                                                    
;     - Base must contain at least 2 characters.                              
;     - Base cannot contain duplicate characters.                             
;     - Base cannot contain '+', '-', or any whitespace characters.           
;                                                                             
;   Conversion algorithm:                                                      
;     result = 0                                                               
;     for each valid digit in str:                                             
;         result = result * base_length + digit_index                         
;     if sign is negative:                                                     
;         result = -result                                                     
;                                                                             
;   Return value:                                                              
;     The converted integer value, or 0 if:                                    
;       - Base is invalid (empty, length < 2, duplicates, forbidden chars)    
;       - String contains no valid digits                                     
;                                                                             
;   C equivalent:                                                              
;                                                                             
;   int ft_atoi_base(char *str, char *base)                                    
;   {                                                                         
;       int result = 0, sign = 1, base_len;                                    
;                                                                             
;       if ((base_len = validate_base(base)) == 0)                            
;           return 0;                                                         
;       while (*str == ' ' || (*str >= 9 && *str <= 13))                      
;           str++;                                                             
;       if (*str == '-' || *str == '+')                                       
;           sign = (*str++ == '-') ? -1 : 1;                                  
;       while (*str)                                                           
;       {                                                                     
;           int digit = find_in_base(*str, base);                              
;           if (digit == -1)                                                  
;               break;                                                         
;           result = result * base_len + digit;                                
;           str++;                                                             
;       }                                                                     
;       return result * sign;                                                 
;   }                                                                         
;                                                                             
; ****************************************************************************

;*****************************************************************************
; int	ft_atoi_base(char *str, char *base);
;
; 			type		size		name		register 
; argument	char*		8(ptr)		str			rdi
; argument	char*		8(ptr)		base		rsi
;
; variable	char*		8(ptr)		str_ptr		r12    ; pointer to current position in string
; variable	char*		8(ptr)		base_ptr	r13    ; preserved base pointer for searches
; variable	int			4(int)		result		ebx    ; accumulated result (32-bit)
; variable	int			4(int)		digit		eax/ecx; temporary digit/index during conversion
; variable	int			4(int)		sign_flag	r15d   ; sign flag: 0 = positive, 1 = negative
; variable	size_t		8(long)		base_len	r14d   ; length of the base returned by check_base_valid
; temp		required	-			rcx, rdx	temporaries used in validation and searching
; return	int			4(int)		(return)	rax    ; final converted integer
;*****************************************************************************

section .text
 	global ft_atoi_base					; make ft_atoi_base visible to the linker

ft_atoi_base:
 	push rbx							; save rbx on stack
 	push r12							; save r12 on stack
 	push r13							; save r13 on stack
 	push r14							; save r14 on stack
 	push r15							; save r15 on stack

 	mov r12, rdi						; r12 = str (first argument)
 	mov r13, rsi						; r13 = base (second argument)

 	;****************************************
 	; Validate base
 	;****************************************

 	mov rdi, r13						; pass base as argument to check_base_valid
 	call check_base_valid				; validate base and get length
 	test rax, rax						; check if base is valid (rax = 0 if invalid)
 	jz .return_zero						; if invalid base, jump to return 0

 	mov r14d, eax						; r14 = validated base length

 	;****************************************
 	; Skip whitespaces
 	;****************************************

 	mov rdi, r12						; pass str to skip_whitespace
 	call skip_whitespace				; skip leading whitespace
 	mov r12, rax						; r12 = str pointer after whitespace

 	;****************************************
 	; Handle sign
 	;****************************************

 	xor r15d, r15d						; r15 = sign flag (0 for positive)
 	movzx eax, BYTE [r12]				; load first character of string
 	cmp al, '-'							; check if character is minus sign
 	jne .check_plus						; if not minus, check for plus
 	mov r15d, 1							; r15 = 1 (mark as negative)
 	inc r12								; advance string pointer past minus
 	jmp .convert						; skip plus check and start conversion

	.check_plus:
		cmp al, '+'						; check if character is plus sign
		jne .convert					; if not plus, start conversion
		inc r12							; advance string pointer past plus

	.convert:
		xor ebx, ebx					; result = 0 (initialize result accumulator)

	.convert_loop:
		movzx edi, BYTE [r12]			; load current character from string
		test dil, dil					; check if character is null terminator
		jz .apply_sign					; if null, we're done parsing, apply sign
		
		;************************************
		; Find char in base
		;************************************
		
		mov rsi, r13					; pass base to find_in_base
		call find_in_base				; get digit index in base (or -1)
		cmp eax, -1						; check if character found in base
		je .apply_sign					; if not found (-1), stop conversion

		;************************************
		; result = result * base_len + index
		;************************************

		mov ecx, eax					; ecx = digit value (index in base)
		mov eax, ebx					; eax = current result
		imul eax, r14d					; eax = result * base_length
		add eax, ecx					; eax = result * base_len + digit_index
		mov ebx, eax					; save new result to rbx

		inc r12							; advance to next character
		jmp .convert_loop				; continue conversion loop

	.apply_sign:
		mov eax, ebx					; move accumulated result to eax (return register)
		test r15d, r15d					; check if sign flag is set (negative)
		jz .done						; if not negative, skip negation
		neg eax							; negate result (make it negative)

	.done:
		pop r15							; restore r15 from stack
		pop r14							; restore r14 from stack
		pop r13							; restore r13 from stack
		pop r12							; restore r12 from stack
		pop rbx							; restore rbx from stack
		ret								; return to caller with result in eax

	.return_zero:
		xor eax, eax					; return 0 (invalid base)
		pop r15							; restore r15 from stack
		pop r14							; restore r14 from stack
		pop r13							; restore r13 from stack
		pop r12							; restore r12 from stack
		pop rbx							; restore rbx from stack
		ret								; return to caller

	;***************************************************
	; Helper: check if base is valid and return length
	; Input: rdi = base
	; Output: rax = base_len (0 if invalid)
	;***************************************************

	check_base_valid:
		push rbx						; save rbx on stack
		push r12						; save r12 on stack
		mov r12, rdi					; r12 = base pointer
		xor ebx, ebx					; rbx = character counter (length)

	.count_loop:
		movzx eax, BYTE [r12 + rbx]		; load character at base[rbx]
		test al, al						; check if null terminator
		jz .check_len					; if end of base, check minimum length

		;************************************
		; Check for +, -, whitespace
		;************************************

		cmp al, '+'						; check for plus sign
		je .invalid						; invalid: plus in base
		cmp al, '-'						; check for minus sign
		je .invalid						; invalid: minus in base
		cmp al, ' '						; check for space
		je .invalid						; invalid: space in base
		cmp al, 9						; check for tab (ASCII 9)
		je .invalid						; invalid: tab in base
		cmp al, 10						; check for newline (ASCII 10)
		je .invalid						; invalid: newline in base
		cmp al, 11						; check for vertical tab (ASCII 11)
		je .invalid						; invalid: vertical tab in base
		cmp al, 12						; check for form feed (ASCII 12)
		je .invalid						; invalid: form feed in base
		cmp al, 13						; check for carriage return (ASCII 13)
		je .invalid						; invalid: carriage return in base

		;************************************
		; Check for duplicates
		;************************************

		mov rcx, rbx					; rcx = current index
		inc rcx							; start checking from next character
		
	.dup_loop:
		movzx edx, BYTE [r12 + rcx]		; load next character
		test dl, dl						; check if null terminator
		jz .no_dup						; no duplicate found
		cmp al, dl						; compare current char with next
		je .invalid						; duplicate found: invalid
		inc rcx							; move to next character
		jmp .dup_loop					; continue checking for duplicates

	.no_dup:
		inc rbx							; increment character counter
		jmp .count_loop					; continue to next character

	.check_len:
		cmp rbx, 2						; check if base length >= 2
		jl .invalid						; if length < 2, invalid base
		mov rax, rbx					; return base length
		pop r12							; restore r12
		pop rbx							; restore rbx
		ret								; return with length in eax

	.invalid:
		xor eax, eax					; return 0 (invalid base)
		pop r12							; restore r12
		pop rbx							; restore rbx
		ret								; return with 0 in eax

	;****************************************
	; Helper: skip whitespace
	; Input: rdi = str
	; Output: rax = str after whitespace
	;****************************************

	skip_whitespace:
		.loop:
			movzx eax, BYTE [rdi]		; load character from string
			cmp al, ' '					; check if character is space
			je .skip					; if space, skip it
			cmp al, 9					; check if character >= 9 (tab)
			jl .done					; if < 9, not whitespace, exit
			cmp al, 13					; check if character <= 13 (CR)
			jg .done					; if > 13, not whitespace, exit
		.skip:
			inc rdi						; advance string pointer
			jmp .loop					; continue skipping
		.done:
			mov rax, rdi				; return string pointer after whitespace
			ret							; return to caller

	;****************************************
	; Helper: find character in base
	; Input: dil = char, rsi = base
	; Output: eax = index or -1
	;****************************************
	
	find_in_base:
		xor eax, eax					; index = 0 (initialize)
		.loop:
			movzx edx, BYTE [rsi + rax]	; load character from base at index
			test dl, dl					; check if null terminator
			jz .not_found				; if null, character not found
			cmp dl, dil					; compare base[index] with search character
			je .found					; if equal, character found
			inc rax						; increment index
			jmp .loop					; continue searching
		.found:
			ret							; return with index in eax
		.not_found:
			mov eax, -1					; return -1 (character not found)
			ret							; return to caller

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits
