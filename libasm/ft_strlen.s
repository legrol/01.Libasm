; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_strlen.s                                        :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2025/12/13 16:03:36 by rdel-olm          #+#    #+#              ;
;    Updated: 2025/12/13 16:03:36 by rdel-olm         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

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

;***************************************************
;	size_t	ft_strlen(const char *s);
;
;				type	size	name	register   
;	argument	char *	8(ptr)	s   	rdi 
;	variable	size_t	8(long)	i   	rax 
;***************************************************

section .text
	global ft_strlen			; make ft_strlen visible to the linker

ft_strlen:
	mov rax, 0					; initialize length counter i = 0
	jmp .loop					; jump to the loop condition

	.loop:
		cmp BYTE [rdi + rax], 0	; compare s[i] with '\0'
		jne .increment			; if not null, continue counting
		jmp .endloop			; if null, end the loop

	.increment:
		inc rax					; increment the length counter i++
		jmp .loop				; repeat the loop

	.endloop:
		ret						; return the length in rax
