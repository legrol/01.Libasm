# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_strcmp.s                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/13 16:03:25 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/19 18:10:11 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;                                                                             
;   int ft_strcmp(const char *s1, const char *s2);                            
;                                                                             
;   Compares two strings character by character.                              
;                                                                             
;   - Iterates through both strings starting at index 0.                      
;   - If a different character is found, returns the difference:              
;         (unsigned char)s1[i] - (unsigned char)s2[i]                         
;   - If the end of s1 ('\0') is reached, returns the difference              
;     with the corresponding character of s2.                                 
;                                                                             
;   Return value:                                                             
;     = 0  -> strings are equal                                               
;     < 0  -> s1 is less than s2                                              
;     > 0  -> s1 is greater than s2                                           
;                                                                             
;   C equivalent:                                                             
;                                                                             
;   int ft_strcmp(const char *s1, const char *s2)                             
;   {                                                                         
;       size_t i = 0;                                                         
;                                                                             
;       while (s1[i] != '\0')                                                 
;       {                                                                     
;           if ((unsigned char)s1[i] != (unsigned char)s2[i])                 
;               return ((unsigned char)s1[i] - (unsigned char)s2[i]);         
;           i++;                                                              
;       }                                                                     
;       return ((unsigned char)s1[i] - (unsigned char)s2[i]);                 
;   }                                                                         
;                                                                             
; ****************************************************************************

;*****************************************************************************
;    int    ft_strcmp(const char *s1, const char *s2);
;
;                type    size    name        register
;  argument     char *   8(ptr)  s1          rdi    	; pointer to first string
;  argument     char *   8(ptr)  s2          rsi    	; pointer to second string
;  variable     size_t   8(long) i           rax    	; index counter (stored in rax)
;  temporary    byte     1       c1,c2       ecx,edx 	; characters loaded from s1/s2 (zero-extended)
;
;  clobbers     caller-saved regs: rax, rcx, rdx
;  return       int      4       diff        eax    	; (unsigned char)s1[i] - (unsigned char)s2[i]
;*****************************************************************************

section .text
	global ft_strcmp					; make ft_strcmp visible to the linker

ft_strcmp:
	mov rax, 0							; initialize index i = 0
	jmp .loop							; jump into the loop

	.loop:
		movzx edx, BYTE [rsi + rax]		; load s2[i] into edx
		movzx ecx, BYTE [rdi + rax]		; load s1[i] into ecx
		cmp ecx, 0						; check if s1[i] is '\0'
		jne .check_diff					; if not null, check difference
		jmp .return						; if null, return difference

	.check_diff:
		cmp edx, ecx					; compare s2[i] and s1[i]
		jne .return						; if different, return difference
		jmp .increment					; if equal, increment index

	.increment:
		inc rax							; increment index i++
		jmp .loop						; repeat the loop

	.return:
		sub ecx, edx					; compute (s1[i] - s2[i])
		mov eax, ecx					; move the result to eax
		ret								; return the result

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits

