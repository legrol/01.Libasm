# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_strlen.s                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/13 16:03:36 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/19 18:12:47 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;                                                                             
;   size_t ft_strlen(const char *s);                                          
;                                                                             
;   Computes the length of the string s, excluding the null terminator.       
;                                                                             
;   - Iterates through the string until the null terminator ('\0') is found.  
;   - Counts the number of characters before '\0'.                            
;                                                                             
;   Return value:                                                             
;     The number of characters in the string.                                 
;                                                                             
;   C equivalent:                                                             
;                                                                             
;   size_t ft_strlen(const char *s)                                           
;   {                                                                         
;       size_t len = 0;                                                       
;                                                                             
;       while (s[len] != '\0')                                                
;           len++;                                                            
;       return len;                                                           
;   }                                                                         
;                                                                             
; ****************************************************************************

;******************************************************************************
;    size_t    ft_strlen(const char *s);
;
;               type     size    name        register
;  argument    	char *   8(ptr)  s           rdi    ; pointer to string
;  variable    	size_t   8(long) len         rax    ; length counter stored in rax (returned)
;  temporary   	byte     1       c           al/ax  ; current character loaded for comparison
;
;  clobbers     caller-saved regs: rax, rcx
;  return       size_t   8(long) len         rax    ; final length in rax
;******************************************************************************

section .text
	global ft_strlen			; make ft_strlen visible to the linker

ft_strlen:
	mov rax, 0					; initialize length counter len = 0
	jmp .loop					; jump to the loop condition

	.loop:
		cmp BYTE [rdi + rax], 0	; compare s[len] with '\0'
		jne .increment			; if not null (!=), continue counting
		jmp .endloop			; if null (==), end the loop

	.increment:
		inc rax					; increment the length counter len++
		jmp .loop				; repeat the loop

	.endloop:
		ret						; return the length in rax

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits
