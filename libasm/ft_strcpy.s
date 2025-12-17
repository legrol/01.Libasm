# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_strcpy.s                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/16 21:51:23 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/17 23:16:02 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;
;   char *ft_strcpy(char *dst, const char *src);
;
;   Copies the string pointed to by src (including the null terminator)
;   into the buffer pointed to by dst.
;
;   - Copies characters one by one from src to dst.
;   - Stops when the null terminator ('\0') is copied.
;   - Assumes dst has enough allocated space.
;
;   Return value:
;     A pointer to dst.
;
;   C equivalent:
;
;   char *ft_strcpy(char *dst, const char *src)
;   {
;       char *original_dst = dst;
;
;       while (*src != '\0')
;       {
;           *dst = *src;
;           dst++;
;           src++;
;       }
;       *dst = '\0';
;       return original_dst;
;   }
;
; ****************************************************************************

;***************************************************
;	char	*ft_strcpy(char *dst, const char *src);
;				type	size	name	register
;	argument	char *	8(ptr)	dst   	rdi
;	argument	char *	8(ptr)	src   	rsi
;	variable	char	1		dl
;***************************************************

section .text
	global ft_strcpy				; make ft_strcpy visible to the linker

ft_strcpy:
	mov rax, rdi					; save original dst pointer in rax
	xor rcx, rcx					; rcx = 0
	
	.loop:
		mov dl, byte [rsi + rcx]	; load byte from src[rcx]
		mov byte [rdi + rcx], dl	; store byte to dst[rcx]
		inc rcx						; increment index
		test dl, dl					; check if null
		jnz .loop					; if not null, continue
		ret							; return original dst

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits
