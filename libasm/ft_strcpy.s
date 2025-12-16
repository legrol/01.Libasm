; **************************************************************************** #
;                                                                              #
;                                                         :::      ::::::::    #
;    ft_strcpy.s                                        :+:      :+:    :+:    #
;                                                     +:+ +:+         +:+      #
;    By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+         #
;                                                 +#+#+#+#+#+   +#+            #
;    Created: 2025/12/13 16:03:31 by rdel-olm          #+#    #+#              #
;    Updated: 2025/12/13 16:03:31 by rdel-olm         ###   ########.fr        #
;                                                                              #
; **************************************************************************** #

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
;       size_t i = 0;                                                         
;                                                                             
;       while (src[i] != '\0')                                                
;       {                                                                     
;           dst[i] = src[i];                                                  
;           i++;                                                              
;       }                                                                     
;       dst[i] = '\0';                                                        
;       return dst;                                                           
;   }                                                                         
;                                                                             
; ****************************************************************************

;***************************************************
;	char	*ft_strcpy(char *dst, const char *src);
;				type	size	name	register 
;	argument	char *	8(ptr)	dst   	rdi 
;	argument	char *	8(ptr)	src   	rsi 
;	variable	size_t	8(long)	i   	rax	
;***************************************************

section .text
	global ft_strcpy				; make ft_strcpy visible to the linker

ft_strcpy:
	mov rax, 0						; initialize index i = 0
	jmp .loop						; jump to the loop

	.loop:
		mov al, BYTE [rsi + rax]	; load src[i] into al
		mov BYTE [rdi + rax], al	; store al into dst[i]
		test al, al					; test if al is '\0'
		jne .increment				; if not null, increment index

		mov rax, rdi				; if null, set return value to dst
		ret							; return dst

	.increment:
		inc rax						; increment index i++
		jmp .loop					; repeat the loop

