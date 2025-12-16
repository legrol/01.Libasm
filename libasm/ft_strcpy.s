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
	global ft_strcpy

ft_strcpy:
	mov rax, 0
	jmp .loop

	.loop:
		mov al, BYTE [rsi + rax]
		mov BYTE [rdi + rax], al
		test al, al
		jne .increment

		mov rax, rdi
		ret

	.increment:
		inc rax
		jmp .loop

