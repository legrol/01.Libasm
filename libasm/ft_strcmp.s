; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_strcmp.s                                        :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2025/12/13 16:03:25 by rdel-olm          #+#    #+#              ;
;    Updated: 2025/12/13 16:03:25 by rdel-olm         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

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

;***************************************************
;	int	ft_strcmp(const char *s1, const char *s2);
;				type	size	name   register
;	argument	char *	8(ptr)	s1		rdi 
;	argument	char *	8(ptr)	s2		rsi 
;	variable	size_t	8(long)	i		rax 
;***************************************************

section .text
	global ft_strcmp

ft_strcmp:
	mov rax, 0
	jmp .loop

	.loop:
		movzx edx, BYTE [rsi + rax]
		movzx ecx, BYTE [rdi + rax]
		cmp ecx, 0
		jne .check_diff
		jmp .return

	.check_diff:
		cmp edx, ecx
		jne .return
		jmp .increment

	.increment:
		inc rax
		jmp .loop

	.return:
		sub ecx, edx
		mov eax, ecx
		ret

